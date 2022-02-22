public class batchTest implements Database.Batchable<SObject>, Database.Stateful {
    public Set<Id> accountIds = new Set<Id>();
    public Set<String> strPOR;
    public batchTest(Set<Id> accIds) {
        this.accountIds = accIds;
        strPOR = new Set<String> {'Sales Owner', 'Global Owner'};
            }
    public Database.QueryLocator start( Database.BatchableContext BC ){ 
        String query = 'SELECT Id, Name, ParentId, represent_concern__c  ' + 
            'FROM Account ' + 
            'WHERE Id IN:accountIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext info, List<Account> accounts) {
        Map<Id, Account> accountMap = new Map<Id, Account>(accounts);
        Map<Id, List<junction_object__c >> accountIdToJuncMap = getAccountIdToJuncMap(accountMap.keySet());
        for(Id accountId : accountIdToJuncMap.keySet()) {
            Integer readyCounter = 0;
            List<junction_object__c> junCObjList = accountIdToJuncMap.get(accountId);
            for(junction_object__c juncObj : junCObjList) {
                if(juncObj.POR__c == 'Global Owner'){
                  readyCounter++;   
                }  
            }
            system.debug('readyCounter ' + readyCounter);
            system.debug('junCObjList ' + junCObjList.size());
        }
    }
    
    private Map<Id, List<junction_object__c>> getAccountIdToJuncMap(Set<Id> accountIds) {
        List<junction_object__c> juncList = [SELECT Id, Account__r.represent_concern__c, IsDeleted, Account__c, type__c, POR__c
                                             FROM junction_object__c 
                                             WHERE Account__c IN: accountIds];
        Map<Id, List<junction_object__c>> accountIdToJuncMap = new Map<Id, List<junction_object__c>>();
        for(junction_object__c juncObj : juncList) {
            Id accountId = juncObj.Account__c;
            List<junction_object__c> juncAssociations = accountIdToJuncMap.containsKey(accountId) ? accountIdToJuncMap.get(accountId) : new List<junction_object__c>();
            juncAssociations.add(juncObj);
            accountIdToJuncMap.put(juncObj.Account__c, juncAssociations);
        }
        
        return accountIdToJuncMap;
    }
    
    public void finish( Database.BatchableContext BC ) {
        
    }
}