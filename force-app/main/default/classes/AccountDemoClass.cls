public class AccountDemoClass {
    
    @testVisible private static AccountDAO.IAccount accountDAOInstance = new AccountDAO();
    
    public static List<Account> demoMethod(List<Account> accData) {
        
        List<Account> newAccounts = new List<Account>();
        List<Account> upAccList = accountDAOInstance.generateAccounts();
        
        for(Account acc : upAccList) {
            Account a = new Account();
            a.Id = acc.Id;
            a.Name = 'Test Account Name Update';
            newAccounts.add(a);
        }
        
        if(!newAccounts.isEmpty()){
            update newAccounts;
        }
        System.debug('newAccounts --------> ' + newAccounts);
        return newAccounts;
    }
}