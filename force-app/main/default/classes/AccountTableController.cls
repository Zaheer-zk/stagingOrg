/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 03-13-2023
 * @last modified by  : Zaheer Khan
**/
public with sharing class AccountTableController {
    public static Boolean FLAG = false;

//M2 -------------------------------------------------
    @AuraEnabled
    public static List<Account> insertRecords(List<AccountWrapper> accountWrappers) {

        // if(FLAG) 
        // return null;
        // FLAG = true; 
        System.debug('accountWrappers: ' + accountWrappers);
        
        try {
            List<Contact> conList = new List<Contact>();
            List<Account> insertAccount = new List<Account>();
            for (AccountWrapper accWrapper : accountWrappers) {
                if (accWrapper.selected) {
                    Account account = new Account();
                    //Insert Account -----------
                    if (accWrapper.acc != null) {
                        account.Name = accWrapper.acc.Name;
                        account.Industry = accWrapper.acc.Industry;
                        account.Phone = accWrapper.acc.Phone;
                        account.Website = accWrapper.acc.Website;
                        insertAccount.add(account);
                    }
                }
            } // for loop of accountWrappers ------------------
            System.debug('insertAccount: ' + insertAccount);
            if (!insertAccount.isEmpty()) {
                insert insertAccount;
            }

           List<Account> Insertedaccounts = [SELECT Id, Name FROM Account WHERE Id IN :insertAccount];

            //Insert Contact -----------   
            for (Integer i = 0; i < Insertedaccounts.size(); i++) {

                Account acc = Insertedaccounts[i];

                for(AccountWrapper accWrapper : accountWrappers) {
                    
                    if (accWrapper.selected && acc.Id == accWrapper.acc.Id) {
                        Contact contact = new Contact();
                        contact.LastName = accWrapper.acc.Name;
                        contact.AccountId = acc.Id;
                        conList.add(contact);
                    }
                }

            }
            
            System.debug('conList: ' + conList);
            if (!conList.isEmpty()) {
                insert conList;
            }

            return Insertedaccounts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } // main function

    public class AccountWrapper {
        @AuraEnabled
        public Boolean selected {get; set;}
        @AuraEnabled
        public Account acc {get; set;}
        @AuraEnabled
        public ContactWrapper conWrapper {get; set;}
        
        public AccountWrapper() {
            this.selected = false;
            this.acc = new Account();
            this.conWrapper = new ContactWrapper();
            conWrapper.con = new Contact();
        }
    }

    public class ContactWrapper {
        @AuraEnabled
        public Contact con {get; set;}
        
        public ContactWrapper() {
            con = new Contact();
        }
    }
}



/**
 * M1 ///////////////////////////////////////////////////
 public class accountWrapper {
    @AuraEnabled public String Name { get; set; }
    @AuraEnabled public String Industry { get; set; }
    @AuraEnabled public String Phone { get; set; }
    @AuraEnabled public String Website { get; set; }
 }  

@AuraEnabled
public static List<Account> insertAccounts(List<AccountWrapper> accountWrappers) {
    list<Account> accounts = new List<Account>();

    for (Account acc : accountWrappers) {
        Account newAccount = new Account();
        newAccount.Name = acc.Name;
        newAccount.Industry = acc.Industry;
        newAccount.Phone = acc.Phone;
        newAccount.Website = acc.Website;
        acounts.add(newAccount);
    }

    if(!accounts.isEmpty()) {
        insert accounts;
    }
}
 */