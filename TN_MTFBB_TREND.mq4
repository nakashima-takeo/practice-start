//+------------------------------------------------------------------+
//|                                               TN_MTFBB_TREND.mq4 |
//|                                                               TN |
//|                                                                  |
//+------------------------------------------------------------------+
  #property copyright "TN"
  #property version   "1.00"
  #property strict
  #property indicator_chart_window
  #include <TN_default.mqh>
  #include <環境認識.mqh>
// マクロ定義
  #define    IND_MIN_INDEX         2               // 最小バー数
  
//週足から順番に定義していく

  #property indicator_buffers 35
//週足
  #property indicator_type1 DRAW_LINE
  #property indicator_color1 clrFireBrick
  #property indicator_style1 STYLE_SOLID
  #property indicator_width1 2
  #property indicator_type2 DRAW_LINE
  #property indicator_color2 clrMidnightBlue
  #property indicator_style2 STYLE_SOLID
  #property indicator_width2 4
  #property indicator_type3 DRAW_LINE
  #property indicator_color3 clrMidnightBlue
  #property indicator_style3 STYLE_SOLID
  #property indicator_width3 4
  #property indicator_type4 DRAW_LINE
  #property indicator_color4 clrCornsilk
  #property indicator_style4 STYLE_SOLID
  #property indicator_width4 2
  #property indicator_type5 DRAW_LINE
  #property indicator_color5 clrCornsilk
  #property indicator_style5 STYLE_SOLID
  #property indicator_width5 2
//日足
  #property indicator_type6 DRAW_LINE
  #property indicator_color6 clrFireBrick
  #property indicator_style6 STYLE_SOLID
  #property indicator_width6 2
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
  #property indicator_width9 2
  #property indicator_type10 DRAW_LINE
  #property indicator_color10 clrCornsilk
  #property indicator_style10 STYLE_SOLID
  #property indicator_width10 2
//四時間足
  #property indicator_type11 DRAW_LINE
  #property indicator_color11 clrFireBrick
  #property indicator_style11 STYLE_SOLID
  #property indicator_width11 2
  #property indicator_type12 DRAW_LINE
  #property indicator_color12 clrMidnightBlue
  #property indicator_style12 STYLE_SOLID
  #property indicator_width12 4
  #property indicator_type13 DRAW_LINE
  #property indicator_color13 clrMidnightBlue
  #property indicator_style13 STYLE_SOLID
  #property indicator_width13 4
  #property indicator_type14 DRAW_LINE
  #property indicator_color14 clrCornsilk
  #property indicator_style14 STYLE_SOLID
  #property indicator_width14 2
  #property indicator_type15 DRAW_LINE
  #property indicator_color15 clrCornsilk
  #property indicator_style15 STYLE_SOLID
  #property indicator_width15 2
//一時間足
  #property indicator_type16 DRAW_LINE
  #property indicator_color16 clrFireBrick
  #property indicator_style16 STYLE_SOLID
  #property indicator_width16 1
  #property indicator_type17 DRAW_LINE
  #property indicator_color17 clrMidnightBlue
  #property indicator_style17 STYLE_SOLID
  #property indicator_width17 3
  #property indicator_type18 DRAW_LINE
  #property indicator_color18 clrMidnightBlue
  #property indicator_style18 STYLE_SOLID
  #property indicator_width18 3
  #property indicator_type19 DRAW_LINE
  #property indicator_color19 clrCornsilk
  #property indicator_style19 STYLE_SOLID
  #property indicator_width19 1
  #property indicator_type20 DRAW_LINE
  #property indicator_color20 clrCornsilk
  #property indicator_style20 STYLE_SOLID
  #property indicator_width20 1
//30分足
  #property indicator_type21 DRAW_LINE
  #property indicator_color21 clrFireBrick
  #property indicator_style21 STYLE_SOLID
  #property indicator_width21 1
  #property indicator_type22 DRAW_LINE
  #property indicator_color22 clrMidnightBlue
  #property indicator_style22 STYLE_SOLID
  #property indicator_width22 3
  #property indicator_type23 DRAW_LINE
  #property indicator_color23 clrMidnightBlue
  #property indicator_style23 STYLE_SOLID
  #property indicator_width23 3
  #property indicator_type24 DRAW_LINE
  #property indicator_color24 clrCornsilk
  #property indicator_style24 STYLE_SOLID
  #property indicator_width24 1
  #property indicator_type25 DRAW_LINE
  #property indicator_color25 clrCornsilk
  #property indicator_style25 STYLE_SOLID
  #property indicator_width25 1
//15分足
  #property indicator_type26 DRAW_LINE
  #property indicator_color26 clrFireBrick
  #property indicator_style26 STYLE_SOLID
  #property indicator_width26 1
  #property indicator_type27 DRAW_LINE
  #property indicator_color27 clrMidnightBlue
  #property indicator_style27 STYLE_SOLID
  #property indicator_width27 2
  #property indicator_type28 DRAW_LINE
  #property indicator_color28 clrMidnightBlue
  #property indicator_style28 STYLE_SOLID
  #property indicator_width28 2
  #property indicator_type29 DRAW_LINE
  #property indicator_color29 clrCornsilk
  #property indicator_style29 STYLE_SOLID
  #property indicator_width29 1
  #property indicator_type30 DRAW_LINE
  #property indicator_color30 clrCornsilk
  #property indicator_style30 STYLE_SOLID
  #property indicator_width30 1
//5分足
  #property indicator_type31 DRAW_LINE
  #property indicator_color31 clrFireBrick
  #property indicator_style31 STYLE_SOLID
  #property indicator_width31 1
  #property indicator_type32 DRAW_LINE
  #property indicator_color32 clrMidnightBlue
  #property indicator_style32 STYLE_SOLID
  #property indicator_width32 2
  #property indicator_type33 DRAW_LINE
  #property indicator_color33 clrMidnightBlue
  #property indicator_style33 STYLE_SOLID
  #property indicator_width33 2
  #property indicator_type34 DRAW_LINE
  #property indicator_color34 clrCornsilk
  #property indicator_style34 STYLE_SOLID
  #property indicator_width34 1
  #property indicator_type35 DRAW_LINE
  #property indicator_color35 clrCornsilk
  #property indicator_style35 STYLE_SOLID
  #property indicator_width35 1

   double     Bufferprice[][250];
   datetime   Buffertime[][250];

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

  double BBBuf_30minits1[];
  double BBBuf_30minits2[];
  double BBBuf_30minits3[];
  double BBBuf_30minits4[];
  double BBBuf_30minits5[];

  double BBBuf_15minits1[];
  double BBBuf_15minits2[];
  double BBBuf_15minits3[];
  double BBBuf_15minits4[];
  double BBBuf_15minits5[];

  double BBBuf_5minits1[];
  double BBBuf_5minits2[];
  double BBBuf_5minits3[];
  double BBBuf_5minits4[];
  double BBBuf_5minits5[];

int OnInit()
  {
   IndicatorBuffers(35);  //全体の指標バッファ数を設定
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
   SetIndexBuffer(20,BBBuf_30minits1);
   SetIndexBuffer(21,BBBuf_30minits2);
   SetIndexBuffer(22,BBBuf_30minits3);
   SetIndexBuffer(23,BBBuf_30minits4);
   SetIndexBuffer(24,BBBuf_30minits5);
   SetIndexBuffer(25,BBBuf_15minits1);
   SetIndexBuffer(26,BBBuf_15minits2);
   SetIndexBuffer(27,BBBuf_15minits3);
   SetIndexBuffer(28,BBBuf_15minits4);
   SetIndexBuffer(29,BBBuf_15minits5);
   SetIndexBuffer(30,BBBuf_5minits1);
   SetIndexBuffer(31,BBBuf_5minits2);
   SetIndexBuffer(32,BBBuf_5minits3);
   SetIndexBuffer(33,BBBuf_5minits4);
   SetIndexBuffer(34,BBBuf_5minits5);
   Bar_Buffer(NULL,Bufferprice,Buffertime);
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
  
    static  datetime lasttime = 0;          // 前回処理時の時間
            datetime temptime = iTime(NULL,0,1);   // 現在の時間軸のオープン時間
    if ( lasttime != temptime )           // 新しいバーが生成された場合
    {
        lasttime = temptime;               // 前回時間を更新
  
  
      	string TN_Symbol     = Symbol();
         string Sym     		= StringSubstr(TN_Symbol,3,3);
         double mFactor 		= 10000.0;
         if (Sym == "JPY") mFactor = 100.0;
        
         int weektrend = 0;
         int daytrend = 0;
         int fourhtrend = 0;
         int onehtrend = 0;
         int thirtymtrend = 0;
         int fifteenmtrend = 0;
         int fivemtrend = 0;
         
         int icount;
         int icountend;
         int min_index;
         int BBPeriod = 21;
         Array(NULL,0,Bufferprice,Buffertime);         
          if(Bars <= IND_MIN_INDEX)                            // ヒストリカルデータ不足時
          {
            return 0;                            // 全て再計算が必要なので、計算済みバー数を0にして終了する
          }
      
         
          if(_Period <= 10080 && _Period >= 30)
          {
            min_index = (int)MathCeil(10080/_Period) + 2;          // 最小描画数取得
      
            icountend = Bars -  prev_calculated;
            if(icountend <= min_index)         // 直近数本は常時更新
              {
                icountend = min_index;
              }
      
            for( icount = icountend - 10 ; icount >= 0  ; icount--)
              {
               int Week = iBarShift(NULL,10080,Time[icount]);
               if(weektrend != 0)
                 {
                  weektrend = IsNonTrend(NULL, 10080, weektrend, Week);
                 }
               if(weektrend == 0)
                 {
                  weektrend = IsTrend(NULL, 10080, Week);
                 }
                if(weektrend != 0)
                {
                   BBBuf_week1[icount] = iBands(_Symbol,10080,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Week);
                   BBBuf_week2[icount] = iBands(_Symbol,10080,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Week);
                   BBBuf_week3[icount] = iBands(_Symbol,10080,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Week);
                   BBBuf_week4[icount] = iBands(_Symbol,10080,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Week);
                   BBBuf_week5[icount] = iBands(_Symbol,10080,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Week);
                }
              }
          
          }
      
          if(_Period <= 1440 && _Period >= 15)
          {
           min_index = (int)MathCeil(1440/_Period) + 2;          // 最小描画数取得
      
            icountend = Bars -  prev_calculated;
            if(icountend <= min_index)         // 直近数本は常時更新
              {
                icountend = min_index;
              }
      
            for( icount = icountend - 10 ; icount >= 0  ; icount--)
              {
               int Day_ = iBarShift(NULL,1440,Time[icount]);
               if(daytrend != 0)
                 {
                  daytrend = IsNonTrend(NULL, 1440, daytrend, Day_);
                 }
               if(daytrend == 0)
                 {
                  daytrend = IsTrend(NULL, 1440, Day_);
                 }
                if(daytrend != 0)
                {
                   BBBuf_day1[icount] = iBands(_Symbol,1440,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Day_);
                   BBBuf_day2[icount] = iBands(_Symbol,1440,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Day_);
                   BBBuf_day3[icount] = iBands(_Symbol,1440,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Day_);
                   BBBuf_day4[icount] = iBands(_Symbol,1440,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Day_);
                   BBBuf_day5[icount] = iBands(_Symbol,1440,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Day_);
                }
              }
      
          }
      
          if(_Period <= 240 && _Period >= 5)
          {
            min_index = (int)MathCeil(240/_Period) + 2;          // 最小描画数取得
      
            icountend = Bars -  prev_calculated;
            if(icountend <= min_index)         // 直近数本は常時更新
              {
                icountend = min_index;
              }
            for( icount = icountend - 10 ; icount >= 0  ; icount--)
              {
               int Fourhour = iBarShift(NULL,240,Time[icount]);
               if(fourhtrend != 0)
                 {
                  fourhtrend = IsNonTrend(NULL, 240, fourhtrend, Fourhour);
                 }
               if(fourhtrend == 0)
                 {
                  fourhtrend = IsTrend(NULL, 240, Fourhour);
                 }
                if(fourhtrend != 0)
                {
                   BBBuf_4hour1[icount] = iBands(_Symbol,240,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Fourhour);
                   BBBuf_4hour2[icount] = iBands(_Symbol,240,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Fourhour);
                   BBBuf_4hour3[icount] = iBands(_Symbol,240,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Fourhour);
                   BBBuf_4hour4[icount] = iBands(_Symbol,240,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Fourhour);
                   BBBuf_4hour5[icount] = iBands(_Symbol,240,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Fourhour);
                }
              }
          }
      
          if(_Period <= 60)
          {
      
      
            min_index = (int)MathCeil(60/_Period) + 2;          // 最小描画数取得
      
            icountend = Bars -  prev_calculated;
            if(icountend <= min_index)         // 直近数本は常時更新
              {
                icountend = min_index;
              }
            for( icount = icountend - 10 ; icount >= 0  ; icount--)
              {
               int Onehour = iBarShift(NULL,60,Time[icount]);
               if(onehtrend != 0)
                 {
                  onehtrend = IsNonTrend(NULL, 60, onehtrend, Onehour);
                 }
               if(onehtrend == 0)
                 {
                  onehtrend = IsTrend(NULL, 60, Onehour);
                 }
                if(onehtrend != 0)
                {
                   BBBuf_1hour1[icount] = iBands(_Symbol,60,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,Onehour);
                   BBBuf_1hour2[icount] = iBands(_Symbol,60,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,Onehour);
                   BBBuf_1hour3[icount] = iBands(_Symbol,60,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,Onehour);
                   BBBuf_1hour4[icount] = iBands(_Symbol,60,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,Onehour);
                   BBBuf_1hour5[icount] = iBands(_Symbol,60,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,Onehour);
                }
              }
          }
          
          if(_Period <= 30)
          {
      
      
            min_index = (int)MathCeil(30/_Period) + 2;          // 最小描画数取得
      
            icountend = Bars -  prev_calculated;
            if(icountend <= min_index)         // 直近数本は常時更新
              {
                icountend = min_index;
              }
            for( icount = icountend - 10 ; icount >= 0  ; icount--)
              {
               int minits30 = iBarShift(NULL,30,Time[icount]);
               if(thirtymtrend != 0)
                 {
                  thirtymtrend = IsNonTrend(NULL, 30, thirtymtrend, minits30);
                 }
               if(thirtymtrend == 0)
                 {
                  thirtymtrend = IsTrend(NULL, 30, minits30);
                 }
                if(thirtymtrend != 0)
                {
                   BBBuf_30minits1[icount] = iBands(_Symbol,30,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,minits30);
                   BBBuf_30minits2[icount] = iBands(_Symbol,30,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,minits30);
                   BBBuf_30minits3[icount] = iBands(_Symbol,30,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,minits30);
                   BBBuf_30minits4[icount] = iBands(_Symbol,30,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,minits30);
                   BBBuf_30minits5[icount] = iBands(_Symbol,30,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,minits30);
                }
              }
          }
          if(_Period <= 15)
          {
      
      
            min_index = (int)MathCeil(15/_Period) + 2;          // 最小描画数取得
      
            icountend = Bars -  prev_calculated;
            if(icountend <= min_index)         // 直近数本は常時更新
              {
                icountend = min_index;
              }
            for( icount = icountend - 10 ; icount >= 0  ; icount--)
              {
               int minits15 = iBarShift(NULL,15,Time[icount]);
               if(fifteenmtrend != 0)
                 {
                  fifteenmtrend = IsNonTrend(NULL, 15, fifteenmtrend, minits15);
                 }
               if(fifteenmtrend == 0)
                 {
                  fifteenmtrend = IsTrend(NULL, 15, minits15);
                 }
                if(fifteenmtrend != 0)
                {
                   BBBuf_15minits1[icount] = iBands(_Symbol,15,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,minits15);
                   BBBuf_15minits2[icount] = iBands(_Symbol,15,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,minits15);
                   BBBuf_15minits3[icount] = iBands(_Symbol,15,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,minits15);
                   BBBuf_15minits4[icount] = iBands(_Symbol,15,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,minits15);
                   BBBuf_15minits5[icount] = iBands(_Symbol,15,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,minits15);
                }
              }
          }
          if(_Period <= 5)
          {
      
      
            min_index = (int)MathCeil(5/_Period) + 2;          // 最小描画数取得
      
            icountend = Bars -  prev_calculated;
            if(icountend <= min_index)         // 直近数本は常時更新
              {
                icountend = min_index;
              }
            for( icount = icountend - 10 ; icount >= 0  ; icount--)
              {
               int minits5 = iBarShift(NULL,5,Time[icount]);
               if(fivemtrend != 0)
                 {
                  fivemtrend = IsNonTrend(NULL, 5, fivemtrend, minits5);
                 }
               if(fivemtrend == 0)
                 {
                  fivemtrend = IsTrend(NULL, 5, minits5);
                 }
                if(fivemtrend != 0)
                {
                   BBBuf_5minits1[icount] = iBands(_Symbol,5,BBPeriod,0,0,PRICE_CLOSE,MODE_MAIN,minits5);
                   BBBuf_5minits2[icount] = iBands(_Symbol,5,BBPeriod,1,0,PRICE_CLOSE,MODE_UPPER,minits5);
                   BBBuf_5minits3[icount] = iBands(_Symbol,5,BBPeriod,1,0,PRICE_CLOSE,MODE_LOWER,minits5);
                   BBBuf_5minits4[icount] = iBands(_Symbol,5,BBPeriod,2,0,PRICE_CLOSE,MODE_UPPER,minits5);
                   BBBuf_5minits5[icount] = iBands(_Symbol,5,BBPeriod,2,0,PRICE_CLOSE,MODE_LOWER,minits5);
                }
              }
          }
      }
   return(rates_total);
  }