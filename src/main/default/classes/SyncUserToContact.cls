public with sharing class SyncUserToContact implements TriggerDispatcher.ITriggerEntry
{
	public void inProgressEntry(TriggerDispatcher.TriggerParameters tp)
	{
		// Confirm caller origin
		system.assert(tp.triggerObject == 'Contact');
	}

	public void mainEntry(TriggerDispatcher.TriggerParameters tp)
	{
		Map<Id, User> newMap = (Map<Id, User>) tp.newMap;
		List<Contact> contactList = [SELECT User__c, Phone, MobilePhone, Fax FROM Contact WHERE User__c IN :newMap.keyset()];
		
		for(Contact c : contactList)
		{
			User u = newMap.get(c.User__c);
			if(c.Phone != u.Phone || c.MobilePhone != u.MobilePhone || c.Fax != u.Fax)
			{
				c.Phone = u.Phone;
				c.MobilePhone = u.MobilePhone;
				c.Fax = u.Fax;
				TriggerDispatcher.sObjectsToUpdate.put(c.Id, c);
			}
		}
	}
}