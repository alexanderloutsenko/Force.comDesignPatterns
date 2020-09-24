/*
ContactTestData.csv:
	Firstname,Lastname,Phone
	Bob,Smith,(415) 555-1212
	John,Doe,(415) 555-2121
*/

@isTest
public with sharing class TestLoadStaticData 
{
	public static testMethod void testStaticLoadData()
	{
		List<Contact> contacts = (List<Contact>) Test.loadData(Contact.sObjectType, 'ContactTestData');
		System.assert(contacts.size() == 2);
		System.assert(contacts[0].Firstname == 'Bob');
		System.assert(contacts[1].Lastname == 'Doe');
 
    	//System.Test.startTest();
		// ...
    	//System.Test.startTest();
    }
}