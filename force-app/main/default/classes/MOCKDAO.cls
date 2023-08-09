public class MOCKDAO {
    
    public class ContactDAOMock implements ContactDAO.IContact {
        
        public List<Contact> conList = new List<Contact>();
        public List<Contact> generateContacts() {
            return conList;
        }
    }
    
    public class AccountDAOMock implements AccountDAO.IAccount {
        
        public List<Account> accList = new List<Account>();
        public List<Account> generateAccounts() {
            return accList;
        }
    }
}