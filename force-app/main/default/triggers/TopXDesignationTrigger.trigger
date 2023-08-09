trigger TopXDesignationTrigger on Top_X_Designation__c (after insert, after update) {
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        
        TopXDesignationTriggerHandler.designationHandle(trigger.new, trigger.oldMap);
    }
}