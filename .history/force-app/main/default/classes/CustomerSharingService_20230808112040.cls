/**
 * Purpose : Create a Automation for manualy sharing costumers program
 * Created By : ZAHEER KHAN
 * Created Date : 07-08-2023
 * Revision Logs : V_1.0 - 
 */

public class CustomerSharingService {

    public static void shareCustomerToUser(Map<Id,Customer__c> oldMapInstance, List<Customer__c> customers) {
        List<Customer__Share> customerShares = new List<Customer__Share>();
        List<Program__Share> programShares = new List<Program__Share>();
        List<Program__Share> programSharesToRemove = new List<Program__Share>();
        // List to hold customer IDs whose status has changed to 'Inactive'
        List<Id> inActiveCustomerIds = new List<Id>();
        
        for (Customer__c customer : customers) {
            if(customer.User__c != null){
                if (oldMapInstance == null && customer.Status__c == 'Active') {
                    Customer__Share customerShare = new Customer__Share();
                    customerShare.ParentId = customer.Id;
                    customerShare.UserOrGroupId = customer.User__c;
                    customerShare.AccessLevel = 'edit';
                    customerShare.RowCause = Schema.Customer__Share.RowCause.Manual;
                    customerShares.add(customerShare);
                    
                    // sharing associated Program__c records
                    if (customer.Program__c != null) {
                        Program__Share programShare = new Program__Share();
                        programShare.ParentId = customer.Program__c;
                        programShare.UserOrGroupId = customer.User__c;
                        programShare.AccessLevel = 'read';
                        programShare.RowCause = Schema.Program__Share.RowCause.Manual;
                        programShares.add(programShare);
                    }
                }else if (oldMapInstance == null && customer.Status__c == 'Inactive') {
                    Customer__Share customerShare = new Customer__Share();
                    customerShare.ParentId = customer.Id;
                    customerShare.UserOrGroupId = customer.User__c;
                    customerShare.AccessLevel = 'edit';
                    customerShare.RowCause = Schema.Customer__Share.RowCause.Manual;
                    customerShares.add(customerShare);
                } else if (oldMapInstance != null && oldMapInstance.get(customer.Id).Status__c == 'Active' 
                            && customer.Status__c == 'Inactive') {
                    // If status changed from Active to Inactive, remove shares
                    inActiveCustomerIds.add(customer.Id);
                }
            }
        }

        System.debug('inActiveCustomerIds: ' + inActiveCustomerIds);

        if (!inActiveCustomerIds.isEmpty()) {
            programSharesToRemove = [SELECT Id FROM Program__Share WHERE ParentId IN :inActiveCustomerIds AND RowCause = 'Manual'];
        }
        
        System.debug('programSharesToRemove: ' + programSharesToRemove);

        if (!customerShares.isEmpty()) {
            System.debug('customerShares :' + customerShares);
            Database.SaveResult[] customerSharesResult = Database.insert(customerShares,false);

        }

        if (!programShares.isEmpty()) {
            System.debug('programShares :' + programShares);
            Database.SaveResult[] programSharesResult = Database.insert(programShares,false);
            System.debug('programSharesResult: ' + programSharesResult);
        }

        if (!programSharesToRemove.isEmpty()) {
            System.debug('programSharesToRemove: ' + programSharesToRemove);
            Database.delete(programSharesToRemove);
        }
    }
}