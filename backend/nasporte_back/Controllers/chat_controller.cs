using Microsoft.AspNetCore.Mvc;
using ChatApp.Models;
using ChatApp.Data;

namespace ChatApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DialogsController : ControllerBase
    {
        private readonly ChatDbContext _context;

        public DialogsController(ChatDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<ActionResult<Dialog>> CreateDialog(Dialog dialog)
        {
            _context.Dialogs.Add(dialog);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetDialog), new { id = dialog.Id }, dialog);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Dialog>> GetDialog(int id)
        {
            var dialog = await _context.Dialogs.FindAsync(id);
            if (dialog == null)
            {
                return NotFound();
            }
            return dialog;
        }
    }
}