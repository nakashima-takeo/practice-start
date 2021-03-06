//+------------------------------------------------------------------+
//|                                                       TN_Dow.mq4 |
//|                                                               TN |
//+------------------------------------------------------------------+
#property copyright "TN"
#property strict
#property indicator_chart_window // カスタムインジケータをチャートウインドウに表示する
#include <TN_default.mqh>
#include <stdlib.mqh>

// マクロ定義(マジックナンバー回避)
#define    OBJ_HEAD              ( __FILE__ + "_" )  // オブジェクトヘッダ名

// インジケータプロパティ設定
#property  indicator_buffers    4               // カスタムインジケータのバッファ数
#property  indicator_color1     clrBlue      // インジケータ1の色
#property  indicator_width1     2               // インジケータ1の太さ
#property  indicator_type1      DRAW_ARROW    // インジケータ1の描画タイプ
#property  indicator_color2     clrRed      // インジケータ2の色
#property  indicator_width2     2               // インジケータ2の太さ
#property  indicator_type2      DRAW_ARROW     // インジケータ2の描画タイプ
#property  indicator_color3     clrBlue     // インジケータ3の色
#property  indicator_width3     5               // インジケータ3の太さ
#property  indicator_type3      DRAW_ARROW     // インジケータ3の描画タイプ
#property  indicator_color4     clrRed     // インジケータ4の色
#property  indicator_width4     5               // インジケータ4の太さ
#property  indicator_type4      DRAW_ARROW     // インジケータ4の描画タイプ

// インジケータ表示用動的配列
double     _IndBuffer1[];        // インジケータ1表示用動的配列 //高値の描写
double     _IndBuffer2[];        // インジケータ2表示用動的配列 //安値の描写
double     _IndBuffer3[];        // インジケータ3表示用動的配列 //意識される高値
double     _IndBuffer4[];        // インジケータ4表示用動的配列 //意識される安値

double     Bufferprice[][250];
datetime   Buffertime[][250];
// インプットパラメータ
extern int Timeframe = 0;                             //高値安値のタイムフレーム


//+------------------------------------------------------------------+
//|初期イベント                       |
//+------------------------------------------------------------------+
int OnInit()
  {
    SetIndexBuffer( 0, _IndBuffer1 );     // インジケータ1表示用動的配列をバインドする
    SetIndexBuffer( 1, _IndBuffer2 );     // インジケータ2表示用動的配列をバインドする
    SetIndexBuffer( 2, _IndBuffer3 );     // インジケータ3表示用動的配列をバインドする
    SetIndexBuffer( 3, _IndBuffer4 );     // インジケータ4表示用動的配列をバインドする
    SetIndexLabel(  0, "高値"  );     // インジケータ1のラベル設定
    SetIndexLabel(  1, "安値"    );     // インジケータ2のラベル設定
    //SetIndexArrow( 0 , 218 );     // インジケータ1のアローシンボル設定
    //SetIndexArrow( 1 , 217 );     // インジケータ2のアローシンボル設定
   Bar_Buffer(NULL,Bufferprice,Buffertime);
   return(INIT_SUCCEEDED); // 戻り値：初期化成功
  }
//+------------------------------------------------------------------+
//| OnDeinit(アンロード)イベント
//+------------------------------------------------------------------+
void OnDeinit( const int reason )
{
    ObjectsDeleteAll(              // 追加したオブジェクトを全削除
                        0,           // チャートID
                        OBJ_HEAD    // オブジェクト名の接頭辞
                       );
}

//+------------------------------------------------------------------+
//| ティックごとに起こるイベント                          |
//+------------------------------------------------------------------+
int OnCalculate(const int     rates_total,      // 入力された時系列のバー数
                const int       prev_calculated,  // 計算済み(前回呼び出し時)のバー数
                const datetime &time[],          // 時間
                const double   &open[],          // 始値
                const double   &high[],          // 高値
                const double   &low[],           // 安値
                const double   &close[],         // 終値a
                const long     &tick_volume[],   // Tick出来高
                const long     &volume[],        // Real出来高
                const int      &spread[])        // スプレッド

  {
    int high_price_bar = 0;
    int low_price_bar = 0;
    static  datetime lasttime = 0;          // 前回処理時の時間
            datetime temptime = iTime(NULL,5,1);
    if ( lasttime != temptime )           // 新しいバーが生成された場合
    {
        lasttime = temptime;               // 前回時間を更新
         int array_point = 0;
         if(Timeframe == 0)Timeframe = Period();
         switch(Timeframe)
         {
            case 5:
               array_point = 30;
               break;
            case 15:
               array_point = 60;
               break;
            case 30:
               array_point = 90;
               break;
            case 60:
               array_point = 120;
               break;
            case 240:
               array_point = 150;
               break;
            case 1440:
               array_point = 180;
               break;
            case 10080:
               array_point = 210;
               break;
            case 43200:
               array_point = 240;
         }
        Array(NULL,Timeframe,Bufferprice,Buffertime);
        VeryGoodLineSet_array(NULL,Timeframe,Bufferprice,Buffertime,OBJ_HEAD);
        
        for ( int icount = 0 ; icount <= Bufferprice[array_point][10]  ; icount++ )
        {
            high_price_bar = iBarShift(NULL,0,Buffertime[icount][array_point]);
            _IndBuffer1[high_price_bar] = Bufferprice[icount][array_point];
            _IndBuffer3[high_price_bar] = Bufferprice[icount][array_point + 2];
        }
        for ( int icount = 0 ; icount <= Bufferprice[array_point + 1][10]  ; icount++ )
        {
            low_price_bar = iBarShift(NULL,0,Buffertime[icount][array_point + 1]);
            _IndBuffer2[low_price_bar] = Bufferprice[icount][array_point + 1];
            _IndBuffer4[low_price_bar] = Bufferprice[icount][array_point + 3];
        }
    }
   return(rates_total);  // 戻り値設定：次回OnCalculate関数が呼ばれた時のprev_calculatedの値に渡される
  }
//+------------------------------------------------------------------+
