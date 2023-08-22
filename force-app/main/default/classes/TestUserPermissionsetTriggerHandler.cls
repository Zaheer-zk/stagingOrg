@isTest
public class TestUserPermissionsetTriggerHandler {
    
    @testSetup
    static void setupTestData() {
        User testUser = new User(
            Alias = 'tuser',
            Email = 'testuser@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Tester',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'testuser' + DateTime.now().getTime() + '@test.com'
        );
        insert testUser;

        PermissionSet pSet = new PermissionSet(
            Name = 'TestPermissionSet',
            Label = 'Test Permission Set'
        );
        insert pSet;

        System.runAs(testUser){
            User_detail__c userDetail = new User_detail__c(
                User__c = testUser.Id
            );
            insert userDetail;
        }

    }

    @isTest
    static void testAddPermissionsetToTheUser() {
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@test.com' LIMIT 1];
        User_detail__c userDetail = [SELECT Id FROM User_detail__c WHERE User__c = :testUser.Id LIMIT 1];
        PermissionSet pSet = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet' LIMIT 1];

        User_Permission_Setup__c ups = new User_Permission_Setup__c(
            Name = 'TestPermissionSet',
            User_Detail__c = userDetail.Id
        );

        List<User_Permission_Setup__c> newList = new List<User_Permission_Setup__c> { ups };
        Map<Id, User_Permission_Setup__c> oldList = new Map<Id, User_Permission_Setup__c>();

        Test.startTest();
            UserPermissionsetTriggerHandler.addPermissionsetToTheUser(newList, oldList);
        Test.stopTest();

        List<PermissionSetAssignment> result = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :testUser.Id AND PermissionSetId = :pSet.Id];
        System.assertEquals(1, result.size(), 'Expected a PermissionSetAssignment to be created');
    }

    @isTest
    static void testRemovePermissionsetFromTheUser() {
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@test.com' LIMIT 1];
        User_detail__c userDetail = [SELECT Id FROM User_detail__c WHERE User__c = :testUser.Id LIMIT 1];
        PermissionSet pSet = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet' LIMIT 1];
        PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = pSet.Id);
        insert psa;

        User_Permission_Setup__c ups = new User_Permission_Setup__c(
            Name = 'TestPermissionSet',
            User_Detail__c = userDetail.Id
        );

        List<User_Permission_Setup__c> newList = new List<User_Permission_Setup__c>();
        Map<Id, User_Permission_Setup__c> oldList = new Map<Id, User_Permission_Setup__c> {
            ups.Id => ups
        };

        Test.startTest();
            UserPermissionsetTriggerHandler.addPermissionsetToTheUser(newList, oldList);
        Test.stopTest();

        List<PermissionSetAssignment> result = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :testUser.Id AND PermissionSetId = :pSet.Id];
        System.assertEquals(0, result.size(), 'Expected the PermissionSetAssignment to be deleted');
    }
}
