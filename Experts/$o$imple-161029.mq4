//    Успех - не окончателен,
//    Неуачи - не фатальны.
//    Значение имеет лишь мужество продолжать...
//          Уинстон Черчилль 

#property version    "161.029" // yym.mdd
#property copyright  "Hohla"
#property link       "hohla.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок 

#ifndef TestMode // 
   #define TestMode // код, находящийся здесь, компилируется, если identifier в данный момент не определен командой препроцессора #define.
#endif

//#ifdef TestMode 
//   Print("Test mode"); 
//#else 
//   Print("Normal mode"); 
//#endif


extern int     BackTest=0;
sinput int     Opt_Trades=10; // Opt_Trades Влияет только на оптимизацию, остальные параметры и на опт ина бэктест
sinput double  RF_=5;         // RF При оптимизациях отбрасываем
sinput double  PF_=1.7;       // PF резы с худшими показателями
sinput int     MO_=2;         // MO множитель спреда, т.е. MO=MO_ * Spred
extern double  Risk= 0;       // Risk процент депо в сделке (на реале задается в файле #.csv) 
sinput int     MM=1;          // 1..4 см. ММ: 
extern bool    Real=false;  // Real
sinput bool    Check=false; 
      sinput string  z2="          -  P O C    L E V E L S    I N D I C A T O R  - ";  
extern int     PocPer=4;   // PocPer=4..8/2 кол-во бар для поиска POC
extern int     OnlyTop=1;  // OnlyTop=0..1 учет только разворотных консолидаций
extern int     TrPoc=0;    // TrPoc=0..2 Смена тренда при образовании подряд TrPoc уровней
      sinput string  z3="          -  P I C    L E V E L S    I N D I C A T O R  - ";
extern int     PicPer=2;      // PicPer=1..3 ширина фракталов для занесения уровня в массив
extern int     LevPer=3;      // LevPer=4..10/2 ширина фрактала для построения уровня
extern int     FirstLev=2;    // FirstLev=-3..3 кол-во ATR+2, которое должен развернуть первый уровень. (<0) дней назад - начало поиска первых уровней
extern int     LevPower=1;    // LevPower=-2..2 сила уровня по величинам переднего и заднего фронтов. Из них берется: 1-передний, 0 среднее, -1 задний, 2 больший, -2 меньший из двух
extern int   FltLen=3;  // FltLen=3..15/3 минимальная длина флэта; и бары от пробиваемого пика до его ложняка в SIG_MIRROR_LEVELS() и FALSE_LEVELS()
extern int   FltPic=2;  // FltPic=2..3 кол-во отскоков для формирования флэтового уровня UP2 (флэт всегда формируется по двум отскокам)
extern int   Target=-1; // Target=-2..2 определение целевого ур-ня -2-крупнейшее движ. от мелкого пика; -1-среднее движ. от мелкого пика; 0-среднее от клоза, 1-среднее от крупного пика; 2-крупнейшее от крупного пика
extern int     MinPower=2; // MinPower=0..5 удаление уровня, сила которого меньше (АТР*MinPower). 0-удаление слабых уровней если если после них появились более сильные. Все по DelSmall
extern int     DelSaw=3;   // DelSaw=0..4/2 кол-во бар, перепиливающих уровень на удаление. 0-просто маркировка факта пробития
extern int     DelSmall=0; // DelSmall=0..1 удаление из массива слабых уровней:  1-реальное; 0 - псевдо удаление (остается в массиве для сравнения, но не строится).
extern int     DelBroken=1;// DelBroken=0..1 удаление пробитых встречным фр-лом: 1-реальное; 0 - псевдо удаление (остается в массиве для сравнения, но не строится).
extern int   TrPic=0;   // TrPic=-2..2 Смена тренда при пробитии флэта(экстремума): 1-малым пиком, 2-большим пиком; -1-противоположным малым пиком; -2-противоположным большим пиком 
extern int   TrLoOnHi=0;// TrLoOnHi=0..2 Смена тренда при пробитии самого низкого максимума минимумом 1-мелкие пики; 2-крупные
extern int   TrLevBrk=2;// TrLevBrk=-2..2 Смена тренда при пробитии подряд TrLevBrk трендовых уровней: >0 шириной LevPer, <0-шириной PicPer
extern int     PicLim=1;   // PicLim=1..3 Допуск Pic.Lim:   1-(atr,ATR)/2  2-min(atr,ATR)  3-max(atr,ATR)
extern int     PicVal=20;  // PicVal=10..50  Допуск  Pic.Lim: АТР%
      sinput string  z4="          -  I M P U L S E    I N D I C A T O R - "; 
extern int  Impulse=200; // Impulse=150..300/50 порог срабатывания ATR% на активацию импульса в баре.     Актуален лишь при fImpulse>0
extern int  ImpBack=100; // ImpBack=70..210/30 откат от пиковой цены на ATR% для снятия сигнала импульса.               Активен только при fImpulse>0
      sinput string  z5="          -  F I L T E R S  -   ФИЛЬТРЫ НА ОТКРЫТИЕ И ЗАКРЫТИЕ ПОЗЫ. ";    
extern int  fNewPic=0;     // fNewPic=-3..3  >0-впадина (для лонга), <0 наоборот вершины) 2,3-потенциал пика       
extern int  fGlbTrnd=0;    // fGlbTrnd=-1..1 против/по глобального тренда, определяемого пробоем первых (сильных) уровней 
extern int  fLocTrnd=0;    // fLocTrnd=-1..3 локальный тренд: -1 против; 1-строго по тренду; 2-по тренду и во флэте; 3-только во флэте. Тренд определяется по TrPic, TrLoOnHi, TrLevBrk, TrChFls. 
extern int  fImpulse=0;    // fImpulse=0..2  1-не входить против резких импульсов величиной ATR*Impulse%; 2-вход только в направлении резких импульсов.
extern int  fTrndLev=0;    // fTrndLev=-2..2 около первых уровней: >0 АТР от краев; <0 =10% от диапазона меж уровнями
      sinput string  z6="          -  I N P U T S - ";
extern int  iLevContact=2; // iLevContact=-3..3 тип отработки уровней: (+)приближение / (-)пробитие уровня на Pic.Lim*iLevСontact пунктов. Pic.Lim-допуск совпадения уровней.       
extern int  iSignal=1;     // iSignal=0..3 1-зеркальные уровни; 2-флэт; 3-ложняк;
extern int  iParam=1;      // iParam=0..4 параметры сигнала
extern int  iBar=0;        // iBar=0..4 0-сигнал продолжителен и отменяется в ф-ях сигналов; >0 действует iParam бар      
extern int  Del=1;   // Del=0..1  удаление отложников при появлении нового сигнала; 
extern int  dAtr=10; // dAtr=6..12  ATR=ATR*dAtr*0.1 - минимальное приращение для расчета стопа, тейка и дельты входа: 
extern int  Iprice=1;// Iprice=0..7 цена вх: 0-sig 1-ask 2-DN1 3-DN2 4-DnCenter 5-Poc.DnLev 6-TargetDn 7-FirstDnCenter
extern int  D=0;     // D=-5..5  дельта для прибавления к ценам входа (D+1)*(D+1)*0.1*ATR  (ATR=ATR*dAtr*0.1)      
      sinput string  z7="          -  S T O P   - ";
extern int  Sprice=1;// Sprice=0..2 стоп: 0-sMin, 1-ближний, 2-дальний из DN1,DN2 (UP1,UP2)
extern int  sSig=0;  // sSig=0..1  Cигнальные стопы из функций сигналов (дальний из НАЧАЛЬНОГО и сигнального)
extern int  sMin=0;  // sMin=-2..2 при стопе меньше |sMin|*ATR: <0 не ставится; >0-стоп отодвигается. Где ATR=ATR*dAtr*0.1;
extern int  sMax=0;  // sMax=-2..2 при стопе больше |sMin+sMaxs|*ATR: <0 не ставится; >0-вход отодвигается. Где ATR=ATR*dAtr*0.1;
extern int  sTrd=0;  // sTrd=0..1  Трендовые стопы (дальний из НАЧАЛЬНОГО и за пик непробитого трендового) 
extern int  sPoc=0;  // sPoc=0..1  POC стопы (дальний из НАЧАЛЬНОГО и за уровни консолидации POC)
extern int  sTgt=0;  // sTgt=0..1  Целевые стопы (дальний из НАЧАЛЬНОГО и за целевые уровни)
extern int  sFst=0;  // sFst=0..1  Пики первых уровней (дальний из НАЧАЛЬНОГО и за Пики первых уровней)  
extern int  S=0;     // S=-2..5  Отдаление (<0 приближение) стопа на (|S|+1)^2*0.1*ATR  (ATR=ATR*dAtr*0.1) 
      sinput string  z8="          -  P R O F I T - ";
extern int  Pprice=1;// Pprice=0..2 тейк: 0-pMax, 1-ближайший, 2-дальний из пиков UP1,UP2 (DN1,DN2)       
extern int  pSig=0;  // pSig=0..1  Cигнальные тейки из функций сигналов (ближний из НАЧАЛЬНОГО и сигнального)
extern int  pMax=0;  // pMax=0..5  Тейк не дальше MaxProfit=(pMax+1)*ATR; ATR=ATR*dAtr*0.1;
extern int  pTrd=0;  // pTrd=0..1  Трендовые тейки (ближний из НАЧАЛЬНОГО и трендового) UP3
extern int  pPoc=0;  // pPoc=0..1  POC тейки (ближний из НАЧАЛЬНОГО и на уровни консолидации POC)
extern int  pTgt=0;  // pTgt=0..1  Целевые тейки (ближний из НАЧАЛЬНОГО и на целевые уровни) TargetUp
extern int  pFst=0;  // pFst=0..1  Первые уровни  (ближний из НАЧАЛЬНОГО и на Первые уровни) FirstUp
extern int  Prf=0;   // Prf=-2..5  Приближение (<0 удаление) тейка на (|Prf|+1)^2*0.1*ATR  (ATR=ATR*dAtr*0.1) 
extern int  minPL=0; // minPL=-6..6/2 если P/L хуже minPL/2: <0 не открываемся; >0 вход отодвигается для улучшения P/L
   sinput string  z9="          -  O U T P U T  - ";
extern int  Out=0;   // Out=0..7  комбинации сигналов GlobalTrend, Trend, Imp.Sig
extern int  oPrice=0;// oPrice=1..3  цены закрытия: 1-bid/ask, 2-UP1,UP2.., 3-MaxFromBuy, 
extern int  oD=0;    // oD=-6..6/2  дельта для прибавления к ценам выхода oD*ATR (ATR=ATR*dAtr*0.1)
extern int  Trl=0;   // Trl=-1..1  Трейлинг от: -1 стопа; 1 входа; 0-без трала.  
      sinput string  z10="          -  A  T  R  - ";       
extern int  A=15;    // A=10..30  кол-во бар^2 для медленного АТР
extern int  a=5;     // a=2..6  кол-во бар^2 для быстрого atr
extern int  Ak=1;    // Ak=1..3 используемый в подсчете стопов ATR:  1-(atr,ATR)/2  2-min(atr,ATR)  3-max(atr,ATR)
      sinput string  z11="          -  T I M E  - ";
extern int  ExpirBars=2;   // ExpirBars=0..23 Время Экспирации  в барах (GTC)
extern int  Tper=0;        // Tper=0..23 при Tin=0 кол-во бар удержания открытой позы; при Tin>0 кол-во часов разрешенной торговли Tin..Tin+Tper  
extern int  Tin=0;         // Tin=0..23 Время разрешения торговли (количество БАР с открытия сессии) Tout=Tin+Tper; if (Tout>23) Tout-=24; 
extern int  TimePrf=0;     // TimePrf=0..5  0 безусловное закрытие в запретный период (Tper или Tin), >0 перенос тейка на ATR*TimePrf*TimePrf

int      OrdersHistory,  Order, DailyConfirmation[100000], day, Today, LastYear, CanTrade, Trend=0,
         HistDD, LastTestDD,  TesterFile, Magic, BarsInDay, SlowAtrPer, FastAtrPer, TimeOn, TimeOff;
double   Equity, DayMinEquity, MaxEquity, DrawDown, FullDD, InitDeposit, FastAtr, SlowAtr,      
         BUY, SELL, BUYSTOP, SELLSTOP, BUYLIMIT, SELLLIMIT, STOP_BUY, PROFIT_BUY, STOP_SELL, PROFIT_SELL,   
         SetBUY, SetSELL, SetSTOP_BUY, SetPROFIT_BUY, SetSTOP_SELL, SetPROFIT_SELL, 
         MaxFromBuy, MinFromBuy, MaxFromSell, MinFromSell, RevBUY, RevSELL, TimeProfit,
         StopLevel, Spred, Lot, MaxRisk=10;  // максимальный суммарный риск всех позиций в одну сторону (все лонги или все шорты), максимальная загрузка маржи
datetime BarTime, LastBarTime, Expiration, LastDay, TestEndTime, ExpMemory, BuyTime, SellTime, BuyStopTime, BuyLimitTime, SellStopTime, SellLimitTime, PositionTime;
string   history, str,  ExpertName="$o$imple-161029", OptPeriod,
         Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13, 
         Str1,Str2,Str3,Str4,Str5,Str6,Str7,Str8,Str9,Str10,Str11,Str12,Str13; 
#include <stdlib.mqh> 
#include <iGRAPH.mqh> 
#include <lib_LOG.mqh> 
#include <lib_POC.mqh>  // сортировка POC
#include <lib_PIC.mqh>  // сортировка фракталов
#include <lib_IMPULSE.mqh>    // ИМПУЛЬС
#include <lib_False.mqh>      // ЛОЖНЯКИ
#include <iCnt.mqh>
#include <iINPUT.mqh>
#include <iOUTPUT.mqh>
#include <iSIGNAL.mqh>
#include <iREPORT.mqh>       // сохранение/восстановление параметров, отчеты и др. заморочки
#include <iSERVICE.mqh>       // сохранение/восстановление параметров, отчеты и др. заморочки
#include <iERROR.mqh>    // проверка исполнения
#include <iMM.mqh> 
#include <iORDERS.mqh>


void OnTick(){ // 2015.10.22. 23:00
   if (Time[bar]==BarTime) return; // Сравниваем время открытия текущего(0) бара
   BarTime=Time[bar];
   if (Time[bar]>=StringToTime("2015.02.05 11:00") && 
       Time[bar]<=StringToTime("2015.02.05 22:00")){Prn=true; ttt=TimeToString(Time[bar],TIME_DATE | TIME_MINUTES)+"    ";} else Prn=false; // Печать в заданный период 
   OrderCheck();  // Узнаем подробности открытых и отложенных поз  
   if (!COUNT()) return; // дожидаемся пока просчитаются все индюки (сравнение по АТР, т.к. он самый длинный) 
   if (!FINE_TIME()) return; // ОГРАНИЧЕНИЕ ПЕРИОДА ТОРГОВЛИ
   if (BUY || SELL){
      TIMER();    // ТАЙМЕР ОТКРЫТЫХ ПОЗИЦИЙ
      OUTPUT();   // ВЫХОДЫ 
      TRAILING(); // ТРЕЙЛИНГИ
      Modify();   // МОДИФИКАЦИЯ, УДАЛЕНИЕ ОРДЕРОВ
      }
   INPUT(); 
   
   DAY_STATISTIC();
   END();
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
bool FINE_TIME(){ // РАЗРЕШЕННОЕ ВРЕМЯ
   if (Tin==0) return (true); // ограничение по времени не работает
   int CurBar=int((TimeHour(Time[0])*60+Minute())/Period()); // приводим текущее время в количесво бар с начала дня
   if ((TimeOn<TimeOff &&  TimeOn<=CurBar && CurBar<TimeOff) ||                // 00:00 -нельзя- Tin -МОЖНО- Tout -нельзя- 23:59
       (TimeOn>TimeOff && (TimeOn<=CurBar || (0<=CurBar && CurBar<TimeOff)))) //  00:00-можно / Tout-НЕЛЬЗЯ-Tin / можно-23:59  
      return (true);
   // Закрытие всех поз в период запрета торговли    
   BUYSTOP=0; BUYLIMIT=0; SELLSTOP=0; SELLLIMIT=0; // отложники херим безоговорочно
   if (BUY>0){
      if (Bid-BUY>TimeProfit)  BUY=0;  // достаточно профита, чтоб сразу закрыться
      else  {if (PROFIT_BUY==0 || PROFIT_BUY>BUY+TimeProfit)  PROFIT_BUY=BUY+TimeProfit;} // Перетащим профит на уровень жадности
      }
   if (SELL>0){ 
      if (SELL-Ask>TimeProfit) SELL=0;  
      else  {if (PROFIT_SELL==0 || PROFIT_SELL<SELL-TimeProfit)  PROFIT_SELL=SELL-TimeProfit;}
      }
   Modify(); // все закрываем, удаляем 
   return (false);     
   }  
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void TIMER(){   // ВРЕМЯ УДЕРЖАНИ ОТКРЫТЫХ ПОЗ (В Барах) /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   if (Tper==0 || Tin>0) return; // если задан период работы Tin, то Tper определяет Tout=Tin+Tper+1; if (Tout>23) Tout-=24;
   if (BUY>0 && Time[0]-BuyTime>=PositionTime){ // Print("dTime=",(Time[0]-BuyTime)/3600.0);
      if (Bid-BUY>TimeProfit)  BUY=0;  // достаточно профита, чтоб сразу закрыться
      else  {if (PROFIT_BUY==0 || PROFIT_BUY>BUY+TimeProfit)  PROFIT_BUY=BUY+TimeProfit;} // Перетащим профит на уровень жадности
      Modify(); // все закрываем, удаляем
      } 
   if (SELL>0 && Time[0]-SellTime>=PositionTime){
      if (SELL-Ask>TimeProfit) SELL=0;  
      else  {if (PROFIT_SELL==0 || PROFIT_SELL<SELL-TimeProfit)  PROFIT_SELL=SELL-TimeProfit;}
      Modify(); // все закрываем, удаляем
   }  }        
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void WeekEnd(){   // закрываемся в конце недели 
   if (TimeDayOfWeek(Time[1])==5 && TimeHour(Time[0])>21){  // && TimeMinute(Time[0])>=60-Period()
      BUY=0; SELL=0; SetBUY=0; SetSELL=0; SetBUY=0; SetSELL=0;
   }  }