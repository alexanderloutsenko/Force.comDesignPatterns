@isTest
public class TestHttpCalloutMock 
{
	public class CustomHttpCalloutMock implements HttpCalloutMock
	{
		public HTTPResponse respond(HTTPRequest req)
		{
            //HTTP response preparation
            HTTPResponse retVal = new HTTPResponse();
			retVal.setHeader('Content-Type', 'application/json');// prepare response header
			retVal.setBody('{"Firstname": "Bob", "Lastname": "Smith"}');// prepare simple response body
			retVal.setStatusCode(200);
			return retVal;
		}
	}

    @isTest static void myUnitTest() 
    {
		Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock());
		HttpResponse res = CalloutClass.callout('http://api.somesite.com/');
		System.assertEquals(res.getHeader('Content-Type'), 'application/json');
		System.assertEquals(res.getBody(), '{"Firstname": "Bob", "Lastname": "Smith"}');
		System.assertEquals(200, res.getStatusCode());
    }
}
