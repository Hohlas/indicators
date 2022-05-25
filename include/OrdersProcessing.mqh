void OrdersSet(){
   bool repeat;   int ticket;   double TradeRisk, LEVEL; 
   RefreshRates(); 
   ASK      =MarketInfo(SYMBOL,MODE_ASK); 
   BID      =MarketInfo(SYMBOL,MODE_BID);    // в функции GlobalOrdersSet() ордера ставятся с одного графика на разные пары, поэтому надо знать данные пары выставляемого ордера     
   DIGITS   =MarketInfo(SYMBOL,MODE_DIGITS); // поэтому надо знать данные пары выставляемого ордера
   StopLevel=MarketInfo(SYMBOL,MODE_STOPLEVEL)*MarketInfo(SYMBOL,MODE_POINT);  
   Spred    =MarketInfo(SYMBOL,MODE_SPREAD)   *MarketInfo(SYMBOL,MODE_POINT);
   LEVEL=StopLevel+Spred;// Спред необходимо учитывать, т.к. вход и выход из позы происходят по разным ценам (ask/bid)
   if (SetBUY>0){ 
      repeat=true; 
      if (Real){
         LEVEL=StopLevel+Spred;
         TradeRisk=RiskChecker(Lot,SetBUY-SetSTOP_BUY,SYMBOL); 
         if (TradeRisk>MaxRisk) {Report("RiskChecker="+DoubleToStr(TradeRisk,1)+"% too BIG!!! Lot="+DoubleToStr(Lot,LotDigits)+" Balance="+DoubleToStr(AccountBalance(),0)+" Stop="+DoubleToStr(SetBUY-SetSTOP_BUY,DIGITS)+" SYMBOL="+SYMBOL); return;}
         }
      while (repeat && BUY==0 && BUYSTOP==0 && BUYLIMIT==0){ // чтобы исключить повторное выставление при ошибке 128
         TerminalHold(60); // ждем 60сек освобождения терминала
         if (SetBUY-ASK>StopLevel)  {str="Set BuyStp ";   ticket=OrderSend(SYMBOL,OP_BUYSTOP, Lot, SetBUY, 3, SetSTOP_BUY, SetPROFIT_BUY, "BuyStop" ,Magic,Expiration,CornflowerBlue);}   else
         if (ASK-SetBUY>StopLevel)  {str="Set BuyLim ";   ticket=OrderSend(SYMBOL,OP_BUYLIMIT,Lot, SetBUY, 3, SetSTOP_BUY, SetPROFIT_BUY, "BuyLimit",Magic,Expiration,CornflowerBlue);}   else
                      {SetBUY=ASK;   str="Set Buy ";      ticket=OrderSend(SYMBOL,OP_BUY,     Lot, SetBUY, 3, SetSTOP_BUY, SetPROFIT_BUY, "Buy",     Magic,    0        ,CornflowerBlue);}
         if (Real){
            Report(str+DoubleToStr(SetBUY,DIGITS)+"/"+DoubleToStr(SetSTOP_BUY,DIGITS)+"/"+DoubleToStr(SetPROFIT_BUY,DIGITS)+"/"+DoubleToStr(Lot,LotDigits)+"x"+DoubleToStr(TradeRisk,1)+"%");
            OrderCheck();
            }
         if (ticket<0) repeat=ErrorCheck(); else repeat=false; 
      }  }
   if (SetSELL>0){ 
      repeat=true; 
      if (Real){
         LEVEL=StopLevel+Spred;
         TradeRisk=RiskChecker(Lot,SetSTOP_SELL-SetSELL,SYMBOL);
         if (TradeRisk>MaxRisk) {Report("RiskChecker="+DoubleToStr(TradeRisk,1)+"% too BIG!!! Lot="+DoubleToStr(Lot,LotDigits)+" Balance="+DoubleToStr(AccountBalance(),0)+" Stop="+DoubleToStr(SetSTOP_SELL-SetSELL,DIGITS)+" SYMBOL="+SYMBOL); return;}
         }
      while (repeat &&  SELL==0 && SELLSTOP==0 && SELLLIMIT==0){
         TerminalHold(60); // ждем 60сек освобождения терминала
         if (BID-SetSELL>StopLevel) {str="Set SellStp ";   ticket=OrderSend(SYMBOL,OP_SELLSTOP, Lot, SetSELL, 3, SetSTOP_SELL, SetPROFIT_SELL, "SellStop", Magic,Expiration,Tomato);}   else
         if (SetSELL-BID>StopLevel) {str="Set SellLim ";   ticket=OrderSend(SYMBOL,OP_SELLLIMIT,Lot, SetSELL, 3, SetSTOP_SELL, SetPROFIT_SELL, "SellLimit",Magic,Expiration,Tomato);}   else
                      {SetSELL=BID;  str="Set Sell ";      ticket=OrderSend(SYMBOL,OP_SELL,     Lot, SetSELL, 3, SetSTOP_SELL, SetPROFIT_SELL, "Sell",     Magic,      0       ,Tomato);}
         if (Real){
            Report(str+DoubleToStr(SetSELL,DIGITS)+"/"+DoubleToStr(SetSTOP_SELL,DIGITS)+"/"+DoubleToStr(SetPROFIT_SELL,DIGITS)+"/"+DoubleToStr(Lot,LotDigits)+"x"+DoubleToStr(TradeRisk,1)+"%");
            OrderCheck();
            }
         if (ticket<0) repeat=ErrorCheck(); else repeat=false; 
      }  }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   TerminalFree();
   }  

void Modify(){   // Похерим необходимые стоп/лимит ордера: удаление если Buy/Sell=0 ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
   if (aOrdRem[0][1]==BUY && aOrdRem[0][2]==BUYSTOP  && aOrdRem[0][3]==BUYLIMIT  && aOrdRem[0][4]==STOP_BUY  && aOrdRem[0][5]==PROFIT_BUY  && // если  эксперт не менял текущие ордера
      aOrdRem[1][1]==SELL && aOrdRem[1][2]==SELLSTOP && aOrdRem[1][3]==SELLLIMIT && aOrdRem[1][4]==STOP_SELL && aOrdRem[1][5]==PROFIT_SELL) return; // не пытаемся что-либо модифицировать
   double LEVEL; int Orders, Ord; bool ReSelect=true, repeat, make;      // если похерили какой-то ордер, надо повторить перебор сначала, т.к. OrdersTotal изменилось, т.е. они все перенумеровались 
   while (ReSelect){        // и переменная ReSelect вызовет их повторный перебор        
      TerminalHold(60); // ждем 60сек освобождения терминала
      ReSelect=false; Orders=OrdersTotal();
      for(Ord=0; Ord<Orders; Ord++){ 
         if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==Magic){
            Order=OrderType();
            repeat=true; 
            RefreshRates();  str="";
            ASK      =MarketInfo(SYMBOL,MODE_ASK); 
            BID      =MarketInfo(SYMBOL,MODE_BID);    // в функции GlobalOrdersSet() ордера ставятся с одного графика на разные пары, поэтому надо знать данные пары выставляемого ордера     
            DIGITS   =MarketInfo(SYMBOL,MODE_DIGITS); // поэтому надо знать данные пары выставляемого ордера
            StopLevel=MarketInfo(SYMBOL,MODE_STOPLEVEL)*MarketInfo(SYMBOL,MODE_POINT);  
            Spred    =MarketInfo(SYMBOL,MODE_SPREAD)   *MarketInfo(SYMBOL,MODE_POINT);
            while (repeat){// повторяем операции над ордером, пока не достигнем результата
               TerminalHold(60); // поддерживаем захваченный терминал
               switch(Order){
                  case OP_SELL:        //  C L O S E   A N D   M O D I F Y    S E L L  //
                     if (SELL==0) {make=OrderClose(OrderTicket(),OrderLots(),ASK,3,Tomato); if (Real) str="Close SELL "+DoubleToStr(OrderOpenPrice(),DIGITS-1); break;}     
                     if (STOP_SELL==OrderStopLoss() && PROFIT_SELL==OrderTakeProfit()) break; // если не требуестся модификация, идем дальше
                     str="Modify Sell";     LEVEL=StopLevel+Spred; // Спред необходимо учитывать, т.к. вход и выход из позы происходят по разным ценам (ask/bid)
                     if (STOP_SELL!=OrderStopLoss())      {if (Real) str=str+"Stop "+DoubleToStr(OrderStopLoss(),DIGITS);      if (STOP_SELL-ASK<LEVEL)    {STOP_SELL=ASK+LEVEL;   if (STOP_SELL>OrderStopLoss())      STOP_SELL=OrderStopLoss();}}
                     if (PROFIT_SELL!=OrderTakeProfit())  {if (Real) str=str+"Profit "+DoubleToStr(OrderTakeProfit(),DIGITS);  if (ASK-PROFIT_SELL<LEVEL)  {PROFIT_SELL=ASK-LEVEL; if (PROFIT_SELL<OrderTakeProfit())  PROFIT_SELL=OrderTakeProfit();}}//Print(" ord=",ord," STOP_SELL=",STOP_SELL," OrderStopLoss=",OrderStopLoss()," PROFIT_SELL=",PROFIT_SELL," OrderTakeProfit=",OrderTakeProfit());
                     if (MathAbs(STOP_SELL-OrderStopLoss()) + MathAbs(PROFIT_SELL-OrderTakeProfit())<1*MarketInfo(SYMBOL,MODE_POINT)) str=""; // модификация всетаки не потребовалась 
                     else  make=OrderModify(OrderTicket(), OrderOpenPrice(), STOP_SELL, PROFIT_SELL,OrderExpiration(),Tomato);   //Print(" ord=",ord," STOP_SELL=",STOP_SELL," OrderStopLoss=",OrderStopLoss()," PROFIT_SELL=",PROFIT_SELL," OrderTakeProfit=",OrderTakeProfit());
                     break; 
                  case OP_SELLSTOP:    //  D E L   S E L L S T O P  //
                     if (SELLSTOP==0){ 
                        if (BID-OrderOpenPrice()>StopLevel){if (Real) str="Del SellStop "+DoubleToStr(OrderOpenPrice(),DIGITS); make=OrderDelete(OrderTicket(),Tomato);}
                        else Report("CanNot Del SELLSTOP near market! BID="+DoubleToStr(BID,DIGITS)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),DIGITS)+" StopLevel="+DoubleToStr(StopLevel,DIGITS));}
                     break;
                  case OP_SELLLIMIT:   //  D E L   S E L L L I M I T  //
                     if (SELLLIMIT==0){
                        if (OrderOpenPrice()-BID>StopLevel) {if (Real) str="Del SellLimit "+DoubleToStr(OrderOpenPrice(),DIGITS);  make=OrderDelete(OrderTicket(),Tomato);}
                        else Report("CanNot Del SELLLIMIT! near market, BID="+DoubleToStr(BID,DIGITS)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),DIGITS)+" StopLevel="+DoubleToStr(StopLevel,DIGITS)); }   
                     break;
                  case OP_BUY: //  C L O S E   A N D   M O D I F Y      B U Y  //////////////////////////////////////////////////////////////
                     if (BUY==0){make=OrderClose(OrderTicket(),OrderLots(),BID,3,CornflowerBlue); if (Real) str="Close BUY "+DoubleToStr(OrderOpenPrice(),DIGITS);  break;}    
                     if (STOP_BUY==OrderStopLoss() && PROFIT_BUY==OrderTakeProfit()) break;
                     str="Modify Buy";    LEVEL=StopLevel+Spred; // Спред необходимо учитывать, т.к. вход и выход из позы происходят по разным ценам (ask/bid)
                     if (STOP_BUY!=OrderStopLoss())      {if (Real) str=str+"Stop "+DoubleToStr(OrderStopLoss(),DIGITS);     if (BID-STOP_BUY<LEVEL)   {STOP_BUY=BID-LEVEL;   if (STOP_BUY<OrderStopLoss())       STOP_BUY=OrderStopLoss();}} 
                     if (PROFIT_BUY!=OrderTakeProfit())  {if (Real) str=str+"Profit "+DoubleToStr(OrderTakeProfit(),DIGITS); if (PROFIT_BUY-BID<LEVEL) {PROFIT_BUY=BID+LEVEL; if (PROFIT_BUY>OrderTakeProfit())   PROFIT_BUY=OrderTakeProfit();}}//Print(" ord=",ord," STOP_BUY=",STOP_BUY," OrderStopLoss=",OrderStopLoss()," PROFIT_BUY=",PROFIT_BUY," OrderTakeProfit=",OrderTakeProfit());
                     if (MathAbs(STOP_BUY-OrderStopLoss()) + MathAbs(PROFIT_BUY-OrderTakeProfit())<1*MarketInfo(SYMBOL,MODE_POINT)) str="";// модификация всетаки не потребовалась
                     else  make=OrderModify(OrderTicket(), OrderOpenPrice(), STOP_BUY, PROFIT_BUY,OrderExpiration(),CornflowerBlue);   //Print(" ord=",ord," STOP_BUY=",STOP_BUY," OrderStopLoss=",OrderStopLoss()," PROFIT_BUY=",PROFIT_BUY," OrderTakeProfit=",OrderTakeProfit());
                     break; 
                  case OP_BUYSTOP:  //  D E L  B U Y S T O P  //
                     if (BUYSTOP==0){
                        if (OrderOpenPrice()-ASK>StopLevel){if (Real) str="Del BuyStop "+DoubleToStr(OrderOpenPrice(),DIGITS); make=OrderDelete(OrderTicket(),CornflowerBlue);}
                        else Report("CanNot Del BUYSTOP near market! ASK="+DoubleToStr(ASK,DIGITS)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),DIGITS)+" StopLevel="+DoubleToStr(StopLevel,DIGITS));}
                     break; 
                  case OP_BUYLIMIT: //  D E L  B U Y L I M I T  //
                     if (BUYLIMIT==0){
                        if (ASK-OrderOpenPrice()>StopLevel){if (Real) str="Del BuyLimit "+DoubleToStr(OrderOpenPrice(),DIGITS); make=OrderDelete(OrderTicket(),CornflowerBlue);}
                     else Report("CanNot Del BUYLIMIT near market! ASK="+DoubleToStr(ASK,DIGITS)+" OpenPrice="+DoubleToStr(OrderOpenPrice(),DIGITS)+" StopLevel="+DoubleToStr(StopLevel,DIGITS));}
                     break;
                  }
               if (Real && str!="") Report(str);
               if (!make) repeat=ErrorCheck(); else repeat=false; // если какие-то операции не выполнились, узнаем причину                 
            }  }//while(repeat)
         if (Orders!=OrdersTotal()) {ReSelect=true; break;} // при ошибках или изменении кол-ва ордеров надо заново перебирать ордера (выходим из цикла "for"), т.к. номера ордеров поменялись
         }//if (OrderSelect      
      }//while(ReSelect)     
   TerminalFree();
   }  //ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
     
void OrderCheck(){   // Узнаем подробности открытых поз//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   BUY=0; BUYSTOP=0; BUYLIMIT=0; SELL=0; SELLSTOP=0; SELLLIMIT=0;  STOP_BUY=0; PROFIT_BUY=0; STOP_SELL=0; PROFIT_SELL=0;
   int BuyExpir, SellExpir, Ord;
   for (Ord=0; Ord<OrdersTotal(); Ord++){ 
      if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==Magic){
         if (OrderType()==6) continue; // ролловеры не записываем
         switch(OrderType()){
            case OP_BUYSTOP:  BUYSTOP=OrderOpenPrice();  STOP_BUY=OrderStopLoss();  PROFIT_BUY=OrderTakeProfit();   BuyStopTime=OrderOpenTime();   BuyExpir=OrderExpiration();  BuyLot=OrderLots();  break;
            case OP_BUYLIMIT: BUYLIMIT=OrderOpenPrice(); STOP_BUY=OrderStopLoss();  PROFIT_BUY=OrderTakeProfit();   BuyLimitTime=OrderOpenTime();  BuyExpir=OrderExpiration();  BuyLot=OrderLots();  break;
            case OP_BUY:      BUY=OrderOpenPrice();      STOP_BUY=OrderStopLoss();  PROFIT_BUY=OrderTakeProfit();   BuyTime=OrderOpenTime();       BuyExpir=OrderExpiration();  BuyLot=OrderLots();  break;
            case OP_SELLSTOP: SELLSTOP=OrderOpenPrice(); STOP_SELL=OrderStopLoss(); PROFIT_SELL=OrderTakeProfit();  SellStopTime=OrderOpenTime();  SellExpir=OrderExpiration(); SellLot=OrderLots(); break;
            case OP_SELLLIMIT:SELLLIMIT=OrderOpenPrice();STOP_SELL=OrderStopLoss(); PROFIT_SELL=OrderTakeProfit();  SellLimitTime=OrderOpenTime(); SellExpir=OrderExpiration(); SellLot=OrderLots(); break;
            case OP_SELL:     SELL=OrderOpenPrice();     STOP_SELL=OrderStopLoss(); PROFIT_SELL=OrderTakeProfit();  SellTime=OrderOpenTime();      SellExpir=OrderExpiration(); SellLot=OrderLots(); break;
      }  }  }
   aOrdRem[0][1]=BUY;  aOrdRem[0][2]=BUYSTOP;  aOrdRem[0][3]=BUYLIMIT;  aOrdRem[0][4]=STOP_BUY;  aOrdRem[0][5]=PROFIT_BUY;   // запоминаем значения ордеров
   aOrdRem[1][1]=SELL; aOrdRem[1][2]=SELLSTOP; aOrdRem[1][3]=SELLLIMIT; aOrdRem[1][4]=STOP_SELL; aOrdRem[1][5]=PROFIT_SELL;  // чтобы выяснить необходимость модификации
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   

void OrdersCollect(){// Запишем ордера для выставления в массив. ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   if (SetBUY>0){ // запланировано открытие лонга
      GlobalVariableSet(DoubleToStr(Magic,0)+"SetBUY",SetBUY);
      GlobalVariableSet(DoubleToStr(Magic,0)+"SetSTOP_BUY",SetSTOP_BUY);
      GlobalVariableSet(DoubleToStr(Magic,0)+"SetPROFIT_BUY",SetPROFIT_BUY);
      GlobalVariableSet(DoubleToStr(Magic,0)+"BuyExpiration",Expiration);
      Print(Magic,"/",Symbol(),Period(),": SetBUY=",SetBUY," STOP=",SetSTOP_BUY," PROFIT=",SetPROFIT_BUY," Expiration=",TimeToStr(Expiration,TIME_DATE | TIME_MINUTES)); 
      }
   if (SetSELL>0){
      GlobalVariableSet(DoubleToStr(Magic,0)+"SetSELL",SetSELL);
      GlobalVariableSet(DoubleToStr(Magic,0)+"SetSTOP_SELL",SetSTOP_SELL);
      GlobalVariableSet(DoubleToStr(Magic,0)+"SetPROFIT_SELL",SetPROFIT_SELL);
      GlobalVariableSet(DoubleToStr(Magic,0)+"SellExpiration",Expiration);
      Print(Magic,"/",Symbol(),Period(),": SetSell=",SetSELL," STOP=",SetSTOP_SELL," PROFIT=",SetPROFIT_SELL," Expiration=",TimeToStr(Expiration,TIME_DATE | TIME_MINUTES));   
   }  }// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   
void GlobalOrdersSet(){ // выставление ордеров с учетом риска остальных экспертов //ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   if (!Real) return;  // mode=0 режим выставления своих ордеров,  mode=1 режим проверки рисков
   double   CurLot[100], NewLot[100], OrdRisk[100], OrdPrice[100], OrdStop[100], OrdProfit[100], NewRisk=0,  Stop=0, OpenLongRisk=0, OpenShortRisk=0,  OpenOrdMargNeed=0, 
            LongRisk, ShortRisk, MargNeed, LotDecrease, LongDecrease=1, ShortDecrease=1, RevBUYTemp=RevBUY, RevSELLTemp=RevSELL,  RiskTemp=Risk;
   string OrdersFilename="OrdersCollect.csv", OrdSym[100], SymTemp=SYMBOL;
   int Ord=0, ord, Exp, Orders=100, MaxDD[100], LastDD[100], LastDDTime[100], OrdType[100], OrdMagic[100], OrdExpir[100], OrdPer[100],  ExpTotal=GlobalVariableGet("ExpertsTotal"),
       MagicTemp=Magic, BackTestTemp=BackTest, BarTemp=Bar, ExpMemoryTemp=ExpMemory, HistDDTemp=HistDD, LastTestDDTemp=LastTestDD, TestEndTimeTemp=TestEndTime,  PerTemp=Per;
   Print(Magic,":                 *   G L O B A L   O R D E R S   S E T   B E G I N   *"); 
   ArrayInitialize(OrdType,0);   ArrayInitialize(CurLot,0);    ArrayInitialize(MaxDD,0);  
   ArrayInitialize(OrdRisk,0);   ArrayInitialize(OrdPrice,0);  ArrayInitialize(LastDD,0); 
   ArrayInitialize(NewLot,0);    ArrayInitialize(OrdProfit,0); ArrayInitialize(OrdMagic,0);
   ArrayInitialize(OrdStop,0);   ArrayInitialize(OrdExpir,0);  ArrayInitialize(LastDDTime,0);
   // перепишем из глобальных переменных в массивы ПАРАМЕТРЫ НОВЫХ ОРДЕРОВ
   for (Exp=0; Exp<ExpTotal; Exp++){            // перебор массива с параметрами всех экспертов
      if (GlobalVariableCheck(DoubleToStr(aMagic[Exp],0))){// есть флаг готовности эксперта
         GlobalVariableDel(DoubleToStr(aMagic[Exp],0)); // удаляем флаг готовности экспертов
         if (GlobalVariableCheck(DoubleToStr(aMagic[Exp],0)+"SetBUY")){// есть ордер для выставления
            Ord++;
            OrdMagic[Ord]  =aMagic[Exp];
            OrdType[Ord]   =10; // значит SetBUY
            OrdPrice[Ord]  =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"SetBUY");         GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"SetBUY"); // тут же  
            OrdStop[Ord]   =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"SetSTOP_BUY");    GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"SetSTOP_BUY"); // удаляем
            OrdProfit[Ord] =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"SetPROFIT_BUY");  GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"SetPROFIT_BUY"); // считанный
            OrdExpir[Ord]  =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"BuyExpiration");  GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"BuyExpiration"); // глобал
            }      
         if (GlobalVariableCheck(DoubleToStr(aMagic[Exp],0)+"SetSELL")){// есть ордер для выставления
            Ord++;
            OrdMagic[Ord]  =aMagic[Exp];
            OrdType[Ord]   =11; // значит SetSELL
            OrdPrice[Ord]  =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"SetSELL");         GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"SetSELL"); // тут же  
            OrdStop[Ord]   =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"SetSTOP_SELL");    GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"SetSTOP_SELL"); // удаляем
            OrdProfit[Ord] =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"SetPROFIT_SELL");  GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"SetPROFIT_SELL"); // считанный
            OrdExpir[Ord]  =GlobalVariableGet(DoubleToStr(aMagic[Exp],0)+"SellExpiration");  GlobalVariableDel(DoubleToStr(aMagic[Exp],0)+"SellExpiration"); // глобал
      }  }  }
   // запишем в массивы параметры имеющихся ордеров  (рыночных и отложенных) 
   for (ord=0; ord<OrdersTotal(); ord++){// перебераем все открытые и отложенные ордера всех экспертов счета и дописываем их в массив ORD. Ролловеры (OrderType=6) туда не пишем.
      if (OrderSelect(ord, SELECT_BY_POS, MODE_TRADES)==true){
         if (OrderType()==6) continue; // ролловеры не записываем
         Ord++; // Print("Отложенные ордера = ",Ord," OrderType()=",OrderType());
         OrdType[Ord]   =OrderType();             
         OrdSym[Ord]    =OrderSymbol();
         OrdPrice[Ord]  =OrderOpenPrice();
         OrdStop[Ord]   =OrderStopLoss();
         OrdProfit[Ord] =OrderTakeProfit();
         CurLot[Ord]    =OrderLots();
         OrdMagic[Ord]  =OrderMagicNumber();
         OrdExpir[Ord]  =OrderExpiration();  // Print("CurrentOrder №-",Ord," OrdType=",OrdType[Ord]," Magic=",OrdMagic[Ord]," SYMBOL=",OrdSym[Ord]," Price=",OrdPrice[Ord]," Stop=",OrdStop[Ord]," Profit=",OrdProfit[Ord]," Expir=",TimeToStr(OrdExpir[Ord],TIME_DATE|TIME_MINUTES)," CurLot=",CurLot[Ord]);                   
      }  }  // теперь массив ORD содержит список всех открытых, отложенных и предстоящих установке ордеров
   if (Ord==0) {Print("Ордеров нет"); return;}  else Orders=Ord; 
   // Пересчитаем РЕАЛЬНЫЙ РИСК КАЖДОГО ЭКСПЕРТА ЧЕРЕЗ MM(), с учетом нового баланса 
   for (Ord=1; Ord<=Orders; Ord++){
      OrdSym[Ord]="AnotherExpert"; // маркировка ордера, относящегося к другому эксперту (чтобы не трогать его ордера) 
      for (Exp=0; Exp<ExpTotal; Exp++){            // из массива с параметрами всех экспертов
         if (OrdMagic[Ord]==0){  // попался ручной ордер
            OrdRisk[Ord]   =1;   // ставим риск
            MaxDD[Ord]     =10000000; // чтобы при ручной торговле риск не корректировался в зависимости от исторической просадки (ее просто нет), возьмем ее заведомо больше текущей.     
            LastDD[Ord]    =0;  // чтобы CurrentDD() вернул 0, опять же для того, чтобы не корректирровать риск
            LastDDTime[Ord]=2100000000; // Время TestEndTime для CurrentDD() возьмем заведомо большое (насколько позволяет компилятор), чтобы сразу выкинуло из цикла и не считалась CurDD
            }  
         if (OrdMagic[Ord]==aMagic[Exp]){      // пропишем риски и др. необходимую инфу
            OrdRisk[Ord]   =aRisk[Exp];        // во все имеющиеся ордера
            MaxDD[Ord]     =aHistDD[Exp];     
            LastDD[Ord]    =aLastTestDD[Exp];
            LastDDTime[Ord]=aTestEndTime[Exp];
            OrdSym[Ord]    =aSym[Exp];
            OrdPer[Ord]    =aPer[Exp]; // период потребуется в TesterFileCreate() при отправке ErrorLog()
         }  }
      if (OrdSym[Ord]=="AnotherExpert") continue; // пропускаем ордера другого эксперта 
      SYMBOL=OrdSym[Ord];
      Stop=MathAbs(OrdPrice[Ord]-OrdStop[Ord]);
      if (OrdType[Ord]<2){// открытый ордер
         OpenOrdMargNeed+=CurLot[Ord]*MarketInfo(SYMBOL,MODE_MARGINREQUIRED); // кол-во маржи, необходимой для открытия лотов
         if (OrdType[Ord]==0 && OrdPrice[Ord]-OrdStop[Ord]>0)  OpenLongRisk +=RiskChecker(CurLot[Ord],Stop,SYMBOL); // если стоп еще не ушел в безубыток, считаем риск. В противном случае риск позы равен нулю
         if (OrdType[Ord]==1 && OrdStop[Ord]-OrdPrice[Ord]>0)  OpenShortRisk+=RiskChecker(CurLot[Ord],Stop,SYMBOL); // суммарный риск открытых ордеров на продажу
         Print(Ord,". ",OrdToStr(OrdType[Ord])," ",OrdMagic[Ord],"/",OrdSym[Ord],"  Open/Stp/Prf:",OrdPrice[Ord],"/",OrdStop[Ord],"/",OrdProfit[Ord],"  CurLot=",DoubleToStr(CurLot[Ord],2),"  Risk=",DoubleToStr(OrdRisk[Ord],2),"%  RiskChecker(CurLot)=",DoubleToStr(RiskChecker(CurLot[Ord],Stop,SYMBOL),2),"%  HistDD=",MaxDD[Ord],"  LastTestDD=",LastDD[Ord],"  Expiration=",TimeToStr(OrdExpir[Ord],TIME_DATE | TIME_MINUTES)); 
         continue;// считать лот для открытых ордеров не надо
         }
      Risk        =OrdRisk[Ord]*Aggress; // умножаем на агрессивность торговли, определяемую при загрузке эксперта: if (Risk>0)  Aggress=Risk; else  Aggress=1
      HistDD      =MaxDD[Ord];
      LastTestDD  =LastDD[Ord];
      TestEndTime =LastDDTime[Ord];
      Magic       =OrdMagic[Ord]; 
      NewLot[Ord] =MoneyManagement(Stop); 
      Print(Ord,". ",OrdToStr(OrdType[Ord])," ",OrdMagic[Ord],"/",OrdSym[Ord],"  Open/Stp/Prf:",OrdPrice[Ord],"/",OrdStop[Ord],"/",OrdProfit[Ord],"  NewLot=",DoubleToStr(NewLot[Ord],2),"  Risk=",DoubleToStr(OrdRisk[Ord],2),"%  RiskChecker(NewLot)=",DoubleToStr(RiskChecker(NewLot[Ord],Stop,SYMBOL),2),"%  HistDD=",MaxDD[Ord],"  CurDD=",CurDD,"  LastTestDD=",LastDD[Ord],"  Expiration=",TimeToStr(OrdExpir[Ord],TIME_DATE | TIME_MINUTES)); 
      if (OrdType[Ord]==2 || OrdType[Ord]==4 || OrdType[Ord]==10)// счиаем риск для лонгов
         LongRisk+=RiskChecker(NewLot[Ord],Stop,SYMBOL); // найдем суммарный риск всех новых и отложенных ордеров
      if (OrdType[Ord]==3 || OrdType[Ord]==5 || OrdType[Ord]==11)// счиаем риск для шортов
         ShortRisk+=RiskChecker(NewLot[Ord],Stop,SYMBOL); // найдем суммарный риск всех новых и отложенных ордеров
      MargNeed+=NewLot[Ord]*MarketInfo(SYMBOL,MODE_MARGINREQUIRED); // кол-во маржи, необходимой для открытия новых и отложенных ордеров
      }  //Print ("GlobalOrdersSet()/ РИСКИ:  Маржа открытых = ",OpenOrdMargNeed/AccountFreeMargin()*100,",  Маржа отложников и новых = ",MargNeed/AccountFreeMargin()*100,", LongRisk=",LongRisk,"%, OpenLongRisk=",OpenLongRisk,"%, ShortRisk=",ShortRisk,"%, OpenShortRisk=",OpenShortRisk,"%, Orders=",Orders);   
   // П Р О В Е Р К А   Р И С К О В  /
   if (OpenLongRisk+LongRisk>MaxRisk && LongRisk!=0){// проверка Лонгов 
      if (MaxRisk>OpenLongRisk){
         LongDecrease=0.95*(MaxRisk-OpenLongRisk)/LongRisk;  
         //Report("LongOrders for open Risk="+DoubleToStr(LongRisk,1)+"%, decrease Lots in "+DoubleToStr(LongDecrease,2)+" ");
         }
      else {
         LongDecrease=0; // т.е. удаляем все отложники, т.к. риск открытых поз не позволяет
         Report("Open LongOrders Risk="+DoubleToStr(OpenLongRisk,1)+"%, delete another pending LongOrders!"); // если риск открытых ордеров превышает MaxRisk, то RiskDecrease будет отрицательным. Значит оставшиеся ордера надо удалить, обнуляя лоты.
      }  }
   if (OpenShortRisk+ShortRisk>MaxRisk && ShortRisk!=0){// проверка Шортов
      if (MaxRisk>OpenShortRisk){
         ShortDecrease=0.95*(MaxRisk-OpenShortRisk)/ShortRisk;
         //Report("ShortOrders for open Risk="+DoubleToStr(ShortRisk,1)+"%, decrease Lots in "+DoubleToStr(ShortDecrease,2)+" ");
         }  
      else {
         ShortDecrease=0;  // т.е. удаляем все отложники, т.к. риск открытых поз не позволяет
         Report("Open ShortOrders Risk="+DoubleToStr(OpenShortRisk,1)+"% , delete another pending ShortOrders!"); // если риск открытых ордеров превышает MaxRisk, то RiskDecrease будет отрицательным. Значит оставшиеся ордера надо удалить, обнуляя лоты.
      }  }   
   if (LongDecrease!=1 || ShortDecrease!=1){ // если необходимо пересчитать лоты    
      MargNeed=0; // придется пересчитать маржу в связи с уменьшением лотов 
      for (Ord=1; Ord<=Orders; Ord++){// пересчитаем все лоты
         if (OrdType[Ord]<2) continue; // открытые (Type=0..1) НЕ ТРОГАЕМ
         SYMBOL=OrdSym[Ord];
         if (OrdType[Ord]==2 || OrdType[Ord]==4 || OrdType[Ord]==10) // счиаем риск для лонгов  
            NewLot[Ord]=NormalizeDouble(NewLot[Ord]*LongDecrease,LotDigits);// на всех лонговых отложниках и новых ордерах уменьшаем риск/лот, чтобы вписаться в максимальный риск на все лонги  
         if (OrdType[Ord]==3 || OrdType[Ord]==5 || OrdType[Ord]==11)// счиаем риск для шортов
            NewLot[Ord]=NormalizeDouble(NewLot[Ord]*ShortDecrease,LotDigits);// на всех шортовых отложниках и новых ордерах уменьшаем риск/лот, чтобы вписаться в максимальный риск на все шорты
         MargNeed+=NewLot[Ord]*MarketInfo(SYMBOL,MODE_MARGINREQUIRED); // заново пересчитываем кол-во маржи, необходимой для открытия ордеров
      }  }
   // П Р О В Е Р К А   М А Р Ж И  ///
   if (OpenOrdMargNeed+MargNeed>AccountFreeMargin()*MaxMargin && MargNeed!=0){// перегрузили маржу 
      if (AccountFreeMargin()*MaxMargin>OpenOrdMargNeed){
         LotDecrease=0.95*(AccountFreeMargin()*MaxMargin-OpenOrdMargNeed)/MargNeed; // расчитаем коэффициент уменьшения риска/лота отложенных и новых ордеров (умножаеам на 0.95 для гистерезиса)
         //Report("For new orders open "+DoubleToStr(MargNeed/AccountFreeMargin()*100,0)+"% Margin need, decrease Lots in "+DoubleToStr(LotDecrease,2));
         }
      else{
         LotDecrease=0; // если риск открытых ордеров превышает MaxRisk, то RiskDecrease будет отрицательным. Значит оставшиеся ордера надо удалить, обнуляя лоты.
         //Report("Open orders have overload Margin to "+DoubleToStr(OpenOrdMargNeed/AccountFreeMargin()*100,0)+"% Delete another orders!");
         }
      for (Ord=1; Ord<=Orders; Ord++){// пересчитаем все лоты
         if (OrdType[Ord]<2) continue; // открытые (Type=0..1) НЕ ТРОГАЕМ
         NewLot[Ord]=NormalizeDouble(NewLot[Ord]*LotDecrease,LotDigits);// на всех отложниках и новых ордерах уменьшаем риск/лот, чтобы вписаться в маржу
      }  }
   // В Ы С Т А В Л Е Н И Е   О Р Д Е Р О В  
   for (Ord=1; Ord<=Orders; Ord++){
      if (OrdSym[Ord]=="AnotherExpert") continue; // пропускаем ордера другого эксперта
      SYMBOL      =OrdSym[Ord];
      Per         =OrdPer[Ord]; // период потребуется в TesterFileCreate() при отправке ErrorLog()
      Risk        =OrdRisk[Ord];
      HistDD      =MaxDD[Ord];
      LastTestDD  =LastDD[Ord];
      TestEndTime =LastDDTime[Ord];
      Magic       =OrdMagic[Ord]; 
      Expiration=OrdExpir[Ord]; 
      Stop=MathAbs(OrdPrice[Ord]-OrdStop[Ord]);// т.к. ордера ставятся с одного графика на разные пары,
      DIGITS=MarketInfo(SYMBOL,MODE_DIGITS); // поэтому надо знать данные пары выставляемого ордера
      StopLevel = MarketInfo(SYMBOL,MODE_STOPLEVEL)*MarketInfo(SYMBOL,MODE_POINT);  
      Spred     = MarketInfo(SYMBOL,MODE_SPREAD)   *MarketInfo(SYMBOL,MODE_POINT);
      if (OrdType[Ord]<2) continue;// открытые (Type=0..1) НЕ ТРОГАЕМ
      if (MathAbs(CurLot[Ord]-NewLot[Ord])>=MarketInfo(SYMBOL,MODE_LOTSTEP)*2 || CurLot[Ord]==0 || NewLot[Ord]==0){// если лот текущего ордера отличается от вновь посчитанного   
         OrderCheck();
         SetBUY=0;  SetSTOP_BUY =OrdStop[Ord]; SetPROFIT_BUY =OrdProfit[Ord]; 
         SetSELL=0; SetSTOP_SELL=OrdStop[Ord]; SetPROFIT_SELL=OrdProfit[Ord];
         switch(OrdType[Ord]){
            case 2:  SetBUY=OrdPrice[Ord];  BUYLIMIT=0;  break; // выбираем тип
            case 3:  SetSELL=OrdPrice[Ord]; SELLLIMIT=0; break; // ордера
            case 4:  SetBUY=OrdPrice[Ord];  BUYSTOP=0;   break; // который
            case 5:  SetSELL=OrdPrice[Ord]; SELLSTOP=0;  break; // нужно удалить
            case 10: SetBUY=OrdPrice[Ord];               break;
            case 11: SetSELL=OrdPrice[Ord];              break;
            } 
         Lot  =NewLot[Ord]; Print("В Ы С Т А В Л Е Н И Е   О Р Д Е Р А   ",Ord,". ",Magic,"/",SYMBOL," ",OrdToStr(OrdType[Ord])," O/S/P",OrdPrice[Ord],"/",OrdStop[Ord],"/",OrdProfit[Ord],"  Risk=",Risk,"  Lot=",Lot,"  Expiration=",TimeToStr(Expiration,TIME_DATE | TIME_MINUTES));   
         if (OrdType[Ord]<6){// Удаление отложников
            Modify(); 
            OrderCheck(); 
            }
         if (Lot>0) OrdersSet();  // выставление заново 
      }  }
   GlobalVariableSet("LastBalance",AccountBalance()); // поскольку риски пересчитали, можно обновить LastBalance   
   BackTest    =BackTestTemp;      
   Bar         =BarTemp;
   ExpMemory   =ExpMemoryTemp;
   HistDD      =HistDDTemp;
   LastTestDD  =LastTestDDTemp;
   Magic       =MagicTemp;
   Per         =PerTemp;
   Risk        =RiskTemp;   
   RevBUY      =RevBUYTemp; 
   RevSELL     =RevSELLTemp; 
   SYMBOL      =SymTemp;
   TestEndTime =TestEndTimeTemp;
   Print(Magic,":                 *   G L O B A L   O R D E R S   S E T   E N D   *");
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 

void BalanceCheck(){// Проверка  состояния баланса для изменения лота текущих отложников  (При инвестировании или после крупных сделок) ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   if (!Real) return; 
   int BalanceChange=(GlobalVariableGet("LastBalance")-AccountBalance())*100/AccountBalance();
   if (MathAbs(BalanceChange)<10  || AccountBalance()<1) return; // баланс изменился свыше 10%
   // тянем жребий, кому выставлять ордера 
   Print(Magic,": BalanceCheck(): Баланс изменился на ", BalanceChange, "%, пробуем захватить терминал для пересчета ордеров"); 
   GlobalVariableSetOnCondition("CanTrade",Magic,0); // попытка захватат флага доступа к терминалу    
   Sleep(100);
   if (GlobalVariableGet("CanTrade")!=Magic) return;// первыми захватили флаг доступа к терминалу
   Print(Magic,": BalanceCheck(): Захватили терминал для пересчета ордеров");
   if (BalanceChange>0) str="increase"; else str="decrease";
   Report("Balance "+str+" on "+ DoubleToStr(MathAbs(BalanceChange),0) +"%, recount orders");
   GlobalVariableSet("LastBalance",AccountBalance()); Sleep(100);
   GlobalVariableSet("CanTrade",0); // сбрасываем глобал
   GlobalOrdersSet(); // расставляем ордера
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 

string OrdToStr(int Type){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
   switch(Type){
      case 0:  return ("BUY"); 
      case 1:  return ("SELL");
      case 2:  return ("BUYLIMIT"); 
      case 3:  return ("SELLLIMIT");
      case 4:  return ("BUYSTOP");
      case 5:  return ("SELLSTOP");
      case 10: return ("SetBUY");
      case 11: return ("SetSELL");
      default: return ("-");
   }  }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
   

