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
  }
}