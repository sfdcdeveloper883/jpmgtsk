public with sharing class ContactController {

    @AuraEnabled(cacheable=true)
    public static List<Task> getContacts() {
        return [
            SELECT ActivityDate, Id, CreatedDate 
            FROM Task
        ];
    }
}