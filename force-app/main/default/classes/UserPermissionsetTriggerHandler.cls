/**
 * Description      : Create a Automation for manualy sharing costumers program
 * Created By       : ZAHEER KHAN
 * Created Date     : 07-08-2023
 * Revision Logs    : V_1.0 - 
 */
public with sharing class UserPermissionsetTriggerHandler {

    public static void addPermissionsetTotheUser(List<User_Permission_Setup__c> newListOfUserPermissionset, Map<Id, User_Permission_Setup__c> oldMapOfUserPermissionset) {

        Set<String> setOfPermissionNames = new Set<String>();
        List<PermissionSetAssignment> listOfPermissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();
        Map<String, Id> mapOfNameToPermissionSetId = new Map<String, Id>();
        Set<Id> setOfUserDetailIds = new Set<Id>();
        
        if(!newListOfUserPermissionset.isEmpty()) {

            for(User_Permission_Setup__c ups : newListOfUserPermissionset) {
                setOfPermissionNames.add(ups.Name);
                setOfUserDetailIds.add(ups.User_Detail__c);
            }

            if(!setOfUserDetailIds.isEmpty()) {
                
                Map<Id, User_detail__c> mapOfUserDetails = new Map<Id, User_Detail__c>(
                    [SELECT Id, User__c FROM User_detail__c WHERE Id IN :setOfUserDetailIds]
                );

                if(!setOfPermissionNames.isEmpty()) {

                    List<PermissionSet> existingPermissionSets = [SELECT Id, Name 
                                                                FROM PermissionSet 
                                                                WHERE Name IN :setOfPermissionNames];
                    if(!existingPermissionSets.isEmpty()) {
        
                        for(PermissionSet ps : existingPermissionSets) {
                            mapOfNameToPermissionSetId.put(ps.Name, ps.Id);
                        }
                    }
                }
            

                for(User_Permission_Setup__c ups : newListOfUserPermissionset) {
                    if(mapOfNameToPermissionSetId.containsKey(ups.Name) && mapOfUserDetails.containsKey(ups.User_Detail__c)) {
                        PermissionSetAssignment psa = new PermissionSetAssignment();
                        psa.PermissionSetId = mapOfNameToPermissionSetId.get(ups.Name);
                        psa.AssigneeId = mapOfUserDetails.get(ups.User_Detail__c).User__c;
                        listOfPermissionSetAssignmentsToInsert.add(psa);
                    }
                }
            }
        }

        if(!listOfPermissionSetAssignmentsToInsert.isEmpty()) {
            System.debug('listOfPermissionSetAssignmentsToInsert :' + listOfPermissionSetAssignmentsToInsert);
            insert listOfPermissionSetAssignmentsToInsert;
        }
    }
}