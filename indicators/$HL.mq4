// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrBlack
#property indicator_color2 clrBlack


extern int HL=1; // 1..9 Type
extern int iHL=8;// 1..8 Period
double HI[], LO[], max, min; 
int Per=1, SessionBars, BarsInDay, f=1;

int OnInit(void){
   string Name="$HL."+DoubleToStr(HL,0)+"."+DoubleToStr(iHL,0);
   //if (!IND_INIT(Name)) return (INIT_FAILED);
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,HI);   SetIndexLabel(0,"HI");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,LO);   SetIndexLabel(1,"LO");
   double Adpt=60/Period(); // адаптация периода индикатора к таймфрейму
   switch (HL){
         case 1:  Per=int(MathPow(iHL,1.7)*Adpt);  Name=Name+"Nearest F ("          +DoubleToStr(Per,0)+")"; break; //  При пробитии одного из уровней ищутся ближайшие фракталы шириной Per бар. 
         case 2:  Per=int((iHL+1)*Adpt);           Name=Name+"Distant F(1) ATR*"    +DoubleToStr(Per,0)+")"; break; // При пробитии одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены
         case 3:  Per=int((iHL+1)*Adpt);           Name=Name+"Tr Distant F(1) ATR*" +DoubleToStr(Per,0)+")"; break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
         case 4:  Per=int((iHL+1)*Adpt);           Name=Name+"Trailing ATR*"        +DoubleToStr(Per,0)+")"; break; // При пробое Н ищется L далее Per*ATR от текущей цены 
         case 5:  Per=int(MathPow(iHL,1.7)*Adpt);  Name=Name+"Classic F("           +DoubleToStr(Per,0)+")"; break; // Фракталы шириной Per бар. 
         case 6:  Per=int((iHL+1)*Adpt);           Name=Name+"Strong F(1)ATR*"      +DoubleToStr(Per,0)+")"; break; // При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
         case 7:  Per=int(MathPow(iHL+1,1.7)*Adpt);Name=Name+"Classic ("            +DoubleToStr(Per,0)+")"; break; // экстремумы на заданном периоде
         case 8:  Per=int((iHL-1)*3*Adpt);         Name=Name+"DayBegin ("           +DoubleToStr(Per,0)+")"; break; // Hi/Lo за 24+N часов
         case 9:  Per=int(iHL*Adpt);               Name=Name+"VolumeCluster ("      +DoubleToStr(Per,0)+")"; break; //  
         default: Per=int((iHL+1)*Adpt);           Name=Name+"no ("                 +DoubleToStr(Per,0)+")"; break;
         }
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   SessionBars=int(Per*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   //Print(" BarsInDay=",BarsInDay," SessionBars=",SessionBars);      
   //Print(Name);  
   max=High[Bars-1]; min=Low[Bars-1]; 
   IndicatorShortName(Name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
double SigHL,  H, L;
int TrendHL=0, DayBar=0;
int start(){ 
   int CountBars=Bars-IndicatorCounted()-1;
   int b=0;
   double D=0, h=0, l=0, c=0, o=0;
   for (int bar=CountBars; bar>0; bar--){     Print("bar=",bar,"  ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
      //if (READ_DATA(bar, HI[bar], LO[bar])) continue; // если данные закончились, переходим в режим записи. Либо, индикатор уже посчитан, и пересчитывать его не стоит.
      if (High[bar]>max)   max=High[bar]+(High[bar]-Low[bar]);
      if (Low [bar]<min)   min=Low [bar]-(High[bar]-Low[bar]);
      switch (HL){
         case 1: // Nearest F(Per). При пробое одного из уровней ищутся ближайшие фракталы шириной Per бар. 
            if (High[bar]>H || Low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar;
               f=Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-Per*2) break; // счетчик бар                
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)]) H=High[b+f]; // пока не найдется новый фрактал выше текущего бара заданной ширины
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)]) L=Low [b+f];
               }  }
         break; 
         case 2: // Distant F(1). При пробое одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены 
            if (High[bar]>H || Low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-Low[bar]>D) H=High[b+f]; // пока не найдется новый фрактал выше текущего бара, 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && High[bar]-Low[b+f]>D) L=Low [b+f]; // давший движение более ATR*Per
               }  }
         break;       
         case 3: // Trend Distant F(1). Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
            D=iATR(NULL,0,100,bar)*Per;
            if (TrendHL<=0){ // при нисходящем тренде
               if (Low[bar]<L) FIND_LO(bar,f); // при пробитии L ищем ниже ближайший фрактал шириной f=1
               if (High[bar]>L+D){// отдаление от нижней границы
                  TrendHL=1; 
                  FIND_HI(bar,f); // ближайший фрактал сверху шириной f=1
               }  }        
            if (TrendHL>=0){ // Тренд вверх
               if (High[bar]>H) FIND_HI(bar,f); // при пробитии H ищем выше ближайший фрактал шириной f=1
               if (Low[bar]<H-D){
                  TrendHL=-1;
                  FIND_LO(bar,f);
               }  }  
         break;             
         case 4: // Trailing - При пробое Н ищется L далее Per*ATR от текущей цены 
            if (Low[bar]<L){  // пробой нижней границы 
               H=0; L=0; b=bar; 
               D=Per*iATR(NULL,0,100,bar);
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-Low[bar]>D)   H=High[b+f]; // любой фрактал выше текущей цены на Per*ATR 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)])                           L=Low [b+f]; // любой ближайший фрактал снизу
               }  }
            if (High[bar]>H ){   // 
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)])                           H=High[b+f]; // любой ближайший фрактал сверху 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && High[bar]-Low[b+f]>D)   L=Low [b+f]; // любой фрактал ниже текущей цены на Per*ATR 
               }  }
         break;
         case 5: // Classic F(Per). Фракталы шириной Per бар. 
            if (bar>Bars-Per-1) break;
            if (High[bar]>H)  FIND_HI(bar,Per); // при пробое верхней границы ищем ближайший фрактал шириной Per
            else              if (High[bar+Per]==High[iHighest(NULL,0,MODE_HIGH,Per*2+1,bar)])  H=High[bar+Per]; // сформировался фрактал шириной Per
            if (Low[bar]<L)   FIND_LO(bar,Per); 
            else              if (Low[bar+Per] ==Low [iLowest (NULL,0,MODE_LOW ,Per*2+1,bar)])  L= Low[bar+Per];
         break;
         case 6:  // Strong F(1) При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
            if (High[bar]>H || Low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               double BackH=Low[bar], BackL=High[bar];   // уровни заднего фронта для H и L (величина отскока от пика)
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (Low [b]<BackH)   BackH=Low[b]; // фиксируем максимальну и минимальную цены от текущего бара до искомых пиков, это будут
                  if (High[b]>BackL)   BackL=High[b];// их Back уровни - движения, которые дал пик.
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-BackH>D) H=High[b+f]; // пока не найдется новый фрактал выше текущего бара, 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && BackL-Low [b+f]>D) L=Low [b+f]; // давший движение более ATR*Per
               }  }
         break;       
         case 7: // HL_Classic 
            if (bar>Bars-Per-1) break;
            b=bar+1; H=High[bar]; L=Low[bar];
            //while(!BarCounter(b,bar,Per)){
            for (b=bar+1; b<=bar+Per; b++){
               if (High[b]>H) H=High[b];
               if (Low[b]<L)  L=Low[b];} 
                
         break;
         case 8: // DayBegin Hi/Lo за 24+N часов
            if (bar>Bars-2) break;
            DayBar++;// номер бара с начала дня
            if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
            if (DayBar==Per){// номер бара с начала дня совпал с заданным значением
               H=High[iHighest(NULL,0,MODE_HIGH,SessionBars,bar)]; // максимум с начала прошлой сессии до текущего бара
               L=Low [iLowest (NULL,0,MODE_LOW ,SessionBars,bar)];
               } 
            if (H<High[bar]) H=High[bar];
            if (L>Low[bar])  L=Low[bar];      
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
                  if ((h-o)/(h-l)<D && (h-c)/(h-l)<D) {L=l; H=h;  SigHL=L;} // Нижний "Фрактал" (открытие и закрытие в верхней части Bar баров)
                  if ((o-l)/(h-l)<D && (c-l)/(h-l)<D) {L=l; H=h;  SigHL=H;} // верхний "фрактал"
               }  }  
            if (H<High[bar]) H=High[bar];
            if (L>Low[bar])  L=Low[bar];      
         break;
         default://
            H=High[bar]; L=Low[bar];
         break;   
         }
      
      if (H>0) HI[bar]=H; 
      else HI[bar]=max;// попался исторический максимум, присваиваем максимальное значение графика 
      if (L>0) LO[bar]=L; //Print("HL: H=",H," L=",L);
      else LO[bar]=min;     
      
      //WRITE_DATA(bar, HI[bar], LO[bar]);
      }    
   return(0);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void FIND_HI(int bar, int width){
   H=0; int b=bar;
   while (!H){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (High[b+width]>High[bar] && High[b+width]==High[iHighest(NULL,0,MODE_HIGH,width*2+1,b)]) H=High[b+width];
   }  }   
void FIND_LO(int bar, int width){   
   L=0; int b=bar;
   while (!L){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (Low [b+width]<Low [bar] && Low [b+width]==Low [iLowest (NULL,0,MODE_LOW ,width*2+1,b)]) L=Low [b+width];
   }  } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
#define WRITE 0
#define READ 1
int Mode, File;
bool IND_INIT(string Name){
   string FileName="x"+Name+"_"+Symbol()+DoubleToStr(Period(),0)+".csv";
   if (FileIsExist(FileName,0)){// файл уже готов, переходим в
      Mode=READ;  Print("Open ", FileName," in READ mode");  // режим чтения    
   }else{//  файла не было
      Mode=WRITE; Print("Open ", FileName," in WRITE mode"); // переходим в режим записи файла 
      }
   File=FileOpen(FileName, FILE_READ | FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE, ';'); // проверка наличия файла - попытка открыть в режиме чтения   
   if (File<0) Print("Can't open ", FileName);
   if (Mode==READ){
      if (!SEARCH_DATA(Bars-1)){ // строка не найдена, на этапе инициализации проще перезаписать  все заново
         FileClose(File); FileDelete(FileName); // удаляем некчемный файл
         File=FileOpen(FileName, FILE_READ | FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE, ';'); // и заводим новый
         Print("Delete and ReOpen ", FileName," in Write Mode");
         Mode=WRITE; // переход в режим записи
      }  }
   return(true);   
   } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
bool SEARCH_DATA(int bar){
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
   if (Mode!=READ) return(false); // флаг необходимости пересчета индюка
   string ReadTime, // время бара записанных в файле данных для сравнения с 
   BarTime=TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES); // временем текущего бара
   for (;;){
      ReadTime=FileReadString(File);
      I0=StrToDouble(FileReadString(File)); 
      I1=StrToDouble(FileReadString(File));
      Print("READ: ",ReadTime," I0=",I0," I1=",I1);  // line++; if (line<5) 
      if (ReadTime==BarTime)   return(true); // из файла cчитаны данные для текущего бара, выходим с флагом успешного выполнения
      if (!SEARCH_DATA(bar)) break; // считанные данные не совпали и в файле не найдено нужной строки, переходим в режим записи
      }
   Mode=WRITE; // переходим в режим записи.
   FileSeek(File,0,SEEK_END); // перемещаемся в конец файла для продолжения записи
   Print("ReadTime!=BarTime, switch to WRITE MODE. ReadTime=",ReadTime," BarTime=",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)); 
   return(false);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void WRITE_DATA(int bar, double I0, double I1){
   if (Mode!=WRITE) return;
   FileWrite(File, TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES), I0, I1); 
   Print("WRITE: bar",bar," ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," I0=", I0," I1=", I1);
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
   
