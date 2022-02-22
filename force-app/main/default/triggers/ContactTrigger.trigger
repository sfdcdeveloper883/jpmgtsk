trigger ContactTrigger on Contact (before insert, before update) {
    Boolean isError = false;
    map<Id, Contact> mapofAccounttoContact = new map<Id, Contact>();
    Set<String> contEmail = new Set<String>();
    if((trigger.Isinsert || trigger.isUpdate) && trigger.isBefore) {
        for(contact cont : trigger.new ){
            Contact co = Trigger.oldMap.get(cont.Id);
            mapofAccounttoContact.put(cont.accountId, cont);
        }
    }
    List<contact> lstCont = [Select Id, AccountId, Email from Contact where accountId IN :mapofAccounttoContact.keyset()];
    if(lstCont.size() > 0) {
        for(Contact con : lstCont) {
            if(mapofAccounttoContact.get(con.AccountId).Email == con.Email && 
               con.AccountId == mapofAccounttoContact.get(con.AccountId).AccountId) {
                 isError = true;
               }
        }
    }
    
    for(Contact c : trigger.new ) {
        if(isError){
            c.addError('error occured');
        }
    }
}