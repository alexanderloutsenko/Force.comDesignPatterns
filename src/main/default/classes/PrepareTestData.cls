@isTest
public class PrepareTestData 
{
	public static List<Contact> prepareContacts(Integer numContacts, Boolean insertNow)
	{
		List<Contact> retVal = new List<Contact>();
		for(Integer i=0; i<numContacts; i++) 
			retVal.add(new Contact(Lastname = 'TEST' + i));
		if(insertNow) 
			insert retVal;
		return retVal;
	}
}