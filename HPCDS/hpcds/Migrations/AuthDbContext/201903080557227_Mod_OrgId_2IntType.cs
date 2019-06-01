namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Mod_OrgId_2IntType : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "O_ID", c => c.Int(nullable: false));
            AddColumn("dbo.AspNetUsers", "O_GUID", c => c.Guid(nullable: false));
            DropColumn("dbo.AspNetUsers", "OrgID");
        }
        
        public override void Down()
        {
            AddColumn("dbo.AspNetUsers", "OrgID", c => c.Guid(nullable: false));
            DropColumn("dbo.AspNetUsers", "O_GUID");
            DropColumn("dbo.AspNetUsers", "O_ID");
        }
    }
}
