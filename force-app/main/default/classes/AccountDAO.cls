public class AccountDAO implements IAccount {
    public List<Account> conList = new List<Account>();
    public interface IAccount {
        List<Account> generateAccounts();
    }
    
     public List<Account> generateAccounts() {
         // SOQL Which generate/Fetch Account 
        return [SELECT ID, Name FROM Account LIMIT 100];
    }
}