using System.ComponentModel.DataAnnotations;

namespace ChatApp.Models
{
    public class Dialog
    {
        [Key]
        public int Id { get; set; }
        public int User1Id { get; set; }
        public int User2Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public ICollection<Message> Messages { get; set; }
    }

    public class Message
    {
        [Key]
        public int Id { get; set; }
        public int DialogId { get; set; }
        public int SenderId { get; set; }
        public string Text { get; set; }
        public DateTime CreatedAt { get; set; }
        public Dialog Dialog { get; set; }
    }
}