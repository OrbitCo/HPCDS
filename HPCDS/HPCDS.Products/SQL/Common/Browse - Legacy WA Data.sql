SELECT [ReportId]
      ,[ProductBrickId]
      ,[ReporterOrganizationId]
      ,[SubmittedDate]
      ,[CreatedByName]
      ,[CreatedDate]
      ,[ModifiedByName]
      ,[ModifiedDate]
      ,[CopiedFromReportId]
      ,[ReportingState]
  FROM [dbo].[Report]

SELECT [ReportDetailId]
      ,[ReportId]
      ,[ComponentId]
      ,[ChemicalId]
      ,[ChemicalFunctionId]
      ,[ConcentrationCategoryId]
      ,[ConcentrationValue]
      ,[CreatedByName]
      ,[CreatedDate]
      ,[ModifiedByName]
      ,[ModifiedDate]
  FROM [dbo].[ReportDetail]
GO

SELECT *
FROM [WA-ChemicalFunction]
ORDER BY ChemicalFunctionName

SELECT *
FROM [WA-Component]
ORDER BY ComponentName

SELECT *
FROM [WA-ProductBrick]
ORDER BY ProductBrickDescription


SELECt *
FROM [WA-ConcentrationCategory]

SELECT count(*)
FROM [WA-Report] r
	RIGHT JOIN [WA-ReportDetail] d on r.ReportId = d.ReportId
WHERE r.ReportId is null


SELECT d.ConcentrationCategoryId, d.ConcentrationValue, cc.ConcentrationCategoryId, cc.ConcentrationCategoryName, count(*) as cntOfRecords
  FROM [WA-ReportDetail] d
	LEFT JOIN [WA-ConcentrationCategory] cc on d.ConcentrationCategoryId = cc.ConcentrationCategoryId
GROUP BY d.ConcentrationCategoryId, d.ConcentrationValue, cc.ConcentrationCategoryId, cc.ConcentrationCategoryName


SELECT * -- count(*)
FROM [WA-ReportDetail] d										-- Expect 1,000 Details with Brick info
	LEFT JOIN [WA-Report] r on r.ReportId = d.ReportId								-- 99, 901x without a Report record
	LEFT JOIN [WA-ReportAccountableOrganization] rro ON d.ReportId = rro.ReportId	-- 1,035, 2x without Resp-Org for ReportId=102
		LEFT JOIN [WA-CSPAOrganization] ro ON rro.AccountableOrganizationId = ro.AffiliationOrganizationId 
	--		--INNER JOIN dbo.vOrganizations ON dbo.CSPAOrganization.OrganizationPIN = dbo.vOrganizations.PIN
	---- Details
		INNER JOIN [WA-Component] cp ON d.ComponentId = cp.ComponentId 
		INNER JOIN [WA-Chemical] c ON d.ChemicalId = c.ChemicalId 
		INNER JOIN [WA-ChemicalFunction] cf ON d.ChemicalFunctionId = cf.ChemicalFunctionId 
		LEFT JOIN [WA-ConcentrationCategory] cc ON d.ConcentrationCategoryId = cc.ConcentrationCategoryId -- 98 w/report - 1,021 w/d; due to some with concentration value instead of range 
--WHERE r.ReportId is null
WHERE rro.ReportId is null or d.ReportId = 102

