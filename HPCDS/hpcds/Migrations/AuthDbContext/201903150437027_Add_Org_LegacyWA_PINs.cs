namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Add_Org_LegacyWA_PINs : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Organizations", "LegacyWaPins", c => c.String(maxLength: 36));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Organizations", "LegacyWaPins");
        }
    }
}
