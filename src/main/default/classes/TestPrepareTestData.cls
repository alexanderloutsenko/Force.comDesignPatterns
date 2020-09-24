@isTest
private class TestPrepareTestData 
{
    @isTest static void testPrepareContactsModifyBeforeInsert() 
    {
    	List<Contact> contacts = PrepareTestData.prepareContacts(100, false);
    	System.assert(contacts.size() == 100);
    	System.assert([SELECT count() FROM Contact] == 0);
    	
		for(Integer i=0; i<100; i++) 
    		contacts[i].Firstname = 'TEST' + i;
    	insert contacts;
    }
    
    @isTest static void testPrepareContactsInsertImmediately() 
    {
    	List<Contact> contacts = PrepareTestData.prepareContacts(200, true);
    	System.assert([SELECT count() FROM Contact] == 200);
    }    
}