@isTest
public class TestVerifyDate {
    @isTest static void checkDateTest() {
        Date returnDate1 = VerifyDate.CheckDates(date.valueOf('2022-11-02'), date.valueOf('2022-11-10'));
        Date returnDate2 = VerifyDate.CheckDates(date.valueOf('2022-11-02'), date.valueOf('2022-12-10'));
        System.assertEquals(date.valueOf('2022-11-10'), returnDate1);
    }
    
    @isTest static void DateWithin30DaysTest() {
        Boolean returnValue1 = VerifyDate.DateWithin30Days(date.valueOf('2022-11-02'), date.valueOf('2022-11-10'));
        Boolean returnValue2 = VerifyDate.DateWithin30Days(date.valueOf('2022-11-02'), date.valueOf('2022-12-10'));
    }
    
    @isTest static void SetEndOfMonthDateTest() {
        Date returnValue1 = VerifyDate.SetEndOfMonthDate(date.valueOf('2022-11-02'));
        Date returnValue2 = VerifyDate.SetEndOfMonthDate(date.valueOf('2022-11-12'));
    }
}