public class testclass {

    @AuraEnabled(cacheable = true)
    public static List<Contact> getAccountdetails() {       
        List<Contact> lstContc = [SELECT Id, Name, Phone, Email, Account.Website, Account.Name FROM Contact WHERE DoNotCall = true AND AccountId = '0015j00000ADlEXAA1' ];
        system.debug('lstContc ' +lstContc);
        return lstContc;
    }

     @AuraEnabled
    public static void updateAsCustomer(Id accountId){
        update new Account(Id=accountId, Type='Customer');
    }
}