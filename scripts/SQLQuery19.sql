/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) 
      [raywhite].[dbo].[Property].creationTime
	  ,[raywhite].[dbo].[Property].updatedAt
	  ,[raywhite].[dbo].[Property].[id]
      ,Address.suburb
	  ,typeCode
      ,[raywhite].[dbo].[Property].[price]
      ,[raywhite].[dbo].[Property].[soldPrice]
      ,[raywhite].[dbo].[Property].[displayPrice]
      ,[raywhite].[dbo].[Property].[soldDate]
      ,[raywhite].[dbo].[Property].[bond]
      ,[raywhite].[dbo].[Property].[bedrooms]
      ,[raywhite].[dbo].[Property].[bathrooms]
      ,[raywhite].[dbo].[Property].[carSpaces]	  
      ,Address.formatted
	  ,description
  FROM [raywhite].[dbo].[Property] join [raywhite].[dbo].Address on [raywhite].[dbo].Address.id = [raywhite].[dbo].[Property].addressId
  where statusCode = 'CUR' and typeCode = 'SAL'  
  and Address.stateCode = 'NSW' And Address.postCode < 2200 and CAST(price AS decimal) < 1000000
  and bedrooms = 2
  and [raywhite].[dbo].[Property].updatedAt > '2019-05-10'
   order by suburb desc