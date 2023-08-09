@isTest
public class TestRestrictContactByName {
    
    static MockDAO.ContactDAOMock contactDAOMockInstance = new MockDAO.ContactDAOMock();
    
    @isTest
    private static void createBadCon() {
        
        List<Contact> contacts = new List<Contact>();
        Contact con = new Contact(FirstName = 'John', LastName = 'INVALIDNAME');
        //contacts = ContactDAO.getContact();
        //contacts.add(con);
        
        contactDAOMockInstance.conList = contacts;
        
        /*
        Test.startTest();
        Database.SaveResult[] srList  = Database.insert(contacts);
        Test.stopTest();
		if(srList.isEmpty)
        */
        //System.assertEquals(srList, [SELECT ID, FirstName, LastName FROM Contact LIMIT 100]);
    }
}