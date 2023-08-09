global class AccountAnnual implements Database.Batchable<SObject>, Schedulable {
    
    // Fetching data and sending job for execution
    global Database.QueryLocator start (Database.BatchableContext bc) {
        return Database.getQueryLocator([Select AnnualRevenue From Lead]);          
    }

    // dividing Jobs in chunk
    global void execute (Database.BatchableContext bc, List<Lead> lList) {
        for(Lead l : lList) {
            l.annualRevenue = 200000; // doing operation for every job
        }
        update lList;
    }

    // after a cycle of execution complete
    global void finish (Database.BatchableContext bc) { 

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String [] toAddress = new String [] {'zaheer.khan@fexle.com'};

        mail.setToAddresses(toAddress);
        mail.setSubject('Batch job Completed');
        mail.setPlainTextBody('Successfully Completed the batch job.');

        Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    //For Execution of the Batch Apex
    /**
     * AccountAnnual acc = new AccountAnnual();
     * Database.execteBatch(acc); // execution will take place when resource will be available
     */

     //Schedule the Batch class.
    global void execute (SchedulableContext sc) {
        AccountAnnual acc = new AccountAnnual();
        Database.executeBatch(acc);
        // Database.execteBatch(acc, 200); // here I'm assigning the size also
    }

}