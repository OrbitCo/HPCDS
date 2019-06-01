namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Add_FKey_User2Org : DbMigration
    {
        public override void Up()
        {
            // Manually create temp Org before setting FKey -->
            Sql(@"INSERT INTO [dbo].[Organizations]([ID],[PIN],[OrganizationName],[IsLegacy],[IsActive],[LegacyWaPins],[IsSameAsMailingAddress],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])
                    VALUES                         (  -1, null,'TBD'             , 0        , 0        , null         , 1                      , '00000000-0000-0000-0000-000000000000', GETUTCDATE()   , '00000000-0000-0000-0000-000000000000', GETUTCDATE());
                  UPDATE dbo.AspNetUsers SET O_ID = -1 WHERE O_ID < 1;");
            // <--
            CreateIndex("dbo.AspNetUsers", "O_ID");
            AddForeignKey("dbo.AspNetUsers", "O_ID", "dbo.Organizations", "ID");
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.AspNetUsers", "O_ID", "dbo.Organizations");
            DropIndex("dbo.AspNetUsers", new[] { "O_ID" });
        }
    }
}
