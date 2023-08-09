trigger CustomerTrigger on Customer__c (after insert, after update) {
    CustomerSharingService.shareCustomerToUser(Trigger.new);
}