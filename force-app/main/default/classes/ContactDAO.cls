public class ContactDAO implements IContact  {
    public List<Contact> conList = new List<Contact>();
    public interface IContact {
        List<Contact> generateContacts();
    }
    
     public List<Contact> generateContacts()
    {
        return [SELECT ID, FirstName, LastName FROM Contact LIMIT 100];
    }
    
}