double ATR; 
int bar, LotDigits, BarCount, MarginRequired;
bool Prn;
string ttt, StartDate;
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
int OnInit(){// при загрузке эксперта, смене инструмента/периода/счета/входных параметров, компиляции
   if (!IsTesting() && !IsOptimization()) Real=true; 
   if (IsOptimization()) Real=false; 
   InitDeposit=int(AccountBalance()); DayMinEquity=InitDeposit;
   StartDate=TimeToStr(TimeCurrent(),TIME_DATE); // дата начала оптимизации/тестированиЯ
   Spred    =MarketInfo(Symbol(),MODE_SPREAD)*Point;
   StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point+Spred; // Спред необходимо учитывать, т.к. вход и выход из позы происходят по разным ценам (ask/bid)
   MarginRequired=int(MarketInfo(Symbol(),MODE_MARGINREQUIRED)) * 2; // Размер свободных средств, необходимых для открытия 1 лота на покупку
   if (MarketInfo(Symbol(),MODE_LOTSTEP)<0.1) LotDigits=2; else LotDigits=1;
   Lot=0.1;
   if (BackTest>0){// Загрузка параметров эксперта из файла отчета *.csv.
      if (INPUT_FILE_READ(BackTest)<0){ 
         Print("OnInit(): отмена инициализации из-за ошибка загрузки данных из файла");
         return(INIT_FAILED); // ненулевой возврат означает неудачную инициализацию и генерирует событие Deinit с кодом причины деинициализации REASON_INITFAILED
      }  }
   // выделение трех бит из входной переменной Out для комбинирования сигналов :
   OutGlob=uchar(Out)&1; // 001 - глобальный тренд = GlobalTrend
   OutLoc =uchar(Out)&2; // 010 - локальный тренда = Trend
   OutImp =uchar(Out)&4; // 100 - обратный импульс = Imp.Sig  
   BarsInDay=60*24/Period(); // кол-во бар в дне
   PositionTime=Tper*60*Period(); // кол-во секунд удержания открытой позы. При Tin=0 Tper - число бар удержания открытой позы.
   TimeOn=Tin*60/Period(); // начало торговли в барах от начала сессии, где Tin-часы от начала сессии
   TimeOff=TimeOn+(Tper+1)*60/Period(); // период торговли в барах от начала торговли, где Tper-часы от начала торговли Tin
   if (TimeOff>BarsInDay) TimeOff-=BarsInDay; // переход через полночь
   SlowAtrPer=A*A;  
   FastAtrPer=a*a;   
   MAGIC_GENERATOR(); 
   INPUT_PARAMETERS_PRINT(); // ПЕЧАТЬ В ЛЕВОЙ ЧАСТИ ГРАФИКА ВХОДНЫХ ПАРАМЕТРОВ ЭКСПЕРТА
   BarCount=1; // счетчик бар с начала работы эксперта для контроля кол-ва сделок
   //bool bb=true; int ii=-1; bool UP=bool(ii); Print("UP=",UP, " ii=",ii);
   bar=Bars-1;
   if (POC_INIT()<0) {Print("OnInit(): POC_INIT()<0"); return(INIT_FAILED);}  // НЕнулевой код возврата означает неудачную инициализацию и генерирует событие Deinit с кодом 
   if (PIC_INIT()<0) {Print("OnInit(): PIC_INIT()<0"); return(INIT_FAILED);}  // причины деинициализации REASON_INITFAILED
   for (bar=Bars-2; bar>1; bar--){// прогоняем индикаторы на доступной истории, чтобы к началу работы все значения были готовы 
      FastAtr=iATR(NULL,0,FastAtrPer,bar); // 
      SlowAtr=iATR(NULL,0,SlowAtrPer,bar); // 
      if (SlowAtr==0) continue;  // функция ATR() не набрала достаточного кол-ва бар
      //double ind1=iATR(NULL,0,FastAtrPer,bar); 
      //double ind2=iATR(NULL,0,SlowAtrPer,bar); 
      PIC();  // ОСНОВНОЙ ЦИКЛ ПОИСКА УРОВНЕЙ 
      POC();  // ПОИСК КОНСОЛИДАЦИЙ
      }
   bar=1; 
   LastBarTime=Time[bar]; // для подсчета пропущенных бар 
   Print(" "); Print(" ");
   //Print(" OnInit(): MarginRequired=",MarginRequired," TickVal=",MarketInfo(Symbol(),MODE_TICKVALUE)," Point=",MarketInfo(Symbol(),MODE_POINT)," Margin=",AccountFreeMargin());
   //Print(" OnInit(): Time[bar]=",TimeToString(Time[bar],TIME_DATE | TIME_MINUTES),"   Time[Bars-1]=",TimeToString(Time[Bars-1],TIME_DATE | TIME_MINUTES)," Bars=",Bars);
   //Print(" OnInit(): BarsInDay=",BarsInDay," FastAtr=",DoubleToString(FastAtr,Digits)," SlowAtr=",DoubleToString(SlowAtr,Digits)); 
   return (INIT_SUCCEEDED); // Успешная инициализация. Результат выполнения функции OnInit() анализируется терминалом только если программа скомпилирована с использованием #property strict.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void MARKET_INFO(){
   if (!Real) return;
   RefreshRates();
   Spred    =MarketInfo(Symbol(),MODE_SPREAD)*Point;
   StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point+Spred; // Спред необходимо учитывать, т.к. вход и выход из позы происходят по разным ценам (ask/bid)
   }   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
bool COUNT(){// Общие расчеты для всего эксперта 
   //TRADES_ENOUGH();
   if (AccountFreeMargin()<MarginRequired) {Print("COUNT(): Недостаточно маржи "); ExpertRemove();}
   MARKET_INFO();
   FastAtr=iATR(NULL,0,FastAtrPer,bar); // 
   SlowAtr=iATR(NULL,0,SlowAtrPer,bar); // 
   //ATR();
   if (SlowAtr==0) {Print("COUNT(): функция ATR() не набрала достаточного кол-ва бар"); return (false);}
   PIC();  // ОСНОВНОЙ ЦИКЛ ПОИСКА УРОВНЕЙ 
   POC();  // ПОИСК КОНСОЛИДАЦИЙ
   //if (Real){
   //   LINE("DN1",0,DN1, 0,0, cIND1);  LINE("UP1",0,UP1, 0,0, cIND1);
   //   LINE("DN2",0,DN2, 0,0, cIND2);  LINE("UP2",0,UP2, 0,0, cIND2);
   //   LINE("DN3",0,DN3, 0,0, cIND3);  LINE("UP3",0,UP3, 0,0, cIND3);
   //   }
   //Print("Risk=",Risk," Lot=",Lot);
   switch (Ak){// АТР для стопов: 0-atr 1-min(atr,ATR) 2-max(atr,ATR)
      case 1: ATR=(FastAtr+SlowAtr)/2;       break; // среднее значение 
      case 2: ATR=MathMin(FastAtr,SlowAtr);  break;
      case 3: ATR=MathMax(FastAtr,SlowAtr);  break;
      default: ATR=(FastAtr+SlowAtr)/2;      break;
      }//if (Prn) Print(ttt,"CNT:   ATR=",DoubleToStr(ATR,4)," FastAtr=",DoubleToStr(FastAtr,4)," SlowAtr=",DoubleToStr(SlowAtr,4)," Trend=",Trend," TrendLevBreakUp=",TrendLevBreakUp," TrendLevBreakDn=",TrendLevBreakDn); 
   ATR=NormalizeDouble(ATR*dAtr*0.1,Digits);   
   // МАКСИМАЛЬНЫЕ/МИНИМАЛЬНЫЕ ЦЕНЫ С МОМЕНТА ОТКРЫТИЯ ПОЗ 
   int Shift;
   if (BUY>0){
      Shift=iBarShift(NULL,0,BuyTime,false);
      MinFromBuy=Low [iLowest (NULL,0,MODE_LOW ,Shift,bar)]; 
      MaxFromBuy=High[iHighest(NULL,0,MODE_HIGH,Shift,bar)]; //  Print("BUY=",BUY," BuyTime=",BuyTime," Shift=",Shift," MinFromBuy=",MinFromBuy," MaxFromBuy=",MaxFromBuy);
      } 
   if (SELL>0){
      Shift=iBarShift(NULL,0,SellTime,false);
      MinFromSell=Low [iLowest (NULL,0,MODE_LOW ,Shift,bar)];
      MaxFromSell=High[iHighest(NULL,0,MODE_HIGH,Shift,bar)];//  Print("SELL=",SELL," SellTime=",SellTime," Shift=",Shift," MinFromSell=",MinFromSell," MaxFromSell=",MaxFromSell);
      }   
   if (TimePrf<=0)   TimeProfit=-20*ATR; // при отрицательных значениях TimePrf поХ c каким кушем выходить
   else              TimeProfit=TimePrf*TimePrf*0.1*ATR; // пороговая прибыль, без которой не закрываемся 0.1  0.4  0.9  1.6  2.5  3.6
   return (true);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void FILTERS (int NewPic, int GlbTrnd, int LocTrnd, int Impls, int TrndLev){ // ФИЛЬТРЫ ГЛОБАЛЬНОГО НАПРАВЛЕНИЯ (
   switch (NewPic){// ФОРМИРОВАНИЕ СООТВЕТСВУЮЩЕГО ПИКА c заданным потенциалом  
      case -3: if (Pic.dir<0 || Pic.Pot!=2) fUP=0;     if (Pic.dir>0 || Pic.Pot!=2) fDN=0; break; // потенциал пика должен быть 2  
      case -2: if (Pic.dir<0 || Pic.Pot!=1) fUP=0;     if (Pic.dir>0 || Pic.Pot!=1) fDN=0; break; // дополнительно к этому потенциал пика должен быть 1
      case -1: if (Pic.dir<0)               fUP=0;     if (Pic.dir>0)               fDN=0; break; // формирование мелкой вершины для лонга, мелкой впадины для шорта
      default: break; // 0
      case  1: if (Pic.dir>0)               fUP=0;     if (Pic.dir<0)               fDN=0; break; // формирование мелкой впадины для лонга, вершины для шорта. Потенциал не важен
      case  2: if (Pic.dir>0 || Pic.Pot!=1) fUP=0;     if (Pic.dir<0 || Pic.Pot!=1) fDN=0; break; // дополнительно к этому потенциал пика должен быть 1
      case  3: if (Pic.dir>0 || Pic.Pot!=2) fUP=0;     if (Pic.dir<0 || Pic.Pot!=2) fDN=0; break; // потенциал пика должен быть 2
      } 
   switch (GlbTrnd){ // ГЛОБАЛЬНЫЙ ТРЕНД
      case 1: if (GlobalTrend>0) fDN=0; else fUP=0; break;    // по тренду
      default : break; // 0
      case-1: if (GlobalTrend<0) fDN=0; else fUP=0; break;    // против тренда
      }
   switch (LocTrnd){ // ЛОКАЛЬНЫЙ ТРЕНД
      case -1: if (Trend>=0)  fUP=0; if (Trend<=0) fDN=0;  break; // против локального тренда
      default : break; // 0
      case  1: if (Trend<=0)  fUP=0; if (Trend>=0) fDN=0;  break; // строго по тренду
      case  2: if (Trend<0)   fUP=0; if (Trend>0)  fDN=0;  break; // по тренду и во флэте = не против тренда
      case  3: if (Trend!=0) {fUP=0; fDN=0;}               break; // только во флэте
      }   
   switch (Impls){ // ОТСЛЕЖИВАНИЕ РЕЗКИХ КОЛЕБАНИЙ    
      default : break; // 0
      case 1: IMPULSE();   // не входить против резких импульсов величиной ATR*Impulse% 
         if (Imp.Sig> 0) fDN=0; // Запрет шорта при резком импульсе вверх.
         if (Imp.Sig< 0) fUP=0; // Запрет лонга при резком импульсе вниз
      break;
      case 2: IMPULSE();   // вход только в направлении резких импульсов 
         if (Imp.Sig>=0) fDN=0;    // Запрет шорта если нет импульса вниз.
         if (Imp.Sig<=0) fUP=0;    // Запрет лонга если нет импульса вверх
      break;
      }
   if (TrndLev>0){ // ПРИБЛИЖЕНИЕ К ПЕРВЫМ ТРЕНДОВЫМ УРОВНЯМ 
      if (FirstDn==0 || Low [bar]<FirstDnPic || Low [bar]>FirstDn+DELTA(TrndLev)) fUP=0; // лонг в районе уровня покупки
      if (FirstUp==0 || High[bar]>FirstUpPic || High[bar]<FirstUp-DELTA(TrndLev)) fDN=0; // шорт при приближение к уровню продажи  
      }
   if (TrndLev<0){ // ПРОБОЙ ПЕРВЫХ ТРЕНДОВЫХ УРОВНЕЙ 
      LINE("LastFirstDnPic",0,LastFirstDnPic, 0,0, cSIG1);  LINE("FirstDnPic",0,FirstDnPic, 0,0, cSIG2);
      LINE("LastFirstUpPic",0,LastFirstUpPic, 0,0, cSIG1);  LINE("FirstUpPic",0,FirstUpPic, 0,0, cSIG2);
      if (FirstDn==0 || Low [bar]>LastFirstDnPic || Low [bar]<LastFirstDnPic+DELTA(TrndLev)) fUP=0; // лонг если лоу ниже пика ПТУ на DELTA
      if (FirstUp==0 || High[bar]<LastFirstUpPic || High[bar]>LastFirstUpPic-DELTA(TrndLev)) fDN=0; // шорт если хай выше пика ПТУ на DELTA  
      }   
      
   }//LINE(FirstUpPic-FrstLevLim, 0, clrGreen);  LINE(FirstDnPic+FrstLevLim, 0, clrBlue); LINE(FirstUpPic, 0, clrWhite); LINE(FirstDnPic, 0, clrWhite);
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void TESTER_FILE_CREATE(string Inf, string TesterFileName){ // создание файла отчета со всеми характеристиками  //////////////////////////////////////////////////////////////////////////////////////////////////
   ResetLastError(); TesterFile=FileOpen(TesterFileName, FILE_READ|FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE, ';'); if(TesterFile<0) {Report("ERROR! TesterFileCreate()  Не могу создать файл "+TesterFileName); return;}
   string SymPer=Symbol()+DoubleToStr(Period(),0);
   MAGIC_GENERATOR();
   if (FileReadString(TesterFile)==""){Print("Create New File ",TesterFileName);
      FileWrite(TesterFile,"INFO","SymPer",Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13,"-Magic-","PocPer","OnlyTop","TrPoc","PicPer","LevPer","FirstLev","LevPower","FltLen","FltPic","Target","MinPower","DelSaw","DelSmall","DelBroken","TrPic" ,"TrLoOnHi","TrLevBrk","PicLim","PicVal","Impulse","ImpBack","fNewPic","fGlbTrnd","fLocTrnd","fImpulse","fTrndLev","iLevContact","iSignal");
      FileSeek (TesterFile,-2,SEEK_END); // перемещаемся в конец строки, и продолжаем заполнять заголовки. Функция FileWrite позволяет только 63 входных параметра, поэтому в два этапа. 
      FileWrite(TesterFile,"","iParam","iBar","Del","dAtr","Iprice","D","Sprice","sSig","sMin","sMax","sTrd","sPoc","sTgt","sFst","S","Pprice","pSig","pMax","pTrd","pPoc","pTgt","pFst","Prf","minPL","Out","oPrice","oD","Trl","A","a","Ak","ExpirBars","Tper","Tin","TimePrf","","","");
      }
   FileSeek (TesterFile, 0,SEEK_END); // перемещаемся в конец   
   FileWrite   (TesterFile, Inf  , SymPer ,Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13,  Magic  , PocPer , OnlyTop , TrPoc , PicPer , LevPer , FirstLev , LevPower , FltLen , FltPic , Target , MinPower , DelSaw , DelSmall , DelBroken , TrPic  , TrLoOnHi , TrLevBrk , PicLim , PicVal , Impulse , ImpBack , fNewPic , fGlbTrnd , fLocTrnd , fImpulse , fTrndLev , iLevContact  , iSignal ); 
   FileSeek (TesterFile,-2,SEEK_END); // перемещаемся в конец строки, и продолжаем заполнять заголовки. Функция FileWrite позволяет только 63 входных параметра, поэтому в два этапа. 
   FileWrite   (TesterFile,"", iParam , iBar , Del , dAtr , Iprice , D , Sprice , sSig , sMin , sMax , sTrd , sPoc , sTgt , sFst , S , Pprice , pSig , pMax , pTrd , pPoc , pTgt , pFst , Prf , minPL , Out , oPrice , oD , Trl , A , a , Ak , ExpirBars , Tper , Tin , TimePrf , 0, 0, 0);    
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void DATA_READ(int InputFile){ // считываем входные параметры эксперта из массива (строка ExNum) //////////////////////////////////////////////////////////////////////////////////////////////////
   // - P O C    L E V E L S    I N D I C A T O R
   PocPer   =int(StrToDouble(FileReadString(InputFile)));
   OnlyTop  =int(StrToDouble(FileReadString(InputFile)));
   TrPoc    =int(StrToDouble(FileReadString(InputFile)));
   // -  P I C    L E V E L S    I N D I C A T O R  -
   PicPer   =int(StrToDouble(FileReadString(InputFile)));
   LevPer   =int(StrToDouble(FileReadString(InputFile)));
   FirstLev =int(StrToDouble(FileReadString(InputFile)));
   LevPower =int(StrToDouble(FileReadString(InputFile)));
   FltLen   =int(StrToDouble(FileReadString(InputFile)));
   FltPic   =int(StrToDouble(FileReadString(InputFile)));
   Target   =int(StrToDouble(FileReadString(InputFile)));
   MinPower =int(StrToDouble(FileReadString(InputFile)));
   DelSaw   =int(StrToDouble(FileReadString(InputFile)));
   DelSmall =int(StrToDouble(FileReadString(InputFile)));
   DelBroken=int(StrToDouble(FileReadString(InputFile)));
   TrPic    =int(StrToDouble(FileReadString(InputFile)));
   TrLoOnHi =int(StrToDouble(FileReadString(InputFile)));
   TrLevBrk =int(StrToDouble(FileReadString(InputFile)));
   PicLim   =int(StrToDouble(FileReadString(InputFile)));
   PicVal   =int(StrToDouble(FileReadString(InputFile)));
   // -  I M P U L S E    I N D I C A T O R -
   Impulse  =int(StrToDouble(FileReadString(InputFile)));
   ImpBack  =int(StrToDouble(FileReadString(InputFile)));
   // -  F I L T E R S  -
   fNewPic  =int(StrToDouble(FileReadString(InputFile)));
   fGlbTrnd =int(StrToDouble(FileReadString(InputFile)));
   fLocTrnd =int(StrToDouble(FileReadString(InputFile)));
   fImpulse =int(StrToDouble(FileReadString(InputFile)));
   fTrndLev =int(StrToDouble(FileReadString(InputFile)));
   // -  I N P U T S -
   iLevContact=int(StrToDouble(FileReadString(InputFile)));
   iSignal  =int(StrToDouble(FileReadString(InputFile)));
   iParam   =int(StrToDouble(FileReadString(InputFile)));
   iBar     =int(StrToDouble(FileReadString(InputFile)));
   Del      =int(StrToDouble(FileReadString(InputFile)));
   dAtr    =int(StrToDouble(FileReadString(InputFile)));
   Iprice   =int(StrToDouble(FileReadString(InputFile)));
   D        =int(StrToDouble(FileReadString(InputFile)));
   // -  S T O P   -
   Sprice   =int(StrToDouble(FileReadString(InputFile)));
   sSig     =int(StrToDouble(FileReadString(InputFile)));
   sMin     =int(StrToDouble(FileReadString(InputFile)));
   sMax     =int(StrToDouble(FileReadString(InputFile)));
   sTrd     =int(StrToDouble(FileReadString(InputFile)));
   sPoc     =int(StrToDouble(FileReadString(InputFile)));
   sTgt     =int(StrToDouble(FileReadString(InputFile)));
   sFst     =int(StrToDouble(FileReadString(InputFile)));
   S        =int(StrToDouble(FileReadString(InputFile)));
   // -  P R O F I T -
   Pprice   =int(StrToDouble(FileReadString(InputFile)));
   pSig     =int(StrToDouble(FileReadString(InputFile)));
   pMax     =int(StrToDouble(FileReadString(InputFile)));
   pTrd     =int(StrToDouble(FileReadString(InputFile)));
   pPoc     =int(StrToDouble(FileReadString(InputFile)));
   pTgt     =int(StrToDouble(FileReadString(InputFile)));
   pFst     =int(StrToDouble(FileReadString(InputFile)));
   Prf      =int(StrToDouble(FileReadString(InputFile)));
   minPL    =int(StrToDouble(FileReadString(InputFile)));
   // -  O U T P U T  -
   Out      =int(StrToDouble(FileReadString(InputFile)));
   oPrice   =int(StrToDouble(FileReadString(InputFile)));
   oD       =int(StrToDouble(FileReadString(InputFile)));
   Trl      =int(StrToDouble(FileReadString(InputFile)));
   // -  A  T  R  -
   A        =int(StrToDouble(FileReadString(InputFile)));
   a        =int(StrToDouble(FileReadString(InputFile)));
   Ak       =int(StrToDouble(FileReadString(InputFile)));
   // -  T I M E  -
   ExpirBars=int(StrToDouble(FileReadString(InputFile)));
   Tper     =int(StrToDouble(FileReadString(InputFile)));
   Tin      =int(StrToDouble(FileReadString(InputFile)));
   TimePrf  =int(StrToDouble(FileReadString(InputFile)));
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void MAGIC_GENERATOR(){
   Magic =int( 
   iSignal           *100000000000+
   Iprice            *10000000000+
   Out*oPrice        *1000000000+ 
   (fNewPic+fGlbTrnd+fLocTrnd+fImpulse+fTrndLev)*10000000+
   (iParam+Del+dAtr+D) *10000000+         
   (sSig+sMin+sTrd+sTrd+sTgt+sFst+S)*Sprice  *1000000+                    
   (pSig+pMax+pTrd+pPoc+pTgt+pFst+Prf+minPL)*Pprice*100000+
   (MinPower+DelSaw+DelSmall+DelBroken)*10000+
   (TrPic+TrLoOnHi+TrLevBrk)*1000+   
   (PicLim+PicVal+(Impulse+ImpBack)/100)*100+               
   (PocPer+OnlyTop+PicPer+LevPer+FirstLev+LevPower+iLevContact)*10+
   (oD+Trl+A+a)*Ak                    
   );
   if (Magic<0) Magic=MathAbs(Magic);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ     
void INPUT_PARAMETERS_PRINT(){ // ПЕЧАТЬ В ЛЕВОЙ ЧАСТИ ГРАФИКА ВХОДНЫХ ПАРАМЕТРОВ ЭКСПЕРТА
   if (!Real) return;
   if (IsOptimization()) return;
   CHART_SETTINGS();
   string FileName=ExpertName+" "+DoubleToString(Magic,0)+".set";   // TerminalInfoString(TERMINAL_DATA_PATH)+"\\tester\\files\\"+ExpertName+DoubleToString(Magic,0)+".txt";
   int file=FileDelete(FileName); // на всякий случай удаляем, чтбы обновить, если он уже создан
   file=FileOpen(FileName,FILE_WRITE|FILE_TXT);
   if(file!=INVALID_HANDLE){
      LABEL("                      BackTest="+  DoubleToStr(BackTest,0)); 
      LABEL("          -  P O C    L E V E L S    I N D I C A T O R  -");
      LABEL("PocPer="+  DoubleToStr(PocPer,0));    FileWrite(file,"PocPer=",DoubleToStr(PocPer,0)); 
      LABEL("OnlyTop="+ DoubleToStr(OnlyTop,0));   FileWrite(file,"OnlyTop=",DoubleToStr(OnlyTop,0)); 
      LABEL("TrPoc="+   DoubleToStr(TrPoc,0));     FileWrite(file,"TrPoc=",DoubleToStr(TrPoc,0));
      LABEL("          -  P I C    L E V E L S    I N D I C A T O R  - ");
      LABEL("PicPer="+  DoubleToStr(PicPer,0));    FileWrite(file,"PicPer=",DoubleToStr(PicPer,0));
      LABEL("LevPer="+  DoubleToStr(LevPer,0));    FileWrite(file,"LevPer=",DoubleToStr(LevPer,0));
      LABEL("FirstLev="+DoubleToStr(FirstLev,0));  FileWrite(file,"FirstLev=",DoubleToStr(FirstLev,0));
      LABEL("LevPower="+DoubleToStr(LevPower,0));  FileWrite(file,"LevPower=",DoubleToStr(LevPower,0));
      LABEL("FltLen="+  DoubleToStr(FltLen,0));    FileWrite(file,"FltLen=",DoubleToStr(FltLen,0));
      LABEL("FltPic="+  DoubleToStr(FltPic,0));    FileWrite(file,"FltPic=",DoubleToStr(FltPic,0));
      LABEL("Target="+  DoubleToStr(Target,0));    FileWrite(file,"Target=",DoubleToStr(Target,0));
      LABEL("MinPower="+DoubleToStr(MinPower,0));  FileWrite(file,"MinPower=",DoubleToStr(MinPower,0));
      LABEL("DelSaw="+  DoubleToStr(DelSaw,0));    FileWrite(file,"DelSaw=",DoubleToStr(DelSaw,0));
      LABEL("DelSmall="+DoubleToStr(DelSmall,0));  FileWrite(file,"DelSmall=",DoubleToStr(DelSmall,0));
      LABEL("DelBroken="+DoubleToStr(DelBroken,0));FileWrite(file,"DelBroken=",DoubleToStr(DelBroken,0));
      LABEL("TrPic="+   DoubleToStr(TrPic,0));     FileWrite(file,"TrPic=",DoubleToStr(TrPic,0));
      LABEL("TrLoOnHi="+DoubleToStr(TrLoOnHi,0));  FileWrite(file,"TrLoOnHi=",DoubleToStr(TrLoOnHi,0));
      LABEL("TrLevBrk="+DoubleToStr(TrLevBrk,0));  FileWrite(file,"TrLevBrk=",DoubleToStr(TrLevBrk,0));
      LABEL("PicLim="+  DoubleToStr(PicLim,0));    FileWrite(file,"PicLim=",DoubleToStr(PicLim,0));
      LABEL("PicVal="+  DoubleToStr(PicVal,0));    FileWrite(file,"PicVal=",DoubleToStr(PicVal,0));
      LABEL("          -  I M P U L S E    I N D I C A T O R - ");
      LABEL("Impulse="+ DoubleToStr(Impulse,0));   FileWrite(file,"Impulse=",DoubleToStr(Impulse,0));
      LABEL("ImpBack="+ DoubleToStr(ImpBack,0));   FileWrite(file,"ImpBack=",DoubleToStr(ImpBack,0));
      LABEL("          -  F I L T E R S  - ");
      LABEL("fNewPic="+ DoubleToStr(fNewPic,0));   FileWrite(file,"fNewPic=",DoubleToStr(fNewPic,0));
      LABEL("fGlbTrnd="+DoubleToStr(fGlbTrnd,0));  FileWrite(file,"fGlbTrnd=",DoubleToStr(fGlbTrnd,0));
      LABEL("fLocTrnd="+DoubleToStr(fLocTrnd,0));  FileWrite(file,"fLocTrnd=",DoubleToStr(fLocTrnd,0));
      LABEL("fImpulse="+DoubleToStr(fImpulse,0));  FileWrite(file,"fImpulse=",DoubleToStr(fImpulse,0));
      LABEL("fTrndLev="+DoubleToStr(fTrndLev,0));  FileWrite(file,"fTrndLev=",DoubleToStr(fTrndLev,0));
      LABEL("          -  I N P U T S - ");
      LABEL("iLevContact="+DoubleToStr(iLevContact,0));  FileWrite(file,"iLevContact=",DoubleToStr(iLevContact,0));
      LABEL("iSignal="+ DoubleToStr(iSignal,0));   FileWrite(file,"iSignal=",DoubleToStr(iSignal,0));
      LABEL("iParam="+  DoubleToStr(iParam,0));    FileWrite(file,"iParam=",DoubleToStr(iParam,0));
      LABEL("iBar="  +  DoubleToStr(iBar,0));      FileWrite(file,"iBar=",DoubleToStr(iBar,0));
      LABEL("Del="+     DoubleToStr(Del,0));       FileWrite(file,"Del=",DoubleToStr(Del,0));
      LABEL("dAtr="+   DoubleToStr(dAtr,0));       FileWrite(file,"dAtr=",DoubleToStr(dAtr,0));
      LABEL("Iprice="+  DoubleToStr(Iprice,0));    FileWrite(file,"Iprice=",DoubleToStr(Iprice,0));
      LABEL("D="+       DoubleToStr(D,0));         FileWrite(file,"D=",DoubleToStr(D,0));
      LABEL("          -  S T O P   - ");
      LABEL("Sprice="+  DoubleToStr(Sprice,0));    FileWrite(file,"Sprice=",DoubleToStr(Sprice,0));
      LABEL("sSig="+    DoubleToStr(sSig,0));      FileWrite(file,"sSig=",DoubleToStr(sSig,0));
      LABEL("sMin="+    DoubleToStr(sMin,0));      FileWrite(file,"sMin=",DoubleToStr(sMin,0));
      LABEL("sMax="+    DoubleToStr(sMax,0));      FileWrite(file,"sMax=",DoubleToStr(sMax,0));
      LABEL("sTrd="+    DoubleToStr(sTrd,0));      FileWrite(file,"sTrd=",DoubleToStr(sTrd,0));
      LABEL("sPoc="+    DoubleToStr(sPoc,0));      FileWrite(file,"sPoc=",DoubleToStr(sPoc,0));
      LABEL("sTgt="+    DoubleToStr(sTgt,0));      FileWrite(file,"sTgt=",DoubleToStr(sTgt,0));
      LABEL("sFst="+    DoubleToStr(sFst,0));      FileWrite(file,"sFst=",DoubleToStr(sFst,0));
      LABEL("S="+       DoubleToStr(S,0));         FileWrite(file,"S=",DoubleToStr(S,0));
      LABEL("          -  P R O F I T - ");
      LABEL("Pprice="+  DoubleToStr(Pprice,0));    FileWrite(file,"Pprice=",DoubleToStr(Pprice,0));
      LABEL("pSig="+    DoubleToStr(pSig,0));      FileWrite(file,"pSig=",DoubleToStr(pSig,0));
      LABEL("pMax="+    DoubleToStr(pMax,0));      FileWrite(file,"pMax=",DoubleToStr(pMax,0));
      LABEL("pTrd="+    DoubleToStr(pTrd,0));      FileWrite(file,"pTrd=",DoubleToStr(pTrd,0));
      LABEL("pPoc="+    DoubleToStr(pPoc,0));      FileWrite(file,"pPoc=",DoubleToStr(pPoc,0));
      LABEL("pTgt="+    DoubleToStr(pTgt,0));      FileWrite(file,"pTgt=",DoubleToStr(pTgt,0));
      LABEL("pFst="+    DoubleToStr(pFst,0));      FileWrite(file,"pFst=",DoubleToStr(pFst,0));
      LABEL("Prf="+     DoubleToStr(Prf,0));       FileWrite(file,"Prf=",DoubleToStr(Prf,0));
      LABEL("minPL="+   DoubleToStr(minPL,0));     FileWrite(file,"minPL=",DoubleToStr(minPL,0));
      LABEL("          -  O U T P U T  - ");
      LABEL("Out="+     DoubleToStr(Out,0));       FileWrite(file,"Out=",DoubleToStr(Out,0));
      LABEL("oPrice="+  DoubleToStr(oPrice,0));    FileWrite(file,"oPrice=",DoubleToStr(oPrice,0));
      LABEL("oD="+      DoubleToStr(oD,0));        FileWrite(file,"oD=",DoubleToStr(oD,0));
      LABEL("Trl="+     DoubleToStr(Trl,0));       FileWrite(file,"Trl=",DoubleToStr(Trl,0));
      LABEL("          -  A  T  R  - ");
      LABEL("A="+       DoubleToStr(A,0));         FileWrite(file,"A=",DoubleToStr(A,0));
      LABEL("a="+       DoubleToStr(a,0));         FileWrite(file,"a=",DoubleToStr(a,0));
      LABEL("Ak="+      DoubleToStr(Ak,0));        FileWrite(file,"Ak=",DoubleToStr(Ak,0));
      LABEL("          -  T I M E  - ");
      LABEL("ExpirBars="+DoubleToStr(ExpirBars,0));FileWrite(file,"ExpirBars=",DoubleToStr(ExpirBars,0));
      LABEL("Tper="+    DoubleToStr(Tper,0));      FileWrite(file,"Tper=",DoubleToStr(Tper,0));
      LABEL("Tin="+     DoubleToStr(Tin,0));       FileWrite(file,"Tin=",DoubleToStr(Tin,0));
      LABEL("TimePrf="+ DoubleToStr(TimePrf,0));   FileWrite(file,"TimePrf=",DoubleToStr(TimePrf,0));
      FileClose(file);  
   }else Print("INPUT_PARAMETERS_PRINT: Can't write setter file ", FileName);   
   }   
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void TRADES_ENOUGH(){// СБРОС ОПТИМИЗАЦИИ ТЕСТЕРА ПРИ ОТСУТСТВИИ СДЕЛОК на 1500 первых барах
   if (BarCount==0) return;  // сделки были, больше нет необходимости проверять 
   BarCount++; 
   if (BarCount<=1500) return;// не набралось достаточное кол-во бар чтобы считать сделки
   for(int Ord=0; Ord<OrdersHistoryTotal(); Ord++){ 
      if (OrderSelect(Ord, SELECT_BY_POS, MODE_HISTORY)==true && (OrderType()==OP_BUY || OrderType()==OP_SELL)){ // хоть одна сделка в истории
         BarCount=0; // флаг достаточности 
         return;
      }  }
   Print("COUNT(): ни одной сделки за 1500 бар, прекращение работы ");   
   ExpertRemove();
   }
 
   

