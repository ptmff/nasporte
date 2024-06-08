using Microsoft.AspNetCore.Mvc;

public class ChatController : Controller
{
    public IActionResult Index(string chatId)
    {
        if (string.IsNullOrEmpty(chatId))
        {
            chatId = Guid.NewGuid().ToString();
        }
        ViewData["ChatId"] = chatId;
        return View();
    }
}