public with sharing class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts( Integer numOfContacts, String lastName) {

        List<Contact> contacts = new List<Contact>();

        // contacts = [Select Id, lastName, From Contact Where lastName =:lastName Limit :numOfContacts];

        for(Integer i =0;i<numOfContacts;i++) {
            Contact contact = new Contact(FirstName = 'John ' + i, LastName = lastName);
            contacts.add(contact);
        }

        return contacts;
    }
}