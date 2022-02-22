@isTest()
public class TestAccountTrigger {
    
    @testSetup 
    static void mytestdata() {
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;    
    } 
    
     static testMethod void mytest1() {
        
     Account acc = [SELECT Id from Account LIMIT 1];   
    }
    
    static testMethod void mytest2() {
        
     Account acc = [SELECT Id, Name from Account LIMIT 1];   
        acc.Name = 'Shilpa';
        update acc;
    }
    
    static testMethod void mytest3() {
        
        Account acc = [SELECT Id, Name from Account LIMIT 1];   
        acc.Name = 'Bharti';
        update acc;
    }
    
    static testMethod void mytest4() {
        
        Account acc = [SELECT Id, Name from Account LIMIT 1];   
        acc.Name = 'Nischal';
        update acc;
    }
 
}