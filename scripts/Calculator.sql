declare @code varchar(max) = 'AWC';
declare @forcastYear int = 1;
declare @targetReturn decimal(12,6) = 0.09;
declare @marginOfSafty decimal(12,6) = 0.5;
declare @minYear int ;
declare @maxYear int ;
select @maxYear = max(FiscalYear), @minYear = min(FiscalYear) from finReport where code = @code
declare @minRTLR decimal(12,6);
declare @maxRTLR decimal(12,6);
declare @minVDES decimal(12,6);
declare @maxVDES decimal(12,6);
declare @minQTLE decimal(12,6);
declare @maxQTLE decimal(12,6);
declare @minOTLO decimal(12,6);
declare @maxOTLO decimal(12,6);
declare @minSCEX decimal(12,6);
declare @maxSCEX decimal(12,6);
declare @currentAsset decimal(12,6);
declare @currentLiabilities decimal(12,6);
declare @totalLiabilities decimal(12,6);

select 
@minRTLR= CAST(RTLR AS decimal(12,6)),
@minVDES= CAST(VDES AS decimal(12,6)),
@minQTLE= CAST(QTLE AS decimal(12,6)),
@minOTLO= CAST(OTLO AS decimal(12,6)),
@minSCEX= iif(SCEX is not null, CAST(SCEX AS decimal(12,6)), 0.0001)
from finReport where code = @code and fiscalYear = @minYear;
select 
@maxRTLR= CAST(RTLR AS decimal(12,6)),
@maxVDES= CAST(VDES AS decimal(12,6)),
@maxQTLE= CAST(QTLE AS decimal(12,6)),
@maxOTLO= CAST(OTLO AS decimal(12,6)),
@maxSCEX= iif(SCEX is not null, CAST(SCEX AS decimal(12,6)), 0.0001),
@currentAsset= CAST(ATCA AS decimal(12,6)),
@currentLiabilities = CAST(LTCL AS decimal(12,6)),
@totalLiabilities = CAST(LTLL AS decimal(12,6))
from finReport where code = @code and fiscalYear = @maxYear;

declare @minFcf decimal(12,6); select @minFcf = (@minOTLO+@minSCEX)
declare @maxFcf decimal(12,6); select @maxFcf = (@maxOTLO+@maxSCEX)

--Ratio
declare @EpsTTM decimal(12,6);
declare @ROIC1 decimal(12,6);
declare @ROIC5 decimal(12,6);
declare @ForcastPE decimal(12,6);

SELECT
@ROIC1 = CAST(AROIPCT AS decimal(12,6)),
@ROIC5 = CAST(AROI5YRAVG AS decimal(12,6)),
@EpsTTM = CAST(TTMEPSINCX AS decimal(12,6)),
@ForcastPE = CAST(APENORM AS decimal(12,6))
from finRatioReport where code = @code and year([date]) = @maxYear;


declare @RTLR decimal(12,6) = dbo.CalRate(@minRTLR,@maxRTLR,@maxYear-@minYear);
declare @VDES decimal(12,6) = dbo.CalRate(@minVDES,@maxVDES,@maxYear-@minYear);
declare @QTLE decimal(12,6) = dbo.CalRate(@minQTLE,@maxQTLE,@maxYear-@minYear);
declare @Fcf decimal(12,6)  = dbo.CalRate(@minFcf,@maxFcf,@maxYear-@minYear);
declare @Growth decimal(12,6) = (@RTLR+@VDES+@QTLE+@Fcf)/4;
declare @targetPrice decimal(12,6) = (@EpsTTM*@ForcastPE*POWER((1+@Growth),@forcastYear))/POWER((1+@targetReturn),@forcastYear);
select
 @code as 'Code',
 @minYear as 'StartYear',
 @maxYear as 'EndYear',
 @forcastYear as 'ForcastYears',
 @ForcastPE as ForcastPE_APENORM,
 @targetPrice as 'TargetPrice',
 @targetPrice*(1-@marginOfSafty) as 'BuyPrice',
 iif(@minRTLR >0 and @maxRTLR >0 and @minVDES >0 and @maxVDES >0 
 and @minQTLE >0 and @maxQTLE >0 and @minFcf >0 and @maxFcf >0 and 
 @EpsTTM >0
 , 1,0) as 'AllPositive' , 
 @Growth as Growth,
 @RTLR  as Sales,
 @VDES  as EPS,
 @QTLE  as EQUITY,
 @Fcf as FCF,
 @ROIC1  as ROIC1,
 @ROIC5  as ROIC5,
 @EpsTTM  as EpsTTM,
 @currentAsset/@currentLiabilities  as CurrentRatio,
 @totalLiabilities/@maxQTLE  as DebtToquityRatio,
 @currentAsset as CurrentAsset,
 @currentLiabilities as CurrentLiabilities,
 @totalLiabilities as TotalLiabilities,
 @minRTLR as 'MinSales',					@maxRTLR as 'MaxSales',
 @minVDES as 'MinEPS',						@maxVDES as 'MaxEPS',
 @minQTLE as 'MinEquity',					@maxQTLE as 'MaxEquity',
 @minOTLO as 'MinOperatingCashFlow',		@maxOTLO as 'MaxOperatingCashFlow',
 @minSCEX as 'MinEquatyExpanse',			@maxSCEX as 'MaxEquatyExpanse',
 @minFcf as 'MinFCF',						@maxFcf as 'MaxFCF',
 @ROIC1 as 'ROIC1Year',						@ROIC5 as 'ROIC5Year'
