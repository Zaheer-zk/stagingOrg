/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 12-27-2022
 * @last modified by  : Zaheer Khan
**/
public with sharing class DataTemplateWizardDemoApex {

    @AuraEnabled (cacheable=true)
    public static List<Account> searchAccounts(String keySearch) {

        String strAccName = keySearch + '%';
        List<Account> accList = [SELECT Id, Name, Type, Phone, Industry, Website FROM Account WHERE Name LIKE: strAccName]; 
        
        if(!accList.isEmpty())
        return accList;
        else {
            return null;
        }
        
        // try {
        //     if(accList) {
        //         return accList;
        //     }
        // } catch(Exception e) {
        //     System.debug(e.getMessage());
        //     return null;
        // }
    }    
    
    @AuraEnabled (cacheable=true)
    public static List<Contact> getAccountAndRelatedContacts(String accountId) {
        
        List<Contact> allConList = new List<Contact>();

        allConList = [SELECT Id, firstName, lastName, AccountId, Email FROM Contact WHERE AccountId =: accountId];
        
        if(!allConList.isEmpty())
        return allConList;
        else {
            return null;
        }

        // try {
        //     return allConList;   
        // } catch(Exception e) {
        //     System.debug(e.getMessage());
        // }
    }
}