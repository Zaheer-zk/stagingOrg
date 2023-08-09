/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 03-15-2023
 * @last modified by  : Zaheer Khan
**/
public with sharing class WebServiceController {
    public class AccountWrapper {
        @AuraEnabled
        public Account acc {get; set;}
        
        public AccountWrapper() {
            acc = new Account();
        }
    }
    
    @AuraEnabled
    public static void submitData(AccountWrapper accountWrapper) {
        
        System.debug('accountWrapper: ' + accountWrapper);
        Account accountData = accountWrapper.acc;

        // Set the access token for the Salesforce REST API
        String access_token = '0pFlPcDZhVPkIN3F5ByyluLmA';

        // Convert the Account data Map to a JSON string
        System.debug('Body: ' + JSON.serialize(accountData));
        String accountDataJson = JSON.serialize(accountData);
        
        // Set the endpoint URL for the Account object
        String endpointUrl = 'https://fexleservicespvtltd-6a-dev-ed.lightning.force.com/services/data/v57.0/sobjects/Account';

        // Create a new HTTP request with the endpoint URL and authorization header
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointUrl);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + access_token);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(accountDataJson);

        // Send the HTTP request and get the response
        Http http = new Http();
        HttpResponse res = http.send(req);

        // Check the response to see if the Account record was inserted successfully
        if (res.getStatusCode() == 302) {
            String redirectUrl = res.getHeader('Location');
            System.debug('Redirect URL: ' + redirectUrl);
        } else if (res.getStatusCode() == 201) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accountId = (String) responseMap.get('id');
            System.debug('Account record created with ID: ' + accountId);
        } else {
            System.debug('Error creating Account record: ' + res.getStatus() +  ' ' + res.getStatusCode());
        }
    }
}