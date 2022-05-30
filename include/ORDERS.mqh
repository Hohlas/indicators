struct PRICE{    // 
   double Val,Stp,Prf;  // 
   }; 
PRICE setSEL, setBUY, SEL, BUY;
double BUYSTP, SELSTP, BUYLIM, SELLIM;

void SET_BUY(){
   int ticket;   double TradeRisk=0;  string str;
   if (setBUY.Val<=0) return;
   char repeat=3; // три попытки у тебя  
   if (MathAbs(setBUY.Val-ASK)<=StopLevel) setBUY.Val=ASK;  
   if (setBUY.Val-setBUY.Stp <= StopLevel)   {X("Stop too close to setBUY: "  +S4(setBUY.Val-setBUY.Stp)+" pips", setBUY.Val, bar, clrRed); repeat=0;}  // слишком близкий/неправильный стоп
   if (setBUY.Prf-setBUY.Val <= StopLevel)   {X("Profit too close to setBUY: "+S4(setBUY.Prf-setBUY.Val)+" pips", setBUY.Val, bar, clrRed); repeat=0;}  // слишком близкий/неправильный тейк
   while (repeat>0 && BUY.Val==0 && BUYSTP==0 && BUYLIM==0){ 
      if (Real){
         TerminalHold(); // ждем 60сек освобождения терминала
         MARKET_UPDATE(SYMBOL);
         Print("ORDERS_SET(): setBUY.Val=",S4(setBUY.Val),"/",S4(setBUY.Stp),"/",S4(setBUY.Prf)," Lot=",Lot," Magic=",Magic," Exp=",Expiration," ASK/BID=",S4(ASK),"/",S4(BID));
         Lot=MM(setBUY.Val-setBUY.Stp, SYMBOL); if (Lot<0) {REPORT("Lot<0"); break;} 
         TradeRisk=RiskChecker(Lot, setBUY.Val-setBUY.Stp, SYMBOL); 
         if (TradeRisk>MaxRisk) {REPORT("RiskChecker="+S2(TradeRisk)+"% too BIG!!! Lot="+S2(Lot)+" Balance="+S0(AccountBalance())+" Stop="+S4(setBUY.Val-setBUY.Stp)+" SYMBOL="+SYMBOL); break;}
         }
      if (setBUY.Val-ASK>StopLevel)  {str="Set BuyStp ";   ticket=OrderSend(SYMBOL,OP_BUYSTOP, Lot, setBUY.Val, 3, setBUY.Stp, setBUY.Prf, ExpID, Magic,Expiration,CornflowerBlue);}   else
      if (ASK-setBUY.Val>StopLevel)  {str="Set BuyLim ";   ticket=OrderSend(SYMBOL,OP_BUYLIMIT,Lot, setBUY.Val, 3, setBUY.Stp, setBUY.Prf, ExpID, Magic,Expiration,CornflowerBlue);}   else
                   {setBUY.Val=ASK;   str="Set setBUY ";      ticket=OrderSend(SYMBOL,OP_BUY,     Lot, setBUY.Val, 3, setBUY.Stp, setBUY.Prf, ExpID, Magic,    0        ,CornflowerBlue);}
      REPORT(str+S4(setBUY.Val)+"/"+S4(setBUY.Stp)+"/"+S4(setBUY.Prf)+"/"+S2(Lot)+"x"+S1(TradeRisk)+"%");
      ORDER_CHECK();
      if (ticket>0) break; // Ордеру назначен номер тикета. В случае неудачи ticket=-1   
      if (ERROR_CHECK("OrdersSet/setBUY")) repeat--; else repeat=0; // ERROR_CHECK() возвращает необходимость повтора торговой операции
      }
   TerminalFree();   
   }  
void SET_SEL(){
   int ticket;   double TradeRisk=0;  string str;   
   if (setSEL.Val<=0) return; 
   char repeat=3; // три попытки у тебя  
   if (MathAbs(BID-setSEL.Val)<=StopLevel) setSEL.Val=BID;
   if (setSEL.Stp-setSEL.Val <= StopLevel) {X("Stop too close to Sell: "  +S4(setSEL.Stp-setSEL.Val)+" pips",  setSEL.Val, bar, clrRed); repeat=0;}  // слишком близкий/неправильный стоп
   if (setSEL.Val-setSEL.Prf <= StopLevel) {X("Profit too close to Sell: "+S4(setSEL.Val-setSEL.Prf)+" pips",  setSEL.Val, bar, clrRed); repeat=0;}  // слишком близкий/неправильный тейк
   while (repeat>0 &&  SEL.Val==0 && SELSTP==0 && SELLIM==0){
      if (Real){
         TerminalHold(); // ждем 60сек освобождения терминала
         MARKET_UPDATE(SYMBOL);
         Print("ORDERS_SET(): setSEL.Val=",S4(setSEL.Val),"/",S4(setBUY.Stp),"/",S4(setBUY.Prf)," Lot=",Lot," Magic=",Magic," Exp=",Expiration," ASK/BID=",S4(ASK),"/",S4(BID));
         Lot=MM(setSEL.Stp-setSEL.Val, SYMBOL); if (Lot<0) {REPORT("Lot<0"); break;} 
         TradeRisk=RiskChecker(Lot, setSEL.Stp-setSEL.Val, SYMBOL);
         if (TradeRisk>MaxRisk) {REPORT("RiskChecker="+S2(TradeRisk)+"% too BIG!!! Lot="+S2(Lot)+" Balance="+S0(AccountBalance())+" Stop="+S4(setSEL.Stp-setSEL.Val)+" SYMBOL="+SYMBOL); break;}
         }
      if (BID-setSEL.Val>StopLevel) {str="Set SellStp ";   ticket=OrderSend(SYMBOL,OP_SELLSTOP, Lot, setSEL.Val, 3, setSEL.Stp, setSEL.Prf, ExpID, Magic,Expiration,Tomato);}   else
      if (setSEL.Val-BID>StopLevel) {str="Set SellLim ";   ticket=OrderSend(SYMBOL,OP_SELLLIMIT,Lot, setSEL.Val, 3, setSEL.Stp, setSEL.Prf, ExpID, Magic,Expiration,Tomato);}   else
                   {setSEL.Val=BID;  str="Set Sell ";      ticket=OrderSend(SYMBOL,OP_SELL,     Lot, setSEL.Val, 3, setSEL.Stp, setSEL.Prf, ExpID, Magic,      0       ,Tomato);}
      REPORT(str+S4(setSEL.Val)+"/"+S4(setSEL.Stp)+"/"+S4(setSEL.Prf)+"/"+S2(Lot)+"x"+S1(TradeRisk)+"%");
      ORDER_CHECK();
      if (ticket>0) break;  // Ордеру назначен номер тикета. В случае неудачи ticket=-1   
      if (ERROR_CHECK("OrdersSet/Sell")) repeat--; else repeat=0; // ERROR_CHECK() возвращает необходимость повтора торговой операции
      }
   TerminalFree();  
   }  
   
     
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void MODIFY(){   // Похерим необходимые стоп/лимит ордера: удаление если setBUY/Sell=0       
   bool ReSelect=true;      // если похерили какой-то ордер, надо повторить перебор сначала, т.к. OrdersTotal изменилось, т.е. они все перенумеровались 
   while (ReSelect){        // и переменная ReSelect вызовет их повторный перебор        
      ReSelect=false; int Orders=OrdersTotal();
      for(int Ord=0; Ord<Orders; Ord++){ 
         if (OrderSelect(Ord, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==Magic){
            int Order=OrderType();
            bool make=true;  
            uchar repeat=3;  
            while (repeat){// повторяем операции над ордером, пока не более 3 раз
               TerminalHold();
               MARKET_UPDATE(SYMBOL);
               switch(Order){
                  case OP_SELL:        //  C L O S E     S E L L  
                     if (SEL.Val==0){
                        make=OrderClose(OrderTicket(),OrderLots(),ASK,3,Tomato); 
                        REPORT("Close SELL/"+S4(OrderOpenPrice())); 
                        break;
                        }               //  M O D I F Y     S E L L  
                     if (!EQUAL(SEL.Stp,OrderStopLoss()) && SEL.Stp-ASK>StopLevel){Print("SEL.Stp=",SEL.Stp," OrderStop=",OrderStopLoss());
                        make=OrderModify(OrderTicket(), OrderOpenPrice(), SEL.Stp, OrderTakeProfit(),OrderExpiration(),Tomato);   REPORT("ModifySellStop/"+S4(SEL.Stp));}
                     if (!EQUAL(SEL.Prf,OrderTakeProfit()) && ASK-SEL.Prf>StopLevel){Print("SEL.Prf=",SEL.Prf," OrderTakeProfit=",OrderTakeProfit());
                        make=OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), SEL.Prf,OrderExpiration(),Tomato);   REPORT("ModifySellProfit/"+S4(SEL.Prf));}
                     break; 
                  case OP_SELLSTOP:    //  D E L   S E L L S T O P  //
                     if (SELSTP==0){ 
                        if (BID-OrderOpenPrice()>StopLevel){   make=OrderDelete(OrderTicket(),Tomato);                              REPORT("Del SellStop/"+S4(OrderOpenPrice()));}
                        else                                                                                                        REPORT("Can't Del SELLSTOP near market! BID="+S5(BID)+" OpenPrice="+S5(OrderOpenPrice())+" StopLevel="+S5(StopLevel));}
                     break;
                  case OP_SELLLIMIT:   //  D E L   S E L L L I M I T  //
                     if (SELLIM==0){
                        if (OrderOpenPrice()-BID>StopLevel){   make=OrderDelete(OrderTicket(),Tomato);                              REPORT("Del SellLimit/"+S4(OrderOpenPrice()));}
                        else                                                                                                        REPORT("Can't Del SELLLIMIT! near market, BID="+S5(BID)+" OpenPrice="+S5(OrderOpenPrice())+" StopLevel="+S5(StopLevel));}   
                     break;
                  case OP_BUY:   //  C L O S E    B U Y  //////////////////////////////////////////////////////////////
                     if (BUY.Val==0){
                        make=OrderClose(OrderTicket(),OrderLots(),BID,3,CornflowerBlue); 
                        REPORT("Close BUY/"+S4(OrderOpenPrice()));  
                        break;
                        }        // M O D I F Y      B U Y
                     if (!EQUAL(BUY.Stp,OrderStopLoss()) && BID-BUY.Stp>StopLevel){Print("BUY.Stp=",BUY.Stp," OrderStop=",OrderStopLoss());
                        make=OrderModify(OrderTicket(), OrderOpenPrice(), BUY.Stp, OrderTakeProfit(),OrderExpiration(),CornflowerBlue);   REPORT("ModifyBuyStop/"+S4(BUY.Stp));} 
                     if (!EQUAL(BUY.Prf,OrderTakeProfit()) && BUY.Prf-BID>StopLevel){Print("BUY.Prf=",BUY.Prf," OrderTakeProfit=",OrderTakeProfit());
                        make=OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), BUY.Prf,OrderExpiration(),CornflowerBlue);   REPORT("ModifyBuyProfit/"+S4(BUY.Prf));}
                     break; 
                  case OP_BUYSTOP:  //  D E L  B U Y S T O P  //
                     if (BUYSTP==0){
                        if (OrderOpenPrice()-ASK>StopLevel){   make=OrderDelete(OrderTicket(),CornflowerBlue);                      REPORT("Del BuyStop/"+S4(OrderOpenPrice()));}
                        else                                                                                                        REPORT("Can't Del BUYSTOP near market! ASK="+S5(ASK)+" OpenPrice="+S5(OrderOpenPrice())+" StopLevel="+S5(StopLevel));}
                     break; 
                  case OP_BUYLIMIT: //  D E L  B U Y L I M I T  //
                     if (BUYLIM==0){
                        if (ASK-OrderOpenPrice()>StopLevel){   make=OrderDelete(OrderTicket(),CornflowerBlue);                      REPORT("Del BuyLimit/"+S4(OrderOpenPrice()));}
                        else                                                                                                        REPORT("Can't Del BUYLIMIT near market! ASK="+S5(ASK)+" OpenPrice="+S5(OrderOpenPrice())+" StopLevel="+S5(StopLevel));}
                     break;
                  }// switch(Order)  
               if (make) break; //  true при успешном завершении, или false в случае ошибки  
               if (ERROR_CHECK("Modify "+OrdToStr(Order)+" Ticket="+S0(OrderTicket())+" repeat="+S0(repeat))) repeat--; else repeat=0; // ERROR_CHECK() возвращает необходимость повтора торговой операции            
               }  //while(repeat)
            }//if (OrderSelect...   
         if (Orders!=OrdersTotal()) {ReSelect=true; break;} // при ошибках или изменении кол-ва ордеров надо заново перебирать ордера (выходим из цикла "for"), т.к. номера ордеров поменялись
         }// for(Ord=0; Ord<Orders; Ord++){    
      }// while(ReSelect)     
   TerminalFree();
   ERROR_CHECK("Modify");  
   }  
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
bool EQUAL(double One, double Two){// совпадение значений с точностью до 10 тиков
   //if (MathAbs(N4(One)-N4(Two))>1) return false; else return true;
   if (MathAbs(One-Two)<MarketInfo(SYMBOL,MODE_DIGITS)) return true; else return false;
   }     
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void MARKET_UPDATE(string SYM){ // ASK, BID, DIGITS, Spred, StopLevel
   RefreshRates(); 
   ASK      =MarketInfo(SYM,MODE_ASK); 
   BID      =MarketInfo(SYM,MODE_BID);    // в функции GlobalOrdersSet() ордера ставятся с одного графика на разные пары, поэтому надо знать данные пары выставляемого ордера     
   DIGITS   =int(MarketInfo(SYM,MODE_DIGITS)); // поэтому надо знать данные пары выставляемого ордера
   Spred    =MarketInfo(SYM,MODE_SPREAD)   *MarketInfo(SYM,MODE_POINT);
   StopLevel=(MarketInfo(SYMBOL,MODE_STOPLEVEL) + MarketInfo(SYMBOL,MODE_SPREAD)) * MarketInfo(SYMBOL,MODE_POINT);  // Спред необходимо учитывать, т.к. вход и выход из позы происходят по разным ценам (ask/bid)
   }      
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void ORDER_CHECK(){   // ПАРАМЕТРЫ ОТКРЫТЫХ И ОТЛОЖЕННЫХ ПОЗ
   BUY.Val=0; BUYSTP=0; BUYLIM=0; SEL.Val=0; SELSTP=0; SELLIM=0;  BUY.Stp=0; BUY.Prf=0; SEL.Stp=0; SEL.Prf=0;
   for (int i=0; i<OrdersTotal(); i++){ 
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==Magic){
         if (OrderType()==6) continue; // ролловеры не записываем
         switch(OrderType()){
            case OP_BUYSTOP:  BUYSTP=OrderOpenPrice();   BUY.Stp=OrderStopLoss();   BUY.Prf=OrderTakeProfit();    BuyTime=OrderOpenTime();    break;
            case OP_BUYLIMIT: BUYLIM=OrderOpenPrice();   BUY.Stp=OrderStopLoss();   BUY.Prf=OrderTakeProfit();    BuyTime=OrderOpenTime();    break;
            case OP_BUY:      BUY.Val=OrderOpenPrice();  BUY.Stp=OrderStopLoss();   BUY.Prf=OrderTakeProfit();    BuyTime=OrderOpenTime();    break;
            case OP_SELLSTOP: SELSTP=OrderOpenPrice();   SEL.Stp=OrderStopLoss();   SEL.Prf=OrderTakeProfit();    SellTime=OrderOpenTime();   break;
            case OP_SELLLIMIT:SELLIM=OrderOpenPrice();   SEL.Stp=OrderStopLoss();   SEL.Prf=OrderTakeProfit();    SellTime=OrderOpenTime();   break;
            case OP_SELL:     SEL.Val=OrderOpenPrice();  SEL.Stp=OrderStopLoss();   SEL.Prf=OrderTakeProfit();    SellTime=OrderOpenTime();   break;
   }  }  }  }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
void ORDERS_COLLECT(){// Запишем ордера для выставления в массив. 
   if (setBUY.Val>0){ // запланировано открытие лонга
      GlobalVariableSet(DoubleToStr(Magic,0)+"setBUY.Val",         setBUY.Val);
      GlobalVariableSet(DoubleToStr(Magic,0)+"setBUY.Stp",    setBUY.Stp);
      GlobalVariableSet(DoubleToStr(Magic,0)+"setBUY.Prf",  setBUY.Prf);
      GlobalVariableSet(DoubleToStr(Magic,0)+"BuyExpiration",  Expiration);
      Print(Magic,": ",Symbol(),Period()," ORDERS_COLLECT: setBUY.Val=",S4(setBUY.Val),"/",S4(setBUY.Stp),"/",S4(setBUY.Prf)," Expir=",TimeToStr(Expiration,TIME_DATE | TIME_MINUTES)); 
      }
   if (setSEL.Val>0){
      GlobalVariableSet(DoubleToStr(Magic,0)+"setSEL.Val",        setSEL.Val);
      GlobalVariableSet(DoubleToStr(Magic,0)+"setSEL.Stp",   setSEL.Stp);
      GlobalVariableSet(DoubleToStr(Magic,0)+"setSEL.Prf", setSEL.Prf);
      GlobalVariableSet(DoubleToStr(Magic,0)+"SellExpiration", Expiration);
      Print(Magic,": ",Symbol(),Period()," ORDERS_COLLECT: SetSell=",S4(setSEL.Val),"/",S4(setSEL.Stp),"/",S4(setSEL.Prf)," Expir=",TimeToStr(Expiration,TIME_DATE | TIME_MINUTES));   
   }  }// 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ  
struct ORDER_DATA{// данные эксперта
   int      Magic, Type, Per, HistDD, LastTestDD, BackTest;
   datetime Expir, Bar, TestEndTime, ExpMemory; 
   string   Sym, Coment;
   double   Price, Stop, Profit, Risk, Lot, NewLot, RevBUY, RevSELL;   
   };  
ORDER_DATA ORD[100], TMP;  
   
void GlobalOrdersSet(){ // выставление ордеров с учетом риска остальных экспертов //ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   if (!Real) return;  // mode=0 режим выставления своих ордеров,  mode=1 режим проверки рисков
   if (!GlobalVariableCheck("GlobalOrdersSet")) GlobalVariableSet("GlobalOrdersSet",0);
   while (!GlobalVariableSetOnCondition("GlobalOrdersSet",Magic,0))  Sleep(1000);
   double   NewRisk=0,  Stop=0, OpenLongRisk=0, OpenShortRisk=0,  OpenOrdMargNeed=0, LongRisk=0, ShortRisk=0, MargNeed=0, LotDecrease=1, LongDecrease=1, ShortDecrease=1;
   int Ord=0, Exp, Orders=100;
   Print(Magic,": ",Symbol(),Period(),"       *   G L O B A L   O R D E R S   S E T   B E G I N   *"); 
   // перепишем из глобальных переменных в массивы ПАРАМЕТРЫ НОВЫХ ОРДЕРОВ
   for (Exp=0; Exp<ExpTotal; Exp++){            // перебор массива с параметрами всех экспертов
      if (CSV[Exp].Name==ExpertName && CSV[Exp].Sym==Symbol() && CSV[Exp].Per==Period()){
         if (GlobalVariableCheck(DoubleToStr(CSV[Exp].Magic,0)+"setBUY.Val")){// есть ордер для выставления
            Ord++;
            ORD[Ord].Magic  =CSV[Exp].Magic;
            ORD[Ord].Type   =10; // значит setBUY.Val
            ORD[Ord].Lot=0;   // лот расчитается ниже, исходя из индивидуального риска
            ORD[Ord].Price  =GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"setBUY.Val");         GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"setBUY.Val"); // тут же  
            ORD[Ord].Stop   =GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"setBUY.Stp");    GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"setBUY.Stp"); // удаляем
            ORD[Ord].Profit =GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"setBUY.Prf");  GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"setBUY.Prf"); // считанный
            ORD[Ord].Expir  =datetime(GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"BuyExpiration"));  GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"BuyExpiration"); // глобал
            }      
         if (GlobalVariableCheck(DoubleToStr(CSV[Exp].Magic,0)+"setSEL.Val")){// есть ордер для выставления
            Ord++;
            ORD[Ord].Magic  =CSV[Exp].Magic;
            ORD[Ord].Type   =11; // значит setSEL.Val
            ORD[Ord].Lot=0;   // лот расчитается ниже, исходя из индивидуального риска
            ORD[Ord].Price  =GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"setSEL.Val");         GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"setSEL.Val"); // тут же  
            ORD[Ord].Stop   =GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"setSEL.Stp");    GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"setSEL.Stp"); // удаляем
            ORD[Ord].Profit =GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"setSEL.Prf");  GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"setSEL.Prf"); // считанный
            ORD[Ord].Expir  =datetime(GlobalVariableGet(DoubleToStr(CSV[Exp].Magic,0)+"SellExpiration"));  GlobalVariableDel(DoubleToStr(CSV[Exp].Magic,0)+"SellExpiration"); // глобал
      }  }  }
   // запишем в массивы параметры имеющихся ордеров  (рыночных и отложенных) 
   for (int i=0; i<OrdersTotal(); i++){// перебераем все открытые и отложенные ордера всех экспертов счета и дописываем их в массив ORD. Ролловеры (OrderType=6) туда не пишем.
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true){
         if (OrderType()==6) continue; // ролловеры не записываем
         Ord++; // Print("Отложенные ордера = ",Ord," OrderType()=",OrderType());
         ORD[Ord].Type   =OrderType();             
         ORD[Ord].Sym    =OrderSymbol();
         ORD[Ord].Price  =OrderOpenPrice();
         ORD[Ord].Stop   =OrderStopLoss();
         ORD[Ord].Profit =OrderTakeProfit();
         ORD[Ord].Lot    =OrderLots();
         ORD[Ord].Magic  =OrderMagicNumber();
         ORD[Ord].Coment =OrderComment();
         ORD[Ord].Expir  =OrderExpiration();   //Print("CurrentOrder-",Ord," ",ORD[Ord].Magic,": ",OrdToStr(ORD[Ord].Type)," ",ORD[Ord].Sym," ",S4(ORD[Ord].Price),"/",S4(ORD[Ord].Stop),"/",S4(ORD[Ord].Profit)," Expir=",TimeToStr(ORD[Ord].Expir,TIME_DATE|TIME_MINUTES)," CurLot=",S2(ORD[Ord].Lot));                   
      }  }  // теперь массив ORD содержит список всех открытых, отложенных и предстоящих установке ордеров
   if (Ord==0){
      Print("No Orders"); 
      GlobalVariableSet("GlobalOrdersSet",0);
      Print(Magic,":                 *   G L O B A L   O R D E R S   S E T   E N D   *      GlobalOrdersSet=",GlobalVariableGet("GlobalOrdersSet"));
      return;}  
   Orders=Ord; 
   TMP.Magic   =Magic;              TMP.TestEndTime=TestEndTime;
   TMP.Per     =Per;                TMP.LastTestDD =LastTestDD;
   TMP.Bar     =BarTime;            TMP.Risk       =Risk;
   TMP.RevBUY  =RevBUY;             TMP.BackTest   =BackTest;
   TMP.HistDD  =HistDD;             TMP.RevSELL    =RevSELL;
   TMP.Sym     =SYMBOL;             TMP.ExpMemory  =ExpMemory;
   TMP.Coment  =ExpID;              
   // Пересчитаем РЕАЛЬНЫЙ РИСК КАЖДОГО ЭКСПЕРТА ЧЕРЕЗ MM(), с учетом нового баланса 
   for (Ord=1; Ord<=Orders; Ord++){
      for (Exp=0; Exp<ExpTotal; Exp++){            // из массива с параметрами всех экспертов
         if (ORD[Ord].Magic==CSV[Exp].Magic){      // пропишем риски и др. необходимую инфу
            ORD[Ord].Risk        =CSV[Exp].Risk;        // во все имеющиеся ордера
            ORD[Ord].HistDD      =CSV[Exp].HistDD;     
            ORD[Ord].LastTestDD  =CSV[Exp].LastTestDD;
            ORD[Ord].TestEndTime =CSV[Exp].TestEndTime;
            ORD[Ord].Sym         =CSV[Exp].Sym;
            ORD[Ord].Per         =CSV[Exp].Per; // период потребуется в TesterFileCreate() при отправке ErrorLog()
         }  } 
      SYMBOL=ORD[Ord].Sym;
      Stop=MathAbs(ORD[Ord].Price-ORD[Ord].Stop);
      if (ORD[Ord].Type<2){// открытый ордер
         OpenOrdMargNeed+=ORD[Ord].Lot*MarketInfo(SYMBOL,MODE_MARGINREQUIRED); // кол-во маржи, необходимой для открытия лотов
         if (ORD[Ord].Type==0 && ORD[Ord].Price-ORD[Ord].Stop>0)  OpenLongRisk +=RiskChecker(ORD[Ord].Lot,Stop,SYMBOL); // если стоп еще не ушел в безубыток, считаем риск. В противном случае риск позы равен нулю
         if (ORD[Ord].Type==1 && ORD[Ord].Stop-ORD[Ord].Price>0)  OpenShortRisk+=RiskChecker(ORD[Ord].Lot,Stop,SYMBOL); // суммарный риск открытых ордеров на продажу
         Print("Order-",Ord," ",ORD[Ord].Magic,": ",OrdToStr(ORD[Ord].Type)," ",ORD[Ord].Sym," ",S4(ORD[Ord].Price),"/",S4(ORD[Ord].Stop),"/",S4(ORD[Ord].Profit)," Expir=",TimeToStr(ORD[Ord].Expir,TIME_DATE|TIME_MINUTES)," Lot=",S2(ORD[Ord].Lot));
         continue;// считать лот для открытых ордеров не надо
         }
      Risk        =ORD[Ord].Risk*Aggress; // умножаем на агрессивность торговли, определяемую при загрузке эксперта: if (Risk>0)  Aggress=Risk; else  Aggress=1
      HistDD      =ORD[Ord].HistDD;
      LastTestDD  =ORD[Ord].LastTestDD;
      TestEndTime =ORD[Ord].TestEndTime;
      Magic       =ORD[Ord].Magic; 
      ORD[Ord].NewLot =MM(Stop, SYMBOL);
      Print("Order-",Ord," ",ORD[Ord].Magic,": ",OrdToStr(ORD[Ord].Type)," ",ORD[Ord].Sym," ",S4(ORD[Ord].Price),"/",S4(ORD[Ord].Stop),"/",S4(ORD[Ord].Profit)," Expir=",TimeToStr(ORD[Ord].Expir,TIME_DATE|TIME_MINUTES)," Lot=",S2(ORD[Ord].Lot)," NewLot=",S2(ORD[Ord].NewLot)," RiskChecker=",RiskChecker(ORD[Ord].NewLot,Stop,SYMBOL));      
      if (ORD[Ord].Type==2 || ORD[Ord].Type==4 || ORD[Ord].Type==10)// счиаем риск для лонгов
         LongRisk+=RiskChecker(ORD[Ord].NewLot,Stop,SYMBOL); // найдем суммарный риск всех новых и отложенных ордеров
      if (ORD[Ord].Type==3 || ORD[Ord].Type==5 || ORD[Ord].Type==11)// счиаем риск для шортов
         ShortRisk+=RiskChecker(ORD[Ord].NewLot,Stop,SYMBOL); // найдем суммарный риск всех новых и отложенных ордеров
      MargNeed+=ORD[Ord].NewLot*MarketInfo(SYMBOL,MODE_MARGINREQUIRED); // кол-во маржи, необходимой для открытия новых и отложенных ордеров
      }  //Print ("GlobalOrdersSet()/ РИСКИ:  Маржа открытых = ",OpenOrdMargNeed/AccountFreeMargin()*100,",  Маржа отложников и новых = ",MargNeed/AccountFreeMargin()*100,", LongRisk=",LongRisk,"%, OpenLongRisk=",OpenLongRisk,"%, ShortRisk=",ShortRisk,"%, OpenShortRisk=",OpenShortRisk,"%, Orders=",Orders);   
   // П Р О В Е Р К А   Р И С К О В  /
   if (OpenLongRisk+LongRisk>MaxRisk && LongRisk!=0){// проверка Лонгов 
      if (MaxRisk>OpenLongRisk){
         LongDecrease=0.95*(MaxRisk-OpenLongRisk)/LongRisk; 
         REPORT("LongRisk="+S1(OpenLongRisk+LongRisk)+"%! Decrease it on "+S1(LongDecrease)+"%");   
      }else{
         LongDecrease=0;   // т.е. удаляем все отложники, т.к. риск открытых поз не позволяет
         REPORT("Open LongOrders Risk="+S1(OpenLongRisk)+"%! delete another pending LongOrders!"); // если риск открытых ордеров превышает MaxRisk, то RiskDecrease будет отрицательным. Значит оставшиеся ордера надо удалить, обнуляя лоты.
         }
      for (Ord=1; Ord<=Orders; Ord++)  
         if (ORD[Ord].Type==2 || ORD[Ord].Type==4 || ORD[Ord].Type==10)  
            ORD[Ord].NewLot=NormalizeDouble(ORD[Ord].NewLot*LongDecrease,LotDigits);  // уменьшаем лоты для BUYLIMIT & BUYSTOP & setBUY.Val    
      }
   if (OpenShortRisk+ShortRisk>MaxRisk && ShortRisk!=0){// проверка Шортов
      if (MaxRisk>OpenShortRisk){
         ShortDecrease=0.95*(MaxRisk-OpenShortRisk)/ShortRisk;
         REPORT("ShortRisk="+S1(OpenShortRisk+ShortRisk)+"%! Decrease it on "+S1(ShortDecrease)+"%");   
      }else{
         ShortDecrease=0;  // т.е. удаляем все отложники, т.к. риск открытых поз не позволяет
         REPORT("Open ShortOrders Risk="+S1(OpenShortRisk)+"%! delete another pending ShortOrders!"); // если риск открытых ордеров превышает MaxRisk, то RiskDecrease будет отрицательным. Значит оставшиеся ордера надо удалить, обнуляя лоты.
         }
      for (Ord=1; Ord<=Orders; Ord++)  
         if (ORD[Ord].Type==3 || ORD[Ord].Type==5 || ORD[Ord].Type==11)  
            ORD[Ord].NewLot=NormalizeDouble(ORD[Ord].NewLot*ShortDecrease,LotDigits); // уменьшаем лоты для SELLLIMIT & SELLSTOP & setSEL.Val   
      }        
   // П Р О В Е Р К А   М А Р Ж И  ///
   if (OpenOrdMargNeed+MargNeed>AccountFreeMargin()*MaxMargin && MargNeed!=0){// перегрузили маржу 
      if (AccountFreeMargin()*MaxMargin>OpenOrdMargNeed){
         LotDecrease=0.95*(AccountFreeMargin()*MaxMargin-OpenOrdMargNeed)/MargNeed; // расчитаем коэффициент уменьшения риска/лота отложенных и новых ордеров (умножаеам на 0.95 для гистерезиса)
         REPORT("Margin="+S1(OpenOrdMargNeed+MargNeed)+"%! Decrease lots on "+S1(LotDecrease)+"%"); 
      }else{
         LotDecrease=0; // если риск открытых ордеров превышает MaxRisk, то RiskDecrease будет отрицательным. Значит оставшиеся ордера надо удалить, обнуляя лоты.
         REPORT("Open Orders Margin="+S1(OpenOrdMargNeed)+"%! delete all pending Orders!");
         }
      for (Ord=1; Ord<=Orders; Ord++){// пересчитаем все лоты
         if (ORD[Ord].Type<2) continue; // открытые (Type=0..1) НЕ ТРОГАЕМ
         ORD[Ord].NewLot=NormalizeDouble(ORD[Ord].NewLot*LotDecrease,LotDigits);// на всех отложниках и новых ордерах уменьшаем риск/лот, чтобы вписаться в маржу
      }  }
   // В Ы С Т А В Л Е Н И Е   О Р Д Е Р О В  
   for (Ord=1; Ord<=Orders; Ord++){
      if (ORD[Ord].Type<2) continue; // открытые (Type=0..1) НЕ ТРОГАЕМ
      SYMBOL      =ORD[Ord].Sym;
      if (MathAbs(ORD[Ord].Lot-ORD[Ord].NewLot)<MarketInfo(SYMBOL,MODE_LOTSTEP)) continue; 
      Per         =ORD[Ord].Per; // период потребуется в TesterFileCreate() при отправке ErrorLog()
      Risk        =ORD[Ord].Risk;
      HistDD      =ORD[Ord].HistDD;
      LastTestDD  =ORD[Ord].LastTestDD;
      TestEndTime =ORD[Ord].TestEndTime;
      Magic       =ORD[Ord].Magic; 
      Expiration  =ORD[Ord].Expir; 
      ExpID       =ORD[Ord].Coment;
      Stop=MathAbs(ORD[Ord].Price-ORD[Ord].Stop);// т.к. ордера ставятся с одного графика на разные пары,
      MARKET_UPDATE(ORD[Ord].Sym); // ASK, BID, DIGITS, Spred, StopLevel
      ORDER_CHECK();
      setBUY.Val=0;  setBUY.Stp =ORD[Ord].Stop; setBUY.Prf =ORD[Ord].Profit; 
      setSEL.Val=0;  setSEL.Stp=ORD[Ord].Stop; setSEL.Prf=ORD[Ord].Profit;
      switch(ORD[Ord].Type){
         case 2:  setBUY.Val=ORD[Ord].Price; BUYLIM=0;   break; // выбираем тип
         case 3:  setSEL.Val=ORD[Ord].Price; SELLIM=0;   break; // ордера
         case 4:  setBUY.Val=ORD[Ord].Price; BUYSTP=0;   break; // который
         case 5:  setSEL.Val=ORD[Ord].Price; SELSTP=0;   break; // нужно удалить
         case 10: setBUY.Val=ORD[Ord].Price;             break;
         case 11: setSEL.Val=ORD[Ord].Price;             break;
         } 
      Lot  =ORD[Ord].NewLot;    
      if (ORD[Ord].Type<6){// Удаление отложников
         MODIFY(); 
         ORDER_CHECK();} 
      if (Lot>0){ Print("GlobalOrdersSet ",Ord,". ",Magic,"/",OrdToStr(ORD[Ord].Type)," ",SYMBOL," ",S4(ORD[Ord].Price),"/",S4(ORD[Ord].Stop),"/",S4(ORD[Ord].Profit),"  Risk=",Risk,"  Lot=",Lot,"  Expir=",TimeToStr(Expiration,TIME_DATE | TIME_MINUTES));
         SET_BUY();  // выставление заново 
         SET_SEL();
      }  }  
   Magic    =TMP.Magic;       TestEndTime =TMP.TestEndTime;
   BackTest =TMP.BackTest;    ExpMemory   =TMP.ExpMemory;
   BarTime  =TMP.Bar;         Risk        =TMP.Risk;
   Per      =TMP.Per;         RevBUY      =TMP.RevBUY;
   HistDD   =TMP.HistDD;      RevSELL     =TMP.RevSELL;
   SYMBOL   =TMP.Sym;         LastTestDD  =TMP.LastTestDD;
   ExpID    =TMP.Coment;
   GlobalVariableSet("LastBalance",AccountBalance()); // для ф. CHECK_OUT()
   GlobalVariableSet("LastOrdTime",LAST_ORD_TIME());
   GlobalVariableSet("GlobalOrdersSet",0);
   GlobalVariableSet("CHECK_OUT_Time",TimeCurrent());
   Print(Magic,":                 *   G L O B A L   O R D E R S   S E T   E N D   *      GlobalOrdersSet=",GlobalVariableGet("GlobalOrdersSet"));
   }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void CHECK_OUT(){// Проверка недавних ордеров и состояния баланса для изменения лота текущих отложников  (При инвестировании или после крупных сделок) ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   if (!Real) return; 
   if (TimeCurrent()-GlobalVariableGet("CHECK_OUT_Time")<600) return;
   if (GlobalVariableGet("CanTrade")!=Magic && !GlobalVariableSetOnCondition("CanTrade",Magic,0)) return; // попытка захватат флага доступа к терминалу    
   GlobalVariableSet("CHECK_OUT_Time",TimeCurrent());
   datetime LastOrdTime=LAST_ORD_TIME();
   bool NeedToCheckOrders=false;
   if (GlobalVariableGet("LastOrdTime")!=LastOrdTime){ // разница между сохраненным временем ордера и последним выставленным больше минуты, т.е. 
      REPORT("CHECK_OUT(): LastOrdTime "+TIME(datetime(GlobalVariableGet("LastOrdTime")))+", changed to "+TIME(LastOrdTime)+", recount orders");
      GlobalVariableSet("LastOrdTime",LastOrdTime); 
      NeedToCheckOrders=true;
      }  
   double BalanceChange=(GlobalVariableGet("LastBalance")-AccountBalance())*100/AccountBalance();
   if (MathAbs(BalanceChange)>5){
      REPORT("CHECK_OUT(): BalanceChange="+ S0(BalanceChange) +"%, recount orders");
      NeedToCheckOrders=true;
      }
   GlobalVariableSet("CanTrade",0); // сбрасываем глобал
   if (NeedToCheckOrders) GlobalOrdersSet(); // расставляем ордера
   else Print(Magic,": CHECK_OUT(): Time of LastOrd ",TIME(LastOrdTime)," not changed, BalanceChange=",S1(BalanceChange),"%"); 
   } 
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
string OrdToStr(int Type){ 
   switch(Type){
      case 0:  return ("BUY"); 
      case 1:  return ("SELL");
      case 2:  return ("BUYLIMIT"); 
      case 3:  return ("SELLLIMIT");
      case 4:  return ("BUYSTOP");
      case 5:  return ("SELLSTOP");
      case 6:  return ("RollOver");
      case 10: return ("setBUY.Val");
      case 11: return ("setSEL.Val");
      default: return ("-");
   }  }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
datetime LAST_ORD_TIME(){
   datetime LastOrdTime=0;
   for (int i=0; i<OrdersTotal(); i++){// перебераем все открытые и отложенные ордера всех экспертов счета и дописываем их в массив ORD. Ролловеры (OrderType=6) туда не пишем.
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==false) continue; 
      if (OrderType()==6) continue; // ролловеры пропускаем
      if (OrderOpenTime()>LastOrdTime) LastOrdTime=OrderOpenTime(); //Print("Order ",OrdToStr(OrderType())," time=",TimeToStr(OrderOpenTime(),TIME_DATE | TIME_MINUTES), " LastOrdTime=",TimeToStr(LastOrdTime,TIME_DATE | TIME_MINUTES));
      }      
   return (LastOrdTime);
   }
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
