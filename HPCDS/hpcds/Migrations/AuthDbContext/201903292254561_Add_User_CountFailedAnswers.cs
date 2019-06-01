namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Add_User_CountFailedAnswers : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "SecQandAFailCount", c => c.Int(nullable: false, defaultValue: 0));
            DropColumn("dbo.AspNetUsers", "O_GUID");
        }
        
        public override void Down()
        {
            AddColumn("dbo.AspNetUsers", "O_GUID", c => c.Guid(nullable: false));
            DropColumn("dbo.AspNetUsers", "SecQandAFailCount");
        }
    }
}
