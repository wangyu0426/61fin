Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server
Imports Microsoft.VisualBasic
Imports Fin = Microsoft.VisualBasic.Financial
Partial Public Class ExcelFunctions
    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
    Public Shared Function FV(ByVal Rate As Double, ByVal NPer As Double, ByVal Pmt As Double, Optional ByVal PV As Double = 0, Optional ByVal Type As Boolean = False) As SqlDouble
        Dim FutureValue As Double
        If Type = True Then
            FutureValue = Math.Round(Fin.FV(Rate, NPer, Pmt, PV, DueDate.BegOfPeriod), 2)
        Else
            FutureValue = Math.Round(Fin.FV(Rate, NPer, Pmt, PV, DueDate.EndOfPeriod), 2)
        End If
        Return New SqlDouble(FutureValue)
    End Function
    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
    Public Shared Function PV(ByVal Rate As Double, ByVal NPer As Double, ByVal Pmt As Double, Optional ByVal FV As Double = 0, Optional ByVal Type As Boolean = False) As SqlDouble
        Dim PresentValue As Double
        If Type = True Then
            PresentValue = Math.Round(Fin.PV(Rate, NPer, Pmt, FV, DueDate.BegOfPeriod), 2)
        Else
            PresentValue = Math.Round(Fin.PV(Rate, NPer, Pmt, FV, DueDate.EndOfPeriod), 2)
        End If
        Return New SqlDouble(PresentValue)
    End Function

    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
   Public Shared Function Rate(ByVal NPer As Double, ByVal Pmt As Double, ByVal PV As Double, Optional ByVal FV As Double = 0, Optional ByVal Type As Boolean = True, Optional ByVal Guess As Double = 0.1) As SqlDouble
        Dim RateValue As Double
        If Type = True Then
            RateValue = Math.Round(Fin.Rate(NPer, Pmt, PV, FV, DueDate.BegOfPeriod, Guess), 4)
        Else
            RateValue = Math.Round(Fin.Rate(NPer, Pmt, PV, FV, DueDate.EndOfPeriod, Guess), 4)
        End If
        Return New SqlDouble(RateValue)
    End Function
    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
   Public Shared Function DDB(ByVal Cost As Double, ByVal Salvage As Double, ByVal Life As Double, ByVal Period As Double, Optional ByVal Factor As Double = 2.0) As SqlDouble
        Dim DDBValue As Double
        DDBValue = Math.Round(Fin.DDB(Cost, Salvage, Life, Period, Factor), 4)
        Return New SqlDouble(DDBValue)
    End Function

    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
        Public Shared Function IPMT(ByVal Rate As Double, ByVal NPer As Double, ByVal PV As Double, Optional ByVal FV As Double = 0.0, Optional ByVal Type As Boolean = False) As SqlDouble
        Dim IPMTValue As Double
        If Type = True Then
            IPMTValue = Math.Round(Fin.IPmt(Rate, NPer, PV, FV, DueDate.BegOfPeriod), 2)
        Else
            IPMTValue = Math.Round(Fin.IPmt(Rate, NPer, PV, FV, DueDate.EndOfPeriod), 2)
        End If
        Return New SqlDouble(IPMTValue)
    End Function
    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
        Public Shared Function PPMT(ByVal Rate As Double, ByVal Per As Double, ByVal NPer As Double, ByVal PV As Double, Optional ByVal FV As Double = 0.0, Optional ByVal Type As Boolean = False) As SqlDouble
        Dim PPMTValue As Double
        If Type = True Then
            PPMTValue = Math.Round(Fin.PPmt(Rate, Per, NPer, PV, FV, DueDate.BegOfPeriod), 2)
        Else
            PPMTValue = Math.Round(Fin.PPmt(Rate, Per, NPer, PV, FV, DueDate.EndOfPeriod), 2)
        End If
        Return New SqlDouble(PPMTValue)
    End Function
    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
     Public Shared Function SLN(ByVal Cost As Double, ByVal Salvage As Double, ByVal Life As Double) As SqlDouble
        Dim SLNValue As Double
        SLNValue = Math.Round(Fin.SLN(Cost, Salvage, Life), 2)
        Return New SqlDouble(SLNValue)
    End Function
    <Microsoft.SqlServer.Server.SqlFunction(IsDeterministic:=True, IsPrecise:=True)> _
      Public Shared Function SYD(ByVal Cost As Double, ByVal Salvage As Double, ByVal Life As Double, ByVal Period As Double) As SqlDouble
        Dim DDBValue As Double
        DDBValue = Math.Round(Fin.SYD(Cost, Salvage, Life, Period), 2)
        Return New SqlDouble(DDBValue)
    End Function
End Class
