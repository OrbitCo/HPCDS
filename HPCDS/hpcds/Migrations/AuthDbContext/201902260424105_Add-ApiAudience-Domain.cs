namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddApiAudienceDomain : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.ApiAudiences", "Domain", c => c.String(nullable: false, maxLength: 100));
        }
        
        public override void Down()
        {
            DropColumn("dbo.ApiAudiences", "Domain");
        }
    }
}
