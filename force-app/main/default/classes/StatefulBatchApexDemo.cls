global class StatefulBatchApexDemo implements Database.Batchable<SObject>, Database.Stateful{
    
    public Integer current = 0;
    
    global Database.QueryLocator Start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([SELECT ID FROM ACCOUNT]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> acc) {
        System.debug('Previous Current == ' + current);
        current++;
        System.debug('After Current== ' + current);
    }
    
    global void finish (Database.BatchableContext bc) {
        System.debug('bc' + bc);
    }
}