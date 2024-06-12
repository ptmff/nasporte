using System.Data;
using Data;
using Microsoft.AspNetCore.Mvc;
using Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Npgsql;
using Microsoft.Extensions.Logging;
using NpgsqlTypes;

namespace Controllers;

[Route("[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<AuthController> _logger;

    public AuthController(IConfiguration configuration, ILogger<AuthController> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegModel userModel)
    {
        try
        {
            using (var connection = PostgresConnection.GetConnection(_configuration))
            {
                var checkUserByNameQuery = "SELECT COUNT(*) FROM Users WHERE username = @Username";
                using (var command = new NpgsqlCommand(checkUserByNameQuery, connection))
                {
                    command.Parameters.AddWithValue("@username", userModel.Username);
                    var existingUsersByNameCount = (long)(await command.ExecuteScalarAsync() ?? throw new InvalidOperationException());
                    if (existingUsersByNameCount > 0)
                    {
                        _logger.LogWarning("User already exists: username={Username}", userModel.Username);
                        return BadRequest("Пользователь с таким именем уже существует.");
                    }
                }

                var checkUserByEmailQuery = "SELECT COUNT(*) FROM Users WHERE email = @email";
                using (var command = new NpgsqlCommand(checkUserByEmailQuery, connection))
                {
                    command.Parameters.AddWithValue("@email", userModel.Email);
                    var existingUsersByEmailCount = (long)await command.ExecuteScalarAsync();
                    if (existingUsersByEmailCount > 0)
                    {
                        _logger.LogWarning("User already exists: email={Email}", userModel.Email);
                        return BadRequest("Пользователь с такой электронной почтой уже существует.");
                    }
                }

                if (userModel.Password != userModel.RepeatedPassword)
                {
                    _logger.LogWarning("Passwords do not match for user: username={Username}", userModel.Username);
                    return BadRequest("Введённые пароли не совпадают.");
                }

                var userId = Guid.NewGuid();
                string hashedPassword = BCrypt.Net.BCrypt.HashPassword(userModel.Password);

                var insertUserQuery = "INSERT INTO Users (username, email, id, password) VALUES (@Username, @email, @id, @password)";
                using (var command = new NpgsqlCommand(insertUserQuery, connection))
                {
                    command.Parameters.AddWithValue("@username", userModel.Username);
                    command.Parameters.AddWithValue("@email", userModel.Email);
                    command.Parameters.AddWithValue("@password", hashedPassword);
                    command.Parameters.AddWithValue("@id", userId);
                    await command.ExecuteNonQueryAsync();
                }

                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_configuration["Salt"]);
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new Claim[]
                    {
                        new Claim("Id", userId.ToString())
                    }),
                    Expires = DateTime.UtcNow.AddHours(1),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key),
                        SecurityAlgorithms.HmacSha256Signature)
                };
                var token = tokenHandler.CreateToken(tokenDescriptor);
                var tokenString = tokenHandler.WriteToken(token);

                _logger.LogInformation("User registered successfully: username={Username}, id={UserId}", userModel.Username, userId);

                return Ok(new { Token = tokenString });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error occurred during user registration: username={Username}", userModel.Username);
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
                var checkUserQuery = "SELECT * FROM Users WHERE username = @username OR email = @email";
                using (var command = new NpgsqlCommand(checkUserQuery, connection))
                {
                    command.Parameters.AddWithValue("@username", model.Login);
                    command.Parameters.AddWithValue("@email", model.Login);
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            string hashedPassword = reader["password"].ToString();
                            if (BCrypt.Net.BCrypt.Verify(model.Password, hashedPassword))
                            {
                                var tokenHandler = new JwtSecurityTokenHandler();
                                var key = Encoding.ASCII.GetBytes(_configuration["Salt"]);
                                var tokenDescriptor = new SecurityTokenDescriptor
                                {
                                    Subject = new ClaimsIdentity(new Claim[]
                                    {
                                        new Claim("Id", reader["id"].ToString())
                                    }),
                                    Expires = DateTime.UtcNow.AddHours(1),
                                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key),
                                        SecurityAlgorithms.HmacSha256Signature)
                                };
                                var token = tokenHandler.CreateToken(tokenDescriptor);
                                var tokenString = tokenHandler.WriteToken(token);

                                _logger.LogInformation("User logged in successfully: login={Login}", model.Login);

                                return Ok(new { Token = tokenString });
                            }
                            else
                            {
                                _logger.LogWarning("Invalid password for user: login={Login}", model.Login);
                                return Unauthorized("Неверный пароль");
                            }
                        }
                        else
                        {
                            _logger.LogWarning("User not found: login={Login}", model.Login);
                            return Unauthorized("Пользователь не найден");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error occurred during user login: login={Login}", model.Login);
            return StatusCode(500, $"Произошла ошибка при авторизации: {ex.Message}");
        }
    }
}

[Route("[controller]")]
[ApiController]
public class ChatController : ControllerBase
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<ChatController> _logger;

    public ChatController(IConfiguration configuration, ILogger<ChatController> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    [HttpGet("Status")]
    [Authorize]
    public IActionResult Status()
    {
        var claimsIdentity = (ClaimsIdentity)User.Identity;
        var claims = claimsIdentity.Claims;
        var userId = claims.FirstOrDefault(c => c.Type == "Id")?.Value;

        _logger.LogInformation("Secure endpoint accessed by user: id={UserId}", userId);

        return Ok($"This is a secure endpoint\nUser ID: {userId}");
    }



    [HttpPost("New")]
    [Authorize]
    public async Task<IActionResult> New([FromBody] string login)
    {
        try
        {
            using (var connection = PostgresConnection.GetConnection(_configuration))
            {
                if (connection.State != System.Data.ConnectionState.Open)
                {
                    await connection.OpenAsync();
                }
                
                var claimsIdentity = (ClaimsIdentity)User.Identity;
                var claims = claimsIdentity.Claims;
                var userIdStr = claims.FirstOrDefault(c => c.Type == "Id")?.Value;
                var userId = Guid.ParseExact(userIdStr, "D");
                var chatId = Guid.NewGuid().ToString();

                var findUserQuery = "SELECT * FROM Users WHERE id = @userId";
                using (var findCommand = new NpgsqlCommand(findUserQuery, connection))
                {
                    findCommand.Parameters.AddWithValue("@userId", userId);

                    using (var reader = await findCommand.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            var chats = reader["chats"] as string[];
                            if (chats == null)
                            {
                                chats = new string[] { };
                            }

                            var updatedChats = chats.Append(chatId).ToArray();
                            reader.Close(); // Ensure reader is closed before executing another command

                            var updateUserQuery = "UPDATE Users SET chats = @chats WHERE id = @userId";
                            using (var updateCommand = new NpgsqlCommand(updateUserQuery, connection))
                            {
                                updateCommand.Parameters.AddWithValue("@chats", updatedChats);
                                updateCommand.Parameters.AddWithValue("@userId", userId);

                                await updateCommand.ExecuteNonQueryAsync();
                            }
                        }
                        else
                        {
                            return NotFound("User not found");
                        }
                    }
                }
                
                findUserQuery = "SELECT * FROM Users WHERE username = @username OR email = @email";
                using (var findCommand = new NpgsqlCommand(findUserQuery, connection))
                {
                    findCommand.Parameters.AddWithValue("@username", login);
                    findCommand.Parameters.AddWithValue("@email", login);

                    using (var reader = await findCommand.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            var chats = reader["chats"] as string[];
                            if (chats == null)
                            {
                                chats = new string[] { };
                            }

                            var updatedChats = chats.Append(chatId).ToArray();
                            reader.Close(); // Ensure reader is closed before executing another command

                            var updateUserQuery = "UPDATE Users SET chats = @chats WHERE username = @username OR email = @email";
                            using (var updateCommand = new NpgsqlCommand(updateUserQuery, connection))
                            {
                                updateCommand.Parameters.AddWithValue("@chats", updatedChats);
                                updateCommand.Parameters.AddWithValue("@username", login);
                                updateCommand.Parameters.AddWithValue("@email", login);

                                await updateCommand.ExecuteNonQueryAsync();
                            }
                        }
                        else
                        {
                            return NotFound("User not found");
                        }
                    }
                }

                _logger.LogInformation("Chat created successfully: userId={UserId}, chatId={ChatId}", userId, chatId);
                return Ok(new { ChatId = chatId });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error occurred during chat creation: userId={UserId}");
            return StatusCode(500, $"Произошла ошибка при создании чата: {ex.Message}");
        }
    }

    [HttpGet("All")]
    [Authorize]
    public async Task<IActionResult> All()
    {
        var claimsIdentity = (ClaimsIdentity)User.Identity;
        var claims = claimsIdentity.Claims;
        var userIdStr = claims.FirstOrDefault(c => c.Type == "Id")?.Value;
        var userId = Guid.ParseExact(userIdStr, "D");
        try
        {
            using (var connection = PostgresConnection.GetConnection(_configuration))
            {
                if (connection.State != System.Data.ConnectionState.Open)
                {
                    await connection.OpenAsync();
                }

                var findUserQuery = "SELECT * FROM Users WHERE id = @userId";
                using (var findCommand = new NpgsqlCommand(findUserQuery, connection))
                {
                    findCommand.Parameters.AddWithValue("@userId", userId);

                    using (var reader = await findCommand.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            var chats = reader["chats"] as string[];
                            if (chats == null)
                            {
                                chats = new string[] { };
                            }

                            _logger.LogInformation("Returned all chats for user: id={UserId}", userId);

                            return Ok($"Chats list\nChat IDs: {JsonSerializer.Serialize(chats)}");
                        }
                        else
                        {
                            return NotFound("User not found");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error occurred during chat listing: userId={UserId}");
            return StatusCode(500, $"Произошла ошибка при выводе всех чатов: {ex.Message}");
        }
    }
}
