/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 02-20-2023
 * @last modified by  : Zaheer Khan
**/
public with sharing class CustomPath {

    @AuraEnabled(cacheable=true)
    public static Opportunity getRecord(Id recordId){
        try {
            return [SELECT Id, StageName, Stage_2__c FROM Opportunity WHERE Id = :recordId LIMIT 1];  
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static void updateRecord(Id recordId, String path1Value, String path2Value) {
        // Retrieve the opportunity record
        Opportunity opp = [SELECT Id, StageName, Stage_2__c FROM Opportunity WHERE Id = :recordId LIMIT 1];

        // Update the path fields
        opp.StageName = path1Value;
        opp.Stage_2__c = path2Value;

        // Save the changes
        try {
            update opp;
        } catch (DmlException e) {
            // Error message
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An error occurred while updating the record: ' + e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
}