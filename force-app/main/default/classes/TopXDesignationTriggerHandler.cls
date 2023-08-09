public class TopXDesignationTriggerHandler {
    
    public static void designationHandle(List<Top_X_Designation__c> newList, Map<Id,Top_X_Designation__c> oldMap) {
        
        Set<Id> oppId = new Set<Id>();
        for(Top_X_Designation__c des : newList) {
            
            
            if((des.Type__c == 'Contract Flow Down/Handoff') && des.Document_Attached__c == True) {
                id desId = des.Opportunity__c;
                oppId.add(desId);
            }

            /*        
			id desId = des.Opportunity__c;
			oppId.add(desId);
			*/
            
        }
        
        List<Opportunity> newDesignationList = new List<Opportunity>();
        
        // List<Opportunity> designationOpp = [Select ID, Handoff_Attached__c From Opportunity Where Id In: oppId];
        
        /*
for(Top_X_Designation__c des : newList) {

Opportunity op = new Opportunity();

for(Opportunity o : designationOpp) {

if((des.Type__c == 'Contract Flow Down/Handoff') && des.Document_Attached__c == True) {

if(o.id == des.Opportunity__c) {

op.Id = o.id;
op.Handoff_Attached__c = 'Yes';
newDesignationList.add(op);
}
} else {

if(o.id == des.Opportunity__c) {

op.Id = o.id;
op.Handoff_Attached__c = 'No';
newDesignationList.add(op);
}
}
}
}
*/
        
        Map<Id,Opportunity> designationOpp = new Map<Id, Opportunity>([Select ID, Handoff_Attached__c From Opportunity Where Id In: oppId]);
        
        for(Top_X_Designation__c des : newList) {
            Opportunity opp = new Opportunity();
            
            if(designationOpp.ContainsKey(des.Opportunity__c) && (des.Type__c == 'Contract Flow Down/Handoff') && des.Document_Attached__c == True) {
                
                opp.Id = designationOpp.get(des.Opportunity__c).Id;
                opp.Handoff_Attached__c = 'Yes';
                newDesignationList.add(opp); 
            } else {
                
                opp.Id = designationOpp.get(des.Opportunity__c).Id;
                opp.Handoff_Attached__c = 'No';
                newDesignationList.add(opp); 
            }
        }
        
        if(!newDesignationList.isEmpty())        
            update newDesignationList;
    }
}