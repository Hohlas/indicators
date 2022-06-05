// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 White    // H1
#property indicator_color2 Yellow    // H2
#property indicator_color3 Orange    // H3
#property indicator_color4 Red // H4
#property indicator_color5 White // L1
#property indicator_color6 Yellow // L2
#property indicator_color7 Orange // L3
#property indicator_color8 Red // L4

#include <i$$_Indicators.mqh>
extern int N=5; 
double   LayerH1[],LayerH2[],LayerH3[],LayerH4[],LayerL1[],LayerL2[],LayerL3[],LayerL4[];
float ATR;
int bar, HL, HLk; 
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ             
int OnInit(void){
   string Name="Layers."+DoubleToStr(N,0);
   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,LayerH1);   SetIndexLabel(0,"H1");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,LayerH2);   SetIndexLabel(1,"H2");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,LayerH3);   SetIndexLabel(2,"H3");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,LayerH4);   SetIndexLabel(3,"H4");
   SetIndexStyle(4,DRAW_LINE);   SetIndexBuffer(4,LayerL1);   SetIndexLabel(4,"L1");
   SetIndexStyle(5,DRAW_LINE);   SetIndexBuffer(5,LayerL2);   SetIndexLabel(5,"L2");
   SetIndexStyle(6,DRAW_LINE);   SetIndexBuffer(6,LayerL3);   SetIndexLabel(6,"L3");
   SetIndexStyle(7,DRAW_LINE);   SetIndexBuffer(7,LayerL4);   SetIndexLabel(7,"L4");
   IndicatorShortName(Name);
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void start(){
   int CountBars=Bars-IndicatorCounted()-1;
   for (bar=CountBars; bar>0; bar--){ //Print("bar=",bar,"  ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
     // if (bar>Bars-2) continue;
      LAYERS(N);
      LayerH1[bar]=LayH1; 
      LayerL1[bar]=LayL1;  
      LayerH2[bar]=LayH2;    
      LayerL2[bar]=LayL2;    
      LayerH3[bar]=LayH3;  
      LayerL3[bar]=LayL3;
      LayerH4[bar]=LayH4; 
      LayerL4[bar]=LayL4;  
   }  }  
