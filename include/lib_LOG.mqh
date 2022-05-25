// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
#define  EXPERTS_LIM  100    // максимальное кол-во проверяемых экспертов
#define  ORDERS_LIM   400   // максимальное кол-во сделок одного эксперта за последние два года

struct AllExperts{  //  C Т Р У К Т У Р А   P I C
   int      magic;
   short    trade[ORDERS_LIM];
   datetime time[ORDERS_LIM];
   float    tickval;
   };
AllExperts Expert[EXPERTS_LIM];   
uchar ExpertsTotal=0;   
   
void MATLAB_LOG (){// Сохранение истории сделок в файл 
   short profit=0;
   short  TradeCnt[EXPERTS_LIM];
   string FileName; 
   ArrayInitialize(TradeCnt,0);
   if (Real) {FileName="MatLab"+AccountCurrency()+".csv"; FileDelete(FileName);} // каждый час создаем новый файл
   else      {FileName="MatLabTest.csv";}//  
   int File=FileOpen(FileName, FILE_READ | FILE_WRITE); 
   if (File<0) {Alert("MatLabLog(): Can not open file "+ FileName+"! for history saving"); return;}
   Alert("MatLabLog()");
   FileWrite(File, "Magic","TickVal","Risk","Deal/Time..."); // прописываем в первую строку названия столбцов
   for(int i=0; i<OrdersHistoryTotal(); i++){// перебераем историю сделок эксперта
      if (OrderSelect(i, SELECT_BY_POS,MODE_HISTORY)==true && OrderMagicNumber()>0 && OrderCloseTime()>0){
         if (Time[0]-OrderCloseTime()>34560000) continue; // Пропускаем все ордера старше двух лет, чтобы не переполнять масссив. Для гарфического анализа они не пригодятся.
         if (OrderProfit()!=0){ // попался закрытый ордер (не Открытый и не Отложенный) 
            uchar Exp=0;
            EXPERTS_PARAMS(Exp, OrderMagicNumber(), MarketInfo(OrderSymbol(),MODE_TICKVALUE));
            Expert[Exp].trade[TradeCnt[Exp]]=short((OrderProfit()+OrderSwap()+OrderCommission())*100/OrderLots()/MarketInfo(OrderSymbol(),MODE_TICKVALUE)*0.1);
            Expert[Exp].time[TradeCnt[Exp]]=OrderCloseTime();  //Print(" TrdCnt[",Exp,"]=",TradeCnt[Exp]," trade=",Expert[Exp].trade[TradeCnt[Exp]]," time=",Expert[Exp].time[TradeCnt[Exp]]);
            TradeCnt[Exp]++; 
      }  }  } 
   //Print("ExpertsTotal=",ExpertsTotal);     
   for (uchar Exp=0; Exp<=ExpertsTotal; Exp++){
      short order=1; // Alert("magic[",Exp,"]=",magic[Exp]);
      FileSeek (File,0,SEEK_END); // перемещаемся в конец файла MatLabTest.csv
      FileWrite(File, DoubleToStr(Expert[Exp].magic,0)+";"+DoubleToStr(Expert[Exp].tickval,5)+";"+"0.1"); // прописываем в первую ячейку magic,
      Print("TradeCnt[Exp]=",TradeCnt[Exp]);
      for (short i=0; i<=TradeCnt[Exp]; i++){ //
         FileSeek (File,-2,SEEK_END); // потом дописываем
         FileWrite(File,  ""    , DoubleToStr(Expert[Exp].trade[i],0)+"/"+TimeToStr(Expert[Exp].time[i],TIME_DATE|TIME_MINUTES));    // ежедневные профиты/время сделки из созданного массива    
      }  }
   FileClose(File); 
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 

void EXPERTS_PARAMS(uchar& ExpCnt, int ExpMagic, double ExpTickVal){// создание массива параметров для всех экспертов
   for (ExpCnt=0; ExpCnt<EXPERTS_LIM; ExpCnt++){
      if (Expert[ExpCnt].magic==ExpMagic) break;
      if (Expert[ExpCnt].magic==0){
         Expert[ExpCnt].magic=ExpMagic;
         ExpertsTotal=ExpCnt;
         break;
         }
      if (ExpCnt>=EXPERTS_LIM) {Alert("WARNING!!! Experts>",EXPERTS_LIM, " Can't create MatLabLog File"); }   
      }  
   Expert[ExpCnt].tickval=(float)ExpTickVal;
   }   