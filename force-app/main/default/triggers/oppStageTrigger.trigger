trigger oppStageTrigger on Opportunity (before update) {
    
    if(trigger.isBefore && trigger.isUpdate) {
        
        oppStateTriggerHandler.ValidateStage(trigger.new, trigger.OldMap);
    }
}