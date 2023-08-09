/**
 * Purpose : Create a Automation for manualy sharing costumers program
 * Created By : ZAHEER KHAN
 * Created Date : 07-08-2023
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 07-08-2023
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