@RestResource(urlMapping='/v1/accountcreate/*')
global class AccountCreate {
    @HttpPost
    global Static string createAccount(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string jsonString=req.requestBody.tostring();
        System.debug('JsonString-->>'+jsonString);
        responseWrapper wResp=(responseWrapper) JSON.deserialize(jsonString,responseWrapper.class);
        System.debug('WResp-->>'+wResp);
        Account acc=new Account();
        acc.Name=wResp.wName;
        acc.AccountNumber = String.valueOf(wResp.Id);
        Insert acc;
        return 'Success';
    }
    
    public class responseWrapper{
        public string wName;
        public string Id;
    }
}