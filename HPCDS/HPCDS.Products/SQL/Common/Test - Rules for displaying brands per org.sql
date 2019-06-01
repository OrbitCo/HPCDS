
SELECT i.OrganizationId, i.VT_ManufacturerName, max(i.cntOfBrands)
	, SUBSTRING(
		( SELECT '| ' + x.BrandName AS 'data()' 
			FROM (
				SELECT TOP(20) b.BrandName as BrandName
				FROM InventoryBNPM b
				WHERE b.OrganizationId = i.OrganizationId AND (( b.cntOfBrands <= 20 AND b.cntOfModels > 1 ) OR (  b.cntOfBrands > 20 AND b.cntOfModels > 2 ) OR (  b.cntOfBrands <= 3 AND b.cntOfModels <= 3 )) AND LEN(b.BrandName) < 50
				GROUP BY b.BrandName, b.cntOfModels
				ORDER BY b.cntOfModels desc ) x
			ORDER BY x.BrandName
		  FOR XML PATH('') 
		) , 2 , 9999) As Brands
		
	, SUBSTRING(
		( SELECT FORMATMESSAGE('| %s (%i, %i)',b.BrandName, b.cntOfModels, max(b.cntOfChemicals)) AS 'data()' 
				FROM InventoryBNPM b
				WHERE b.OrganizationId = i.OrganizationId -- AND b.cntOfModels > 1
				GROUP BY b.BrandName, b.cntOfModels
				ORDER BY b.cntOfModels desc
			
		  FOR XML PATH('') 
		) , 2 , 9999) As AllBrands

FROM InventoryBNPM i
GROUP BY i.OrganizationId, i.VT_ManufacturerName
ORDER BY i.VT_ManufacturerName 

;

/*
SELECT b.OrganizationId, b.VT_ManufacturerName, b.BrandName, b.cntOfBrands, b.cntOfModels , LEN(b.BrandName)
				FROM InventoryBNPM b
				-- WHERE b.OrganizationId = i.OrganizationId AND 
				WHERE ( b.cntOfBrands <= 20 AND b.cntOfModels > 1 ) OR (  b.cntOfBrands > 20 AND b.cntOfModels > 2 )
				GROUP BY b.OrganizationId, b.VT_ManufacturerName, b.BrandName, b.cntOfBrands, b.cntOfModels
				ORDER BY -- b.cntOfBrands desc, 
				LEN(b.BrandName) desc,
				b.VT_ManufacturerName, b.cntOfModels desc

				*/

				
--TOP 1000 inv.InventoryBNPMId, inv.cntOfChemicals
--	, SUBSTRING(
--		( SELECT FORMATMESSAGE('| %s',invChem.VT_ChemicalNameDescription) AS 'data()' 
--				FROM InventoryBNPMChemical invChem
--				WHERE invChem.InventoryBNPMId = inv.InventoryBNPMId
--				ORDER BY invChem.VT_ChemicalNameDescription
--		  FOR XML PATH('') 
--		) , 2 , 9999) As AllChems

SELECT inv.InventoryBNPMId, inv.OrganizationId, inv.VT_ManufacturerName as OrganizationName -- TODO (HPCDS-127) : Get HPCDS Master Org
	, invChem.ChemicalId
	, invChem.VT_ChemicalNameDescription as ChemicalName -- TODO (HPCDS-86) : Get HPCDS Master Chem name
	, inv.BrandName
	, inv.ProductModel
	, invChem.cntDisclosures
FROM InventoryBNPM inv
	   INNER JOIN InventoryBNPMChemical invChem on inv.InventoryBNPMId = invChem.InventoryBNPMId
WHERE inv.OrganizationId = -1
ORDER BY invChem.VT_ChemicalNameDescription, inv.BrandName, inv.ProductModel

	