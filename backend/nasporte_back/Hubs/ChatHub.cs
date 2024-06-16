using Data;
using Microsoft.AspNetCore.SignalR;
using Npgsql;

namespace Hubs;

public class ChatHub : Hub
{
    private readonly IConfiguration _configuration;
    public ChatHub(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public async Task JoinChat(string chatId)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, chatId);
    }

    public async Task LeaveChat(string chatId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, chatId);
    }

    public async Task SendMessage(string chatId, string user, string message)
    {
        using (var connection = PostgresConnection.GetConnection(_configuration))
        {
            if (connection.State != System.Data.ConnectionState.Open)
            {
                await connection.OpenAsync();
            }
    
            var timestamp = DateTime.UtcNow;
    
            using (var command = new NpgsqlCommand("INSERT INTO messages (chat_id, username, message_text, time_stamp) VALUES (@chatId, @username, @messageText, @timestamp)", connection))
            {
                command.Parameters.AddWithValue("@chatId", chatId);
                command.Parameters.AddWithValue("@username", user);
                command.Parameters.AddWithValue("@messageText", message);
                command.Parameters.AddWithValue("@timestamp", timestamp);
    
                await command.ExecuteNonQueryAsync();
            }
        }
        await Clients.Group(chatId).SendAsync("ReceiveMessage", user, message);
    }
}