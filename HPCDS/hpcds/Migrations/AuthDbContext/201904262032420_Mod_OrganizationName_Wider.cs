namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Mod_OrganizationName_Wider : DbMigration
    {
        public override void Up()
        {
            DropIndex("dbo.Organizations", "UQ_OrganizationName");
            AlterColumn("dbo.Organizations", "OrganizationName", c => c.String(nullable: false, maxLength: 255));
            CreateIndex("dbo.Organizations", "OrganizationName", unique: true, name: "UQ_OrganizationName");
        }
        
        public override void Down()
        {
            DropIndex("dbo.Organizations", "UQ_OrganizationName");
            AlterColumn("dbo.Organizations", "OrganizationName", c => c.String(nullable: false, maxLength: 50));
            CreateIndex("dbo.Organizations", "OrganizationName", unique: true, name: "UQ_OrganizationName");
        }
    }
}
