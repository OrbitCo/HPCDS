using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Data.Entity.SqlServer;

namespace hpcds.Models
{
    /// <summary>
    /// Modify default Db context configuration so we can use DB SEQUENCE with DatabaseGeneratedOption.Identity
    /// see: EF v6.2, issue #165 and pull request #182 (https://github.com/aspnet/EntityFramework6/issues/165)
    /// </summary>
    public class DbContextConfiguration : DbConfiguration
    {
        public DbContextConfiguration()
        {
            var providerInstance = SqlProviderServices.Instance;
            SqlProviderServices.UseScopeIdentity = false;
            this.SetProviderServices(SqlProviderServices.ProviderInvariantName, SqlProviderServices.Instance);
        }
    }

    /// <summary>
    /// Migration Seeder - specific Application Db context that enables AddOrUpdate to provide PKey values for the following Entities
    /// </summary>
    public class SeederDbContext : ApplicationDbContext
    {
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Organization>()
                .Property(p => p.ID)
                    .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            modelBuilder.Entity<OrganizationAddress>()
                .Property(p => p.ID)
                    .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            modelBuilder.Entity<SecurityQuestion>()
                .Property(p => p.ID)
                    .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

        }
    }

    [DbConfigurationType(typeof(DbContextConfiguration))]
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext()
            : base("authDbContext", throwIfV1Schema: false)
        {
            ApiAudience = Set<ApiAudience>();
            SecurityQuestions = Set<SecurityQuestion>();
            UserQuestions = Set<UserQuestion>();

            OrganizationAddresses = Set<OrganizationAddress>();
            Organizations = Set<Organization>();
        }

        internal virtual DbSet<ApiAudience> ApiAudience { get; set; }

        internal virtual DbSet<SecurityQuestion> SecurityQuestions { get; set; }
        internal virtual DbSet<UserQuestion> UserQuestions { get; set; }

        internal virtual DbSet<OrganizationAddress> OrganizationAddresses { get; set; }
        internal virtual DbSet<Organization> Organizations { get; set; }

        public static ApplicationDbContext Create()
        {
            var dbContext = new ApplicationDbContext();
            dbContext.Database.Log = Console.WriteLine;
            return dbContext;
        }
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Organization>()
                .HasMany(e => e.Addresses)
                .WithRequired(e => e.Organization)
                .HasForeignKey(e => e.OrganizationID)
                .WillCascadeOnDelete(true);

            modelBuilder.Entity<Organization>()
                .HasMany(e => e.Users)
                .WithRequired(e => e.Organization)
                .HasForeignKey(e => e.O_ID)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Organization>()
                .Property(p => p.OrganizationName).IsRequired();

            modelBuilder.Entity<Organization>()
                .HasOptional(e => e.ContactUser)
                ;
        }
    }
}