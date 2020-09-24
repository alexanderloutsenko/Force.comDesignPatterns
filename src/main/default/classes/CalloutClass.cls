public with sharing class CalloutClass 
{
	public static HttpResponse callout(String endpoint)
	{
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('GET');
		Http h = new Http();
		HttpResponse res = h.send(req);
		return res;
	}
}