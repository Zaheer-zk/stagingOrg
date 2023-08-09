@isTest
public class TopXDesignationTriggerHandlerTest {
	
    @testSetup
    static void testSetupData() {
        List<Opportunity> opp = new  List<Opportunity>();
        for(Integer i=1; i<=200; i++) {
            Opportunity o = new Opportunity();
            o.Name = 'Test'+i;
            o.CloseDate = System.today();
            o.StageName = 'Prospecting';
            o.Handoff_Attached__c='';
            opp.add(o);
        }
            
        System.assertEquals(200, opp.size());
        insert opp;
    }
    
    @isTest
    static void main() {
        Test.StartTest();
        List<Opportunity> oppList = [Select Id, Handoff_Attached__c From Opportunity];	
		Id oppId1 = oppList.get(0).Id;
        Id oppId2 = oppList.get(1).Id;
	        
        Top_X_Designation__c designation = new Top_X_Designation__c(Name='Demo', Type__c = 'Contract Flow Down/Handoff', Opportunity__c = oppId1,  Document_Attached__c = True);
        insert designation;
        Top_X_Designation__c designation2 = new Top_X_Designation__c(Name='Demo', Type__c = 'Software Engineer', Opportunity__c = oppId2,  Document_Attached__c = True);
        insert designation2;
        
        
        System.assertEquals('Yes', [Select Id, Handoff_Attached__c From Opportunity Where Id = :oppId1].get(0).Handoff_Attached__c);
        System.assertEquals('No', [Select Id, Handoff_Attached__c From Opportunity Where Id = :oppId2].get(0).Handoff_Attached__c);
        Test.stopTest();
    }
}