/****** Script for SelectTopNRows command from SSMS ******/
DECLARE db_cursor CURSOR FOR 
select distinct code 
FROM [61Fin].[dbo].[Financial]

DECLARE @code AS NVARCHAR(MAX);

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @code  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 --declare @code varchar(200) = 'BAL'
	SELECT	Code, 
			Currency,
			[date],
			[FieldCode],
			[Value]
			into #temptable
	FROM [61Fin].[dbo].[FinancialRatio] F 
	CROSS APPLY OPENJSON (F.[RatioReport]) 
	with (
		[Ratio] nvarchar(max) '$.Ratio' as json
	) R
	cross apply openjson( R.Ratio )
	with (
		[FieldCode] varchar(200) '$.FieldName' ,
		[Value] varchar(200) '$.Value'
	) C
	where code = @code

	DECLARE @temp AS NVARCHAR(MAX),
		@cols AS NVARCHAR(MAX),
		@query  AS NVARCHAR(MAX)
	select @temp = (SELECT ',' +code
		FROM RatioCodeList 
		FOR XML PATH(''));
	select @cols = Stuff(@temp,1,1,'')
	set @query = 
	'Insert  Into FinRatioReport (Code, Currency, date,'+@cols+')
		(select Code, Currency, date,'+@cols+' 
		from #temptable
		pivot
		(
			Max([Value])
			for FieldCode in ('+@cols+')
		) piv
	);'

	execute(@query);
	DROP TABLE #TempTable
FETCH NEXT FROM db_cursor INTO @code 
END 
CLOSE db_cursor  
DEALLOCATE db_cursor
-- select * from FinRatioReport
-- delete from FinRatioReport


