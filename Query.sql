/****** Script for SelectTopNRows command from SSMS ******/
DECLARE db_cursor CURSOR FOR 
select distinct code 
FROM [61Fin].[dbo].[Financial]

DECLARE @code AS NVARCHAR(MAX);

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @code  
WHILE @@FETCH_STATUS = 0  
BEGIN  

	SELECT	Code, 
			Currency
			[Type],
			[EndDate],
			[FiscalYear],
			[CoaCode],
			[Value]
			into #temptable
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
	where code = @code

	DECLARE @temp AS NVARCHAR(MAX),
		@cols AS NVARCHAR(MAX),
		@query  AS NVARCHAR(MAX)
	select @temp = (SELECT ',' +code
		FROM CodeList 
		FOR XML PATH(''));
	select @cols = Stuff(@temp,1,1,'')
	set @query = 
	'Insert  Into FinReport (Code, Type, EndDate,FiscalYear,'+@cols+')
		(select Code, Type, EndDate,FiscalYear,'+@cols+'
		from #temptable
		pivot
		(
			Max([Value])
			for CoaCode in ('+@cols+')
		) piv
	);'

	execute(@query);
	DROP TABLE #TempTable
FETCH NEXT FROM db_cursor INTO @code 
END 
CLOSE db_cursor  
DEALLOCATE db_cursor
-- select * from FinReport
-- delete from FinReport


