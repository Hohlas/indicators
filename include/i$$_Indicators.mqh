


// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
//                                        D I R E C T     M O V E N T 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                             
float DM,DM1, DMmax,DMmin;
void iDM(int MODE, int per){//      MODE=0..3, per=1..10
   if (bar+per>=Bars) return;
   float Noise=0, Line=0, Delta=0, UP=0, DN=0, MO=0; 
   DM1=DM;
   switch (MODE){
      case 0: // Classic
         DM=0;
         for (int b=bar; b<bar+per; b++){ 
            if (High[b]>High[b+1]) DM+=float(High[b]-High[b+1]);
            if (Low[b] <Low [b+1]) DM+=float(Low [b]-Low [b+1]); 
            }
      break;
      case 1: // Signal / Noise
         for (int b=bar; b<bar+per; b++)  Noise+=MathAbs(float(High[b]+Low[b]+Close[b])/3 - float(High[b+1]+Low[b+1]+Close[b+1])/3); 
         if (Noise>0) DM = (float(High[bar]+Low[bar]+Close[bar])/3 - float(High[bar+per]+Low[bar+per]+Close[bar+per])/3) / Noise;  
      break;
      case 2: // UpIntegral - DnIntegral
         MO=float(Close[bar]-Close[bar+per])/per; // Momentum
         for (int b=bar; b<bar+per; b++){ 
            Line=float(Close[bar])-MO*(b-bar); // расчетное значение цены на прямой bar..(bar+per) знак "-", т.к. считаем с зада на перед
            Delta=float(Close[b])-Line;
            if (Delta>0) DN+=Delta; else UP-=Delta;
            }
         DM=UP-DN;
      break;
      case 3: // Momentum
         for (int b=bar; b<bar+per; b++)  // считаем b, т.е. bar+per
            DM=float(Open[bar]-Open[b]);
      break;
      }
   if ((DM>=0 && DM1<0) || (DM<=0 && DM1>0)) {DMmax=0; DMmin=0;}
   if (DM>DMmax) DMmax=DM;
   if (DM<DMmin) DMmin=DM; 
   //Print(TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)," DM=",DM," Min=", DMmin," Max=",DMmax);   
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
//                                        H I     L O
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                              
int BarsInDay, SessionBars, HLper, HLtrend, DayBar=0;         // кол-во бар в сессии
float o,h,l,c, HLC, MaxHI, MinLO;
void HL_init(){
   double Adpt=60/Period(); // адаптация периода индикатора к таймфрейму
   switch (HL){
      case 1:  HLper=int(MathPow(HLk,1.7)*Adpt);  break; // При пробитии одного из уровней ищутся ближайшие фракталы шириной HLper бар. 
      case 2:  HLper=int((HLk+1)*Adpt);           break; // При пробитии одного из уровней ищутся фракталы шириной per=1 далее ATR*HLper от текущей цены
      case 3:  HLper=int((HLk+1)*Adpt);           break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*HLper от последнего лоу
      case 4:  HLper=int((HLk+1)*Adpt);           break; // При пробое Н ищется L далее HLper*ATR от текущей цены 
      case 5:  HLper=int(MathPow(HLk,1.7)*Adpt);  break; // Фракталы шириной HLper бар. 
      case 6:  HLper=int((HLk+1)*Adpt);           break; // При пробое одного из уровней ищутся фракталы шириной per=1 с отскоком (силой) более ATR*HLper
      case 7:  HLper=int(MathPow(HLk+1,1.7)*Adpt);break; // экстремумы на заданном периоде
      case 8:  HLper=int((HLk-1)*3*Adpt);         break; // Hi/Lo за 24+HLper часов
      case 9:  HLper=int(HLk*Adpt);               break; //  
      default: HLper=int((HLk+1)*Adpt);           break;
      }
   MaxHI=float(High[Bars-1]);
   MinLO=float(Low [Bars-1]); 
   BarsInDay=int(24*60/Period());
   SessionBars=int(HLper*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   }
// HL=4  HL=6   одинаковые
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                             
void iHILO(){      
   float Delta=ATR*HLper, hi=float(High[bar]), lo=float(Low[bar]);
   int per=1; // минимальный период фрактала
   
   if (hi>=MaxHI)   {MaxHI=hi; H=hi;}// обновление абсолютного  пика
   if (lo<=MinLO)   {MinLO=lo; L=lo;}  
   switch (HL){
      case 1: // Nearest F(HLper). При пробое одного из уровней ищутся ближайшие фракталы шириной HLper бар. 
         if (hi>=H || lo<=L){// пробитие одной из границ канала
            for (int b=bar; b<Bars-HLper; b++)   if (FIND_HI(b,HLper,true)) break; // поиск ближайшего фрактала шириной HLper
            for (int b=bar; b<Bars-HLper; b++)   if (FIND_LO(b,HLper,true)) break; // поиск ближайшего фрактала шириной HLper
            }
      break; 
      case 2: // Distant F(1). При пробое одного из уровней ищутся фракталы шириной per=1 далее ATR*HLper от текущей цены 
         if (hi>=H || lo<=L){   // пробитие одной из границ канала
            for (int b=bar; b<Bars-per; b++)   if (FIND_HI(b,per, High[b]-lo>Delta)) break; // поиск ближайшего фрактала шириной per=1 при условии, что он будет удален на ATR*HLper
            for (int b=bar; b<Bars-per; b++)   if (FIND_LO(b,per, hi-Low[b]>Delta)) break; //
            }      
      break;       
      case 3: // HLtrend Distant F(1). Формирование хая на ближайшем фрактале(1) при удалении на ATR*HLper от последнего лоу
         if (HLtrend<=0){ // при нисходящем тренде
            if (lo<=L)  // при пробитии L
               for (int b=bar; b<Bars-per; b++)   if (FIND_LO(b,per,true)) break; // ищем ниже ближайший фрактал шириной per=1
            if (hi>L+Delta){// отдаление от нижней границы
               HLtrend=1; 
               for (int b=bar; b<Bars-per; b++)   if (FIND_HI(b,per,true)) break; // ближайший фрактал сверху шириной per=1
            }  }        
         if (HLtrend>=0){ // Тренд вверх
            if (hi>=H) // при пробитии H
               for (int b=bar; b<Bars-per; b++)   if (FIND_HI(b,per,true)) break; // ищем выше ближайший фрактал шириной per=1
            if (lo<H-Delta){ // при отдалении от верхней границы
               HLtrend=-1;
               for (int b=bar; b<Bars-per; b++)   if (FIND_LO(b,per,true)) break; // ближайший снизу фрактал шириной per=1
            }  }    
      break;             
      case 4: // Trailing - При пробое Н ищется L далее HLper*ATR от текущей цены 
         if (lo<=L){  // пробой нижней границы 
            for (int b=bar; b<Bars-per; b++)   if (FIND_HI(b,per, High[b]-lo>Delta)) break; // ближайший фрактал сверху шириной per=1 удаленный на ATR*HLper
            for (int b=bar; b<Bars-per; b++)   if (FIND_LO(b,per,true)) break;// ближайший фрактал снизу  шириной per=1
            } 
         if (hi>=H ){   // пробой верхней границы
            for (int b=bar; b<Bars-per; b++)   if (FIND_HI(b,per,true)) break;// любой ближайший фрактал сверху
            for (int b=bar; b<Bars-per; b++)   if (FIND_LO(b,per, hi-Low[b]>Delta)) break;// любой фрактал ниже текущей цены на HLper*ATR 
            } 
      break;
      case 5: // Classic F(HLper). Фракталы шириной HLper бар. 
         if (bar+HLper>=Bars) break;
         if (hi>=H){   for (int b=bar; b<Bars-HLper; b++)   if (FIND_HI(b,HLper,true)) break;} // при пробое верхней границы ищем ближайший фрактал шириной HLper
         else{                 if (High[bar+HLper]==High[iHighest(NULL,0,MODE_HIGH,HLper*2+1,bar)])  H=float(High[bar+HLper]);} // сформировался фрактал шириной HLper
         if (lo<=L){    for (int b=bar; b<Bars-HLper; b++)   if (FIND_LO(b,HLper,true)) break;} 
         else{                 if (Low[bar+HLper] ==Low [iLowest (NULL,0,MODE_LOW ,HLper*2+1,bar)])  L=float(Low [bar+HLper]);}
      break;
      case 6:  // The same as 4.  Strong F(1) При пробое одного из уровней ищутся фракталы шириной per=1 с отскоком (силой) более ATR*HLper
         if (hi>=H || lo<=L){   // пробитие одной из границ канала
            float max=hi, min=lo;
            for (int b=bar; b<Bars-per; b++){
               if (Low [b]<min) min=float(Low [b]); // минимум от искомого пика до текущего бара - величина отскока
               if (FIND_HI(b,per, High[b]-min>Delta)) break; // ближайший фрактал шириной per=1 с величиной отскока более ATR*HLper
               }
            for (int b=bar; b<Bars-per; b++){
               if (High[b]>max) max=float(High[b]);
               if (FIND_LO(b,per, max-Low[b]>Delta)) break;// любой фрактал ниже текущей цены на HLper*ATR 
            }   }
      break;       
      case 7: // HL_Classic 
         if (bar+HLper+1>Bars) break;
         H=hi; L=lo;
         for (int b=bar+1; b<=bar+HLper; b++){
            if (High[b]>H) H=float(High[b]);
            if (Low[b]<L)  L=float(Low [b]);} 
      break;
      case 8: // DayBegin Hi/Lo за 24+HLper часов
         if (bar+2>Bars) break;
         DayBar++;// номер бара с начала дня
         if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
         if (DayBar==HLper){// номер бара с начала дня совпал с заданным значением
            H=float(High[iHighest(NULL,0,MODE_HIGH,SessionBars,bar)]); // максимум с начала прошлой сессии до текущего бара
            L=float(Low [iLowest (NULL,0,MODE_LOW ,SessionBars,bar)]);
            } 
         if (H<hi) H=hi;
         if (L>lo) L=lo;      
      break;
      case 9: // VolumeCluster  Delta=(13-HLper)*0.03; // при HLper=1..9, Delta=36%-12%, (25% у автора)
         if (bar+HLper+per+1>Bars) break;  
         c=float(Close[bar+1]);
         h=float(High [bar+1]);
         l=float(Low  [bar+1]);
         Delta=float((13-HLper)*0.03); // при N=1..9, Delta=36%-12%, (25% у автора)
         for (int b=bar+1; b<=bar+per+1; b++){
            if (High[b]>h) h=float(High[b]);
            if (Low [b]<l) l=float(Low [b]);
            o=float(Open[b]);
            if (h-l>ATR*1.5){//  Не работаем в узком диапазоне
               if ((h-o)/(h-l)<Delta && (h-c)/(h-l)<Delta) {L=l; H=h;} // Нижний "Фрактал" (открытие и закрытие в верхней части Bar баров)
               if ((o-l)/(h-l)<Delta && (c-l)/(h-l)<Delta) {L=l; H=h;} // верхний "фрактал"
            }  }  
         if (H<hi) H=hi;
         if (L>lo) L=lo;      
      break;
      default://
         H=hi; L=lo;
      break;   
   }  }    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ                             
float LocalMax, LocalMin;
bool FIND_HI(int b, int width, bool Condition){ // Поиск фрактала шириной width. Condition - доп. внешнее условие
   float hi=float(High[b]);
   if (hi==MaxHI){ // добрались до абсолютного максимума Print(" H=MaxHI ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES),"      bar=",bar,"  ", " H=",H," High[bar]=",High[bar]," MaxHI=",MaxHI);
      H=hi;  return(true);}     // это будет искомый пик, дальше искать нет смысла 
   if (b==bar) {LocalMax=hi;   return(false);} // первый бар поиска, фиксируем максимальное значение на периоде поиска
   if (hi>LocalMax){ LocalMax=hi;} // цена должна быть максимальной на всем участке поиска
   if (hi==LocalMax && High[b]==High[iHighest(NULL,0,MODE_HIGH,width+1,b)]){// максимальный пик и фрактал периодом width
      H=hi;  return(true && Condition);}   // пик найден Print(TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES),"      bar=",bar,"  ", " H=",H," High[bar]=",High[bar]);
   return (false); // пока не найдется новый фрактал выше текущего бара заданной ширины   
   } 
bool FIND_LO(int b, int width, bool Condition){
   float lo=float(Low[b]);
   if (lo==MinLO){
      L=lo; return(true);}
   if (b==bar) {LocalMin=lo;    return(false);}
   if (lo<LocalMin) LocalMin=lo;
   if (lo==LocalMin && Low[b]==Low[iLowest (NULL,0,MODE_LOW ,width+1,b)]){
      L=lo; return(true && Condition);} // пока не найдется новый фрактал выше текущего бара заданной ширины
   return (false);    
   }            
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  

// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
float LayH4,LayH3,LayH2,LayH1,LayL4,LayL3,LayL2,LayL1;
void LAYERS(int Layer){
   int BarsToCount;
   if (bar+2>Bars) return;
   if (Layer<3){
      if (TimeHour(Time[bar])<TimeHour(Time[bar+1])){  // ищем конец прошлого дня
         h=float(High[iHighest(NULL,0,MODE_HIGH,BarsInDay,bar)]);   // щитаем экстремумы
         l=float(Low [iLowest (NULL,0,MODE_LOW ,BarsInDay,bar)]);    // прошлого дня
         c=float(Close[bar+1]);                             // и его цену закрытия
         HLC=(h+l+c)/3;
         }
      if (Layer==0){// Camarilla Equation ORIGINAL
         LayH4=c+(h-l)*float(1.1/2);    
         LayH3=c+(h-l)*float(1.1/4);    
         LayH2=c+(h-l)*float(1.1/6);  
         LayH1=c+(h-l)*float(1.1/12);
         LayL4=c-(h-l)*float(1.1/2);    
         LayL3=c-(h-l)*float(1.1/4);    
         LayL2=c-(h-l)*float(1.1/6);  
         LayL1=c-(h-l)*float(1.1/12);  
         }
      if (Layer==1){ // Camarilla Equation My Edition
         LayH4=c+(h-l)*4/4;    
         LayH3=c+(h-l)*3/4;    
         LayH2=c+(h-l)*2/4;  
         LayH1=c+(h-l)*1/4;
         LayL4=c-(h-l)*4/4;    
         LayL3=c-(h-l)*3/4;    
         LayL2=c-(h-l)*2/4;  
         LayL1=c-(h-l)*1/4;  
         }
      if (Layer==2){// Метод Гнинспена (Валютный спекулянт-48, с.62)
         LayH1=HLC; LayL1=HLC;  
         LayH2=2*HLC-l;    
         LayL2=2*HLC-h;    
         LayH3=HLC+(h-l);  
         LayL3=HLC-(h-l);
         LayH4=LayH3; LayL4=LayL3;  
         }
   }else{ // if (Layer>=3) Метод Гнинспена (Валютный спекулянт-48, с.62), экстремум ищется не на прошлом дне, а на барах с 0 часов до Layer бара текущего дня
      if (Layer<24)  BarsToCount=Layer*60/Period();
      else           BarsToCount=  23 *60/Period();
      if (bar+BarsToCount+1>Bars) return;
      DayBar++;// номер бара с начала дня
      if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
      if (DayBar==BarsToCount){// номер бара с начала дня совпал с заданным значением
         h=float(High[iHighest(NULL,0,MODE_HIGH,BarsToCount,bar)]);
         l=float(Low [iLowest (NULL,0,MODE_LOW,BarsToCount,bar)]);
         c=float(Close[bar]);
         HLC=(h+l+c)/3;
         }   
      LayH1=HLC; LayL1=HLC;  
      LayH2=2*HLC-l;    
      LayL2=2*HLC-h;    
      LayH3=HLC+(h-l);  
      LayL3=HLC-(h-l);
      LayH4=LayH3; 
      LayL4=LayL3;  
   }  }   