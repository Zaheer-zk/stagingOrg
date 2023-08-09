public class TransactionEntryController {
    
    // get set to make these as apex properties and make use of these in vf pages
    public List<SelectOption> options{get;set;}
    public String option {get; set;}
    public String name {get;set;}
    public Double amount_In_Between {get;set;}
    public Date date_In_Between {get;set;}
    public String status {get;set;}
    public String contact_Name {get;set;}
    public Transaction_Entry__c transaction_Entry{get; set;}
    public Date startDate{get;set;}
    public Date endDate{get;set;}
    public Double minAmount{get;set;}
    public Double maxAmount{get;set;}
    
    public List<String> findHow = new List<String>{'Name', 'Amount In Between', 'Date In Between', 'Status', 'Contact Name'};
        
        public List<SelectOption> getstatuslst(){
            List<SelectOption> listStatus = new List<SelectOption>();
            List<Schema.PicklistEntry> getStatusList = Transaction_Entry__c.Status__c.getDescribe().getPickListValues();
            listStatus.add(new SelectOption('', '--Select Status--'));
            for(Schema.PicklistEntry Statusvalue : getStatusList){
                listStatus.add(new SelectOption(Statusvalue.getValue(), Statusvalue.getLabel()));
            }
            return listStatus;
        }
    
    
    public String chooseStatus{get; set;}
    public void selectStatus(){
        System.debug('chooseStatus ' +chooseStatus);
        status = chooseStatus;
    }
    public List<SelectOption> getItems() {
        options = new List<SelectOption>();
        System.debug('getItems' );
        options.add(new SelectOption('', '--Select an Options--'));
        /*
        for(String option : findHow){
            options.add(new SelectOption('id', option));
        }*/
        SYstem.debug(options);
        
        options.add(new SelectOption('name', 'Name'));
        options.add(new SelectOption('amount_In_Between', 'Amount In Between'));
        options.add(new SelectOption('date_In_Between', 'Date In Between'));
        options.add(new SelectOption('status', 'Status'));
        options.add(new SelectOption('contact_Name', 'Contact Name'));
        
        return options;
    }
    
    public String selectedFields{get;set;}
    public String fieldValue {get; set;}
    public void passValueToController(){
        SYstem.debug('passValueToController');
        SYstem.debug('selectedFields'+ selectedFields);
        if(selectedFields == 'name'){
            fieldValue = selectedFields;
        }
        else if(selectedFields == 'amount_In_Between'){
            fieldValue = selectedFields;
        }
        else if(selectedFields == 'date_In_Between'){
            fieldValue = selectedFields;
        }
        else if(selectedFields == 'status'){
            fieldValue = selectedFields;
        }
        else if(selectedFields == 'contact_Name'){
            fieldValue = selectedFields;
        } 
        else if(selectedFields == '--Select an Options--'){
            fieldValue = selectedFields;
        } 
    }
    
    public list<Transaction_Entry__c> entries { get; set; }
    public boolean searched{get;set;}
    
    public PageReference executeSearch() {
      searched=true;
         System.debug('name' +name);
         System.debug('amount_In_Between' +amount_In_Between);
         System.debug('date_In_Between' +date_In_Between);
         System.debug('status' +status);
         System.debug('contact_Name' +contact_Name);
         System.debug('startDate' +startDate);
         System.debug('endDate' +endDate);
        System.debug('startDate' +minAmount);
        System.debug('endDate' +maxAmount);
        if(name != null){
            entries = [SELECT id, Name, Amount__c, Transaction_Date__c, Status__c, Contact__r.Name FROM Transaction_Entry__c WHERE Name LIKE : name];
        } else if(minAmount != null && maxAmount != null){
            entries = [SELECT id, Name, Amount__c, Transaction_Date__c, Status__c, Contact__r.Name FROM Transaction_Entry__c WHERE Amount__c >=: minAmount AND Amount__c <=: maxAmount];
        } else if(startDate != null && endDate != null){
            entries = [SELECT id, Name, Amount__c, Transaction_Date__c, Status__c, Contact__r.Name FROM Transaction_Entry__c WHERE Transaction_Date__c >= : startDate 
                       AND Transaction_Date__c <= : endDate];
        } else if(status != null){
            entries = [SELECT id, Name, Amount__c, Transaction_Date__c, Status__c, Contact__r.Name FROM Transaction_Entry__c WHERE Status__c LIKE : status];
        } else if(contact_Name != null){
            entries = [SELECT id, Name, Amount__c, Transaction_Date__c, Status__c, Contact__r.Name FROM Transaction_Entry__c WHERE Contact__r.Name LIKE : contact_Name];
        }else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Please find the way, How do you want to Search the Transactions!'));
        }
        /*
        entries = [select id, Name, Amount_c, Transaction_Datec, Statusc, Contactr.Name from Transaction_Entry_c 
                   where Name Like:name OR (Amount_c >=: minAmount AND Amountc <=: maxAmount ) OR (Transaction_Date_c >= : startDate 
                   AND Transaction_Date_c <= : endDate) OR Statusc LIKE : status OR Contact_r.Name LIKE : contact_Name];
        */
        System.debug(entries);
        if(!entries.isEmpty()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.INFO, 'Transaction Record Found Successfully'));
        }else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'No Transaction Record Found, Unsufficient Info or No Transaction Happend!'));
        }
        return null;
}
}