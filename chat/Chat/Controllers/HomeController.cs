using Microsoft.AspNetCore.Mvc;

public class HomeController : Controller
{
    public IActionResult Index()
    {
        return View();
    }

    [HttpPost]
    public IActionResult CreateChat()
    {
        string chatId = Guid.NewGuid().ToString();
        return RedirectToAction("Index", "Chat", new { chatId = chatId });
    }
}