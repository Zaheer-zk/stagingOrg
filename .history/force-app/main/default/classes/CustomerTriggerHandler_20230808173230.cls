/**
 * Purpose : Create a Automation for manualy sharing costumers program
 * Created By : ZAHEER KHAN
 * Created Date : 07-08-2023
 * Revision Logs : V_1.0 - 
 */
public without sharing class CustomerTriggerHandler {

    public static void shareProgramToCustomerUser(List<Customer__c> newListOfCustomers, Map<Id,Customer__c> oldMapOfCustomers) {
        List<Customer__Share> customerShares = new List<Customer__Share>();
        List<Program__Share> programShares = new List<Program__Share>();
        List<Program__Share> programSharesToRemove = new List<Program__Share>();
        // List to hold customer IDs whose status has changed to 'Inactive'
        List<Id> listOfProgramIdsToDelete = new List<Id>();
        
        if(newListOfCustomers != null) {
            for (Customer__c customer : newListOfCustomers) {
    
                if(customer.User__c != null && customer.Program__c != null){
                    if (oldMapOfCustomers == null && customer.Status__c == CustomerConstants.STATUS_ACTIVE) {
                        // sharing associated Program__c records
                            Program__Share programShare = new Program__Share();
                            programShare.ParentId = customer.Program__c;
                            programShare.UserOrGroupId = customer.User__c;
                            programShare.AccessLevel = 'Read';
                            programShare.RowCause = Schema.Program__Share.RowCause.Share_To_Customer_User__c;
                            programShares.add(programShare);
                    } 
                    // Update case
                    else if (oldMapOfCustomers != null && ((oldMapOfCustomers.get(customer.Id).Status__c == CustomerConstants.STATUS_ACTIVE 
                                && customer.Status__c == CustomerConstants.STATUS_INACTIVE) || 
                                (oldMapOfCustomers.get(customer.Id).User__c != null 
                                && customer.User__c == null))) {
                        // If status changed from Active to Inactive, remove shares
                        if(customer.Program__c != null) {
                            listOfProgramIdsToDelete.add(customer.Program__c);
                        }
                    } else if (oldMapOfCustomers != null && oldMapOfCustomers.get(customer.Id).Status__c == CustomerConstants.STATUS_INACTIVE 
                                && customer.Status__c == CustomerConstants.STATUS_ACTIVE) {
                        // If status changed from Inactive to Active, add sharing
                        Program__Share programShare = new Program__Share();
                        programShare.ParentId = customer.Program__c;
                        programShare.UserOrGroupId = customer.User__c;
                        programShare.AccessLevel = 'Read';
                        programShare.RowCause = Schema.Program__Share.RowCause.Share_To_Customer_User__c;
                        programShares.add(programShare);
                    }
                }
            }
        }

        // Delete case
        if(oldMapOfCustomers != null && newListOfCustomers == null) {
            for(Customer__c customer : oldMapOfCustomers.values()){
                if(customer.Program__c != null) {
                    listOfProgramIdsToDelete.add(customer.Program__c);
                }
            }
        }

        System.debug('listOfProgramIdsToDelete: ' + listOfProgramIdsToDelete);

        if (!listOfProgramIdsToDelete.isEmpty()) {
            programSharesToRemove = [SELECT Id FROM Program__Share 
                                    WHERE ParentId IN :listOfProgramIdsToDelete AND RowCause = :Schema.Program__Share.RowCause.Share_To_Customer_User__c];
        }

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