# HPCDS
 High Priority Chemicals Data System (HPCDS) a multi-state reporting system of chemical disclosures for kids products


## Instructions
1. Install Git for Windows: https://git-scm.com/download/win 
1. Install Atlassian SourceTree for GUI interface with Git for Windows or iOS: https://www.sourcetreeapp.com/ (optional, but I highly recommend it)
   - Helpful tutorial on SourceTree for a .NET project https://www.lynda.com/Git-tutorials/Source-Code-Control-NET-Git-Using-SourceTree/601791-2.html 
1. Install Visual Studio Community 2017 with (Individual components tab in Visual Studio Community 2017 installer):
   - **.NET**
     - .NET Framework 4.7.2 SDK (download developer pack, https://dotnet.microsoft.com/download/)
    - .NET Framework 4.7.2 targeting pack
   - **Code tools*
     - NuGet package manager
   - **Development activities**
     - C#
   - **SDKs, libraries, and frameworks**
     - Blend for Visual Studio SDK for .NET
     - Entity Framework 6.2 tools
   - **Uncategorized**
     - GitHub extension for Visual Studio
   - ...
1. Clone this repository from GitHub: `git clone https://github.com/Eastern-Research-Group/HPCDS.git`.
1. Get latest development code: `git checkout develop`
1. Retrieve Secret Connection Strings from ERGs SharePoint: **TODO - _secretsERG.7z.pgp**
   - Obtain password for the encrypted file(s) from an ERG developer
   - Use the password provided to extract the contents from the root git directory Or
   - OR create a file, `secretConnStrings.Dev.config`, in the same folder as a Web.config or App.config that has `<connectionStrings>` tag and populate with Server, DB, user/password info like the following:
     ```xml
     <!-- hpcds/Web.config -->
     <connectionStrings>
       <add name="authDbContext"
            connectionString="Data Source=4.36.57.70;Initial Catalog=hpcds-auth;User ID=HPCDS_WEB_USER;Password=SECRET_PASSWORD"
            providerName="System.Data.SqlClient" />
     </connectionStrings>

     <!-- odata/Web.config -->
     <connectionStrings>
       <add name="hpcdsDbContext" connectionString="metadata=res://*/Models.hpcdsModel.csdl|res://*/Models.hpcdsModel.ssdl|res://*/Models.hpcdsModel.msl;provider=System.Data.SqlClient;provider connection string=&quot;
            data source=4.36.57.70;initial catalog=hpcds-dev;
            persist security info=True;user id=HPCDS_WEB_USER;Password=SECRET_PASSWORD;
            MultipleActiveResultSets=True;App=EntityFramework&quot;" 
            providerName="System.Data.EntityClient" />
     </connectionStrings>
     ```
1. Add External NuGet Packages for Telerik and RESTier
   - **Add Source Packages**: via `Manage NuGet Packages...`
   - **Telerik (for hpcds)**: commercial lib, downloaded in `HPCDS.Products\ThirdParty\KendoUI\`
   - **RESTier (nightly build)**: pre-release 1.0 package from nightly build (1/10/2019): https://www.myget.org/F/restier-nightly/api/v3/index.json
1. Open the HPCDS.sln file in the main folder with Visual Studio.
1. Visual Studio usually checks and automatically restore all NuGet packages on opening or starting the application.
   - if the auto-restore fails then open the NuGet Console Manager to either press the `Restore` button or enter on the commandline 
     ```
     PM> Update-Package -reinstall
     ```
1. **Local ONLY** if connecting to `*Dev-Local*.config` and editing data model via Migrations they the following commands come in handy for creating a Migration or Updating the database
   For **authDbContext**
   ```
   PM> Add-Migration -configuration hpcds.Migrations.AuthDbContext.Configuration Initial
   PM> Update-Database -configuration hpcds.Migrations.AuthDbContext.Configuration -Verbose
   ```
   - 101 EF Code-First Resource: http://www.entityframeworktutorial.net/code-first/what-is-code-first.aspx
1. Start the application in Visual Studio, via build or debug.
1. **if error** appears about `rolyn` appears then
   `PM> Update-Package Microsoft.CodeDom.Providers.DotNetCompilerPlatform -r`
   May need change policy to allow
  
  
## Naming and versioning

Production Release will use Semantic Versioning 2: see http://semver.org/ for details.

In short, versions will always use the format X.Y.Z.a in the `Properties\AssemblyInfo.cs` file:
- X represents major versions. This will rarely change. X=1 first production release.
- Y represents minor versions. This should be used for all planned releases for the application.
- Z represents patch versions. This is for bug fixes and unplanned releases.
- a represnets pre-release id. This should be zero on Production, it's only used for internal intermediate releases.

Intermediate Release Versions on GitHub ONLY will use of Hyphenated identifiers and pre-release versions (e.g. `1.0-alpha`, `1.0-beta.3`, `0.7-rc.1`) since it's a bit more client friendly (e.g. `1.2-beta.9b` was temporary AssemblyInfo Id `1.1.9.2`)

## Branches, Gitflow and Pull-Requests
We are using the **Gitflow** workflow via SourceTree: see https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow 
- The `master` branch relfect the latest public version pushed to AWS-Gov, client Production Servers (hpcds.theic2.org/hpcds and hpcds.theic2.org/odata/hpcds)
- The `release\*` branch will reflect the latest version published for client review and Change Request (CR), on  Staging Server (app10.erg.com/hpcds and app10.erg.com/odata)
- The `develop` branch reflects the lastest development work done
- the `feature\*` branches can be created off the develop branch by developers working on series of changes for a particular feature
**GitHub flow** via pull requests are possible as well make sure to indicate `develop` as the base branch and to prefix any branches with `feature\JIRA-#...`


## Notes
- We are not including NuGet packages in version control. Instead, use NuGet Package Restore to restore packages prior to running a build in Visual Studio (should happen automatically on build/start).
- We do not including `.vs\*` settings nor `bin\` or `obj\` build files
- Packages and libraries not loaded via NuGet should be saved in the `HPCDS.Products\ThirdParty\` folder (e.g., Telerik's Commercial version of Kendo.MVC.dll)

## Test - Core Users/Roles
We have created the following users for testing purposes only...
- Site Admin Users:
  - `hpcds@erg.com`, App Admin, used whenever we do back-end batch updates
  - `site.admin@erg.com`, Site Admin, interactive site admin users users
- State Admin Users:
  - `state.admin@erg.com`, State admin for OR-TFKA program
- Repoters/Pending Reporters:
  - `reporter@erg.com`, successfully registered user to the fake `Active Org` (tA5f7h9, 995)
  - `new@erg.com`, pending approval reporter for the fake `Active Org` (tA5f7h9, 995)
  - `newUserOrg@erg.com`, new user and organization post registration pending verification of email and approval for fake `Inactive Org` (996) 
