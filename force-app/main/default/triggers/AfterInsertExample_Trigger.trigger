trigger AfterInsertExample_Trigger on Account (after insert) {
    // List<String> toAddresses = new List<String>(); 
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    for(Account a : Trigger.New) {
        String accountName = a.Name;
        String accountNo = a.AccountNumber;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{a.Email__c});
        mail.setSubject('Congratulations for creating account');
        mail.setPlainTextBody('Congratulations for creating account your account details are Account Number = ' + accountNo + ', Account Name = ' + accountName);    
        String emailAddress = a.Email__c;
        // toAddresses.add(a.Email__c);
        // EmailManager.sendMail(emailAddress, 'Congratulations for creating account', 'Congratulations for creating account your account details are Account Number = ' + accountNo + ', Account Name = ' + accountName);
        System.debug('Email Send Successfully at: ' + emailAddress);
        messages.add(mail);
    }
    // Messaging.sendEmail(messages);
    Messaging.SendEmailResult[] results = Messaging.sendEmail(  messages );

    System.debug('Result' + results);
    

    // for all account holder
    /*
        List<Account> acc = [Select Id, Name, Email__c From Account];
        for(Account a: acc) {
            String accountName = a.Name;
            String accountNo = a.AccountNumber;
            String emailAddress = a.Email__c;
            EmailManager.sendMail(emailAddress, 'Congratulations for creating acconut', 'Congratulations for creating account your account details are Account Number = ' + accountNo + ', Account Name = ' + accountName);
        }
    */
}

/*
After Insert Example: Sending a email to to account holder on Account holder mail with Congratulation message
 */