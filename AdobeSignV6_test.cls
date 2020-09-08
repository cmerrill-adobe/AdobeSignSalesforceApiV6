// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  Test class. Covers:
//  AdobeSignV6.cls & AdobeSignv6_rest.cls
//  https://github.com/cmerrill-adobe/AdobeSignSalesforceApiV6
//  by Chris Merrill cmerrill.adobe@gmail.com
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
@isTest
private class AdobeSignV6_test {
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    	
	@isTest
	private static void test_get_signingUrl() {
        
        Test.setMock(HttpCalloutMock.class, new Mock_signingUrl());
        Test.startTest();
        string result = AdobeSignV6.get_signingUrl('test');
        system.assertEquals( result, null );
        
        AdobeSignv6_rest.signingURLS r = new AdobeSignv6_rest.signingURLS();
        List<AdobeSignv6_rest.cls_signingUrlSetInfos> urls = new List<AdobeSignv6_rest.cls_signingUrlSetInfos>();
        r.signingUrlSetInfos = urls;
        
        Test.stopTest();   
        
	}
	private class Mock_signingUrl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody( JSON.serialize(new AdobeSignv6_rest.signingURLS() ) );
            res.setStatusCode( 200 );
            return res;
        }
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
    @isTest
	private static void test_get_agreements() {
        
        Test.setMock(HttpCalloutMock.class, new Mock_agreements());
        Test.startTest();
        AdobeSignv6_rest.UserAgreements result = AdobeSignV6.get_agreements();
        system.assertNotEquals( result, null );
        Test.stopTest();   
        
	}
	private class Mock_agreements implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody( JSON.serialize( new AdobeSignv6_rest.UserAgreements() ) );
            res.setStatusCode( 200 );
            return res;
        }
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    	
    @isTest
	private static void test_get_agreement() {
        
        Test.setMock(HttpCalloutMock.class, new Mock_agreement());
        Test.startTest();
        AdobeSignv6_rest.Agreementinfo result = AdobeSignV6.get_agreement('test');
        system.assertNotEquals( result, null );
        Test.stopTest();   
        
	}
	private class Mock_agreement implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody( JSON.serialize( new AdobeSignv6_rest.Agreementinfo() ) );
            res.setStatusCode( 200 );
            return res;
        }
    }
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  	
    @isTest
	private static void test_get_formData_success() {
        
        Test.setMock(HttpCalloutMock.class, new Mock_formData());
        Test.startTest();
        Map<String,String> result = AdobeSignV6.get_FormData('test');
        system.assertNotEquals( result, null );
        Test.stopTest();   
        
	}
	private class Mock_formData implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody( JSON.serialize( new AdobeSignv6_rest.formData() ) );
            res.setStatusCode( 200 );
            return res;
        }
    }
}