namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Mod_RemovePhone : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.AspNetUsers", "Phone");
        }
        
        public override void Down()
        {
            AddColumn("dbo.AspNetUsers", "Phone", c => c.String(maxLength: 25));
        }
    }
}
