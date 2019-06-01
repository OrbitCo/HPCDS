namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddApiAudience : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.ApiAudiences",
                c => new
                    {
                        ClientId = c.String(nullable: false, maxLength: 32),
                        Base64Secret = c.String(nullable: false, maxLength: 80),
                        Name = c.String(nullable: false, maxLength: 100),
                    })
                .PrimaryKey(t => t.ClientId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.ApiAudiences");
        }
    }
}
