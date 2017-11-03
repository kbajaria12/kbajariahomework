Sub refresh_stock_analysis()

    'Initialize variables, set source & target worksheets
    'Set source worksheet
    Dim StockData As Worksheet: Set StockData = Worksheets("Stock_data_2016")
    'Set target worksheet
    Dim StockAnalysis As Worksheet: Set StockAnalysis = Worksheets("Solution")
    Dim RowCount As Long
    RowCount = 0
    SrcTickerCol = 1
    SrcDateCol = 2
    SrcOpenPriceCol = 3
    SrcHighPriceCol = 4
    SrcLowPriceCol = 5
    SrcClosePriceCol = 6
    SrcVolCol = 7
    SrcStartRow = 2
    Dim SrcCurrentRow As Long: SrcCurrentRow = 0
    TgtTickerCol = 1
    TgtTotalChgCol = 2
    TgtPctChgCol = 3
    TgtAvgDailyChgCol = 4
    TgtTotalVolCol = 5
    TgtStartRow = 5
    TgtCurrentRow = TgtStartRow + 1
    StockAnalysis.Cells(TgtStartRow, TgtTickerCol) = "Ticker"
    StockAnalysis.Cells(TgtStartRow, TgtTotalChgCol) = "Total Change"
    StockAnalysis.Cells(TgtStartRow, TgtPctChgCol) = "% Change"
    StockAnalysis.Cells(TgtStartRow, TgtAvgDailyChgCol) = "Avg. Daily Change"
    StockAnalysis.Cells(TgtStartRow, TgtTotalVolCol) = "Volume"
    Dim VolumeAccumulator As Double: VolumeAccumulator = 0
    Dim LastRow As Long: LastRow = StockData.UsedRange.Find("*", SearchOrder:=xlByRows, SearchDirection:=xlPrevious).Row - 1
    LastTicker = StockData.Cells(SrcStartRow, SrcTickerCol)
    StartPrice = StockData.Cells(SrcStartRow, SrcOpenPriceCol)
    PreviousChangeRow = SrcStartRow
    GreatestPercentIncrease = 0
    GreatestPercentIncreaseTicker = ""
    GreatestPrecentDecrease = 0
    GreatestPrecentDecreaseTicker = ""
    GreatestVolume = 0
    GreatestVolumeTicker = ""
    GreatestAvgChg = 0
    GreatestAvgChgTicker = ""
    MaximumsLabelColumn = 7
    MaximumsTickerColumn = 9
    MaximumsValueColumn = 8
    GreatestPercentIncreaseRow = 7
    GreatestPercentDecreaseRow = 9
    GreatestVolumeRow = 5
    GreatestAvgChangeRow = 11
    Dim CurrentRange As Range
    
    'Loop through all rows in the source data
    
    For SrcCurrentRow = SrcStartRow To LastRow
        
        CurrentTicker = StockData.Cells(SrcCurrentRow, SrcTickerCol)
 
        'Determine if the ticker has changed in the current source row
        
        If CurrentTicker <> LastTicker Then
        
            'Perform row computations
            TotalDays = SrcCurrentRow - PreviousChangeRow
            YrClosePrice = StockData.Cells(SrcCurrentRow - 1, SrcClosePriceCol)
            TotalStockChange = YrClosePrice - StartPrice
            AvgDailyChg = TotalStockChange / TotalDays
            percentChange = TotalStockChange / StartPrice
            
            'Determine maximums
            If percentChange < 0 Then
                StockAnalysis.Cells(TgtCurrentRow, TgtTotalChgCol).Interior.Color = RGB(255, 0, 0)
                            
                If percentChange < GreatestPercentDecrease Then
                    GreatestPercentDecrease = percentChange
                    GreatestPercentDecreaseTicker = CurrentTicker
                End If
                
            End If
            
            If percentChange > 0 Then
                StockAnalysis.Cells(TgtCurrentRow, TgtTotalChgCol).Interior.Color = RGB(0, 255, 0)
                      
                If percentChange > GreatestPercentIncreae Then
                    GreatestPercentIncrease = percentChange
                    GreatestPercentIncreaseTicker = CurrentTicker
                End If
                
            End If
            
            If VolumeAccumulator > GreatestVolume Then
                GreatestVolume = VolumeAccumulator
                GreatestVolumeTicker = CurrentTicker
            End If
            
            If AvgDailyChg > GreatestAvgChange Then
                GreatestAvgChange = AvgDailyChg
                GreatestAvgChangeTicker = CurrentTicker
            End If
            
            'Write output cells
            StockAnalysis.Cells(TgtCurrentRow, TgtTickerCol) = CurrentTicker
            StockAnalysis.Cells(TgtCurrentRow, TgtTotalVolCol) = VolumeAccumulator
            StockAnalysis.Cells(TgtCurrentRow, TgtTotalChgCol) = TotalStockChange
            StockAnalysis.Cells(TgtCurrentRow, TgtPctChgCol) = percentChange
            StockAnalysis.Cells(TgtCurrentRow, TgtAvgDailyChgCol) = AvgDailyChg
            
            'Reset inner accumulators, counters, and markers
            LastTicker = CurrentTicker
            TgtCurrentRow = TgtCurrentRow + 1
            VolumeAccumulator = 0
            PreviousChangeRow = SrcCurrentRow

        End If
        
        'Update outer accumulators
        VolumeAccumulator = VolumeAccumulator + StockData.Cells(SrcCurrentRow, SrcVolCol)
        
    Next SrcCurrentRow
    
'Write maximums summary data

StockAnalysis.Cells(GreatestPercentIncreaseRow, MaximumsLabelColumn) = "Greatest % Increase"
StockAnalysis.Cells(GreatestPercentIncreaseRow, MaximumsTickerColumn) = GreatestPercentIncreaseTicker
StockAnalysis.Cells(GreatestPercentIncreaseRow, MaximumsValueColumn) = GreatestPercentIncrease

StockAnalysis.Cells(GreatestPercentDecreaseRow, MaximumsLabelColumn) = "Greatest % Decrease"
StockAnalysis.Cells(GreatestPercentDecreaseRow, MaximumsTickerColumn) = GreatestPercentDecreaseTicker
StockAnalysis.Cells(GreatestPercentDecreaseRow, MaximumsValueColumn) = GreatestPercentDecrease

StockAnalysis.Cells(GreatestVolumeRow, MaximumsLabelColumn) = "GreatestVolume"
StockAnalysis.Cells(GreatestVolumeRow, MaximumsTickerColumn) = GreatestVolumeTicker
StockAnalysis.Cells(GreatestVolumeRow, MaximumsValueColumn) = GreatestVolume

StockAnalysis.Cells(GreatestAvgChangeRow, MaximumsLabelColumn) = "Greatest Avg Change"
StockAnalysis.Cells(GreatestAvgChangeRow, MaximumsTickerColumn) = GreatestAvgChangeTicker
StockAnalysis.Cells(GreatestAvgChangeRow, MaximumsValueColumn) = GreatestAvgChange

End Sub