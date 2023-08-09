trigger CustomerTrigger on Customer__c (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            CustomerSharingService.shareCustomerToUser(Trigger.new);
        }
    }
}