public class oppStateTriggerHandler {
    
    
    public static void ValidateStage(List<Opportunity> ListOfNewOpp, Map<Id,Opportunity> OldMap) {
        
        //get picklist value
        
        Schema.DescribeFieldResult fieldDetail = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> values = fieldDetail.getPicklistValues();
        
        List<String> stageValueList = new List<String>(); // List of PickList Value
        
        for(Schema.PicklistEntry value : values) {
            
            stageValueList.add(value.getValue());
        }
        
        For(Opportunity Opp : ListOfNewOpp) {
            
            Id OppId = Opp.Id;
            
            if(OldMap != Null && Opp.StageName != OldMap.get(Opp.Id).StageName) {
                
                String oldStageNameOpp =  OldMap.get(Opp.Id).StageName;
                
                Integer oldIndex = stageValueList.indexOf(oldStageNameOpp);
                Integer currIndex = stageValueList.indexOf(Opp.StageName);
                
                if( (oldIndex >= 0 && oldIndex < stageValueList.size()) && (currIndex >= 0 && currIndex < stageValueList.size()) ) {
                    
                    if(currIndex > oldIndex && currIndex - oldIndex != 1) {
                        
                        Opp.StageName.addError('You have Jumped more then a stage on forward');
                    } else if(currIndex < oldIndex &&  oldIndex - currIndex != 1){
                        
                        Opp.StageName.addError('You have Jumped more then a stage on backward');
                    }
                }
            }
        }
        
        System.Debug(values);
    }
    
    
}