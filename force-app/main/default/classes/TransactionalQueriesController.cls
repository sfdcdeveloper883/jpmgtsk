/*
 Controller class for API call out 
 */
public class TransactionalQueriesController {
    public static String domain;
    public static String transactionsProcessed;
    public static String retreiveTransactionDetails;
    public TransactionalQueriesController(){
        Map<String, Transaction_Callouts__mdt>  mapTQ = Transaction_Callouts__mdt.getAll();
        for(String nameTQ : mapTQ.keySet()){
            domain = mapTQ.get(nameTQ).Domain__c;
            if(nameTQ == 'retreiveTransactionDetails') {
            retreiveTransactionDetails = mapTQ.get(nameTQ).Endpoint__c;
            }
            if(nameTQ == 'transactionsProcessed') {
                transactionsProcessed = mapTQ.get(nameTQ).Endpoint__c;
            }
        }
    }
    
    
    @AuraEnabled(cacheable=false)
    public static void updateTransactionalQueries(String tqtoprocess) {
        String resp;
        system.debug('tqtoprocess ' + tqtoprocess);
        Body reqBody = new Body();
        HTTP auth = new HTTP();
        HTTPRequest r = new HTTPRequest();
        r.setHeader('Content-Type','application/json');
        r.setEndpoint(domain+'/'+transactionsProcessed);
        r.setMethod('POST');   
        r.setBody(JSON.serialize(tqtoprocess));   
        HTTPResponse authresp=new HttpResponse();
        authresp = auth.send(r);
        resp = authresp.getBody();
        system.debug('resp ' + resp);  
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Response> getTransactionalQueries(String strAccountName) {
        String resp;
        
        Body reqBody = new Body();
        HTTP auth = new HTTP();
        HTTPRequest r = new HTTPRequest();
        r.setHeader('Content-Type','application/json');
        r.setEndpoint(domain+'/'+retreiveTransactionDetails);
        r.setMethod('POST');   
        r.setBody(JSON.serialize(reqBody));   
        HTTPResponse authresp=new HttpResponse();
        authresp = auth.send(r);
        resp = authresp.getBody();
        system.debug('resp ' + resp);
        return (List<Response>)System.JSON.deserialize(resp, List<Response>.class);
        
    }
    @AuraEnabled(cacheable=false)
    public static List<Transaction_Query__c> insertTransactionalQueries(Object data, Id recId) {
        system.debug('jsonString ' + data);
        List<Response> parsedData = (List<Response>) JSON.deserialize(JSON.serialize(data), List<Response>.class);
        system.debug('parsedData ' + parsedData);
        List<Transaction_Query__c> lsttq = new List<Transaction_Query__c>();
        for(Response rsp : parsedData) {
            Transaction_Query__c tq = new Transaction_Query__c ();
            tq.Description__c = rsp.description;
            tq.Transaction_Amount__c = Decimal.valueof(rsp.transactionAmount);
            tq.Transaction_Reference__c = rsp.reference;
            tq.Account__c = recId;
            tq.Transaction_Date__c = date.valueOf(rsp.transactionDate);
            lsttq.add(tq);
        }
        system.debug('lsttq ' + lsttq);
        insert lsttq;
        return lsttq;
    }
    
    public class Body {
        public String accountNumber {get;set;}
        public Body(){
            accountNumber = '123456';
        }
    }
    
    public class Response {
        @AuraEnabled
        public string reference{get; set;}
        @AuraEnabled
        public string transactionDate{get;set;}
        @AuraEnabled 
        public String transactionAmount{get; set;}
        @AuraEnabled 
        public String description{get; set;}
    }
}