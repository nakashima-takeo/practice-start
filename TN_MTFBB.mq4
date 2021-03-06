//+------------------------------------------------------------------+
//|                                                     TN_MTFBB.mq4 |
//|                                                               TN |
//|                                                                  |
//+------------------------------------------------------------------+
  #property copyright "TN"
  #property version   "1.00"
  #property strict
  #property indicator_chart_window
  enum TimeFrame_List
          {
              no =0,//無し
              M5 =5,//5分足
              M15=15,//15分足
              M30=30,//30分足
              H1=60,//一時間足
              H4=240,//4時間足
              D1=1440,//日足
              W1=10080,//週足
          };
//週足から順番に定義していく

  #property indicator_buffers 20
//週足
  #property indicator_type1 DRAW_LINE
  #property indicator_color1 clrFireBrick
  #property indicator_style1 STYLE_SOLID
  #property indicator_width1 5
  #property indicator_type2 DRAW_LINE
  #property indicator_color2 clrMidnightBlue
  #property indicator_style2 STYLE_SOLID
  #property indicator_width2 5
  #property indicator_type3 DRAW_LINE
  #property indicator_color3 clrMidnightBlue
  #property indicator_style3 STYLE_SOLID
  #property indicator_width3 5
  #property indicator_type4 DRAW_LINE
  #property indicator_color4 clrCornsilk
  #property indicator_style4 STYLE_SOLID
  #property indicator_width4 5
  #property indicator_type5 DRAW_LINE
  #property indicator_color5 clrCornsilk
  #property indicator_style5 STYLE_SOLID
  #property indicator_width5 5
//日足
  #property indicator_type6 DRAW_LINE
  #property indicator_color6 clrFireBrick
  #property indicator_style6 STYLE_SOLID
  #property indicator_width6 4
  #property indicator_type7 DRAW_LINE
  #property indicator_color7 clrMidnightBlue
  #property indicator_style7 STYLE_SOLID
  #property indicator_width7 4
  #property indicator_type8 DRAW_LINE
  #property indicator_color8 clrMidnightBlue
  #property indicator_style8 STYLE_SOLID
  #property indicator_width8 4
  #property indicator_type9 DRAW_LINE
  #property indicator_color9 clrCornsilk
  #property indicator_style9 STYLE_SOLID
  #property indicator_width9 4
  #property indicator_type10 DRAW_LINE
  #property indicator_color10 clrCornsilk
  #property indicator_style10 STYLE_SOLID
  #property indicator_width10 4
//日足
  #property indicator_type6 DRAW_LINE
  #property indicator_color6 clrFireBrick
  #property indicator_style6 STYLE_SOLID
  #property indicator_width6 4
  #property indicator_type7 DRAW_LINE
  #property indicator_color7 clrMidnightBlue
  #property indicator_style7 STYLE_SOLID
  #property indicator_width7 4
  #property indicator_type8 DRAW_LINE
  #property indicator_color8 clrMidnightBlue
  #property indicator_style8 STYLE_SOLID
  #property indicator_width8 4
  #property indicator_type9 DRAW_LINE
  #property indicator_color9 clrCornsilk
  #property indicator_style9 STYLE_SOLID
  #property indicator_width9 4
  #property indicator_type10 DRAW_LINE
  #property indicator_color10 clrCornsilk
  #property indicator_style10 STYLE_SOLID
  #property indicator_width10 4
//四時間足
  #property indicator_type11 DRAW_LINE
  #property indicator_color11 clrFireBrick
  #property indicator_style11 STYLE_SOLID
  #property indicator_width11 3
  #property indicator_type12 DRAW_LINE
  #property indicator_color12 clrMidnightBlue
  #property indicator_style12 STYLE_SOLID
  #property indicator_width12 3
  #property indicator_type13 DRAW_LINE
  #property indicator_color13 clrMidnightBlue
  #property indicator_style13 STYLE_SOLID
  #property indicator_width13 3
  #property indicator_type14 DRAW_LINE
  #property indicator_color14 clrCornsilk
  #property indicator_style14 STYLE_SOLID
  #property indicator_width14 3
  #property indicator_type15 DRAW_LINE
  #property indicator_color15 clrCornsilk
  #property indicator_style15 STYLE_SOLID
  #property indicator_width15 3
//一時間足
  #property indicator_type16 DRAW_LINE
  #property indicator_color16 clrFireBrick
  #property indicator_style16 STYLE_SOLID
  #property indicator_width16 1
  #property indicator_type17 DRAW_LINE
  #property indicator_color17 clrMidnightBlue
  #property indicator_style17 STYLE_SOLID
  #property indicator_width17 1
  #property indicator_type18 DRAW_LINE
  #property indicator_color18 clrMidnightBlue
  #property indicator_style18 STYLE_SOLID
  #property indicator_width18 1
  #property indicator_type19 DRAW_LINE
  #property indicator_color19 clrCornsilk
  #property indicator_style19 STYLE_SOLID
  #property indicator_width19 1
  #property indicator_type20 DRAW_LINE
  #property indicator_color20 clrCornsilk
  #property indicator_style20 STYLE_SOLID
  #property indicator_width20 1


//タイムフレーム設定
  input TimeFrame_List TimeFrame1 = 10080; //週足
  input TimeFrame_List TimeFrame2 = 1440; //日足
  input TimeFrame_List TimeFrame3 = 240; //四時間足
  input TimeFrame_List TimeFrame4 = 60; //一時間足


//期間設定
  input int BBPeriod = 21;//BBの期間


//bufferの定義
  double BBBuf_week1[];
  double BBBuf_week2[];
  double BBBuf_week3[];
  double BBBuf_week4[];
  double BBBuf_week5[];

  double BBBuf_day1[];
  double BBBuf_day2[];
  double BBBuf_day3[];
  double BBBuf_day4[];
  double BBBuf_day5[];

  double BBBuf_4hour1[];
  double BBBuf_4hour2[];
  double BBBuf_4hour3[];
  double BBBuf_4hour4[];
  double BBBuf_4hour5[];

  double BBBuf_1hour1[];
  double BBBuf_1hour2[];
  double BBBuf_1hour3[];
  double BBBuf_1hour4[];
  double BBBuf_1hour5[];

// マクロ定義
  #define    IND_MIN_INDEX         2               // 最小バー数
int OnInit()
  {
   IndicatorBuffers(20);  //全体の指標バッファ数を設定
   SetIndexBuffer(0,BBBuf_week1);
   SetIndexBuffer(1,BBBuf_week2);
   SetIndexBuffer(2,BBBuf_week3);
   SetIndexBuffer(3,BBBuf_week4);
   SetIndexBuffer(4,BBBuf_week5);
   SetIndexBuffer(5,BBBuf_day1);
   SetIndexBuffer(6,BBBuf_day2);
   SetIndexBuffer(7,BBBuf_day3);
   SetIndexBuffer(8,BBBuf_day4);
   SetIndexBuffer(9,BBBuf_day5);
   SetIndexBuffer(10,BBBuf_4hour1);
   SetIndexBuffer(11,BBBuf_4hour2);
   SetIndexBuffer(12,BBBuf_4hour3);
   SetIndexBuffer(13,BBBuf_4hour4);
   SetIndexBuffer(14,BBBuf_4hour5);
   SetIndexBuffer(15,BBBuf_1hour1);
   SetIndexBuffer(16,BBBuf_1hour2);
   SetIndexBuffer(17,BBBuf_1hour3);
   SetIndexBuffer(18,BBBuf_1hour4);
   SetIndexBuffer(19,BBBuf_1hour5);
   
   
   return(INIT_SUCCEEDED);
  }
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])

  {
   int icount;
   int icountend;
   int min_index;
   
    if(Bars <= 2)                            // ヒストリカルデータ不足時
    {
      return 0;                            // 全て再計算が必要なので、計算済みバー数を0にして終了する
    }

   
    if(TimeFrame1 != 0)
    {
      min_index = (int)MathCeil(TimeFrame1/Period()) + 2;          // 最小描画数取得

      icountend = Bars -  prev_calculated;
      if(icountend <= min_index)         // 直近数本は常時更新
        {
          icountend = min_index;
        }

      for(icount = 0; icount < icountend ; icount++)
        {
          int Week1 = iBarShift(NULL,TimeFrame1,Time[icount]);
          BBBuf_week1[icount] = iBands(_Symbol,TimeFrame1,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Week1);
          int Week2 = iBarShift(NULL,TimeFrame1,Time[icount]);
          BBBuf_week2[icount] = iBands(_Symbol,TimeFrame1,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Week2);
          int Week3 = iBarShift(NULL,TimeFrame1,Time[icount]);
          BBBuf_week3[icount] = iBands(_Symbol,TimeFrame1,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Week3);
          int Week4 = iBarShift(NULL,TimeFrame1,Time[icount]);
          BBBuf_week4[icount] = iBands(_Symbol,TimeFrame1,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Week4);
          int Week5 = iBarShift(NULL,TimeFrame1,Time[icount]);
          BBBuf_week5[icount] = iBands(_Symbol,TimeFrame1,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Week5);
        }
    
    }

    if(TimeFrame2 != 0)
    {
     min_index = (int)MathCeil(TimeFrame2/Period()) + 2;          // 最小描画数取得

      icountend = Bars -  prev_calculated;
      if(icountend <= min_index)         // 直近数本は常時更新
        {
          icountend = min_index;
        }

      for(icount = 0; icount < icountend ; icount++)
        {
          int Day1 = iBarShift(NULL,TimeFrame2,Time[icount]);
          BBBuf_day1[icount] = iBands(_Symbol,TimeFrame2,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Day1);
          int Day2 = iBarShift(NULL,TimeFrame2,Time[icount]);
          BBBuf_day2[icount] = iBands(_Symbol,TimeFrame2,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Day2);
          int Day3 = iBarShift(NULL,TimeFrame2,Time[icount]);
          BBBuf_day3[icount] = iBands(_Symbol,TimeFrame2,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Day3);
          int Day4 = iBarShift(NULL,TimeFrame2,Time[icount]);
          BBBuf_day4[icount] = iBands(_Symbol,TimeFrame2,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Day4);
          int Day5 = iBarShift(NULL,TimeFrame2,Time[icount]);
          BBBuf_day5[icount] = iBands(_Symbol,TimeFrame2,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Day5);
        }

    }

    if(TimeFrame3 != 0)
    {
      min_index = (int)MathCeil(TimeFrame3/Period()) + 2;          // 最小描画数取得

      icountend = Bars -  prev_calculated;
      if(icountend <= min_index)         // 直近数本は常時更新
        {
          icountend = min_index;
        }

      for(icount = 0; icount < icountend ; icount++)
        {
          int Fourhour1 = iBarShift(NULL,TimeFrame3,Time[icount]);
          BBBuf_4hour1[icount] = iBands(_Symbol,TimeFrame3,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Fourhour1);
          int Fourhour2 = iBarShift(NULL,TimeFrame3,Time[icount]);
          BBBuf_4hour2[icount] = iBands(_Symbol,TimeFrame3,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Fourhour2);
          int Fourhour3 = iBarShift(NULL,TimeFrame3,Time[icount]);
          BBBuf_4hour3[icount] = iBands(_Symbol,TimeFrame3,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Fourhour3);
          int Fourhour4 = iBarShift(NULL,TimeFrame3,Time[icount]);
          BBBuf_4hour4[icount] = iBands(_Symbol,TimeFrame3,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Fourhour4);
          int Fourhour5 = iBarShift(NULL,TimeFrame3,Time[icount]);
          BBBuf_4hour5[icount] = iBands(_Symbol,TimeFrame3,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Fourhour5);
        }

    }

    if(TimeFrame4 != 0)
    {


      min_index = (int)MathCeil(TimeFrame4/Period()) + 2;          // 最小描画数取得

      icountend = Bars -  prev_calculated;
      if(icountend <= min_index)         // 直近数本は常時更新
        {
          icountend = min_index;
        }

      for(icount = 0; icount < icountend ; icount++)
        {
          int Onehour1 = iBarShift(NULL,TimeFrame4,Time[icount]);
          BBBuf_1hour1[icount] = iBands(_Symbol,TimeFrame4,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Onehour1);
          int Onehour2 = iBarShift(NULL,TimeFrame4,Time[icount]);
          BBBuf_1hour2[icount] = iBands(_Symbol,TimeFrame4,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Onehour2);
          int Onehour3 = iBarShift(NULL,TimeFrame4,Time[icount]);
          BBBuf_1hour3[icount] = iBands(_Symbol,TimeFrame4,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Onehour3);
          int Onehour4 = iBarShift(NULL,TimeFrame4,Time[icount]);
          BBBuf_1hour4[icount] = iBands(_Symbol,TimeFrame4,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Onehour4);
          int Onehour5 = iBarShift(NULL,TimeFrame4,Time[icount]);
          BBBuf_1hour5[icount] = iBands(_Symbol,TimeFrame4,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Onehour5);
        }

    }

   return(rates_total);
  }
//+------------------------------------------------------------------+
  //+------------------------------------------------------------------+
  //| 最小更新バー数を取得
  //+------------------------------------------------------------------+
  //int GetMinIndex(int timeframe)
  //  {
  //   int ret = IND_MIN_INDEX;
  //
  //   if(TimeFrame1 > Period())      // 指定した時間軸がチャートの時間軸よりも大きい場合
  //     {
  //      ret = IND_MIN_INDEX + timeframe / Period();
  //     }
  //
  //   return ret;
  //  }
  //+------------------------------------------------------------------+
//+------------------------------------------------------------------+
