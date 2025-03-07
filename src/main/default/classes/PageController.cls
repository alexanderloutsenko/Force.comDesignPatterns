public with sharing class PageController {
    
    public class MyWrapper
    {
        public Contact con {get; private set;}
        public Opportunity opp {get; private set;}

        public MyWrapper (Contact c, Opportunity o)
        {
            this.con = c;
            this.opp = o;
        }
    }

    // Prototype list member, to be instantiated later
	public List<MyWrapper> wrapperList {get; private set;}
	
	// Constructor
	public PageController()
	{
		// Create contact map
		Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, Name FROM Contact WHERE Id IN 
			(SELECT ContactId FROM OpportunityContactRole WHERE IsPrimary = true)]);
			
		// Create opportunity map
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Name FROM Opportunity WHERE Id IN 
			(SELECT OpportunityId FROM OpportunityContactRole WHERE IsPrimary = true)]);
		
		// Create junction table list to iterate
		List<OpportunityContactRole> oppConRoles = [SELECT OpportunityId, ContactId FROM OpportunityContactRole WHERE IsPrimary = true];
		
		// Initialize and populate wrapper list
		this.wrapperList = new List<MyWrapper>();
		for(OpportunityContactRole ocr : oppConRoles)
		{
			this.wrapperList.add(new MyWrapper(conMap.get(ocr.ContactId), oppMap.get(ocr.OpportunityId)));
		}
	}

}
