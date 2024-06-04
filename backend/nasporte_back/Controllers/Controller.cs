using Data;
using Microsoft.AspNetCore.Mvc;
using Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Npgsql;

namespace Controllers;

[Route("[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly IConfiguration _configuration;

    public AuthController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegModel userModel)
    {
        try
        {
            using (var connection = PostgresConnection.GetConnection(_configuration))
            {
                // Проверяем, не существует ли уже пользователь с таким же именем
                var checkUserByNameQuery = "SELECT COUNT(*) FROM Users WHERE username = @Username";
                using (var command = new NpgsqlCommand(checkUserByNameQuery, connection))
                {
                    command.Parameters.AddWithValue("@username", userModel.Username);
                    var existingUsersByNameCount = (long)(await command.ExecuteScalarAsync() ?? throw new InvalidOperationException());
                    if (existingUsersByNameCount > 0)
                    {
                        return BadRequest("Пользователь с таким именем уже существует.");
                    }
                }

                // Проверяем, не существует ли уже пользователь с такой же электронной почтой
                var checkUserByEmailQuery = "SELECT COUNT(*) FROM Users WHERE email = @email";
                using (var command = new NpgsqlCommand(checkUserByEmailQuery, connection))
                {
                    command.Parameters.AddWithValue("@email", userModel.Email);
                    var existingUsersByEmailCount = (long)await command.ExecuteScalarAsync();
                    if (existingUsersByEmailCount > 0)
                    {
                        return BadRequest("Пользователь с такой электронной почтой уже существует.");
                    }
                }
                
                // Проверяем что оба введённых пароля идентичны
                if (userModel.Password != userModel.RepeatedPassword)
                {
                    return BadRequest("Введённые пароли не совпадают.");
                }
                
                // Генерируем уникальный id для нового пользователя
                var userId = Guid.NewGuid();

                // Хэшируем пароль, прежде чем сохранять его в базе данных
                string hashedPassword = BCrypt.Net.BCrypt.HashPassword(userModel.Password);

                // Добавляем нового пользователя в базу данных
                var insertUserQuery = "INSERT INTO Users (username, email, id, password) VALUES (@Username, @email, @id, @password)";
                using (var command = new NpgsqlCommand(insertUserQuery, connection))
                {
                    command.Parameters.AddWithValue("@username", userModel.Username);
                    command.Parameters.AddWithValue("@email", userModel.Email);
                    command.Parameters.AddWithValue("@password", hashedPassword);
                    command.Parameters.AddWithValue("@id", userId);
                    await command.ExecuteNonQueryAsync();
                }

                // Создаем JWT токен
                var tokenHandler = new JwtSecurityTokenHandler();

                var key = Encoding.ASCII.GetBytes(_configuration["Salt"]);
                
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new Claim[]
                    {
                        new Claim("Id", userId.ToString())
                        // Здесь можно добавить другие утверждения (claims), если требуется
                    }),
                    Expires = DateTime.UtcNow.AddHours(1), // Время жизни токена - 1 час
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key),
                        SecurityAlgorithms.HmacSha256Signature)
                };
                var token = tokenHandler.CreateToken(tokenDescriptor);
                var tokenString = tokenHandler.WriteToken(token);

                // Возвращаем успешный ответ с JWT токеном
                return Ok(new { Token = tokenString });
            }
        }
        catch (Exception ex)
        {
            // Обрабатываем любые ошибки и возвращаем ошибку сервера
            return StatusCode(500, $"Произошла ошибка при регистрации: {ex.Message}");
        }
    }
    
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginModel model)
    {
        try
        {
            using (var connection = PostgresConnection.GetConnection(_configuration))
            {
                // Проверяем, существует ли пользователь с таким именем или электронной почтой
                var checkUserQuery = "SELECT * FROM Users WHERE username = @username OR email = @email";
                using (var command = new NpgsqlCommand(checkUserQuery, connection))
                {
                    command.Parameters.AddWithValue("@username", model.Login);
                    command.Parameters.AddWithValue("@email", model.Login);
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            // Проверяем пароль
                            string hashedPassword = reader["password"].ToString();
                            if (BCrypt.Net.BCrypt.Verify(model.Password, hashedPassword))
                            {
                                // Создаем JWT токен
                                var tokenHandler = new JwtSecurityTokenHandler();

                                var key = Encoding.ASCII.GetBytes(_configuration["Salt"]);

                                var tokenDescriptor = new SecurityTokenDescriptor
                                {
                                    Subject = new ClaimsIdentity(new Claim[]
                                    {
                                        new Claim("Id", reader["id"].ToString())
                                        // Здесь можно добавить другие утверждения (claims), если требуется
                                    }),
                                    Expires = DateTime.UtcNow.AddHours(1), // Время жизни токена - 1 час
                                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key),
                                        SecurityAlgorithms.HmacSha256Signature)
                                };
                                var token = tokenHandler.CreateToken(tokenDescriptor);
                                var tokenString = tokenHandler.WriteToken(token);

                                // Возвращаем успешный ответ с JWT токеном
                                return Ok(new { Token = tokenString });
                            }
                            else
                            {
                                return Unauthorized("Неверный пароль");
                            }
                        }
                        else
                        {
                            return Unauthorized("Пользователь не найден");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Обрабатываем любые ошибки и возвращаем ошибку сервера
            return StatusCode(500, $"Произошла ошибка при авторизации: {ex.Message}");
        }
    }
}

[Route("[controller]")]
[ApiController]
public class LoggedController : ControllerBase
{
    [HttpGet]
    [Authorize]
    public IActionResult Get()
    {
        var claimsIdentity = (ClaimsIdentity)User.Identity;
        var claims = claimsIdentity.Claims;
        var userId = claims.FirstOrDefault(c => c.Type == "Id")?.Value;
        return Ok($"This is a secure endpoint\nUser ID: {userId}");
    }
}



