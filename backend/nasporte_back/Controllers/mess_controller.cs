using Microsoft.AspNetCore.Mvc;
using ChatApp.Models;
using ChatApp.Data;
using Microsoft.EntityFrameworkCore;

namespace ChatApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class MessagesController : ControllerBase
    {
        private readonly ChatDbContext _context;

        public MessagesController(ChatDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<ActionResult<Message>> CreateMessage(Message message)
        {
            _context.Messages.Add(message);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetMessage), new { id = message.Id }, message);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Message>> GetMessage(int id)
        {
            var message = await _context.Messages.FindAsync(id);
            if (message == null)
            {
                return NotFound();
            }
            return message;
        }

        [HttpGet("dialog/{dialogId}")]
        public async Task<ActionResult<IEnumerable<Message>>> GetMessagesByDialogId(int dialogId)
        {
            var messages = await _context.Messages.Where(m => m.DialogId == dialogId).ToListAsync();
            return messages;
        }
    }
}