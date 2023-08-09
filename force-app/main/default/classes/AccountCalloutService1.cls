public with sharing class AccountCalloutService1 {

    // @AuraEnabled (cacheable=true)
    // public static List<Account> allData() {
        
    //     List<Account> accList = new List<Account>();
    //     return accList = [SELECT Id, Name, Type, Phone, Industry, Website, (SELECT
    //                     Name, AccountId, FirstName, LastName, Email, Phone
    //                     FROM
    //                         Contacts)
    //                     FROM 
    //                         Account];
    // }

    // @AuraEnabled (cacheable=true)
    // public static List<Account> searchAccounts(String keySearch) {

    //     List<Account> accList = new List<Account>();
    //     String strAccName;

    //     if(keySearch == null) {

    //         accList = [SELECT Id, Name, Type, Phone, Industry, Website, (SELECT
    //                     Name, AccountId, FirstName, LastName, Email, Phone
    //                     FROM
    //                         Contacts)
    //                     FROM 
    //                         Account];
    //     }
    //     else {
            
    //         strAccName = keySearch + '%';
    //         accList = [SELECT Id, Name, Type, Phone, Industry, Website, (SELECT
    //                     Name, AccountId, FirstName, LastName, Email, Phone
    //                     FROM
    //                         Contacts)
    //                     FROM 
    //                         Account 
    //                     WHERE 
    //                         Name LIKE: strAccName];
    //     }

    //     System.debug('accList: ' + accList);
    //     return accList;
    // }    
    
    // @AuraEnabled (cacheable=true)
    // public static List<Contact> getAccountAndRelatedContacts(String accountId) {
        
    //     List<Contact> allConList = [ SELECT
    //                                     Name, AccountId, FirstName, LastName, Email, Phone
    //                                 FROM
    //                                     Contact
    //                                 Where
    //                                     AccountId =:accountId];

    //     System.debug(allConList);

    //     return allConList;
    // }




    //Display the Contacts based on AccountId the help of event in LWc
    @AuraEnabled(cacheable=true)
    public static List<Account> retrieveAccountRecordsNoKey(){
        List<Account> accList = [Select Id, Name, Phone, Industry From Account Where Phone != null limit 10];
        return accList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> accRecordWithRecordId(String recordId) {

        System.debug('recordId ' + recordId);
        List<Account> accList = [Select Id, Name, Phone, Industry From Account Where Id =:recordId];

        System.debug('accList: ' + accList);
        return accList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> retrieveAccountRecords(String keySearch) {

        String strAccName = keySearch + '%';

        List<Account> accList = [Select Id, Name, Phone, Industry From Account Where Name Like :strAccName];

        System.debug('accList: ' + accList);
        return accList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> retrieveContactRecords(string accId){
      List<Contact> conObj = new  List<Contact>();
      List<Contact> conList = [Select Id, FirstName, LastName, Email, Phone, AccountId From Contact Where AccountId=:accId];
      for(Contact con:conList){
        conObj.add(con);
      }
      return conObj;
    }
}