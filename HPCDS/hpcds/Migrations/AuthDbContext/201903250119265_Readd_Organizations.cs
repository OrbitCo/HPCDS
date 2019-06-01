namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Readd_Organizations : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.OrganizationAddresses",
                c => new
                    {
                        ID = c.Int(nullable: false),
                        OrganizationID = c.Int(nullable: false),
                        AddressType = c.Int(nullable: false),
                        AddressLine1 = c.String(maxLength: 150),
                        AddressLine2 = c.String(maxLength: 100),
                        City = c.String(maxLength: 40),
                        StateProv = c.String(maxLength: 30),
                        PostalCodeNumber = c.String(maxLength: 24),
                        CountryCd = c.String(maxLength: 30),
                    })
                .PrimaryKey(t => t.ID)
                .ForeignKey("dbo.Organizations", t => t.OrganizationID, cascadeDelete: true)
                .Index(t => new { t.OrganizationID, t.AddressType }, unique: true, name: "UQ_OrganizationID_AddressType");
            
            CreateTable(
                "dbo.Organizations",
                c => new
                    {
                        ID = c.Int(nullable: false),
                        PIN = c.String(maxLength: 8),
                        OrganizationName = c.String(nullable: false, maxLength: 50),
                        IsLegacy = c.Boolean(nullable: false),
                        IsActive = c.Boolean(nullable: false),
                        LegacyWaPins = c.String(maxLength: 36),
                        IsSameAsMailingAddress = c.Boolean(nullable: false),
                        CreatedBy = c.Guid(nullable: false),
                        CreatedOn = c.DateTime(nullable: false),
                        ModifiedBy = c.Guid(nullable: false),
                        ModifiedOn = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.ID)
                .Index(t => t.OrganizationName, unique: true, name: "UQ_OrganizationName");
            // Setup Custom SQL -->
            // 01 - Setup Unique Index for Nullable values like OID
            Sql(string.Format(@" CREATE UNIQUE NONCLUSTERED INDEX {0} ON {1}({2}) WHERE {2} IS NOT NULL;"
                                , "UQ_Nullable_PIN", "dbo.Organizations", "PIN"));
            // 02 - Setup Sequence
            Sql(@"CREATE SEQUENCE dbo.SeqOrganizationId as int START WITH 1000 INCREMENT BY 1");
            AlterColumn("dbo.Organizations", "ID", c => c.Int(nullable: false, defaultValueSql: "NEXT VALUE FOR dbo.SeqOrganizationId", name: "DF_SEQ_OrganizationId"));
            // 03 - Setup Sequence
            Sql(@"CREATE SEQUENCE dbo.SeqAddressId as int START WITH 1000 INCREMENT BY 1");
            AlterColumn("dbo.OrganizationAddresses", "ID", c => c.Int(nullable: false, defaultValueSql: "NEXT VALUE FOR dbo.SeqAddressId", name: "DF_SEQ_AddressId"));
            // <--
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.OrganizationAddresses", "OrganizationID", "dbo.Organizations");
            DropIndex("dbo.Organizations", "UQ_OrganizationName");
            DropIndex("dbo.OrganizationAddresses", "UQ_OrganizationID_AddressType");
            DropTable("dbo.Organizations");
            DropTable("dbo.OrganizationAddresses");
            // Drop Sequence -->
            Sql(@"IF OBJECT_ID(N'dbo.SeqOrganizationId', N'SO') IS NOT NULL
                    DROP SEQUENCE dbo.SeqOrganizationId
                  IF OBJECT_ID(N'dbo.SeqAddressId', N'SO') IS NOT NULL
                    DROP SEQUENCE dbo.SeqAddressId");
            // <--
        }
    }
}
