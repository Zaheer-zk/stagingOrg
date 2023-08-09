global class TransactionMonthlyEmail  implements Database.Batchable<sObject>, Schedulable{

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Email, Status__c, Contact.Owner.Name FROM Contact WHERE Email != null AND Status__c = 'Active']);
    }
    global void execute(Database.batchableContext bc, List<Contact> contactList) {

        //GenerateMonthlyEmail.sendEmail(contactList);

        List<Messaging.Email> emailList = new List<Messaging.Email>();
        List<Transaction_Entry__c> fetchLast30DaysEntries = [SELECT Name, Amount__c, Transaction_Date__c, Type__c FROM Transaction_Entry__c WHERE CreatedDate = LAST_N_DAYS:30 AND Contact__c In : contactList];

        System.debug(fetchLast30DaysEntries);

        for(Contact contact : contactList) {
            //Insitialization to mailing method
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage(); 
            String[] toAddress = new String[]{contact.Email};
                emailMsg.setToAddresses(toAddress);
            String emailSub ='E-Account Monthly Statement'; //Email Subject
            emailMsg.setSubject(emailSub);
            String disName = contact.Owner.Name; //Display Name
            emailMsg.setSenderDisplayName(disName);
            //Content or Body of the Email
            String content ='';
            content ='Dear '+ disName +',<br/>';
            content +='Your Monthly Transactions!'+'<br/><br/>';            
            //if(!sensorSetName.isEmpty()){
            //content +='<font size = "4">'+'Successful:'+'</font><br/><br/>';
            content +='<table border="1" cellpadding = "10" cellspacing = "10" style="border-collapse:collapse">'+''+
                '<tr height = "35" align="center"><th>'+'Transaction Name'+'</th><th>'+'Type'+
                '</th><th>'+'Amount'+'</th><th>'+'Transaction Date'+'</th></tr>';
            
            for(Transaction_Entry__c entry : fetchLast30DaysEntries) {
                content +='<tr height = "45" align="center"><td>'+ entry.Name+'</td><td>'+entry.Type__c+
                    '</td><td>'+entry.Amount__c+'</td><td>'+entry.Transaction_Date__c+'</td></tr>';
            }
            content+='</table><br/><br/>';
            emailMsg.setHtmlBody(content);
            emailList.add(emailMsg);  
            System.debug(content);
        }

        //Send the email what we have created
        if(emailList.size() > 0){
            Messaging.sendEmail(emailList);
        }
    }

    global void finish(Database.BatchableContext bc){
        system.debug('Job Id' + bc);
    }

    global void execute(SchedulableContext sc) {

        TransactionMonthlyEmail batchClass = new TransactionMonthlyEmail(); //ur batch class
        database.executebatch(batchClass);
    }
}