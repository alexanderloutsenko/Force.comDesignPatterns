public with sharing class SyncContactToUser implements TriggerDispatcher.ITriggerEntry 
{
	public void inProgressEntry(TriggerDispatcher.TriggerParameters tp)
	{
		// Confirm caller origin
		system.assert(tp.triggerObject == 'User');
	}

	public void mainEntry(TriggerDispatcher.TriggerParameters tp)
	{
		Map<Id, Contact> newMap = (Map<Id, Contact>) tp.newMap;
		List<Id> userIds = new List<Id>();
		for(Contact c : newMap.values())
			userIds.add(c.User__c);

		Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Phone, MobilePhone, Fax FROM User WHERE Id IN :userIds]);
		
		for(Contact c : newMap.values())
		{
			User u = userMap.get(c.User__c);
			if(u.Phone != c.Phone || u.MobilePhone != c.MobilePhone || u.Fax != c.Fax)
			{
				u.Email = c.Email;
				u.Phone = c.Phone;
				u.MobilePhone = c.MobilePhone;
				u.Fax = c.Fax;
				TriggerDispatcher.sObjectsToUpdate.put(u.Id, u);
			}
		}
	}
}