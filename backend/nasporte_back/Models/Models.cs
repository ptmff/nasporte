using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Models
{
  [Table("users")]
  public class User
  {
    [Column("id")]
    public Guid Id { get; set; }

    [Column("username")]
    public string Username { get; set; }

    [Column("email")]
    public string Email { get; set; }
    
    [Column("password")]
    public string Password { get; set; }
    
    [Column("chats")]
    public string[]? Chats { get; set; }
    
    [Column("profile_pic")]
    public string? ProfilePic { get; set; }
  }
  
  public class LoginModel
  {
    public string Login { get; set; }
    public string Password { get; set; }
  }
  
  public class RegModel
  {
    public string Username { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
    public string RepeatedPassword { get; set; }
  }
  
  [Table("messages")]
  public class Message
  {
    [Key]
    [Column("id")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public Guid Id { get; set; }
    
    [Column("chat_id")]
    public string ChatId { get; set; }

    [Column("username")]
    public string Username { get; set; }

    [Column("message_text")]
    public string MessageText { get; set; }
    
    [Column("time_stamp")]
    public DateTime TimeStamp { get; set; }
  }
}