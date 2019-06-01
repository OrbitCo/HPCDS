namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Del_OrgAndAddress : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Organizations", new[] { "MO_ID", "PhysicalAddress_AddressType" }, "dbo.AddressLocations");
            DropForeignKey("dbo.Organizations", new[] { "MO_ID", "MailingAddress_AddressType" }, "dbo.AddressLocations");
            DropIndex("dbo.Organizations", new[] { "MO_ID", "PhysicalAddress_AddressType" });
            DropIndex("dbo.Organizations", new[] { "MO_ID", "MailingAddress_AddressType" });
            DropIndex("dbo.Organizations", "UQ_OrganizationName");
            DropIndex("dbo.Organizations", "UQ_Nullable_OID");
            DropIndex("dbo.Organizations", "UQ_OrgId");
            DropTable("dbo.Organizations");
            DropTable("dbo.AddressLocations");
            Sql(@"IF OBJECT_ID(N'dbo.SeqOrganizationId', N'SO') IS NOT NULL
                    DROP SEQUENCE dbo.SeqOrganizationId");

            // NOTE : SEED will break after this update
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.AddressLocations",
                c => new
                {
                    MO_ID = c.Int(nullable: false),
                    AddressType = c.Int(nullable: false),
                    AddressLine1 = c.String(nullable: false, maxLength: 150),
                    AddressLine2 = c.String(maxLength: 100),
                    City = c.String(maxLength: 40),
                    StateProv = c.String(maxLength: 30),
                    PostalCodeNumber = c.String(maxLength: 24),
                    CountryCd = c.String(maxLength: 30),
                })
                .PrimaryKey(t => new { t.MO_ID, t.AddressType });

            CreateTable(
                "dbo.Organizations",
                c => new
                {
                    MO_ID = c.Int(nullable: false),
                    OID = c.String(maxLength: 8),
                    OrganizationName = c.String(nullable: false, maxLength: 50),
                    IsLegacy = c.Boolean(nullable: false),
                    IsActive = c.Boolean(nullable: false),
                    // -->
                    LegacyWaPins = c.String(maxLength: 36),
                    // <--
                    IsMailingAddressDiff = c.Boolean(nullable: false),
                    CreatedBy = c.Guid(nullable: false),
                    CreatedOn = c.DateTime(nullable: false),
                    ModifiedBy = c.Guid(nullable: false),
                    ModifiedOn = c.DateTime(nullable: false),
                    MailingAddress_AddressType = c.Int(),
                    PhysicalAddress_AddressType = c.Int(nullable: false),
                })
                .PrimaryKey(t => t.MO_ID)
                .ForeignKey("dbo.AddressLocations", t => new { t.MO_ID, t.MailingAddress_AddressType }, name: "FK_Organization_MailingAddress")
                .ForeignKey("dbo.AddressLocations", t => new { t.MO_ID, t.PhysicalAddress_AddressType }, name: "FK_Organization_PhysicalAddress", cascadeDelete: true)
                .Index(t => t.MO_ID, unique: true, name: "UQ_OrgId")
                .Index(t => t.OrganizationName, unique: true, name: "UQ_OrganizationName")
                .Index(t => new { t.MO_ID, t.MailingAddress_AddressType })
                .Index(t => new { t.MO_ID, t.PhysicalAddress_AddressType });
            // -->
            // Setup Unique Index for Nullable values like OID
            Sql(string.Format(@" CREATE UNIQUE NONCLUSTERED INDEX {0} ON {1}({2}) WHERE {2} IS NOT NULL;"
                                , "UQ_Nullable_OID", "dbo.Organizations", "OID"));
            // Setup Sequence
            Sql(@"CREATE SEQUENCE dbo.SeqOrganizationId as int START WITH 1000 INCREMENT BY 1");
            AlterColumn("dbo.Organizations", "MO_ID", c => c.Int(nullable: false, defaultValueSql: "NEXT VALUE FOR dbo.SeqOrganizationId", name: "DF_SEQ_OrganizationId"));
            // <--
        }
    }
}
