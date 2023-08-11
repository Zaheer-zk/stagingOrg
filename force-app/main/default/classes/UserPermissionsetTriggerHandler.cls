public with sharing class UserPermissionsetTriggerHandler {

    public static void addPermissionsetToTheUser(List<User_Permission_Setup__c> newListOfUserPermissionset, Map<Id, User_Permission_Setup__c> oldMapOfUserPermissionset) {

        Set<String> setOfPermissionNames = new Set<String>();
        Set<String> setOfNewPermissionNames = new Set<String>();
        List<PermissionSetAssignment> listOfPermissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> listOfexistingPermissionSetAssignmentsToDelete = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> listOfPermissionSetAssignmentsToDelete = new List<PermissionSetAssignment>();
        Map<String, Id> mapOfNameToPermissionSetId = new Map<String, Id>();
        Map<String, Id> mapOfNameToPermissionSetIdToInsert = new Map<String, Id>();
        List<Id> listOfUserDetailIds = new List<Id>();
        List<Id> listOfUserIds = new List<Id>();
        List<Id> listOfPermissionsetIdsRemoveFromUser = new List<Id>();
        List<PermissionSet> existingPermissionSets = new List<PermissionSet>();
        
        if(newListOfUserPermissionset != null && oldMapOfUserPermissionset == null) {
            for(User_Permission_Setup__c ups : newListOfUserPermissionset) {
                if(ups.User_Detail__c != null && ups.Name != null){
                    setOfNewPermissionNames.add(ups.Name);
                    listOfUserDetailIds.add(ups.User_Detail__c);
                }
            }
        }

        if(newListOfUserPermissionset != null && oldMapOfUserPermissionset != null) {
            for(User_Permission_Setup__c newUserPermission : newListOfUserPermissionset) {
                if (oldMapOfUserPermissionset.get(newUserPermission.Id).Name != newUserPermission.Name) {
                    setOfPermissionNames.add(oldMapOfUserPermissionset.get(newUserPermission.Id).Name);
                    setOfNewPermissionNames.add(newUserPermission.Name);
                    listOfUserDetailIds.add(oldMapOfUserPermissionset.get(newUserPermission.Id).User_Detail__c);
                }
            }
        }

        System.debug('setOfPermissionNames: ' + setOfPermissionNames);
        System.debug('setOfNewPermissionNames: ' + setOfNewPermissionNames);
        System.debug('listOfUserDetailIds: ' + listOfUserDetailIds);

        if(!listOfUserDetailIds.isEmpty() && !setOfPermissionNames.isEmpty() 
            || !setOfNewPermissionNames.isEmpty()
            && ((newListOfUserPermissionset != null && oldMapOfUserPermissionset != null) 
            || (newListOfUserPermissionset != null && oldMapOfUserPermissionset == null))) {
            
            Map<Id, User_detail__c> mapOfUserDetails = new Map<Id, User_Detail__c>(
                [SELECT Id, User__c 
                    FROM User_detail__c 
                    WHERE Id IN :listOfUserDetailIds]
            );

            if(!mapOfUserDetails.isEmpty()){
                for(User_detail__c userDetail : mapOfUserDetails.values()) {
                    listOfUserIds.add(userDetail.User__c);
                }
            }

            System.debug('listOfUserIds: ' + listOfUserIds);

            existingPermissionSets = [SELECT Id, Name 
                                        FROM PermissionSet 
                                        WHERE Name IN :setOfPermissionNames OR Name IN :setOfNewPermissionNames];

            System.debug('existingPermissionSets: ' + existingPermissionSets);

            if(!existingPermissionSets.isEmpty()) {
                for(User_Permission_Setup__c newUserPermissionset : newListOfUserPermissionset) {
                    for(PermissionSet ps : existingPermissionSets) {
                        if(ps.Name == newUserPermissionset.Name){
                            mapOfNameToPermissionSetId.put(ps.Name, ps.Id);
                        }
                    }
                }

                if(oldMapOfUserPermissionset != null) {
                    for(User_Permission_Setup__c oldUserPermissionset : oldMapOfUserPermissionset.values()) {
                        for(PermissionSet ps : existingPermissionSets) {
                            if(ps.Name == oldUserPermissionset.Name)
                            listOfPermissionsetIdsRemoveFromUser.add(ps.Id);
                        }
                    }
                }
            }

            System.debug('mapOfNameToPermissionSetId: ' + mapOfNameToPermissionSetId.keySet());
            System.debug('listOfPermissionsetIdsRemoveFromUser: ' + listOfPermissionsetIdsRemoveFromUser);

            if(!listOfUserIds.isEmpty() && !listOfPermissionsetIdsRemoveFromUser.isEmpty() && oldMapOfUserPermissionset != null) {
                System.debug('1st');
                listOfexistingPermissionSetAssignmentsToDelete = [SELECT Id, PermissionSetId, AssigneeId 
                                                                  FROM PermissionSetAssignment 
                                                                  WHERE AssigneeId IN :listOfUserIds 
                                                                  AND (PermissionSetId IN :listOfPermissionsetIdsRemoveFromUser
                                                                  OR PermissionSetId IN :mapOfNameToPermissionSetId.values())];
            }

            System.debug('listOfexistingPermissionSetAssignmentsToDelete: ' + listOfexistingPermissionSetAssignmentsToDelete);

            if(!listOfexistingPermissionSetAssignmentsToDelete.isEmpty()){
                for(PermissionSetAssignment assignment : listOfexistingPermissionSetAssignmentsToDelete){
                    //Check new permission set already exists
                    // if(newListOfUserPermissionset != null && oldMapOfUserPermissionset == null){
                    System.debug('2nd');
                    for(User_Permission_Setup__c newUserPermissionset : newListOfUserPermissionset) {
                        if(mapOfNameToPermissionSetId.containsKey(newUserPermissionset.Name)){
                            Id newPermissionsetId = mapOfNameToPermissionSetId.get(newUserPermissionset.Name);
                            if(assignment.PermissionSetId != newPermissionsetId){
                                mapOfNameToPermissionSetIdToInsert.put(newUserPermissionset.Name, newPermissionsetId);
                            }
                        }
                    }

                    if(listOfPermissionsetIdsRemoveFromUser.contains(assignment.PermissionSetId)){
                        listOfPermissionSetAssignmentsToDelete.add(assignment);
                    }
                }
            }

            System.debug('mapOfNameToPermissionSetIdToInsert: ' + mapOfNameToPermissionSetIdToInsert.values());
            
            if(!listOfUserIds.isEmpty()){
                System.debug('Inside');
                for(User_Permission_Setup__c ups : newListOfUserPermissionset) {
                    if(mapOfNameToPermissionSetIdToInsert.containsKey(ups.Name) && mapOfUserDetails.containsKey(ups.User_Detail__c)) {
                        PermissionSetAssignment psa = new PermissionSetAssignment();
                        psa.PermissionSetId = mapOfNameToPermissionSetIdToInsert.get(ups.Name);
                        psa.AssigneeId = mapOfUserDetails.get(ups.User_Detail__c).User__c;
                        System.debug('psa: ' + psa);
                        listOfPermissionSetAssignmentsToInsert.add(psa);
                    }
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

    public static void addUpdatedPermissionsetToTheUser(List<User_Permission_Setup__c> newListOfUserPermissionset, Map<Id, User_Permission_Setup__c> oldMapOfUserPermissionset) {

        Set<String> setOfOldPermissionNames = new Set<String>();
        Set<Id> setOfOldUserDetailIds = new Set<Id>();
        Set<Id> setOfUserIds = new Set<Id>();
        List<User_detail__c> listOfUserDetails = new List<User_detail__c>();
        List<PermissionSetAssignment> existingAssignments = new List<PermissionSetAssignment>();

        // if(newListOfUserPermissionset != null && oldMapOfUserPermissionset != null) {

        //     for(User_Permission_Setup__c newUserPermission : newListOfUserPermissionset) {
        //         if (oldMapOfUserPermissionset.get(newUserPermission.Id).Name != newUserPermission.Name) {
        //             setOfOldUserDetailIds.add(oldMapOfUserPermissionset.get(newUserPermission.Id).User_Detail__c);
        //             setOfOldPermissionNames.add(oldMapOfUserPermissionset.get(newUserPermission.Id).Name);
        //         }
        //     }

            // if(!setOfOldPermissionNames.isEmpty() && !setOfOldUserDetailIds.isEmpty()) {
            //     Map<Id, PermissionSet> mapOfIdWithExistingPermissionSet = new Map<Id, PermissionSet>(
            //         [SELECT Id, Name 
            //          FROM PermissionSet 
            //          WHERE Name IN :setOfOldPermissionNames]
            //     );

            //     listOfUserDetails = [SELECT Id, User__c 
            //                          FROM User_detail__c 
            //                          WHERE Id IN :setOfOldUserDetailIds];
                
            //     if(!listOfUserDetails.isEmpty()) {
            //         for(User_detail__c userDetail : listOfUserDetails) {
            //             setOfUserIds.add(userDetail.User__c);
            //         }
            //     }
            
            //     if(!setOfUserIds.isEmpty() && !mapOfIdWithExistingPermissionSet.isEmpty()) {
            //         existingAssignments = [SELECT Id 
            //                                FROM PermissionSetAssignment 
            //                                WHERE AssigneeId IN :setOfUserIds 
            //                                AND PermissionSetId IN :mapOfIdWithExistingPermissionSet.keySet()];
            //     }
                                    
                // if (!existingAssignments.isEmpty()) {
                //     System.debug('existingAssignments: ' + existingAssignments);
                //     delete existingAssignments;
                //     addPermissionsetTotheUser(newListOfUserPermissionset);
                // }
            // }
        // }

        if(newListOfUserPermissionset == null && oldMapOfUserPermissionset != null) {

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
                    existingAssignments = [SELECT Id 
                                           FROM PermissionSetAssignment 
                                           WHERE AssigneeId IN :setOfUserIds 
                                           AND PermissionSetId IN :mapOfIdWithExistingPermissionSet.keySet()];
                }
                                    
                if (!existingAssignments.isEmpty()) {
                    System.debug('existingAssignments: ' + existingAssignments);
                    delete existingAssignments;
                }
            }
        }
    }
    
    // @future
    // public static void insertPermissionSetAssignmentsAsync(Set<Id> permissionSetIds, Set<Id> assigneeIds) {
    //     List<PermissionSetAssignment> listOfPermissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();
    //     for (Integer i = 0; i < permissionSetIds.size(); i++) {
    //         PermissionSetAssignment psa = new PermissionSetAssignment();
    //         psa.PermissionSetId = permissionSetIds[i];
    //         psa.AssigneeId = assigneeIds[i];
    //         System.debug('Insert psa: ' + psa);
    //         listOfPermissionSetAssignmentsToInsert.add(psa);
    //     }

    //     if(!listOfPermissionSetAssignmentsToInsert.isEmpty()){
    //         System.debug('listOfPermissionSetAssignmentsToInsert: '+ listOfPermissionSetAssignmentsToInsert);
    //         insert listOfPermissionSetAssignmentsToInsert;
    //     }
    // }

    @future
    public static void insertPermissionSetAssignmentsAsync(string listOfPermissionSetAssignments) {

        list<PermissionSetAssignment> listOfPermissionSetAssignmentsToInsert =  (list<PermissionSetAssignment>)JSON.deserializeStrict(listOfPermissionSetAssignments, list<PermissionSetAssignment>.class);

        if(!listOfPermissionSetAssignmentsToInsert.isEmpty()) {
            System.debug('listOfPermissionSetAssignmentsToInsert: ' + listOfPermissionSetAssignmentsToInsert);
            insert listOfPermissionSetAssignmentsToInsert;
        }
    }

    // @future
    // public static void deletePermissionSetAssignmentsAsync(Set<Id> permissionSetIds, Set<Id> assigneeIds) {
    //     List<PermissionSetAssignment> listOfPermissionSetAssignmentsToDelete = new List<PermissionSetAssignment>();
    //     for (Integer i = 0; i < permissionSetIds.size(); i++) {
    //         PermissionSetAssignment psa = new PermissionSetAssignment();
    //         psa.PermissionSetId = permissionSetIds[i];
    //         psa.AssigneeId = assigneeIds[i];
    //         System.debug('Delete psa: ' + psa);
    //         listOfPermissionSetAssignmentsToDelete.add(psa);
    //     }

    //     System.debug('listOfPermissionSetAssignmentsToDelete: '+ listOfPermissionSetAssignmentsToDelete);
    //     if(!listOfPermissionSetAssignmentsToDelete.isEmpty()){
    //         delete listOfPermissionSetAssignmentsToDelete;
    //     }
    // }

    @future
    public static void deletePermissionSetAssignmentsAsync(string listOfPermissionSetAssignments) {

        list<PermissionSetAssignment> listOfPermissionSetAssignmentsToDelete =  (list<PermissionSetAssignment>)JSON.deserializeStrict(listOfPermissionSetAssignments, list<PermissionSetAssignment>.class);

        if(!listOfPermissionSetAssignmentsToDelete.isEmpty()) {
            System.debug('listOfPermissionSetAssignmentsToDelete: ' + listOfPermissionSetAssignmentsToDelete);
            delete listOfPermissionSetAssignmentsToDelete;
        }
    }
}