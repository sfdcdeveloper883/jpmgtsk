trigger AccountTrigger on Account (after update) {
    if(trigger.isafter && trigger.isUpdate) {
        AccountTriggerHelper.updateAccount(trigger.newMap);   
    }
    
    /* Set<Id> parentIds = new Set<Id>();
// Records to Update
Account[] recordsToUpdate = new Account[0];
// Records that we need to process in second loop
Account[] testCheckAccounts = new Account[0];
// Extract parent Ids
for(Account record: Trigger.new) {
if(record.represent_concern__c && record.ParentId != null) {
parentIds.add(record.ParentId);
testCheckAccounts.add(record);
}
}
system.debug('parentIds ' + parentIds);
system.debug('testCheckAccounts ' + testCheckAccounts);
// Nothing to do here
if(parentIds.isEmpty()) {
return;
}
// Keep parent Ids with more than one child checked
parentIds.retainAll(new Map<Id, AggregateResult>([SELECT ParentId Id FROM Account WHERE ParentId = :parentIds 
AND represent_concern__c = true GROUP BY ParentId HAVING COUNT(ParentId) > 1]).keySet());
system.debug('parentIds ' + parentIds);
// Nothing to do here
if(parentIds.isEmpty()) {
return;
}
// Track checked records in this trigger context
Map<Id, Id> parentChildChecked = new Map<Id, Id>();
for(Account record: testCheckAccounts) {
// More than one child in this transaction is already checked
if(parentIds.contains(record.ParentId) && 
parentChildChecked.put(record.ParentId, record.Id) != null) {
recordsToUpdate.add(new Account(Id=record.id, represent_concern__c=false));
}
}
// Get child records for parents that have more than two checked records and not in this trigger context
for(Account record: [SELECT Id FROM Account WHERE ParentId = :parentIds AND represent_concern__c = true AND Id NOT IN :testCheckAccounts]) {
recordsToUpdate.add(new Account(Id=record.Id, represent_concern__c=false));
}
update recordsToUpdate;*/
    /*set<Id> accPId = new set<Id>();
    set<Id> accId = new set<Id>();
    List<Account> lstToUpdate = new List<Account>();
    for(Account acc: trigger.new) {
        Account oldacc  = trigger.oldMap.get(acc.Id);
        if(acc.ParentId != oldacc.ParentId && oldacc.ParentId == null) {
            if(acc.represent_concern__c){
                accPId.add(acc.ParentId);
                accId.add(acc.Id);
            }
        }else{
            if(acc.represent_concern__c !=  oldacc.represent_concern__c) {
                accPId.add(acc.ParentId);
                accId.add(acc.Id);  
            }
            system.debug('accPId ' + accPId);
            system.debug('accId ' + accId);
        }
    } 
    List<Account> lstacc = [SELECT Id,Name, represent_concern__c from Account where Id NOT IN:accId AND ParentId IN: accPId AND represent_concern__c = true];
    system.debug('lstacc ' + lstacc);
    for(Account a: lstacc) {
        a.represent_concern__c = false;
        lstToUpdate.add(a);
    }
    
    update lstToUpdate;*/
}