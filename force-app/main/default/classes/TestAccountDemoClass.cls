@isTest
public class TestAccountDemoClass {
    
    static MockDAO.AccountDAOMock accountDAOMockInstance = new MockDAO.AccountDAOMock();

    @isTest
    private static void generateAccountTest() {
        
        List<Account> accData = new List<Account>();
        Account accObj = TestDataFactory.createAccount(true);
        accData.add(accObj);
        accountDAOMockInstance.accList = accData;
        
        List<Account> returnedAccounts = new List<Account>();
        Test.startTest();
        returnedAccounts = AccountDemoClass.demoMethod(accData);
        Test.stopTest();
        System.assertEquals(true , returnedAccounts.size()>0,'Method should have returned atleast one account');
    }
}