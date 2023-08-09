/**
 * Purpose : Create a Automation for manualy sharing costumers program
 * Created By : ZAHEER KHAN
 * Created Date : 07-08-2023
 * Revision Logs : V_1.0 - 
 */
public with sharing class CustomerTriggerHandler {
    public CustomerTriggerHandler() {

    }

    public static void shareCustomerToUser(List<Customer__c> customers, Map<Id,Customer__c> oldMapInstance) {
        List<Customer__Share> customerShares = new List<Customer__Share>();
        List<Program__Share> programShares = new List<Program__Share>();
        List<Program__Share> programSharesToRemove = new List<Program__Share>();
        // List to hold customer IDs whose status has changed to 'Inactive'
        List<Id> inActiveCustomerIds = new List<Id>();
        
        for (Customer__c customer : customers) {

            if(customer.User__c != null){
                if (oldMapInstance == null && customer.Status__c == 'Active') {
                    // sharing associated Program__c records
                    if (customer.Program__c != null) {
                        Program__Share programShare = new Program__Share();
                        programShare.ParentId = customer.Program__c;
                        programShare.UserOrGroupId = customer.User__c;
                        programShare.AccessLevel = 'read';
                        programShare.RowCause = Schema.Program__Share.RowCause.Manual;
                        programShares.add(programShare);
                    }
                } else if (oldMapInstance != null && oldMapInstance.get(customer.Id).Status__c == 'Active' 
                            && customer.Status__c == 'Inactive') {
                    // If status changed from Active to Inactive, remove shares
                    inActiveCustomerIds.add(customer.Id);
                } else if (oldMapInstance != null && oldMapInstance.get(customer.Id).Status__c == 'Inactive' 
                            && customer.Status__c == 'Active') {
                    // If status changed from Inactive to Active, add sharing
                    Program__Share programShare = new Program__Share();
                    programShare.ParentId = customer.Program__c;
                    programShare.UserOrGroupId = customer.User__c;
                    programShare.AccessLevel = 'read';
                    programShare.RowCause = Schema.Program__Share.RowCause.Manual;
                    programShares.add(programShare);
                }
            }
        }

        System.debug('inActiveCustomerIds: ' + inActiveCustomerIds);

        if (!inActiveCustomerIds.isEmpty()) {
            programSharesToRemove = [SELECT Id FROM Program__Share 
                                    WHERE ParentId IN :inActiveCustomerIds AND RowCause = 'Manual'];
        }
        
        System.debug('programSharesToRemove: ' + programSharesToRemove);

        if (!programShares.isEmpty()) {
            System.debug('programShares :' + programShares);
            insert programShares;
        }

        if (!programSharesToRemove.isEmpty()) {
            System.debug('programSharesToRemove: ' + programSharesToRemove);
            delete programSharesToRemove;
        }
    }
}