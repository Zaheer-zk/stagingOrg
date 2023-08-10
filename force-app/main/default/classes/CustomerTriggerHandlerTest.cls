@isTest
public with sharing class CustomerTriggerHandlerTest {

    @testSetup 
    static void setupTestData() {

        Program__c program = new Program__c(Name = 'Test Program');
        insert program;

        User testUser = new User(
            Alias = 'tuser',
            Email = 'testuser@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser' + DateTime.now().getTime() + '@test.com'
        );
        insert testUser;

        Customer__c customer = new Customer__c(Name = 'Test Customer', Status__c = CustomerConstants.STATUS_ACTIVE, User__c = testUser.Id, Program__c = program.Id);
        insert customer;
    }

    @isTest
    static void testShareProgramToCustomerUserAfterInsert() {

        User testUser = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
        Program__c program = [SELECT Id FROM Program__c WHERE Name = 'Test Program' LIMIT 1];
        Customer__c customer = [SELECT Id, Status__c, User__c, Program__c FROM Customer__c WHERE Name = 'Test Customer' LIMIT 1];

        Test.startTest();
            CustomerTriggerHandler.shareProgramToCustomerUser(new List<Customer__c>{customer}, null);
        Test.stopTest();

        List<Program__Share> programShares = [SELECT Id FROM Program__Share WHERE ParentId = :program.Id AND UserOrGroupId = :testUser.Id];
        System.assertEquals(1, programShares.size(), 'Expected program to be shared with the user.');
    }

    @isTest
    static void testShareProgramToCustomerUserAfterUpdateStatusInactive() {

        User testUser = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
        Program__c program = [SELECT Id FROM Program__c WHERE Name = 'Test Program' LIMIT 1];
        Customer__c customer = [SELECT Id, Status__c, User__c, Program__c FROM Customer__c WHERE Name = 'Test Customer' LIMIT 1];

        Customer__c oldCustomer = new Customer__c(Name = 'Test Customer', Status__c = CustomerConstants.STATUS_ACTIVE, User__c = testUser.Id, Program__c = program.Id);
        oldCustomer.Id = customer.Id;

        customer.Status__c = CustomerConstants.STATUS_INACTIVE;

        Test.startTest();
            CustomerTriggerHandler.shareProgramToCustomerUser(new List<Customer__c>{customer}, new Map<Id, Customer__c>{customer.Id => oldCustomer});
        Test.stopTest();

        List<Program__Share> programShares = [SELECT Id FROM Program__Share WHERE ParentId = :program.Id AND UserOrGroupId = :testUser.Id];
        System.assertEquals(0, programShares.size(), 'Expected program sharing to be removed.');
    }

    @isTest
    static void testShareProgramToCustomerUserAfterUpdateStatusActive() {

        User testUser = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
        Program__c program = [SELECT Id FROM Program__c WHERE Name = 'Test Program' LIMIT 1];
        Customer__c customer = [SELECT Id, Status__c, User__c, Program__c FROM Customer__c WHERE Name = 'Test Customer' LIMIT 1];

        Customer__c oldCustomer = new Customer__c(Name = 'Test Customer', Status__c = CustomerConstants.STATUS_INACTIVE, User__c = testUser.Id, Program__c = program.Id);
        oldCustomer.Id = customer.Id;

        customer.Status__c = CustomerConstants.STATUS_ACTIVE;
        
        Test.startTest();
            CustomerTriggerHandler.shareProgramToCustomerUser(new List<Customer__c>{customer}, new Map<Id, Customer__c>{customer.Id => oldCustomer});
        Test.stopTest();

        List<Program__Share>  programShares = [SELECT Id FROM Program__Share WHERE ParentId = :program.Id AND UserOrGroupId = :testUser.Id];
        System.assertEquals(1, programShares.size(), 'Expected program to be shared again with the user.');
    }

    @isTest
    static void testShareProgramToCustomerUserAfterUpdateUserNull() {

        User testUser = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
        Program__c program = [SELECT Id FROM Program__c WHERE Name = 'Test Program' LIMIT 1];
        Customer__c customer = [SELECT Id, Status__c, User__c, Program__c FROM Customer__c WHERE Name = 'Test Customer' LIMIT 1];

        Customer__c oldCustomer = new Customer__c(Name = 'Test Customer', Status__c = CustomerConstants.STATUS_INACTIVE, User__c = testUser.Id, Program__c = program.Id);
        oldCustomer.Id = customer.Id;

        customer.User__c = null;
        
        Test.startTest();
            CustomerTriggerHandler.shareProgramToCustomerUser(new List<Customer__c>{customer}, new Map<Id, Customer__c>{customer.Id => oldCustomer});
        Test.stopTest();
        
        List<Program__Share> programShares = [SELECT Id FROM Program__Share WHERE ParentId = :program.Id AND UserOrGroupId = :testUser.Id];
        System.assertEquals(0, programShares.size(), 'Expected program sharing to be removed.');
    }

    @isTest
    static void testShareProgramToCustomerUserAfterDelete() {

        User testUser = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
        Program__c program = [SELECT Id FROM Program__c WHERE Name = 'Test Program' LIMIT 1];
        Customer__c customer = [SELECT Id, Status__c, User__c, Program__c FROM Customer__c WHERE Name = 'Test Customer' LIMIT 1];

        Test.startTest();
            CustomerTriggerHandler.shareProgramToCustomerUser(null, new Map<Id, Customer__c>{customer.Id => customer});
        Test.stopTest();

        List<Program__Share>  programShares = [SELECT Id FROM Program__Share WHERE ParentId = :program.Id AND UserOrGroupId = :testUser.Id];
        System.assertEquals(0, programShares.size(), 'Expected program sharing to be removed on customer deletion.');
    }
}
