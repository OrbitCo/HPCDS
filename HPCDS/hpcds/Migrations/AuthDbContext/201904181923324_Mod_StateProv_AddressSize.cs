namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Mod_StateProv_AddressSize : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.OrganizationAddresses", "StateProv", c => c.String(maxLength: 70));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.OrganizationAddresses", "StateProv", c => c.String(maxLength: 30));
        }
    }
}
