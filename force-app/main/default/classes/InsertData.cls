/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 03-13-2023
 * @last modified by  : Zaheer Khan
 **/
public with sharing class InsertData {
    @AuraEnabled
    public static void insertAccount(String accountName, String accountIndustry) {
        try {
            Account newAccount = new Account();
            newAccount.Name = accountName;
            newAccount.Industry = accountIndustry;
            
            System.debug('newAccount: ' + newAccount);
            insert newAccount;
        } catch(Exception e) {
            throw new AuraHandledException('Internal Server Error: ' + e.getMessage());
        }
    }
}