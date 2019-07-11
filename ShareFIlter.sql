Select 
s.Code,
s.Growth,
s.ForcastPE_APENORM,
(1-price.[CLOSE]/TargetPrice)*100 as MarginOfSafty,
price.[CLOSE] as Price,
s.TargetPrice,
s.BuyPrice,
* 
From ShareIntrinsicValue S LEFT JOIN price on price.code = s.Code
where s.ForcastPE_APENORM > 0
and s.Growth >0
and s.Sales >0
and s.EPS >0
and s.EQUITY >0
and s.FCF >0
and s.TargetPrice > 0
and s.AllPositive = 1
and (price.[CLOSE] <= TargetPrice*0.9 or price.[CLOSE] is null)
and TargetPrice >5
ORDER by  (price.[CLOSE]/TargetPrice)