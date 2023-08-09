public class AccountHandler {
    public static Account insertNewAccount(string accName) {
        Account acct = new Account(Name = accName);
        
        try {
            System.debug('Executed');
            insert acct;
        }
        catch (DmlException error) {
            System.debug('DML exception occured' + error.getMessage());
            return null;
        }
        return acct;
    }
}