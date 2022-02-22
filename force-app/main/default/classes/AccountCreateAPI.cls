@RestResource(urlMapping='/v1/accountRecordCreate/*')
global class AccountCreateAPI {
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
        acc.Phone=wResp.wPhone;
        acc.AccountNumber = String.valueOf(wResp.wId);
        Insert acc;
        return 'Success';
    }
    
    public class responseWrapper{
        public string wName;
        public string wPhone;
        public Integer wId;
    }
}