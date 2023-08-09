/**
 * @description       : Apex controller for creating contact records using a wrapper class
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 03-01-2023
 * @last modified by  : Zaheer Khan
**/
public with sharing class ContactController {

    @AuraEnabled
    public static void createContacts(ContactWrapper conWrapper) {
        try {
            // Extract the contact from the wrapper class
            Contact con = conWrapper.con;

            // Validate the contact record
            if (con.LastName == null || con.LastName.trim() == '') {
                throw new AuraHandledException('Last Name is required');
            }
            if (con.AccountId == null) {
                throw new AuraHandledException('Account ID is required');
            }

            // Insert the contact record
            insert con;

        } catch (Exception e) {
            // Handle any exceptions that occur
            System.debug('Error creating contact: ' + e.getMessage());
            throw e;
        }
    }
    
    public class ContactWrapper {
        @AuraEnabled
        public Contact con {get; set;}

        
        public ContactWrapper() {
            con = new Contact();
        }
    }
}