namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Add_PrimaryContactForOrg : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Organizations", "ContactUserId", c => c.String(maxLength: 128));
            AddColumn("dbo.Organizations", "DUNSNumber", c => c.String(maxLength: 9));
            AddColumn("dbo.AspNetUsers", "JobTitle", c => c.String(maxLength: 50));
            CreateIndex("dbo.Organizations", "ContactUserId");
            AddForeignKey("dbo.Organizations", "ContactUserId", "dbo.AspNetUsers", "Id");
            // Manually set a primary contact for the Orgs that have at least one memeber (HPCDS-131) -->
            Sql(@"UPDATE [dbo].[Organizations]
                   SET [ContactUserId] = u.Id
                   FROM Organizations o
	                INNER JOIN (
		                SELECT f.O_ID, max(f.Id) as Id
		                FROM AspNetUsers f 
		                WHERE NOT f.UserName LIKE 'e0%'
		                GROUP BY f.O_ID
		                ) as u on u.O_ID = o.ID  ;");
            // <--
        }

        public override void Down()
        {
            DropForeignKey("dbo.Organizations", "ContactUserId", "dbo.AspNetUsers");
            DropIndex("dbo.Organizations", new[] { "ContactUserId" });
            DropColumn("dbo.AspNetUsers", "JobTitle");
            DropColumn("dbo.Organizations", "DUNSNumber");
            DropColumn("dbo.Organizations", "ContactUserId");
        }
    }
}
