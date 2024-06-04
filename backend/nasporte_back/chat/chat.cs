using Microsoft.AspNetCore.SignalR;
 
namespace SignalRApp
{
    public class ChatHub : Hub
    {
        public async Task Send(string message, string userName)
        {
            await Clients.All.SendAsync("Receive", message, userName);
        }
    }
}