pragma solidity 0.5.2;

import "./Ownable.sol";
import "./SafeMath.sol";


contract iBaseLottery {
    function getPeriod() public view returns (uint);
    function startLottery(uint _startPeriod) public payable;
    function setTicketPrice(uint _ticketPrice) public;
}


contract Management is Ownable {
    using SafeMath for uint;

    uint constant public BET_PRICE = 10000000000000000;  //0.01 eth in wei
    uint constant public HOURLY_LOTTERY_SHARE = 40;  //0.01 eth in wei
    uint constant public DAILY_LOTTERY_SHARE = 10;                        //10% to daily lottery
    uint constant public WEEKLY_LOTTERY_SHARE = 5;                        //5% to weekly lottery
    uint constant public MONTHLY_LOTTERY_SHARE = 5;                       //5% to monthly lottery
    uint constant public YEARLY_LOTTERY_SHARE = 5;                        //5% to yearly lottery
    uint constant public SUPER_JACKPOT_LOTTERY_SHARE = 15;                 //15% to superJackpot lottery
    uint constant public SHARE_DENOMINATOR = 100;                        //denominator for share
    uint constant public ORACLIZE_TIMEOUT = 86400;

    iBaseLottery public mainLottery;
    iBaseLottery public dailyLottery;
    iBaseLottery public weeklyLottery;
    iBaseLottery public monthlyLottery;
    iBaseLottery public yearlyLottery;
    iBaseLottery public superJackPot;

    //uint public start = 1546300800; // 01.01.2019 00:00:00
    uint public start = now;

    constructor (
        address _mainLottery,
        address _dailyLottery,
        address _weeklyLottery,
        address _monthlyLottery,
        address _yearlyLottery,
        address _superJackPot
    )
        public
    {
        require(_mainLottery != address(0), "");
        require(_dailyLottery != address(0), "");
        require(_weeklyLottery != address(0), "");
        require(_monthlyLottery != address(0), "");
        require(_yearlyLottery != address(0), "");
        require(_superJackPot != address(0), "");

        mainLottery = iBaseLottery(_mainLottery);
        dailyLottery = iBaseLottery(_dailyLottery);
        weeklyLottery = iBaseLottery(_weeklyLottery);
        monthlyLottery = iBaseLottery(_monthlyLottery);
        yearlyLottery = iBaseLottery(_yearlyLottery);
        superJackPot = iBaseLottery(_superJackPot);
    }

    function startLotteries() public payable onlyOwner {

        mainLottery.setTicketPrice(BET_PRICE.mul(HOURLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        dailyLottery.setTicketPrice(BET_PRICE.mul(DAILY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        weeklyLottery.setTicketPrice(BET_PRICE.mul(WEEKLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        monthlyLottery.setTicketPrice(BET_PRICE.mul(MONTHLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        yearlyLottery.setTicketPrice(BET_PRICE.mul(YEARLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        superJackPot.setTicketPrice(
            BET_PRICE.mul(SUPER_JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR)
        );

        mainLottery.startLottery.value(msg.value/6)(start.add(mainLottery.getPeriod()).sub(now));
        dailyLottery.startLottery.value(msg.value/6)(start.add(dailyLottery.getPeriod()).sub(now));
        weeklyLottery.startLottery.value(msg.value/6)(start.add(weeklyLottery.getPeriod()).sub(now));
        monthlyLottery.startLottery.value(msg.value/6)(start.add(monthlyLottery.getPeriod()).sub(now));
        yearlyLottery.startLottery.value(msg.value/6)(start.add(yearlyLottery.getPeriod()).sub(now));
        superJackPot.startLottery.value(msg.value/6)(ORACLIZE_TIMEOUT);
    }
}
