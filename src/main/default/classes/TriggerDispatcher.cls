public with sharing class TriggerDispatcher 
{
	private static final String SACCOUNT = 'Account';
	private static final String SCONTACT = 'Contact';
	private static final String SLEAD = 'Lead';
	private static final String SOPPORTUNITY = 'Opportunity';
	private static final String SUSER = 'User';

	public static ITriggerEntry activeInstance = null;
	public static Map<Id, SObject> sObjectsToUpdate = new Map<Id, SObject>();

	public interface ITriggerEntry
	{
		void mainEntry(TriggerParameters tp);
		void inProgressEntry(TriggerParameters tp);
	}
	//holds all the trigger parameters and assign received parameters to the locals
	public class TriggerParameters
	{
		public String triggerObject {get; private set;}
		public Boolean isBefore {get; private set;}
		public Boolean isAfter {get; private set;}
		public Boolean isDelete {get; private set;}
		public Boolean isInsert {get; private set;}
		public Boolean isUpdate {get; private set;}
		public Boolean isExecuting {get; private set;}
		public List<SObject> oldList {get; private set;}
		public List<SObject> newList {get; set;}
		public Map<Id, SObject> oldMap {get; private set;}
		public Map<Id, SObject> newMap {get; set;}
		// assigns trigger's parameters to the locals
		public TriggerParameters(Boolean ib, Boolean ia, Boolean id, Boolean ii, Boolean iu, Boolean ie, 
			List<SObject> ol, List<SObject> nl, Map<Id, SObject> om, Map<Id, SObject> nm)
		{
			this.isBefore = ib;
			this.isAfter = ia;
			this.isDelete = id;
			this.isInsert = ii;
			this.isUpdate = iu;
			this.isExecuting = ie;
			this.oldList = ol;
			this.newList = nl;
			this.oldMap = om;
			this.newMap = nm;
			this.triggerObject = getSObjType((this.oldList != null && this.oldList.size() > 0) ? 
				this.oldList[0] : this.newList[0]);
		}
		// identifies which object has fired the trigger and returns this object's name
		private String getSObjType(SObject so)
		{
			String retVal;
			if(so instanceof Account) retVal = SACCOUNT;
			else if(so instanceof Contact) retVal = SCONTACT;
			else if(so instanceof Lead)	retVal = SLEAD;
			else if(so instanceof Opportunity) retVal = SOPPORTUNITY;
			else if(so instanceof User) retVal = SUSER;
			return retVal;
		}
	}

	// Central dispatch entry which controls the order of triggers' execution
	public static void entry(TriggerParameters tp)
	{	
		if(activeInstance == null) // a trigger has not been fired yet 
			processWork(tp);
		else
			activeInstance.inProgressEntry(tp); // handle the case when a trigger has already been fired and is in progress of execution
	}
	
	// Order of execution is controlled
	private static void processWork(TriggerParameters tp)
	{
		if(tp.triggerObject == SCONTACT && tp.isAfter && tp.isUpdate)
		{
			execute(new SyncContactToUser(), tp);
			//execute(new RollupTotals(), tp);
			//execute(new AccountSync(), tp);
			//execute(new CalloutQueue(), tp);
		}
		else if(tp.triggerObject == SUSER && tp.isAfter && tp.isUpdate)
			execute(new SyncUserToContact(), tp);
		
		if(sObjectsToUpdate.size() > 0) 
			update sObjectsToUpdate.values();
	}
	// wrapper class
	private static void execute(ITriggerEntry ite, TriggerParameters tp)
	{
		activeInstance = ite;
		activeInstance.mainEntry(tp);
	}
}