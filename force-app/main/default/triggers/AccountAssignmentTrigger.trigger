trigger AccountAssignmentTrigger on Account (before insert, after insert) {
  if(Trigger.isBefore && Trigger.isInsert) {
    AccountTriggerAssignmentHelper.prefixedMessage(Trigger.New);
  }
  else if(Trigger.isAfter && Trigger.isInsert) {
    AccountTriggerAssignmentHelper.emialSender(Trigger.New);
  }
}

//