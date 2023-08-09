public class CustomerSharingService {

    public static void shareCustomerToUser(List<Customer__c> customers) {
        List<Customer__Share> customerShares = new List<Customer__Share>();
        List<Program__Share> programShares = new List<Program__Share>();
        
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
            }
        }
        
        if (!customerShares.isEmpty()) {
            System.debug('customerShares :' + customerShares);
            Database.SaveResult[] customerSharesResult = Database.insert(customerShares,false);

        }

        if (!programShares.isEmpty()) {
            Database.SaveResult[] programSharesResult = Database.insert(programShares,false);
        }
    }
}