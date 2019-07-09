/****** Script for SelectTopNRows command from SSMS ******/
SELECT	Code, 
		Currency
		[Type],
		[EndDate],
		[FiscalYear],
		[StatementType],
		[CoaCode],
		[Value]
FROM [61Fin].[dbo].[Financial] F 
CROSS APPLY OPENJSON (F.[report]) 
with (
	[FiscalPeriod] nvarchar(max) '$.FiscalPeriod' as json
) R
cross apply openjson( R.FiscalPeriod )
with (
	[Type] nvarchar(max) '$.Type' ,
	[EndDate] nvarchar(max) '$.EndDate' ,
	[FiscalYear] nvarchar(max) '$.FiscalYear' ,
	[Statement] nvarchar(max) '$.Statement' as json) A
cross apply	openjson( A.Statement )
with (
	StatementType varchar(max) '$.Type',
	[StatementValue] nvarchar(max) '$.lineItem' as Json) B
cross apply	openjson( B.[StatementValue] )
with (
	[CoaCode] varchar(200) '$.coaCode' ,
	[Value] varchar(200) '$.Value'
) C
where code = 'bal'
