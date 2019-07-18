USE [61Fin]
DECLARE	@code nvarchar(200) = 'LIC'

Select * from ShareIntrinsicValue where code =@code


EXEC	[dbo].[Calculate_Rate]
		@code = @code,
		@forcastYear = 1,
		@marginOfSafty = 0.5


GO