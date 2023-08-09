public class Demo {
	
    public static void main() {
        
        Map<Id, List<Contact>> allAccConts = new Map<Id, List<Contact>>();
        List<Account> acc = [Select Id From Account];
        List<Contact> con = [Select Id, Name, AccountId From Contact Where AccountId In :acc];
        
        List <Contact> accConList = new List<Contact>();
        
        For(Account a : acc) {
            
            for(Contact c : con) {
                
                if(a.id == c.AccountId) {
                    
                    accConList.add(c);
                }
            }
            allAccConts.put(a.Id, accConList);
        }  
        System.debug('Map === ' + allAccConts);
    }
}