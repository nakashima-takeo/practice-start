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
//#define  IND_MIN_INDEX    2               // 最小バー数
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
// インプットパラメータ
input int             xxx   = 6;                  //前後何本の高値安値を取るのか
input int   howmany_highlowbars = 100;                 //判定する高安の未更新時間(本数)


//内部変数
int IND_MIN_INDEX = xxx;            //今回は最低繰り返し回数が函数に依存する


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
   return(INIT_SUCCEEDED); // 戻り値：初期化成功
  }
//+------------------------------------------------------------------+
//| OnDeinit(アンロード)イベント
//+------------------------------------------------------------------+
void OnDeinit( const int reason ) {

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
                const double   &close[],         // 終値
                const long     &tick_volume[],   // Tick出来高
                const long     &volume[],        // Real出来高
                const int      &spread[])        // スプレッド

  {
   int end_index = Bars - prev_calculated - 1;  // バー数取得(未計算分)
    if ( end_index <= IND_MIN_INDEX ) {                    // 直近2本は常時更新
        end_index = xxx;
    }
   if ( Bars <= IND_MIN_INDEX  ) {                       // ヒストリカルデータ不足時
        return 0;                            // 全て再計算が必要なので、計算済みバー数を0にして終了する
    }
    static int object_number = 0; //オブジェクト番号
    static bool object_flag = 1; // 現在オブジェクトが生成中か否か
    static string obj_name = "a";            // オブジェクト名
    static datetime no_new_highlow = Time[0]; //新価格の発生時間
    bool ObjectCreate_Success = false; // オブジェクトの作成に成功したか
    bool ObjectMove_Success = false; // オブジェクトの移動に成功したか

    static bool highlow = 0; //現在上目線1なのか下目線0なのか
    static double criticalhighprice = (high[0]+low[0])/2; //  ダウの更新価格
    static double criticallowprice = (high[0]+low[0])/2; //  ダウの更新価格
    static double onehighprice = (high[0]+low[0])/2; //  ひとつ前の高値
    static double onelowprice = (high[0]+low[0])/2; //  ひとつ前の安値
    int     get_index = 0; //意識される高値安値
    static  datetime lasttime = 0;          // 前回処理時の時間
            datetime temptime = Time[0];   // 現在の時間軸のオープン時間
    if ( lasttime != temptime ) {          // 新しいバーが生成された場合
        lasttime = temptime;               // 前回時間を更新

        for( int icount = end_index ; icount > 0 ; icount-- ) {

            if ( int(Time[icount] - no_new_highlow)/PeriodSeconds() > howmany_highlowbars)
            {   
                if( object_flag == 0)
                {
                    obj_name = StringFormat( "%sRectangle%d" , OBJ_HEAD, object_number);
                    ObjectCreate_Success = CreateRectangle(obj_name,
                                                            Time[
                                                                    MathMax(GetFirstIndexOfArray(_IndBuffer3),
                                                                            GetFirstIndexOfArray(_IndBuffer4))
                                                                ],
                                                            criticallowprice,
                                                            Time[icount + 1],
                                                            criticalhighprice
                                                            );
                                            object_number++;
                    object_flag = 1;
                    if(ObjectCreate_Success == 0) printf( "オブジェクト作成失敗だよ");
                }
                else
                {
                    ObjectMove_Success = ObjectMove(obj_name,
                                1,
                                Time[icount],
                                criticalhighprice);
                    // エラー処理
                    if(ObjectMove_Success == false)
                        {
                            int ErrorCode = GetLastError();
                            string ErrDesc = ErrorDescription(ErrorCode);
   			                printf( "エラーコード:%d 詳細:%s" , ErrorCode , ErrDesc);
                        }
                }

            }
            switch(IsHLinX(icount,xxx))
            {
                case 1:
                    _IndBuffer1[icount] = high[icount];                             //高値をバッファに代入
                    onehighprice = high[icount];                                    //意識される高値候補の価格
                    if(criticalhighprice < high[icount])
                    {
                        criticalhighprice = high[icount];
                        criticallowprice = onelowprice;
                        get_index = GetFirstIndexOfArray(_IndBuffer2);                    
                        _IndBuffer3[icount] = criticalhighprice;
                        _IndBuffer4[get_index] = criticallowprice;
                        highlow = 1;
                        no_new_highlow = Time[icount];
                        //object_flag = 0;
                    }
                    break;
                case -1:
                    _IndBuffer2[icount] = low[icount];                              //安値をバッファに代入
                    onelowprice = low[icount];                                      //意識される安値候補の価格
                    if(criticallowprice > low[icount])
                    {
                        criticalhighprice = onehighprice;
                        criticallowprice = low[icount];
                        get_index = GetFirstIndexOfArray(_IndBuffer1);                    
                        _IndBuffer3[get_index] = criticalhighprice;
                        _IndBuffer4[icount] = criticallowprice;
                        highlow = 0;
                        no_new_highlow = Time[icount];
                        //object_flag = 0;
                    }
                    break;
            }
        }
    }
   return(rates_total);  // 戻り値設定：次回OnCalculate関数が呼ばれた時のprev_calculatedの値に渡される
  }
//+------------------------------------------------------------------+






//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+






//以下参考
//+------------------------------------------------------------------+
//| オブジェクト描画1
//+------------------------------------------------------------------+
void DispObj1( int        in_disp_no,  // 表示順
               string    in_disp_str  // 表示文字列
) {

    const int disp_fontsize  = 15;             // フォントサイズ
    const int disp_margin    = 2;              // ラベルマージン
           int disp_offset_y;                   // Y座標オフセット

    disp_offset_y = ( disp_fontsize + disp_margin ) * in_disp_no;

    string obj_name;            // オブジェクト名
    obj_name = StringFormat( "%sTextLabel_DispTime_%d" , OBJ_HEAD, in_disp_no);

    if ( ObjectFind( obj_name ) < 0 ) {  // オブジェクト名重複チェック
        // 重複していない場合

        ObjectCreate(                     // オブジェクト生成
                        obj_name,          // オブジェクト名
                        OBJ_LABEL,       // オブジェクトタイプ
                        0,                 // ウインドウインデックス
                        0,                 // 1番目の時間のアンカーポイント
                        0                  // 1番目の価格のアンカーポイント
                        );


        ObjectSetInteger( 0, obj_name, OBJPROP_COLOR, clrYellow);              // 色設定
        ObjectSetInteger( 0, obj_name, OBJPROP_CORNER, CORNER_RIGHT_LOWER);  // コーナーアンカー設定
        ObjectSetInteger( 0, obj_name, OBJPROP_XDISTANCE, 0);                   // X座標
        ObjectSetInteger( 0, obj_name, OBJPROP_YDISTANCE, disp_offset_y);       // Y座標

        ObjectSetInteger( 0, obj_name, OBJPROP_SELECTABLE, false );            // オブジェクトの選択可否設定

        ObjectSetInteger( 0, obj_name, OBJPROP_FONTSIZE, disp_fontsize);        // フォントサイズ
        ObjectSetString( 0, obj_name, OBJPROP_FONT, "メイリオ");           // フォント

        // オブジェクトバインディングのアンカーポイント設定
        ObjectSetInteger( 0, obj_name, OBJPROP_ANCHOR, ANCHOR_RIGHT_LOWER);  

    }

    // テキストは常時更新する
    ObjectSetString( 0, obj_name, OBJPROP_TEXT, in_disp_str );             // 表示するテキスト

}



//+------------------------------------------------------------------+
//| 他通貨ペア名を取得
//+------------------------------------------------------------------+
string GetOtherSymbol( string in_symbol ) {
    
    string ret_symbol = in_symbol;
    string now_symbol = Symbol();              // 現在表示の通貨ペア名
    int    str_length = StringLen(now_symbol);   // 文字列数
    
    if ( str_length > 6 ) {                      // 文字列が6文字越えの場合
        string add_str = StringSubstr( now_symbol, 6 , str_length); // 末尾文字列抽出
        ret_symbol += add_str;
    }  
    return ret_symbol;
}
//+------------------------------------------------------------------+
//| 指定した時間軸の移動平均を算出する
//+------------------------------------------------------------------+
double CalOtherPeriodMA( 
                        ENUM_TIMEFRAMES in_period , // 表示したい時間軸
                        int in_time_period ,          // MAの平均期間
                        int in_index                  // インデックス
                       )
{
    double   ret          = 0;            // 戻り値
    double   get_other_ma = 0;            // 他時間軸の移動平均値
    int      other_index   = 0;            // 指定した時間軸のインデックス
    datetime other_time   = 0;            // 現在の時間軸の日時

    other_time  = Time[in_index];          // 現在の時間軸のインデックス時間を取得

    other_index = iBarShift(                // 指定した時間から、他時間軸でのインデックスを取得する
                            Symbol(),       // 通貨ペア
                            in_period,       // 時間軸
                            other_time,      // 日時
                            false            // 検索モード(指定した日時に近いインデックスを取得する)
                    );

    if ( other_index >= 0) {               // インデック取得していた場合

        get_other_ma = iMA (                // 移動平均算出
                            Symbol(),      // 通貨ペア
                            in_period,      // 時間軸
                            in_time_period, // MAの平均期間
                            0,              // MAシフト
                            MODE_SMA,      // MAの平均化メソッド
                            PRICE_CLOSE,  // 適用価格
                            other_index     // シフト
                        );

        ret = get_other_ma; // 戻り値に算出した移動平均を設定
    }

    return ret; // 戻り値を返す
}

//+------------------------------------------------------------------+
//| 最小更新バー数を取得
//+------------------------------------------------------------------+
int GetMinIndex(
                ENUM_TIMEFRAMES _ATimePeriod //表示したいインジケーターの時間軸
               )  
{
    int ret = IND_MIN_INDEX;

    if ( _ATimePeriod > Period() ) { // 指定した時間軸がチャートの時間軸よりも大きい場合
        ret = IND_MIN_INDEX + _ATimePeriod / Period();
    }
    
    return ret;
}
//+------------------------------------------------------------------+
//| SMA(単純移動平均)を算出する[配列ベース]
//+------------------------------------------------------------------+
double CalSMA( 
                const double &in_array[],         // インプット変数配列アドレス（close等）
                       int     in_time_period ,    // MAの平均期間
                       int     in_index            // インデックス
                       )
{
    double ret = 0;   // 戻り値

    int    array_count = ArraySize(in_array);       // 配列要素数取得
    int    end_index = in_index + in_time_period;   // ループエンド
    double temp_sum  = 0;                           // 合計値

    if ( end_index < array_count ) {                  // 配列範囲内チェック
        for ( int icount = in_index ; icount < end_index ; icount++  ) {
            temp_sum += in_array[icount];               // 合計値に値を加算
        }

        if ( in_time_period > 0 ) {                     // 0除算対策
            ret = temp_sum / in_time_period;            // 平均値算出
        }
    }else{
        ret = in_array[array_count]; //チャートの最初の方の垂直落下の対策のつもり
    }
    return ret;       // 戻り値を返す
}
//+------------------------------------------------------------------+
//| 価格レートをPixel単位でオフセットする
//|     (函数にはY座標関係の話も混じっているが、実際にはY座標は無視している。)
//+------------------------------------------------------------------+
double GetOffsetRate(
    double in_rate,         // 価格レート
    int    in_offset_pixel  // オフセット(Pixel単位)
)
{
   double   ret            = in_rate; // 戻り値
   double   move_rate;                // オフセットしたレート
   datetime dummy_time;               // ダミー時間
   int      bese_axis_x;              // 取得座標X
   int      bese_axis_y;              // 取得座標Y
   int      get_window_no;            // 取得サブウインドウNo
   int      disp_pixel;               // オフセットした座標
   bool     get_bool;                 // 判定結果
     
   get_bool = ChartTimePriceToXY(             // 時間・価格値をX・Y座標に変換
                                 0,           // チャートID
                                 0,           // サブウインドウ番号
                                 Time[0],     // チャート上の時間
                                 in_rate,     // チャート上の価格
                                 bese_axis_x, // X座標
                                 bese_axis_y  // Y座標
                              );
   
   if ( get_bool == true ) {                      // 変換できた場合
      disp_pixel = bese_axis_y + in_offset_pixel; // 座標Yをオフセット
   
      get_bool = ChartXYToTimePrice(                // X・Y座標を時間・価格値に変換
                                    0,              // チャートID
                                    bese_axis_x,    // X座標
                                    disp_pixel,     // Y座標
                                    get_window_no,  // サブウインドウ番号
                                    dummy_time,     // チャート上の時間
                                    move_rate       // チャート上の価格
                                   );
   
      if ( get_bool == true ) {     // 変換できた場合
         ret = move_rate;           // 戻り値に変換後の価格を設定
      }
   }
   
   return ret;
}

//+------------------------------------------------------------------+
//| ある期間内のHL価格取得
//+------------------------------------------------------------------+
bool GetHLRate( int    in_index,     // 1番目のインデックス（現在から遠いほうのインデックス）
                int    end_index,    // 2番目のインデックス（現在に近いほうのインデックス）
                double &out_high,    // 高値(出力)
                double &out_low      // 安値(出力)

) {

    bool ret = false;

    // インデックスが範囲外の場合は描画しない
    if ( in_index < 0 || end_index < 0 ) {
        return ret;
    }

    if ( in_index >= Bars || end_index >= Bars ) {
        return ret;
    }

    int diff_index = MathAbs( in_index - end_index ); // インデックス期間
    int max_index  = -1;                              // 最大値インデックス
    int min_index  = -1;                              // 最小値インデックス

    max_index = iHighest(                           // 最大値インデックス取得
                         Symbol(),                  // 通貨ペア
                         Period(),                  // 時間軸
                         MODE_HIGH,                // データタイプ
                         diff_index,                // バーカウント数
                         end_index                  // バースタート位置
                );

    min_index = iLowest(                            // 最小値インデックス取得
                         Symbol(),                  // 通貨ペア
                         Period(),                  // 時間軸
                         MODE_LOW,                 // データタイプ
                         diff_index,                // バーカウント数
                         end_index                  // バースタート位置
                );

    if ( max_index >= 0 && min_index >= 0 ) {       // インデックス取得済みの場合
        out_high = High[max_index];                 // 最高値取得
        out_low  = Low[ min_index];                 // 最安値取得
        ret      = true;                            // 戻り値にtrue設定
    }

    return ret;
}












/* 
ローソク足を記述するインジケーター
（メインウインドウでヒストグラムを指定した場合、
  偶数のインジケータバッファの値と次の奇数のインジケータバッファの値の間にラインを引くようになっている）
    SetIndexStyle( 0, DRAW_HISTOGRAM, STYLE_SOLID,  1, clrRed );
    SetIndexStyle( 1, DRAW_HISTOGRAM, STYLE_SOLID,  1, clrRed );
    SetIndexStyle( 2, DRAW_HISTOGRAM, STYLE_SOLID,  5, clrRed );
    SetIndexStyle( 3, DRAW_HISTOGRAM, STYLE_SOLID,  5, clrRed );

    SetIndexStyle( 4, DRAW_HISTOGRAM, STYLE_SOLID,  1, clrAqua );
    SetIndexStyle( 5, DRAW_HISTOGRAM, STYLE_SOLID,  1, clrAqua );
    SetIndexStyle( 6, DRAW_HISTOGRAM, STYLE_SOLID,  5, clrAqua );
    SetIndexStyle( 7, DRAW_HISTOGRAM, STYLE_SOLID,  5, clrAqua );

for( int icount = 0 ; icount < end_index ; icount++ ) {
        if ( Open[icount] < Close[icount] ) {     // 上昇時
            _IndBuffer1[icount] = High[icount];   // インジケータ1に高値を設定
            _IndBuffer2[icount] = Low[icount];     // インジケータ2に安値を設定

            _IndBuffer3[icount] = Open[icount];   // インジケータ3に始値を設定
            _IndBuffer4[icount] = Close[icount];     // インジケータ4に終値を設定
        } else {                                  // 下降時
            _IndBuffer5[icount] = High[icount];   // インジケータ5に高値を設定
            _IndBuffer6[icount] = Low[icount];     // インジケータ6に安値を設定

            _IndBuffer7[icount] = Open[icount];   // インジケータ7に始値を設定
            _IndBuffer8[icount] = Close[icount];     // インジケータ8終値を設定

        }
    }
 */
