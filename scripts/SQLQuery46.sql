/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [raywhite].[dbo].[Property].[id]
      ,Address.suburb
      ,[raywhite].[dbo].[Property].creationTime
	  ,[raywhite].[dbo].[Property].updatedAt
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
  where typeCode='SAL' 
   and  statusCode = 'CUR' 
   and Address.postCode in( '2179') 
   order by updatedAt desc