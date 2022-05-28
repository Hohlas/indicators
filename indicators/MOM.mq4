#property copyright   "Hohla"
#property link        "http://www.Hohla.ru"
#property description "Momentum_mq5"
#property strict

#property indicator_separate_window
#property indicator_buffers 1
//---- plot Line 
#property indicator_label1  "Line" 
#property indicator_type1   DRAW_LINE 
#property indicator_color1 DodgerBlue
#property indicator_style1  STYLE_SOLID 
#property indicator_width1  1 
//--- input parameter
input int InpMomPeriod=14;  // Momentum Period
//--- buffers
double MOM[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void){
   string Name="Mom("+IntegerToString(InpMomPeriod)+")";
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,MOM);  SetIndexLabel(0,Name);
   if(InpMomPeriod<=0){//--- check for input parameter
      Print("Wrong input parameter Momentum Period=",InpMomPeriod);
      return(INIT_FAILED);
      }
   IndicatorShortName(Name);   
   SetIndexDrawBegin(0,InpMomPeriod);
   return(INIT_SUCCEEDED);
   }
//+------------------------------------------------------------------+
//| Momentum                                                         |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,    // количество баров, доступных индикатору для расчета (баров на графике)
                const int prev_calculated,// значение, которое вернула функция OnCalculate() на предыдущем вызове
                const datetime &time[],   //
                const double &open[],     // Если с момента последнего вызова функции OnCalculate() ценовые данные были изменены (подкачана более глубокая история или были заполнены пропуски истории), 
                const double &high[],     // то значение входного параметра prev_calculated будет установлено в нулевое значение самим терминалом. 
                const double &low[],      // 
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
   {//Print("Bars = ",Bars(Symbol(),0),", rates_total = ",rates_total,", prev_calculated = ",prev_calculated," time[0] = ",time[0]," time[rates_total-1] = ",time[rates_total-1]); 
      
   int limit;

   if (rates_total<=InpMomPeriod) return(0);//--- check for bars count and input parameter
      
//--- counting from 0 to rates_total
   ArraySetAsSeries(MOM,false);
   ArraySetAsSeries(close,false);
//--- initial zero
   if (prev_calculated<=0){
      for (int b=0; b<InpMomPeriod; b++)    MOM[b]=0.0;
      limit=InpMomPeriod;
   }else
      limit=prev_calculated-1;
   Print("limit=",limit," rates_total=",rates_total," prev_calculated=",prev_calculated);   
//--- the main loop of calculations
   for (int b=limit; b<rates_total; b++){
      Print("bar=",b,"  ",TimeToStr(Time[b],TIME_DATE | TIME_MINUTES));
      MOM[b]=close[b]*100/close[b-InpMomPeriod];
      }

   return(rates_total); // количество баров при текущем вызове функции
   }
