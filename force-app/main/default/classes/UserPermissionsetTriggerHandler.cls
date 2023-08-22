/**
 * Purpose          : To handle permission set assignment to the User on User_Details object as per the 
 * Created By       : ZAHEER KHAN
 * Created Date     : 10-08-2023
 * Revision Logs    : V_2.0 
 * Created By       : ZAHEER KHAN 
 */
public with sharing class UserPermissionsetTriggerHandler {

    public static void addPermissionsetToTheUser(List<User_Permission_Setup__c> newListOfUserPermissionset, Map<Id, User_Permission_Setup__c> oldMapOfUserPermissionset) {

        Set<String> setOfNewPermissionNames = new Set<String>();
        List<PermissionSetAssignment> listOfPermissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> listOfPermissionSetAssignmentsToDelete = new List<PermissionSetAssignment>();
        Map<String, Id> mapOfNameToPermissionSetId = new Map<String, Id>();
        List<Id> listOfUserDetailIds = new List<Id>();
        List<PermissionSet> existingPermissionSets = new List<PermissionSet>();
        Set<String> setOfOldPermissionNames = new Set<String>();
        Set<Id> setOfOldUserDetailIds = new Set<Id>();
        Set<Id> setOfUserIds = new Set<Id>();
        List<User_detail__c> listOfUserDetails = new List<User_detail__c>();
        
        if(newListOfUserPermissionset != null) {
            for(User_Permission_Setup__c ups : newListOfUserPermissionset) {
                if(ups.User_Detail__c != null && ups.Name != null){
                    setOfNewPermissionNames.add(ups.Name);
                    listOfUserDetailIds.add(ups.User_Detail__c);
                }
            }

            if(!listOfUserDetailIds.isEmpty() && !setOfNewPermissionNames.isEmpty()) {
                
                Map<Id, User_detail__c> mapOfUserDetails = new Map<Id, User_Detail__c>(
                    [SELECT Id, User__c 
                        FROM User_detail__c 
                        WHERE Id IN :listOfUserDetailIds]
                );

                existingPermissionSets = [SELECT Id, Name 
                                            FROM PermissionSet 
                                            WHERE Name IN :setOfNewPermissionNames];

                System.debug('existingPermissionSets: ' + existingPermissionSets);

                if(!existingPermissionSets.isEmpty()){
                    for(PermissionSet ps : existingPermissionSets){
                        mapOfNameToPermissionSetId.put(ps.Name, ps.Id);
                    }
                }
                
                if(mapOfUserDetails != null && mapOfNameToPermissionSetId != null){
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
        }

        if(oldMapOfUserPermissionset != null) {

            for(User_Permission_Setup__c oldUserPermissionSetup : oldMapOfUserPermissionset.values()) {
                setOfOldUserDetailIds.add(oldUserPermissionSetup.User_Detail__c);
                setOfOldPermissionNames.add(oldUserPermissionSetup.Name);
            }

            if(!setOfOldPermissionNames.isEmpty() && !setOfOldUserDetailIds.isEmpty()) {
                Map<Id, PermissionSet> mapOfIdWithExistingPermissionSet = new Map<Id, PermissionSet>(
                    [SELECT Id, Name 
                     FROM PermissionSet 
                     WHERE Name IN :setOfOldPermissionNames]
                );

                listOfUserDetails = [SELECT Id, User__c 
                                     FROM User_detail__c 
                                     WHERE Id IN :setOfOldUserDetailIds];
                
                if(!listOfUserDetails.isEmpty()) {
                    for(User_detail__c userDetail : listOfUserDetails) {
                        setOfUserIds.add(userDetail.User__c);
                    }
                }
            
                if(!setOfUserIds.isEmpty() && !mapOfIdWithExistingPermissionSet.isEmpty()) {
                    listOfPermissionSetAssignmentsToDelete = [SELECT Id 
                                                            FROM PermissionSetAssignment 
                                                            WHERE AssigneeId IN :setOfUserIds 
                                                            AND PermissionSetId IN :mapOfIdWithExistingPermissionSet.keySet()];
                }
            }
        }
        
        System.debug('listOfPermissionSetAssignmentsToInsert: ' + listOfPermissionSetAssignmentsToInsert);
        System.debug('listOfPermissionSetAssignmentsToDelete: ' + listOfPermissionSetAssignmentsToDelete);

        if(!listOfPermissionSetAssignmentsToInsert.isEmpty()){
            string jsonString = JSON.serializePretty(listOfPermissionSetAssignmentsToInsert);
            insertPermissionSetAssignmentsAsync(jsonString);
        }

        if(!listOfPermissionSetAssignmentsToDelete.isEmpty()){
            string jsonString = JSON.serializePretty(listOfPermissionSetAssignmentsToDelete);
            deletePermissionSetAssignmentsAsync(jsonString);
        }
    }

    @future
    public static void insertPermissionSetAssignmentsAsync(string listOfPermissionSetAssignments) {

        list<PermissionSetAssignment> listOfPermissionSetAssignmentsToInsert =  (list<PermissionSetAssignment>)JSON.deserializeStrict(listOfPermissionSetAssignments, list<PermissionSetAssignment>.class);

        if(!listOfPermissionSetAssignmentsToInsert.isEmpty()) {
            System.debug('listOfPermissionSetAssignmentsToInsert: ' + listOfPermissionSetAssignmentsToInsert);
            insert listOfPermissionSetAssignmentsToInsert;
        }
    }

    @future
    public static void deletePermissionSetAssignmentsAsync(string listOfPermissionSetAssignments) {

        list<PermissionSetAssignment> listOfPermissionSetAssignmentsToDelete =  (list<PermissionSetAssignment>)JSON.deserializeStrict(listOfPermissionSetAssignments, list<PermissionSetAssignment>.class);

        if(!listOfPermissionSetAssignmentsToDelete.isEmpty()) {
            System.debug('listOfPermissionSetAssignmentsToDelete: ' + listOfPermissionSetAssignmentsToDelete);
            delete listOfPermissionSetAssignmentsToDelete;
        }
    }
}