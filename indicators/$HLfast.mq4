// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property description "Встроена функция R/W для ускорения оптимизации. При первом вызове создается файл со значениями индикатора, при последующих вызовах из него считываются посчитанные значения. Не дает никакого преимущества в скорости"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 clrBlue // iHI
#property indicator_color2 clrBlue // iLO
#property indicator_color3 clrGainsboro // MaxHI
#property indicator_color4 clrGainsboro // MinLO

extern int HL=1; // 1..9 Type
extern int HLk=8;// 1..8 Period
double iHI[], iLO[], iMaxHI[], iMinLO[]; 
#include <i$$_Indicators.mqh>
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int OnInit(void){
   string Name="$HLfast."+DoubleToStr(HL,0)+"."+DoubleToStr(HLk,0);
   //if (!IND_INIT(Name)) return (INIT_FAILED);
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,iHI);     SetIndexLabel(0,"iHI");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,iLO);     SetIndexLabel(1,"iLO");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,iMaxHI);  SetIndexLabel(2,"MaxHI");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,iMinLO);  SetIndexLabel(3,"MinLO");
   if (HL<1 || HL>9){//--- check for input parameter
      Print("Wrong input parameter HL=",HL);
      return(INIT_FAILED);
      }
   double Adpt=60/Period(); // адаптация периода индикатора к таймфрейму
   switch (HL){
         case 1:  HLper=int(MathPow(HLk,1.7)*Adpt);  Name=Name+"Nearest F ("          +DoubleToStr(HLper,0)+")"; break; //  При пробитии одного из уровней ищутся ближайшие фракталы шириной HLper бар. 
         case 2:  HLper=int((HLk+1)*Adpt);           Name=Name+"Distant F(1) ATR*"    +DoubleToStr(HLper,0)+")"; break; // При пробитии одного из уровней ищутся фракталы шириной f=1 далее ATR*HLper от текущей цены
         case 3:  HLper=int((HLk+1)*Adpt);           Name=Name+"Tr Distant F(1) ATR*" +DoubleToStr(HLper,0)+")"; break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*HLper от последнего лоу
         case 4:  HLper=int((HLk+1)*Adpt);           Name=Name+"Trailing ATR*"        +DoubleToStr(HLper,0)+")"; break; // При пробое Н ищется LO далее HLper*ATR от текущей цены 
         case 5:  HLper=int(MathPow(HLk,1.7)*Adpt);  Name=Name+"Classic F("           +DoubleToStr(HLper,0)+")"; break; // Фракталы шириной HLper бар. 
         case 6:  HLper=int((HLk+1)*Adpt);           Name=Name+"Strong F(1)ATR*"      +DoubleToStr(HLper,0)+")"; break; // При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*HLper
         case 7:  HLper=int(MathPow(HLk+1,1.7)*Adpt);Name=Name+"Classic ("            +DoubleToStr(HLper,0)+")"; break; // экстремумы на заданном периоде
         case 8:  HLper=int((HLk-1)*3*Adpt);         Name=Name+"DayBegin ("           +DoubleToStr(HLper,0)+")"; break; // Hi/Lo за 24+HLper часов
         case 9:  HLper=int(HLk*Adpt);               Name=Name+"VolumeCluster ("      +DoubleToStr(HLper,0)+")"; break; //  
         default: HLper=int((HLk+1)*Adpt);           Name=Name+"no ("                 +DoubleToStr(HLper,0)+")"; break;
         }
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   SessionBars=int(HLper*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   MaxHI=float(High[Bars-1]); 
   MinLO=float(Low [Bars-1]); 
   IndicatorShortName(Name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int bar;         
float H, L, ATR;
int start(){ 
   int CountBars=Bars-IndicatorCounted()-1; // IndicatorCounted() меньше на 1 чем prev_calculated в новом типе индикаторов  
   for (bar=CountBars; bar>0; bar--){    // Print("bar=",bar,"  ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
      ATR=float(iATR(NULL,0,100,bar));
      iHILO();
      iHI[bar]=H; iMaxHI[bar]=MaxHI;
      iLO[bar]=L; iMinLO[bar]=MinLO;
      }    
   return(0);
   }
