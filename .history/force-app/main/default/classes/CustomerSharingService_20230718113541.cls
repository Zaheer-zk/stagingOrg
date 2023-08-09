public class CustomerSharingService {

    public static void shareCustomerToUser(Map<Id,Customer__c>oldMapInstance, List<Customer__c> customers) {
        List<Customer__Share> customerShares = new List<Customer__Share>();
        List<Program__Share> programShares = new List<Program__Share>();
        List<Program__Share> programSharesToRemove = new List<Program__Share>();
        
        for (Customer__c customer : customers) {
            if (customer.Status__c == 'Active') {
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
            } else if (oldMapInstance.get(customer.Id).Status__c == 'Active' && customer.Status__c == 'Inactive') {
                // If status changed from Active to Inactive, remove shares
                
            }
        }

        for (Program__Share programShare : [SELECT Id FROM Program__Share WHERE ParentId = :customer.Program__c AND UserOrGroupId = :customer.User__c AND RowCause = 'Manual']) {
            programSharesToRemove.add(programShare);
        }
        
        if (!customerShares.isEmpty()) {
            System.debug('customerShares :' + customerShares);
            Database.SaveResult[] customerSharesResult = Database.insert(customerShares,false);

        }

        if (!programShares.isEmpty()) {
            System.debug('programShares :' + programShares);
            Database.SaveResult[] programSharesResult = Database.insert(programShares,false);
        }
    }
}