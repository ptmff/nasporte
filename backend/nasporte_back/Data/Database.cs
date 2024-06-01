using System.Data;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace Data;

public class PostgresConnection
{
    private static NpgsqlConnection _connection;
    private static readonly object _lock = new object();

    private PostgresConnection() { }

    public static NpgsqlConnection GetConnection(IConfiguration configuration)
    {
        if (_connection == null || _connection.State != ConnectionState.Open)
        {
            lock (_lock)
            {
                if (_connection == null || _connection.State != ConnectionState.Open)
                {
                    string ConnectionString = "DefaultConnection";
                    _connection = new NpgsqlConnection(configuration.GetConnectionString(ConnectionString));
                    _connection.Open();
                }
            }
        }

        return _connection;
    }
}

public class MigrateDatabase
{
    public static void Migrate()
    {
        var builder = WebApplication.CreateBuilder(Array.Empty<string>());
        var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

        using (var context = new UserContext(new DbContextOptionsBuilder<UserContext>()
                   .UseNpgsql(connectionString)
                   .Options))
        {
            context.Database.EnsureCreated();
        }
    }
}
