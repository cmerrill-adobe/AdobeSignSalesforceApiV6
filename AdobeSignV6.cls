// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  Working directly with Adobe Sign REST api V6 using APEX. 
//  https://github.com/cmerrill-adobe/AdobeSignSalesforceApiV6
//  by Chris Merrill cmerrill.adobe@gmail.com
//
//  Adobe Sign API portal : https://corporate.na1.adobesign.com/public/docs/restapi/v6
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
public class AdobeSignV6 {
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
//  EXAMPLE URL:
//  https://mydomain.na1.echosign.com/public/docs/restapi/v6
//         API_SHARD ^^                       API_VERSION ^^
    private static final string API_VERSION = 'v6';
    private static final string API_SHARD = 'na1';
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  Could be echosign.com or the newly assigned adobesign.com
    private static final string API_HOSTNAME = 'echosign.com';
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  Could be moved and accessed via custom settings or custom metadatatype
//  Instructions: https://helpx.adobe.com/sign/kb/how-to-create-an-integration-key.html
    private static string INTEGRATION_KEY = 'INTEGRATION KEY GOES HERE';
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  List All Agreements
    public static AdobeSignV6_rest.UserAgreements get_agreements() {
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint( 'https://api.' + API_SHARD +'.' + API_HOSTNAME + '/api/rest/' + API_VERSION + '/agreements' );
        req.setMethod( 'GET' );
        
        Http http = new Http();
        HttpResponse res = http.send( requestHeaders( req ) );
        
        AdobeSignV6_rest.UserAgreements response = new AdobeSignV6_rest.UserAgreements();
        response = ( AdobeSignV6_rest.UserAgreements)JSON.deserialize(res.getBody(), AdobeSignV6_rest.UserAgreements.class);
        
        return response;
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  get agreement details   
    public static AdobeSignV6_rest.Agreementinfo get_agreement( string agreementId ) {
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint( 'https://api.' + API_SHARD +'.' + API_HOSTNAME + '/api/rest/' + API_VERSION + '/agreements/' + agreementId );
        req.setMethod( 'GET' );
        
        Http http = new Http();
        HttpResponse res = http.send( requestHeaders( req ) );
        
        AdobeSignV6_rest.Agreementinfo response = new AdobeSignV6_rest.Agreementinfo();
        response = ( AdobeSignV6_rest.Agreementinfo )JSON.deserialize( res.getBody(), AdobeSignV6_rest.Agreementinfo.class );
        
        return response;
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
//  get Signing URL
    public static string get_signingUrl( string agreementId ) {
        
        string response;
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint( 'https://api.' + API_SHARD +'.' + API_HOSTNAME + '/api/rest/' + API_VERSION + '/agreements/' + agreementId + '/signingUrls'  );
        req.setMethod( 'GET' );
        
        Http http = new Http();
        HttpResponse res = http.send( requestHeaders( req ) );
        
        AdobeSignV6_rest.signingURLS  urls = ( AdobeSignV6_rest.signingURLS )JSON.deserialize( res.getBody(), AdobeSignV6_rest.signingURLS.class ); 
        
        if( urls.signingUrlSetInfos!= null ) response = urls.signingUrlSetInfos.get(0).signingUrls.get(0).esignUrl;
        
        return response;
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Consolidating headers to a single method. Making it easier to add or remove x-api-user
    private static HttpRequest requestHeaders( HttpRequest req ) {
        
        req.setHeader( 'Content-Type', 'application/json' );
        req.setHeader( 'Authorization', 'Bearer ' + INTEGRATION_KEY );
        req.setHeader( 'x-api-user', 'email:' + UserInfo.getUserEmail() );
        return req;
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  Collect form data from Adobe Sign API
//  Return form data as map with label/value
//    
    public static Map<String,String> get_FormData( String agreementId ) {
        Map<String,String> response = new Map<String,String>();
        for( AdobeSignv6_rest.formData_element d : get_agreement_formData( agreementId ).elements ) {
            response.put( d.label, d.value );
        }
        return response;
    }

    private static AdobeSignv6_rest.formData get_agreement_formData( String agreementId ) {
        AdobeSignv6_rest.formData response = new AdobeSignv6_rest.formData();
        if( agreementId != null ) {
            List<AdobeSignv6_rest.formData_element> elements = new List<AdobeSignv6_rest.formData_element>();
            AdobeSignv6_rest.formData_element formData;
            HttpRequest req = new HttpRequest();
            req.setEndpoint( 'https://api.' + API_SHARD +'.' + API_HOSTNAME + '/api/rest/' + API_VERSION + '/agreements/' + agreementId + '/formData' );
            req.setMethod( 'GET' );
            req.setHeader( 'Content-Type', 'application/json' );
            req.setHeader( 'Access-Token', INTEGRATION_KEY );
            system.debug( agreementId );
            req.setHeader( 'agreementId', agreementId );
            Http http = new Http();
            
            HttpResponse res; 
            
            if( !test.isRunningTest() ) { res = http.send( req );
            } else {
                res = new HttpResponse();
                res.setStatusCode(200);
                res.setBody('label1,label2\nvalue1,value2');
            }
            
            response.status = res.getStatus();
            if( res.getStatusCode() == 200 ) {
                List<String> f_keys = res.getBody().split('\n').get(0).split(',');
                List<String> f_vals = res.getBody().split('\n').get(1).split(',');
                for (Integer i = 0, j = 0; i < f_keys.size(); i++) {
                    formData = new AdobeSignv6_rest.formData_element();
                    formData.label = f_keys.get(i).remove('"').capitalize();
                    formData.value = f_vals.get(i).remove('"');
                    if( formData.value != '' ) {
                        elements.add(formData);
                    }    
                }
            } else {
                AdobeSignv6_rest.errorResponse status = (AdobeSignv6_rest.errorResponse)JSON.deserialize(res.getBody(), AdobeSignv6_rest.errorResponse.class);
                response.status = status.code + ' : ' + status.message;
            }
            response.elements = elements;
        }
        return response;
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
}