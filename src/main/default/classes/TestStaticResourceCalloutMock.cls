/*
StaticCalloutMock.txt:
	{"Firstname": "Bob", "Lastname": "Smith"}
*/

@isTest
private class TestStaticResourceCalloutMock 
{
    static testMethod void myUnitTest() 
    {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('CalloutMock');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');		
		System.Test.setMock(HttpCalloutMock.class, mock);
		
		HttpResponse res = CalloutClass.callout('http://api.somesite.com/');
		System.assertEquals(res.getBody(), '{"Firstname": "Sasha", "Lastname": "Lu"}');
		System.assertEquals(res.getStatusCode(), 200);
		System.assertEquals(res.getHeader('Content-Type'), 'application/json');
    }
}