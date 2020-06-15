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
    private static final string API_HOSTNAME = 'adobesign.com';
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
}