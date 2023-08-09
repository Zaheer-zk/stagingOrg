/*
Purpose : Bulk Adding Task (if Opportunity state is Closed win)
Created By : Zaheer Khan
Created Date : 21-07-22 
Revision Log : 01
*/
trigger CustomerTrigger on Customer__c (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            CustomerSharingService.shareCustomerToUser(Trigger.oldMap, Trigger.new);
            System.debug('============Updated a record: Old record=========' + Trigger.oldMap);
            System.debug('============Updated a record: New record=========' + Trigger.new);
        }
    }
}