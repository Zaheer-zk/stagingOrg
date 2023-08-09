/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 03-14-2023
 * @last modified by  : Zaheer Khan
**/
public with sharing class AccountInsertWrapper {
    @AuraEnabled
    public String Name { get; set; }
    @AuraEnabled
    public String industry { get; set; }
    @AuraEnabled
    public String phone { get; set; }
    @AuraEnabled
    public String website { get; set; }
}