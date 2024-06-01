using Microsoft.EntityFrameworkCore;
using Models;

namespace Data
{
  public class UserContext : DbContext
  {
    public UserContext(DbContextOptions<UserContext> options) : base(options)
    {
    }

    public DbSet<User> Users { get; set; }
  }
}