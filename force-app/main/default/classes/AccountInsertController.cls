/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 03-15-2023
 * @last modified by  : Zaheer Khan
**/
public with sharing class AccountInsertController {

    //Account Wrapper
    public class AccountWrapper {
        @AuraEnabled
        public Account acc {get; set;}
        @AuraEnabled
        public ContactWrapper conWrappers {get; set;}
        
        public AccountWrapper() {
            acc = new Account();
            conWrappers = new ContactWrapper();
            conWrappers.con = new Contact();
        }
    }

    //Contact Wrapper
    public class ContactWrapper {
        @AuraEnabled
        public Contact con {get; set;}
        @AuraEnabled
        public OpportunityWrapper oppWrappers {get; set;}

        public ContactWrapper() {
            con = new Contact();
            oppWrappers = new OpportunityWrapper();
            oppWrappers.opp = new Opportunity();
        }
    }

    //Opportunity Wrapper
    public class OpportunityWrapper {
        @AuraEnabled
        public Opportunity opp {get; set;}
        @AuraEnabled
        public CaseWrapper caseWrapper {get; set;}

        public OpportunityWrapper() {
            opp = new Opportunity();
            caseWrapper = new CaseWrapper();
            caseWrapper.cas = new Case();
        }
    }

    //Case Wrapper
    public class CaseWrapper {
        @AuraEnabled
        public Case cas {get; set;}

        public CaseWrapper() {
            cas = new Case();
        }
    }

    //Method Wrapper inside wrapper upto 4 level
    @AuraEnabled
    public static void saveData(AccountWrapper accWrapper) {
        System.debug('accWrapper: ' + accWrapper);
        try {

            if(accWrapper != null) {
                Account account = new Account();
                account.Name = accWrapper.acc.Name;
                account.Industry = accWrapper.acc.Industry;
                insert account;
                
                Contact contact = new Contact();
                contact.LastName = accWrapper.conWrappers.con.LastName;
                insert contact;

                Opportunity opp = new Opportunity();
                opp.Name = accWrapper.conWrappers.oppWrappers.opp.Name;
                opp.StageName = accWrapper.conWrappers.oppWrappers.opp.StageName;
                opp.CloseDate = System.today();
                insert opp;

                Case cas = new Case();
                cas.Subject = accWrapper.conWrappers.oppWrappers.caseWrapper.cas.Subject;
                cas.Origin = accWrapper.conWrappers.oppWrappers.caseWrapper.cas.Origin;
                insert cas;
            }
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    // -------------------------------------------------------------------------------

    @AuraEnabled
    public static void insertAccount(AccountInsertWrapper accountWrapper) {
        System.debug('accountWrapper: ' + accountWrapper);
        Account accountRecord = new Account();
        accountRecord.Name = accountWrapper.Name;
        // accountRecord.Industry = accountWrapper.industry;
        accountRecord.Phone = accountWrapper.phone;
        accountRecord.Website = accountWrapper.website;
        
        try {
            System.debug('accountRecord: ' + accountRecord);
            insert accountRecord;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void insertData(String dataWrapperString) {
        System.debug('dataWrapperString: ' + dataWrapperString);
        DataWrapper dataWrapper = (DataWrapper) JSON.deserialize(dataWrapperString, DataWrapper.class);

        try {
            // Insert the account record
            Account accountRecord = (Account) dataWrapper.accountRecord;
            System.debug('accountRecord: ' + accountRecord);
            insert accountRecord;

            // Insert the contact record
            Contact contactRecord = (Contact) dataWrapper.contactRecord;
            // contactRecord.AccountId = accountRecord.Id;
            System.debug('contactRecord: ' + contactRecord);
            insert contactRecord;

            // Insert the opportunity record
            Opportunity opportunityRecord = (Opportunity) dataWrapper.opportunityRecord;
            // opportunityRecord.AccountId = accountRecord.Id;
            System.debug('opportunityRecord: ' + opportunityRecord);
            insert opportunityRecord;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    // @AuraEnabled(cacheable=true)
    // public static List<Schema.PicklistEntry> getPicklistValues(String objectApiName, String fieldApiName) {
    //     List<Schema.PicklistEntry> picklistValues = new List<Schema.PicklistEntry>();
    //     Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe();

    //     if (fieldResult.isPicklist()) {
    //         for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
    //             picklistValues.add(entry);
    //         }
    //     }

    //     return picklistValues;
    // }

    public class DataWrapper {
        @AuraEnabled
        public SObject accountRecord { get; set; }
        @AuraEnabled
        public SObject contactRecord { get; set; }
        @AuraEnabled
        public SObject opportunityRecord { get; set; }
    }
}