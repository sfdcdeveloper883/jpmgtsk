public with sharing class MySOAPWebService implements Queueable,Database.AllowsCallouts {
    public void execute(QueueableContext qc){
        //ID jobID = System.enqueueJob(new MySOAPWebService());
        Http h = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setHeader('Accept','application/json'); 
        httpReq.setHeader('Content-Type','application/json'); 
        httpReq.setEndpoint('https://us-street.api.smartystreets.com/street-address?auth-id=ff144849-97e7-dfae-60e8-e812e8e1a6de&auth-token=wItmq3M8bgOoFuFyfPCl&street=1600+amphitheatre+pkwy&city=mountain+view&state=CA&candidates=10');
        HttpResponse res = h.send(httpReq);
        System.debug('res'+res.getBody());
    }
    
    public class mywrapper {
        public mywrapper(){
            
        }
    }
}