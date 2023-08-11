/**
 * Purpose          : To handle User Permission Setup records and perform certain actions after insert, update, or delete.
 * Created By       : ZAHEER KHAN
 * Created Date     : 10-08-2023
 * Revision Logs    : V_1.0 
 * Created By       : ZAHEER KHAN 
 */
trigger Trigger_UserPermissionSetup on User_Permission_Setup__c (after insert, after update, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            UserPermissionsetTriggerHandler.addPermissionsetToTheUser(Trigger.new, Trigger.oldMap);
            System.debug('============Updated a record: New record=========' + Trigger.new);
            System.debug('============Updated a record: Old record=========' + Trigger.oldMap);
        }
        if(Trigger.isDelete){
            UserPermissionsetTriggerHandler.addUpdatedPermissionsetToTheUser(Trigger.new, Trigger.oldMap);
            System.debug('============Updated a record: Old record=========' + Trigger.oldMap);
            System.debug('============Updated a record: New record=========' + Trigger.new);
        }
    }
}