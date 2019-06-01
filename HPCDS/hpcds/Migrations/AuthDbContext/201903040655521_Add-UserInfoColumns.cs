namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddUserInfoColumns : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "FirstName", c => c.String(nullable: false, maxLength: 50));
            AddColumn("dbo.AspNetUsers", "LastName", c => c.String(nullable: false, maxLength: 50));
            AddColumn("dbo.AspNetUsers", "PhoneInternationalFlag", c => c.Boolean(nullable: false));
            AddColumn("dbo.AspNetUsers", "Phone", c => c.String(maxLength: 25));
            AddColumn("dbo.AspNetUsers", "OrgID", c => c.Guid(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.AspNetUsers", "OrgID");
            DropColumn("dbo.AspNetUsers", "Phone");
            DropColumn("dbo.AspNetUsers", "PhoneInternationalFlag");
            DropColumn("dbo.AspNetUsers", "LastName");
            DropColumn("dbo.AspNetUsers", "FirstName");
        }
    }
}
