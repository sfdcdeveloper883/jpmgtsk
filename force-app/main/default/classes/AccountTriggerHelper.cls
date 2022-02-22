public class AccountTriggerHelper {
    
    /*   public static void afterUpdate(Map<Id,Account> newMap) {
Set<Id> accId = new Set<Id>();
List<Account> acclst = [SELECT AccountNumber, Id from Account where Id IN: newMap.keySet()];
for(Account acc: acclst) {
if(acc.AccountNumber !=null) {
acc.AccountNumber += 1;
}else{
acc.AccountNumber = String.valueOf(1);
}
}
update acclst;
}*/
    //on before update
    /* public static void beforeUpdate(map<ID, Account> newMap, map<ID, Account> oldMap) {

List<Account> accList = new List<Account>();
if(!RecursiveTriggerHandler.recordIdMap.containsKey('beforeupdate'))
RecursiveTriggerHandler.recordIdMap.put('beforeupdate', new Set<ID>());
for (Account acc: newMap.values()) {
if(!RecursiveTriggerHandler.recordIdMap.get('beforeupdate').contains(acc.Id)){
accList.add(acc);
RecursiveTriggerHandler.recordIdMap.get('beforeupdate').add(acc.Id);
}
}
System.debug('=== Trigger run === '+accList.size()+' === Total Processed Records === '+RecursiveTriggerHandler.recordIdMap.get('beforeupdate').size());
}*/
    
    public static void updateAccount(map<Id,Account> newAccountUpdate){ 
        RecursiveTriggerHandler handler = new RecursiveTriggerHandler();
        if(newAccountUpdate!=Null && !newAccountUpdate.isEmpty()){
            List<Account> accList = new List<Account>([select id,AccountNumber from Account Where Id In: newAccountUpdate.keyset()]);
            system.debug(accList);
            for(Account a : accList){
                system.debug(RecursiveTriggerHandler.setAccountIds);
                if(!RecursiveTriggerHandler.setAccountIds.containsAll(newAccountUpdate.keyset())){
                     RecursiveTriggerHandler.setAccountIds.addAll(newAccountUpdate.KeySet());
                    if(a.AccountNumber !=Null){
                        a.AccountNumber +=1;
                    }else{
                        a.AccountNumber = String.valueOf(1);
                    }
                }
            } 
            system.debug(accList);
            Update accList ;
        }
        
    }
}