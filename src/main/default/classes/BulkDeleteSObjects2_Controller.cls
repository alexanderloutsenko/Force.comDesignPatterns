public with sharing class BulkDeleteSObjects2_Controller 
{
	public List<SObjectWrapper> sObjectWrapperList {get; private set;}
	public List<SelectOption> sObjectList {get; private set;} // list of select options (a dropdown list to show on the VF page)
	public String selectedSObject {get; set;} // to store a selected dropdown value
	public Boolean hasName {get; private set;} // determine whether selected object has a Name field or not
	
	public class SObjectWrapper
	{
		public SObject sObj {get; private set;}
		public Boolean deleteThis {get; set;}
		public Object name {get; private set;}
		
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
	
	public BulkDeleteSObjects2_Controller()
	{
		this.sObjectWrapperList = new List<SObjectWrapper>();
		prepareSObjectList();
	}
    // this method is called on the load of the VF page and this method is intended to
    // create a dynamic list of the objects existing on the org
	private void prepareSObjectList()
	{
		this.sObjectList = new List<SelectOption>();
		this.sObjectList.add(new SelectOption('none', '--None--'));// adds default option to the dropdown
	    Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();// retreives list of the sobjects existing on the org
        List<String> sObjs = new List<String>(globalMap.keySet());// extracts only sobject names from the Map
        sObjs.sort(); // this line of code just sort the SObjects list

        for(String s : sObjs)//below IF statement checks that we show in the dropdown list only the SObjects which are visible to users and can be updated (in our case - deleted)
			if(globalMap.get(s).getDescribe().isAccessible() == true && globalMap.get(s).getDescribe().isUpdateable() == true)
	        	this.sObjectList.add(new SelectOption(s, globalMap.get(s).getDescribe().getLabel()));
	        	
	    this.selectedSObject = 'none';
	}
	//below method consructs the dynamic SOQL query and execute it to load a data for showing
	public PageReference executeSelect()
	{
		// Clear out wrapper list
		this.sObjectWrapperList = new List<SObjectWrapper>();
		
		if(this.selectedSObject != null && this.selectedSObject != 'none')
		{
			try
			{
				String fieldList = 'Id';
				if(doesFieldExist(this.selectedSObject, 'Name'))
				{
					this.hasName = true;
					fieldList += ', Name';
				}
				
				String selectString = 'SELECT ' + fieldList + ' FROM ' + selectedSObject + ' LIMIT 1000'; // Could add dynamic WHERE clause
				loadData(Database.query(selectString));
			}
			catch(Exception e)
			{
				logError(e.getMessage());
			}
		}
		
		return null;
	}
	// checks whether or not the Name field exist within specific SObject
	private Boolean doesFieldExist(String objName, String fldName)
	{
		List<Schema.SObjectField> fldObjs = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().values();
		Set<String> fldNames = new Set<String>();
			
		for(Schema.SObjectField s : fldObjs)
			fldNames.add(s.getDescribe().getName());

		return (fldNames.contains(fldName));
	}

	private void loadData(List<SObject> sObjs)
	{
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
			for(SObjectWrapper so : this.sObjectWrapperList)
			{
				if(so.deleteThis == true)
					sObjs.add(so.sObj);
			}
			
			delete sObjs;
			executeSelect();
		}
		catch(Exception e)
		{
			logError(e.getMessage());
		}
		
		return null;
	}

	private void logError(String errorString)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, errorString));
	}
}
