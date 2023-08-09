trigger CustomerTrigger on Customer__c (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            CustomerSharingService.shareCustomerToUser(Trigger.new);
                  System.debug('============Updated a record: Old record=========' + Trigger.oldMap);
      System.debug('============Updated a record: New record=========' + Trigger.new);
        }
    }
}