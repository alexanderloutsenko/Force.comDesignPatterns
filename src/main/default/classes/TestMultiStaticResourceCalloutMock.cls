/*
StaticCalloutMock.txt:
	{"Firstname": "Sasha", "Lastname": "Lu"}
StaticCalloutMock2.txt
	{"Firstname": "Nata", "Lastname": "Ole"}
*/

@isTest
private class TestMultiStaticResourceCalloutMock 
{
    static testMethod void myUnitTest() 
    {
        // this permits testing the callouts to different endpoints
		MultiStaticResourceCalloutMock multiMock = new MultiStaticResourceCalloutMock();
		multiMock.setStaticResource('http://api.somesite.com/', 'CalloutMock');
		multiMock.setStaticResource('http://api.anothersite.com/', 'CalloutMock2');
		multiMock.setStatusCode(200);
		multiMock.setHeader('Content-Type', 'application/json');

		System.Test.setMock(HttpCalloutMock.class, multiMock);

		HttpResponse res = CalloutClass.callout('http://api.somesite.com/');
		System.assertEquals(res.getBody(), '{"Firstname": "Sasha", "Lastname": "Lu"}');
		
		res = CalloutClass.callout('http://api.anothersite.com/');
		System.assertEquals(res.getBody(), '{"Firstname": "Nata", "Lastname": "Ole"}');
    }		
}