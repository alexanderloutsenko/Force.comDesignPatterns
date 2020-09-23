// <!-- this code is from Pluralsight course called Force.com Design Patterns 1 -->
public with sharing class BulkDeleteSObjects_Controller 
{
	public List<SObjectWrapper> sObjectWrapperList {get; private set;}
	public String selectString {get; set;}
	
	public class SObjectWrapper
	{
		public SObject sObj {get; private set;}
		public Object name {get; private set;}
		public Boolean deleteThis {get; set;}
		
		public SObjectWrapper(SObject so)
		{
			this.sObj = so;
			try
			{
				this.name = this.sObj.get('Name');
			}
			catch(Exception e){}
		}
	}
	
	// Constructor
	public BulkDeleteSObjects_Controller()
	{
		this.sObjectWrapperList = new List<SObjectWrapper>();
	}
    // if you use PageReference this means that this code is used by VF page
    // and this method is supposed return another VF page for redirecting you from
    // you current VF page of return NULL for keeping you on the same VF page
	public PageReference executeSelect()
	{
		try
		{
            //Database.query is used to run a dynamic query included in selectString variable
            // which is supposed to be provided by a user in the related VF page
			loadData(Database.query(this.selectString));
		}
		catch(Exception e)
		{
			logError(e);
		}
		// says SF to keep you on the same VF page
		return null;
	}
	// this method is a common pattern in Apex
	private void loadData(List<SObject> sObjs)
	{
        // this line of code just refreshed the sObjectWrapperList every time the method is called
		this.sObjectWrapperList = new List<SObjectWrapper>();
		for(SObject s : sObjs)
		{
			this.sObjectWrapperList.add(new SObjectWrapper(s));
		}
	}
	
	public PageReference deleteSelected()
	{
		try
		{
            List<SObject> sObjs = new List<SObject>();
            // here we extract data from sObjectWrapperList and check
            // whether particular record is a candidate for being deleted
			for(SObjectWrapper so : this.sObjectWrapperList)
			{
				if(so.deleteThis == true)
					sObjs.add(so.sObj);
			}
			
			delete sObjs; // here we delete necessary records
			executeSelect(); // here we refresh the list of records to remove just deleted records from the list
			
			// Allow partial success...
			// Database.DeleteResult[] result = Database.delete(sObjs, false);
		}
		catch(Exception e){ logError(e); }
		
		return null;
	}
    // this is a helper method logging the errors happed during a deletion process
	private void logError(Exception e)
	{ 
		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
	}
}
