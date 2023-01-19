int INIT(){
   if (ATR_INIT()==INIT_FAILED) return(INIT_FAILED);
   if (PIC_INIT()==INIT_FAILED) return(INIT_FAILED);
   return(INIT_SUCCEEDED);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
float MAX(double num1, double num2){
   if (num1>num2) return (float(num1)); else return (float(num2));
   } 
float MIN(double num1, double num2){// возвращает меньшее, но не нулевое значение
   if (num1==0) return (float(num2));
   if (num2==0) return (float(num1));
   if (num1<num2) return (float(num1)); else return (float(num2));
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
bool COUNT(){// Общие расчеты для всего эксперта 
   ChartHistory="";
   MARKET_UPDATE(Symbol());
   if (!PIC()) return (false);   // ОСНОВНОЙ ЦИКЛ ПОИСКА УРОВНЕЙ 
   POC_SIMPLE();  // ОПРЕДЕЛЕНИЕ ПЛОТНОГО СКОПЛЕНИЯ БАР БЕЗ ПРОПУСКОВ 
   if (BUY.Val>0){
      int Shift=SHIFT(BuyTime);
      MinFromBuy=(float)Low [iLowest (NULL,0,MODE_LOW ,Shift,0)]; 
      MaxFromBuy=(float)High[iHighest(NULL,0,MODE_HIGH,Shift,0)];} //  Print("BUY.Val=",BUY.Val," BuyTime=",BuyTime," Shift=",Shift," MinFromBuy=",MinFromBuy," MaxFromBuy=",MaxFromBuy);    
   if (SEL.Val>0){
      int Shift=SHIFT(SellTime);
      MinFromSell=(float)Low [iLowest (NULL,0,MODE_LOW ,Shift,0)];
      MaxFromSell=(float)High[iHighest(NULL,0,MODE_HIGH,Shift,0)];}//  Print("SEL.Val=",SEL.Val," SellTime=",SellTime," Shift=",Shift," MinFromSell=",MinFromSell," MaxFromSell=",MaxFromSell);      
   if (ExpirBars>0)  Expiration=Time[0]+ExpirBars*Period()*60; else Expiration=0;// уменьшаем период на 30сек, чтоб совпадало с реалом 
   //TREND_FILTER (iDblTop, iImp, iFltBrk, UP, DN); // ФИЛЬТРЫ ГЛОБАЛЬНОГО НАПРАВЛЕНИЯ формируют сигналы UP, DN        
   TARGET_ZONE_CHECK(BUYLIM, SELLIM); // ЗАКРЫТИЕ ОРДЕРОВ, ПОПАДАЮЩИХ В ЗОНУ ЦЕЛЕВОГО ДВИЖЕНИЯ / iINPUT()      
   POC_CLOSE_TO_ORDER();// удаление отложника если перед ним формируется флэт(пик) / iOUTPUT()  
   //LINE("HI["+S0(HI)+"] Back="+S4(F[HI].Back)+" Glb"+S0(Trnd.LevBrk), bar+1, F[HI].P, bar, F[HI].P,  clrPink,2);       // LINE("F[HI].Tr", bar+1, F[HI].Tr, bar, F[HI].Tr,  clrPink,0); 
   //LINE("LO["+S0(LO)+"] Back="+S4(F[LO].Back)+" Glb"+S0(Trnd.LevBrk), bar+1, F[LO].P, bar, F[LO].P,  clrLightBlue,2);  // LINE("F[HI].Tr", bar+1, F[HI].Tr, bar, F[HI].Tr,  clrLightBlue,0);  
   // if (BUY.Val){  A("BUY.Val="+S4(BUY.Val)+" Shift="+S0(SHIFT(BuyTime))+" MaxFromBuy="+S4(MaxFromBuy -BUY.Val),  H-ATR*3, 0,  clrGray);
   //if (SEL.Val) V("SEL.Val="+S4(SEL.Val)+" DN="+S0(DN),  L+ATR*3, 0,  clrGray);// " Shift="+S0(SHIFT(SellTime))+" MinFromSell="+S4(SEL.Val-MinFromSell)
   //Print(__FUNCTION__," ",__LINE__);
   ERROR_CHECK(__FUNCTION__);
   return (true);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void CONSTANT_COUNTER(){// Индивидуальные константы: MinProfit, PerAdapter, AtrPer, время входа/выхода...      
   PerAdapter=float(60.00/Period()); //Print("PerAdapter=",PerAdapter);
   SlowAtrPer=A*A;  
   FastAtrPer=a*a;
   TimeOn=short(Tin*60/Period()); // начало торговли в барах от начала сессии, где Tin-часы от начала сессии
   TimeOff=short(TimeOn+(Tper+1)*60/Period()); // период торговли в барах от начала торговли, где Tper-часы от начала торговли Tin
   if (TimeOff>BarsInDay) TimeOff-=BarsInDay; // переход через полночь
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
struct INDIVIDUAL_VARIABLES{// структура данных эксперта
   char Dir;
   uchar n, BrokenPic, hi, lo, hi2, lo2, HI, LO, Hi2, Lo2, midHI, midLO, jmpHI, jmpLO, RevHi, RevLo, RevHi2, RevLo2, FlsUp, FlsDn, uFsUp, uFsDn, TrgHi, TrgLo;
   float ATR, Impulse, New, HiBack, LoBack, MidMovUp, MidMovDn, LastMovUp, LastMovDn, MovUp[Movements], MovDn[Movements], MovUpSrt[Movements], MovDnSrt[Movements], TargetHi, TargetLo;
   float RevBUY, RevSELL, minHi, maxLo;  
   short PocSum;  
   datetime ExpMemory; 
   AtrStruct      Atr;
   PICS           F[LevelsAmount];
   TREND_SIGNALS  Trnd;
   } v[MAX_EXPERTS_AMOUNT];      

void LOAD_VARIABLES(ushort e){// восстановление индивидуальных переменных для эксперта "e" (HI,LO,DM,DayBar) на каждом баре в режиме последовательного запуска на реале
   if (!Real) return;
   Dir=v[e].Dir;
   n=v[e].n; BrokenPic=v[e].BrokenPic; hi=v[e].hi; lo=v[e].lo; hi2=v[e].hi2; lo2=v[e].lo2; HI=v[e].HI; LO=v[e].LO; Hi2=v[e].Hi2; Lo2=v[e].Lo2; RevHi=v[e].RevHi; RevLo=v[e].RevLo; RevHi2=v[e].RevHi2; RevLo2=v[e].RevLo2; FlsUp=v[e].FlsUp; FlsDn=v[e].FlsDn; uFsUp=v[e].uFsUp; uFsDn=v[e].uFsDn; TrgHi=v[e].TrgHi; TrgLo=v[e].TrgLo;    
   ATR=v[e].ATR; Impulse=v[e].Impulse; New=v[e].New; MidMovUp=v[e].MidMovUp; MidMovDn=v[e].MidMovDn; LastMovUp=v[e].LastMovUp; LastMovDn=v[e].LastMovDn; TargetHi=v[e].TargetHi; TargetLo=v[e].TargetLo;
   //for (char i=0; i<Movements; i++) {MovUp[i]=v[e].MovUp[i]; MovDn[i]=v[e].MovDn[i]; MovUpSrt[i]=v[e].MovUpSrt[i]; MovDnSrt[i]=v[e].MovDnSrt[i];}
   RevBUY=v[e].RevBUY; RevSELL=v[e].RevSELL; minHi=v[e].minHi; maxLo=v[e].maxLo; 
   PocSum=v[e].PocSum;
   Atr=v[e].Atr;
   for (int i=0; i<LevelsAmount; i++) F[i]=v[e].F[i]; 
   Trnd=v[e].Trnd; 
   }

void SAVE_VARIABLES(ushort e){// сохранение индивидуальных переменных для эксперта "e" (HI,LO,DM,DayBar) на каждом баре в режиме последовательного запуска на реале
   if (!Real) return;
   v[e].Dir=Dir;
   v[e].n=n; v[e].BrokenPic=BrokenPic; v[e].hi=hi; v[e].lo=lo; v[e].hi2=hi2; v[e].lo2=lo2; v[e].HI=HI; v[e].LO=LO; v[e].Hi2=Hi2; v[e].Lo2=Lo2; v[e].RevHi=RevHi; v[e].RevLo=RevLo; v[e].RevHi2=RevHi2; v[e].RevLo2=RevLo2; v[e].FlsUp=FlsUp; v[e].FlsDn=FlsDn; v[e].uFsUp=uFsUp; v[e].uFsDn=uFsDn; v[e].TrgHi=TrgHi; v[e].TrgLo=TrgLo;    
   v[e].ATR=ATR; v[e].Impulse=Impulse; v[e].New=New;  v[e].MidMovUp=MidMovUp; v[e].MidMovDn=MidMovDn; v[e].LastMovUp=LastMovUp; v[e].LastMovDn=LastMovDn; v[e].TargetHi=TargetHi; v[e].TargetLo=TargetLo;
   //for (char i=0; i<Movements; i++) {v[e].MovUp[i]=MovUp[i]; v[e].MovDn[i]=MovDn[i]; v[e].MovUpSrt[i]=MovUpSrt[i]; v[e].MovDnSrt[i]=MovDnSrt[i];}
   v[e].RevBUY=RevBUY; v[e].RevSELL=RevSELL; v[e].minHi=minHi; v[e].maxLo=maxLo; 
   v[e].PocSum=PocSum;
   v[e].Atr=Atr;
   for (int i=0; i<LevelsAmount; i++) v[e].F[i]=F[i]; 
   v[e].Trnd=Trnd; 
   }   
    


// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
void DATA_PROCESSING(int source, char ProcessingType){// универсальная ф-ция для записи/чтения парамеров, их печати на графике и генерации MagicLong   
   ERROR_CHECK("DATA_PROCESSING/BEGIN");
   if (ProcessingType==LABEL_WRITE)   LABEL(10," - P I C   L E V E L S - ");///////////
   DATA("FltLen", FltLen,     source,ProcessingType);
   DATA("PicCnt", PicCnt,     source,ProcessingType);
   DATA("Target", Target,     source,ProcessingType);
   DATA("Power",  Power,      source,ProcessingType);
   DATA("Trd",    Trd,        source,ProcessingType);
   DATA("Pot",    Pot,        source,ProcessingType);
   DATA("Rev",    Rev,        source,ProcessingType);
   DATA("Tch",    Tch,        source,ProcessingType);
   DATA("Poc",    Poc,        source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(10," -  T R E N D   S I G N A L S  - ");////////////////
   DATA("fGlb",   fGlb,       source,ProcessingType);
   DATA("iFlt",   iFlt,       source,ProcessingType);
   DATA("iPic",   iPic,       source,ProcessingType);
   DATA("iImp",   iImp,       source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(10," - A  T  R -");////////////////
   DATA("A",         A,       source,ProcessingType);
   DATA("a",         a,       source,ProcessingType);
   DATA("Ak",        Ak,      source,ProcessingType);
   DATA("PicVal",    PicVal,  source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(10," -  I N P U T S -");////////////////
//   DATA("iFrstLev",iFrstLev,  source,ProcessingType);
   DATA("iSignal",iSignal,    source,ProcessingType);
   DATA("iParam", iParam,     source,ProcessingType);
   DATA("Iprice", Iprice,     source,ProcessingType);
   DATA("D",      D,          source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(10," -  S T O P -");////////////////
   DATA("sMin",   sMin,       source,ProcessingType);
   DATA("sMax",   sMax,       source,ProcessingType);
   DATA("Stp",    Stp,        source,ProcessingType);
   DATA("Prf",    Prf,        source,ProcessingType);
   DATA("minPL",  minPL,      source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(10," -  O U T P U T  -");////////////////
   DATA("oImp",   oImp,       source,ProcessingType);
   DATA("oSig",   oSig,       source,ProcessingType);
   DATA("oDblTch",oDblTch,    source,ProcessingType);
   DATA("oFlt",   oFlt,       source,ProcessingType);
   DATA("oPrice", oPrice,     source,ProcessingType);
   DATA("oStop",  oStop,      source,ProcessingType);
   DATA("Trl",    Trl,        source,ProcessingType);
   if (ProcessingType==LABEL_WRITE)   LABEL(10," -  T I M E  -");////////////////
   DATA("ExpirBars",ExpirBars,source,ProcessingType);
   DATA("Tper",   Tper,       source,ProcessingType);
   DATA("Tin",    Tin,        source,ProcessingType);
   //DATA("tPrice", tPrice,     source,ProcessingType);
   if (ProcessingType==READ_ARR){
      TestEndTime=CSV[Exp].TestEndTime;
      OptPeriod=  CSV[Exp].OptPeriod;
      HistDD=     CSV[Exp].HistDD;
      LastTestDD= CSV[Exp].LastTestDD;
  //  Risk=       CSV[Exp].Risk;
      Magic=      CSV[Exp].Magic;
      ID=         CSV[Exp].ID;
      }
   ERROR_CHECK(__FUNCTION__);   
   }       
    
   

