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
    public DbSet<Message> Messages { get; set; }
    
    //Такое только для messages делаем, так как там uuid сами должны создаваться а для этого расширение нужно
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      base.OnModelCreating(modelBuilder);

      modelBuilder.Entity<Message>(entity =>
      {
        entity.HasKey(e => e.Id);
        entity.Property(e => e.Id)
          .HasDefaultValueSql("gen_random_uuid()");
        entity.Property(e => e.ChatId).IsRequired();
        entity.Property(e => e.Username).IsRequired();
        entity.Property(e => e.MessageText).IsRequired();
        entity.Property(e => e.TimeStamp).IsRequired();
      });

      // Ensure pgcrypto extension is created
      modelBuilder.HasPostgresExtension("pgcrypto");
    }
  }
}