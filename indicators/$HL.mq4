// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property description "Встроена функция R/W для ускорения оптимизации. При первом вызове создается файл со значениями индикатора, при последующих вызовах из него считываются посчитанные значения. Не дает никакого преимущества в скорости"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 clrBlack // iHI
#property indicator_color2 clrBlack // iLO
#property indicator_color3 clrGainsboro // MaxHI
#property indicator_color4 clrGainsboro // MinLO

extern int HL=1; // 1..9 Type
extern int iHL=8;// 1..8 Period
double iHI[], iLO[],  HI, LO, iMaxHI[], iMinLO[], MaxHI, MinLO; 
int Per=1, SessionBars, BarsInDay, f=1;
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int OnInit(void){
   string Name="$HL."+DoubleToStr(HL,0)+"."+DoubleToStr(iHL,0);
   //IND_INIT(Name);
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,iHI);      SetIndexLabel(0,"iHI");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,iLO);      SetIndexLabel(1,"iLO");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,iMaxHI);   SetIndexLabel(2,"MaxHI");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,iMinLO);   SetIndexLabel(3,"MinLO");
   if (HL<1 || HL>9){//--- check for input parameter
      Print("Wrong input parameter HL=",HL);
      return(INIT_FAILED);
      }
   double Adpt=60/Period();  // адаптация периода индикатора к таймфрейму
   switch (HL){
         case 1:  Per=int(MathPow(iHL,1.7)*Adpt);  Name=Name+" Nearest F ("          +DoubleToStr(Per,0)+")"; break; //  При пробитии одного из уровней ищутся ближайшие фракталы шириной Per бар. 
         case 2:  Per=int((iHL+1)*Adpt);           Name=Name+" Distant F(1) ATR*"    +DoubleToStr(Per,0)+")"; break; // При пробитии одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены
         case 3:  Per=int((iHL+1)*Adpt);           Name=Name+" Tr Distant F(1) ATR*" +DoubleToStr(Per,0)+")"; break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
         case 4:  Per=int((iHL+1)*Adpt);           Name=Name+" Trailing ATR*"        +DoubleToStr(Per,0)+")"; break; // При пробое Н ищется LO далее Per*ATR от текущей цены 
         case 5:  Per=int(MathPow(iHL+1,1.7)*Adpt);  Name=Name+" Classic F("           +DoubleToStr(Per,0)+")"; break; // Фракталы шириной Per бар. 
         case 6:  Per=int((iHL+1)*Adpt);           Name=Name+" Strong F(1)ATR*"      +DoubleToStr(Per,0)+")"; break; // При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
         case 7:  Per=int(MathPow(iHL+1,1.7)*Adpt);Name=Name+" Classic ("            +DoubleToStr(Per,0)+")"; break; // экстремумы на заданном периоде
         case 8:  Per=int((iHL-1)*3*Adpt);         Name=Name+" DayBegin ("           +DoubleToStr(Per,0)+")"; break; // Hi/Lo за 24+N часов
         case 9:  Per=int(iHL*Adpt);               Name=Name+" VolumeCluster ("      +DoubleToStr(Per,0)+")"; break; //  
         default: Per=int((iHL+1)*Adpt);           Name=Name+" no ("                 +DoubleToStr(Per,0)+")"; break;
         }
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   SessionBars=int(Per*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   IndicatorShortName(Name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 

int Trend=0, DayBar=0;
uint Ext;
bool ReCntHi, ReCntLo;
void start(){ 
   int CountBars, b=0;
   double D=0, h=0, l=0, c=0, o=0;
   if (IndicatorCounted()<=0){//--- initial zero
      MaxHI=High[Bars-1];  
      MinLO=Low[Bars-1];   
      for (int bar=Bars-1; bar>Bars-Per-1; bar--){
         if (High[bar]>MaxHI) MaxHI=High[bar]; 
         if (Low [bar]<MinLO) MinLO=Low [bar]; //    
         iHI[bar]=MaxHI; iMaxHI[bar]=MaxHI; 
         iLO[bar]=MinLO; iMinLO[bar]=MinLO; 
         }  
      HI=MaxHI;   
      LO=MinLO;
      CountBars=Bars-Per-1;
   }else{
      CountBars=Bars-IndicatorCounted()-1; // IndicatorCounted() меньше на 1 чем prev_calculated в новом типе индикаторов
      }//  
   for (int bar=CountBars; bar>0; bar--){    //Print("bar=",bar,"  ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," CountBars=",CountBars," Bars=",Bars," IndicatorCounted()=",IndicatorCounted());
      //if (READ_DATA(bar, iHI[bar], iLO[bar])) continue; // если данные закончились, переходим в режим записи. Либо, индикатор уже посчитан, и пересчитывать его не стоит.
      if (bar<Bars-1000) break;
      ReCntHi=true; ReCntLo=true;
      if (High[bar]>=MaxHI){// обновление абсолютного  пика
         MaxHI=High[bar]; 
         HI=High[bar];
         ReCntHi=false; // не стоит искать уровень, т.к. выше абсолютного пика его быть не может
         }//if (bar>99900) Print(" MaxHI ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES),"      bar=",bar,"  ", " HI=",HI," High[bar]=",High[bar]," ReCntHi=",ReCntHi);
      if (Low [bar]<=MinLO){  
         MinLO=Low [bar]; 
         LO=Low[bar];
         ReCntLo=false;
         }  
      switch (HL){
         case 1: // Nearest F(Per). При пробое одного из уровней ищутся ближайшие фракталы шириной Per бар. if (bar>99900) Print(TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES),"      bar=",bar,"  ", " HI=",HI," High[bar]=",High[bar]," LO=",LO," Low[bar]=",Low[bar]);
            if (High[bar]>=HI || Low[bar]<=LO){   // пробитие одной из границ канала
               //ReCntHi=true; ReCntLo=true;
               b=bar;
               int a=0; Ext=0;
               while (ReCntHi || ReCntLo){ // обе границы находим заново
                  //b++; if (b>Bars-Per*2) break; // счетчик бар     
                  //if (ReCntHi && High[b+Per]>High[bar] && High[b+Per]==High[iHighest(NULL,0,MODE_HIGH,Per*2+1,b)]) {HI=High[b+Per];  ReCntHi=false;}// пока не найдется новый фрактал выше текущего бара заданной ширины
                  //if (ReCntLo && Low [b+Per]<Low [bar] && Low [b+Per]==Low [iLowest (NULL,0,MODE_LOW ,Per*2+1,b)]) {LO=Low [b+Per];  ReCntLo=false;}  
                  
                  a++; if (bar+a+Per*2>Bars) break;
                  if (ReCntHi && High[bar+a]==High[iHighest(NULL,0,MODE_HIGH,a+Per,bar)]) {HI=High[bar+a];  ReCntHi=false;}// пока не найдется новый фрактал выше текущего бара заданной ширины
                  if (ReCntLo && Low [bar+a]==Low [iLowest (NULL,0,MODE_LOW ,a+Per,bar)]) {LO=Low [bar+a];  ReCntLo=false;}  
                  //Print(TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES),"      bar=",bar," a=",a," bar+a=",bar+a, " HI=",HI," High[bar]=",High[bar]," High[bar+a]=",High[bar+a]," LO=",LO," Low[bar]=",Low[bar]);
                  Ext++;     
               }  }
         break; 
         case 2: // Distant F(1). При пробое одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены 
            if (High[bar]>=HI || Low[bar]<=LO){   // пробитие одной из границ канала
               b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               while (ReCntHi || ReCntLo){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (ReCntHi && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-Low[bar]>D) {HI=High[b+f];  ReCntHi=false;} // пока не найдется новый фрактал выше текущего бара, 
                  if (ReCntLo && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && High[bar]-Low[b+f]>D) {LO=Low [b+f];  ReCntLo=false;}// давший движение более ATR*Per
               }  }
         break;       
         case 3: // Trend Distant F(1). Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
            D=iATR(NULL,0,100,bar)*Per;
            if (Trend<=0){ // при нисходящем тренде
               if (Low[bar]<=LO) FIND_LO(bar,f); // при пробитии LO ищем ниже ближайший фрактал шириной f=1
               if (High[bar]>LO+D){// отдаление от нижней границы
                  Trend=1; 
                  FIND_HI(bar,f); // ближайший фрактал сверху шириной f=1
               }  }        
            if (Trend>=0){ // Тренд вверх
               if (High[bar]>=HI) FIND_HI(bar,f); // при пробитии HI ищем выше ближайший фрактал шириной f=1
               if (Low[bar]<HI-D){
                  Trend=-1;
                  FIND_LO(bar,f);
               }  }  
         break;             
         case 4: // Trailing - При пробое Н ищется LO далее Per*ATR от текущей цены 
            if (Low[bar]<=LO){  // пробой нижней границы  
               b=bar; 
               D=Per*iATR(NULL,0,100,bar);
               while (ReCntHi || ReCntLo){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (ReCntHi && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-Low[bar]>D)   {HI=High[b+f]; ReCntHi=false;} // любой фрактал выше текущей цены на Per*ATR 
                  if (ReCntLo && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)])                           {LO=Low [b+f]; ReCntLo=false;} // любой ближайший фрактал снизу
               }  }
            if (High[bar]>=HI ){   // 
               b=bar; 
               D=Per*iATR(NULL,0,100,bar);
               while (ReCntHi || ReCntLo){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (ReCntHi && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)])                           {HI=High[b+f]; ReCntHi=false;} // любой ближайший фрактал сверху 
                  if (ReCntLo && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && High[bar]-Low[b+f]>D)   {LO=Low [b+f]; ReCntLo=false;} // любой фрактал ниже текущей цены на Per*ATR 
               }  }
         break;
         case 5: // Classic F(Per). Фракталы шириной Per бар. 
            if (bar>Bars-Per-1) break;
            if (High[bar]>=HI) FIND_HI(bar,Per); // при пробое верхней границы ищем ближайший фрактал шириной Per
            else              if (High[bar+Per]==High[iHighest(NULL,0,MODE_HIGH,Per*2+1,bar)])  HI=High[bar+Per]; // сформировался фрактал шириной Per
            if (Low[bar]<=LO)  FIND_LO(bar,Per); 
            else              if (Low[bar+Per] ==Low [iLowest (NULL,0,MODE_LOW ,Per*2+1,bar)])  LO= Low[bar+Per];
         break;
         case 6:  // Strong F(1) При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
            if (High[bar]>=HI || Low[bar]<=LO){   // пробитие одной из границ канала
               b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               double BackH=Low[bar], BackL=High[bar];   // уровни заднего фронта для HI и LO (величина отскока от пика)
               while (ReCntHi || ReCntLo){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (Low [b]<BackH)   BackH=Low[b]; // фиксируем максимальну и минимальную цены от текущего бара до искомых пиков, это будут
                  if (High[b]>BackL)   BackL=High[b];// их Back уровни - движения, которые дал пик.
                  if (ReCntHi && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-BackH>D) {HI=High[b+f]; ReCntHi=false;} // пока не найдется новый фрактал выше текущего бара, 
                  if (ReCntLo && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && BackL-Low [b+f]>D) {LO=Low [b+f]; ReCntLo=false;} // давший движение более ATR*Per
               }  }
         break;       
         case 7: // HL_Classic 
            if (bar>Bars-Per-1) break;
            HI=High[bar]; LO=Low[bar];
            for (b=bar+1; b<=bar+Per; b++){
               if (High[b]>HI) HI=High[b];
               if (Low[b]<LO)  LO=Low[b];} 
                
         break;
         case 8: // DayBegin Hi/Lo за 24+N часов
            if (bar>Bars-2) break;
            DayBar++;// номер бара с начала дня
            if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
            if (DayBar==Per){// номер бара с начала дня совпал с заданным значением
               HI=High[iHighest(NULL,0,MODE_HIGH,SessionBars,bar)]; // максимум с начала прошлой сессии до текущего бара
               LO=Low [iLowest (NULL,0,MODE_LOW ,SessionBars,bar)];
               } 
            if (HI<High[bar]) HI=High[bar];
            if (LO>Low[bar])  LO=Low[bar];      
         break;
         case 9: // VolumeCluster
            if (bar>Bars-Per-f-1) break; 
            D=(13-Per)*0.03; // при Per=1..9, D=36%-12%, (25% у автора) 
            c=Close[bar+1];
            h=High[bar+1];
            l=Low [bar+1];
            for (b=bar+1; b<=bar+f+1; b++){
               if (High[b]>h) h=High[b];
               if (Low [b]<l) l=Low [b];
               o=Open[b];
               if (h-l>iATR(NULL,0,100,bar)*1.5){//  Не работаем в узком диапазоне
                  if ((h-o)/(h-l)<D && (h-c)/(h-l)<D) {LO=l; HI=h;} // Нижний "Фрактал" (открытие и закрытие в верхней части Bar баров)
                  if ((o-l)/(h-l)<D && (c-l)/(h-l)<D) {LO=l; HI=h;} // верхний "фрактал"
               }  }  
            if (HI<High[bar]) HI=High[bar];
            if (LO>Low[bar])  LO=Low[bar];      
         break;
         default://
            HI=High[bar]; LO=Low[bar];
         break;   
         }
      if (High[bar]>HI) iHI[bar]=MaxHI; else iHI[bar]=HI; // 
      if ( Low[bar]<LO) iLO[bar]=MinLO; else iLO[bar]=LO;    
      iMaxHI[bar]=MaxHI; 
      iMinLO[bar]=MinLO;
      Print("Ext=",Ext);
      //if (bar>Bars-20)  Print(TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," iHI=",iHI[bar]," iLO=",iLO[bar]);
      //WRITE_DATA(bar, iHI[bar], iLO[bar]);
   }  }    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void FIND_HI(int bar, int width){
   int b=bar;
   while (ReCntHi){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (High[b+width]>High[bar] && High[b+width]==High[iHighest(NULL,0,MODE_HIGH,width*2+1,b)]) {HI=High[b+width]; ReCntHi=false;}
   }  }   
void FIND_LO(int bar, int width){   
   int b=bar;
   while (ReCntLo){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (Low [b+width]<Low [bar] && Low [b+width]==Low [iLowest (NULL,0,MODE_LOW ,width*2+1,b)]) {LO=Low [b+width]; ReCntLo=false;}
   }  } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
// режим R/W для ускорения оптимизации. 
// При первом вызове создается файл со значениями индикатора, при последующих вызовах из него считываются посчитанные значения. 
// Не дает никакого преимущества в скорости"
// для его активации разкомментировать функции IND_INIT, READ_DATA, WRITE_DATA и  
#define WRITE  0
#define READ   1
#define NONE  -1 // отключение режима RW (присвоить при инициализации переменной Mode)
int Mode, File; // =NONE
void IND_INIT(string Name){
   if (Mode==NONE) return;
   string FileName="x"+Name+"_"+Symbol()+DoubleToStr(Period(),0)+".csv";
   if (FileIsExist(FileName,0)){// файл уже готов, переходим в
      Mode=READ;  Print("Open ", FileName," in READ mode");  // режим чтения    
   }else{//  файла не было
      Mode=WRITE; Print("Open ", FileName," in WRITE mode"); // переходим в режим записи файла 
      }
   File=FileOpen(FileName, FILE_SHARE_READ | FILE_SHARE_WRITE, ';'); // проверка наличия файла - попытка открыть в режиме чтения   
   if (File<0) Print("Can't open ", FileName);
   } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
bool SEARCH_DATA(int bar){
   if (bar>=Bars) return(false);
   string BarTime=TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES); // будем искать строку с временем текущего бара, от которого продолжится считывание данных
   FileSeek (File,0,SEEK_SET);
   while (FileReadString(File)!=BarTime){ // ищем строку с датой начала тестирования
      if (FileIsEnding(File)){// добрались до конца файла, строка так и не нашлась
         Print("Can't find string with time ",BarTime);
         return(false);
      }  }
   FileSeek (File,-17,SEEK_CUR);   // нашли нужную строку, отмотаем назад, чтобы потом читать с самого начала этой строки     
   Print("Find string ",BarTime);
   return (true);
   } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
bool READ_DATA(int bar, double& I0, double& I1){
   if (Mode!=READ) return(false); // false - флаг необходимости пересчета индюка
   string ReadTime, // время бара записанных в файле данных для сравнения с 
   BarTime=TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES); // временем текущего бара
   for (;;){
      ReadTime=FileReadString(File);
      I0=StrToDouble(FileReadString(File)); 
      I1=StrToDouble(FileReadString(File));
      //Print("READ: ",ReadTime," I0=",I0," I1=",I1);  // line++; if (line<5) 
      if (ReadTime==BarTime)   return(true); // из файла cчитаны данные для текущего бара, выходим с флагом успешного выполнения
      if (!SEARCH_DATA(bar)) break; // считанные данные не совпали и в файле не найдено нужной строки, переходим в режим записи
      }
   Mode=WRITE; // переходим в режим записи.
   FileSeek(File,0,SEEK_END); // перемещаемся в конец файла для продолжения записи
   //Print("ReadTime!=BarTime, switch to WRITE MODE. ReadTime=",ReadTime," BarTime=",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)); 
   return(false);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void WRITE_DATA(int bar, double I0, double I1){
   if (Mode!=WRITE) return;
   FileWrite(File, TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES), I0, I1); 
   //Print("WRITE: bar",bar," ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," I0=", I0," I1=", I1);
   }       
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void OnDeinit(const int reason){
   FileClose(File);
    switch (reason){ // вместо reason можно использовать UninitializeReason()
      //case 0: str="Эксперт самостоятельно завершил свою работу"; break;
      case 1: Print("Indicator DEINIT: Program "+" removed from chart"); break;
      case 2: Print("Indicator DEINIT: Program "+" recompile"); break;
      case 3: Print("Indicator DEINIT: Symbol or Period was CHANGED!"); break;
      case 4: Print("Indicator DEINIT: Chart closed!"); break;
      case 5: Print("Indicator DEINIT: Input Parameters Changed!"); break;
      case 6: Print("Indicator DEINIT: Another Account Activate!"); break; 
      case 9: Print("Indicator DEINIT: Terminal closed!"); break;   
   }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
   
