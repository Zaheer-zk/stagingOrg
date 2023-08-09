trigger AccountTriggerLogs on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore){
        system.debug('=================== Before Trigger Fired ===============');
        if(Trigger.isInsert) {
            system.debug('New Inserted record ::: Trigger.New ' + Trigger.New);
            system.debug('Old Inserted record ::: Trigger.old ' + Trigger.old);
        }
        if(Trigger.isUpdate) {
            system.debug('Check Update List ::: Trigger.New ' + Trigger.New);
            system.debug('Check Update List ::: Trigger.old ' + Trigger.old);
        }
        if(Trigger.isDelete) {
          System.debug('Deleted record' + Trigger.New);
        }
    }
    
    if(Trigger.isAfter){
        system.debug('=================== After Trigger Fired ===============');
        if(Trigger.isInsert) {
          system.debug('New Inserted record ::: Trigger.New ' + Trigger.New);
          system.debug('Old Inserted record ::: Trigger.old ' + Trigger.old);
      }
      else if(Trigger.isUpdate) {
          system.debug('New Inserted record ::: Trigger.New ' + Trigger.New);
          system.debug('Old Inserted record ::: Trigger.old ' + Trigger.old);
      }
      else if (Trigger.isDelete) {
        system.debug('New Inserted record ::: Trigger.New ' + Trigger.New);
          system.debug('Old Inserted record ::: Trigger.old ' + Trigger.old);
      }
      else if(Trigger.isUndelete) {
        system.debug('New Inserted record ::: Trigger.New ' + Trigger.New);
          system.debug('Old Inserted record ::: Trigger.old ' + Trigger.old);
      }
    }
} // main