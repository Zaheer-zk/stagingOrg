@isTest(SeeAllData=false)
public with sharing class UserPermissionsetTriggerHandlerTest {

    @testSetup
    static void setupTestData() {

        User testUserByZK = new User(
            UserName = 'testuserzk123@test.com',
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuserzk123@test.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUserByZK;

        system.runAs(testUserByZK){

            User_detail__c userDetail = new User_detail__c(
                User__c = testUserByZK.Id
            );
            insert userDetail;

            PermissionSet ps1 = new PermissionSet(
                Name = 'TestPermissionSet1',
                Label = 'Test Permission Set 1'
            );
            insert ps1;

            PermissionSet ps2 = new PermissionSet(
                Name = 'TestPermissionSet2',
                Label = 'Test Permission Set 2'
            );
            insert ps2;

            User_Permission_Setup__c ups = new User_Permission_Setup__c(
                Name = 'TestPermissionSet1',
                User_Detail__c = userDetail.Id
            );
            insert ups;
        }
    }

    @isTest
    static void testAddPermissionsetToTheUser() {
        
        User testUser = [SELECT Id FROM User WHERE UserName = 'testuserzk123@test.com'];
        User_detail__c userDetail = [SELECT Id FROM User_detail__c WHERE User__c = :testUser.Id LIMIT 1];
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet1'];
        User_Permission_Setup__c ups = [SELECT Id, Name, User_Detail__c FROM User_Permission_Setup__c WHERE Name = 'TestPermissionSet1'];

        system.runAs(testUser) {
            Test.startTest();
                UserPermissionsetTriggerHandler.addPermissionsetToTheUser(new List<User_Permission_Setup__c> {ups});
            Test.stopTest();
        }

        // Test.startTest();
        //     UserPermissionsetTriggerHandler.addPermissionsetToTheUser(new List<User_Permission_Setup__c> {ups});
        // Test.stopTest();

        List<PermissionSetAssignment> assignments = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :testUser.Id];
        System.assertEquals(1, assignments.size(), 'The permission set was not correctly assigned to the user');
    }

    @isTest 
    static void testAddUpdatedPermissionsetToTheUser() {
        
        User testUser = [SELECT Id FROM User WHERE UserName = 'testuserzk123@test.com'];
        User_detail__c userDetail = [SELECT Id FROM User_detail__c WHERE User__c = :testUser.Id LIMIT 1];
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet1'];
        PermissionSet ps2 = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet2'];

        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.PermissionSetId = ps1.Id;
        psa.AssigneeId = testUser.Id;
        insert psa;

        User_Permission_Setup__c ups = new User_Permission_Setup__c(
            Name = 'TestPermissionSet2',
            User_Detail__c = userDetail.Id
        );
        insert ups;

        Test.startTest();
            UserPermissionsetTriggerHandler.addUpdatedPermissionsetToTheUser(
                new List<User_Permission_Setup__c> {ups},
                new Map<Id, User_Permission_Setup__c> {ups.Id => new User_Permission_Setup__c(Name = 'TestPermissionSet1', User_Detail__c = userDetail.Id)}
            );
        Test.stopTest();

        List<PermissionSetAssignment> assignments = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :testUser.Id];
        System.assertEquals(1, assignments.size(), 'The permission set was not correctly updated for the user');
    }

    @isTest 
    static void testRemovePermissionSetOnDelete() {
        
        User testUser = [SELECT Id FROM User WHERE UserName = 'testuserzk123@test.com'];
        User_detail__c userDetail = [SELECT Id FROM User_detail__c WHERE User__c = :testUser.Id LIMIT 1];
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet1'];

        User_Permission_Setup__c ups = new User_Permission_Setup__c(
            Name = 'TestPermissionSet1',
            User_Detail__c = userDetail.Id
        );
        insert ups;

        Test.startTest();
            UserPermissionsetTriggerHandler.addPermissionsetToTheUser(new List<User_Permission_Setup__c> {ups});
        Test.stopTest();

        List<PermissionSetAssignment> initialAssignments = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :testUser.Id];
        System.assertEquals(1, initialAssignments.size(), 'The permission set was not initially assigned to the user');

        Test.startTest();
            UserPermissionsetTriggerHandler.addUpdatedPermissionsetToTheUser(
                new List<User_Permission_Setup__c>(), 
                new Map<Id, User_Permission_Setup__c> {ups.Id => ups}
            );
        Test.stopTest();

        List<PermissionSetAssignment> postDeletionAssignments = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :testUser.Id];
        System.assertEquals(0, postDeletionAssignments.size(), 'The permission set was not removed from the user post deletion');
    }
}