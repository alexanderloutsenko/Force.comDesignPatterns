public with sharing class FlowFactoryDemoController 
{
	public Contact theContact {get; set;}
	public List<FlowStep> flowSteps {get; private set;}
	public class FlowStep
	{
		public Integer stepNumber {get; private set;}
		public String step {get; private set;}
		public FlowStep(Integer stepNumber, String step)
		{
			this.stepNumber = stepNumber;
			this.step = step;
		}
	}

	public List<External_Account__c> externalAccounts 
	{
		get
		{
			return [SELECT Id, Name, Email__c, Membership_Level__c FROM External_Account__c];
		}
		private set;
	}
	
	public List<Mailing_List__c> mailingList
	{
		get
		{
			return [SELECT Id, Name, Email__c, Membership_Level__c FROM Mailing_List__c];
		}
		private set;
	}

	public FlowFactoryDemoController()
	{
		this.theContact = new Contact();
		this.flowSteps = new List<FlowStep>();
	}
	
	public PageReference syncContact()
	{
		if(this.theContact.ReportsToId == null) return null;
		MembershipLevelFlow mlf = new MembershipLevelFlow();
		MembershipLevelFlow.MembershipLevelState flowResults = mlf.processWork(getContact(this.theContact.ReportsToId));
		populateResults(flowResults.steps);
		return null;
	}
	
	public PageReference unsubscribeContact()
	{
		if(this.theContact.ReportsToId == null) return null;
		UnsubscribeFlow uf = new UnsubscribeFlow();
		UnsubscribeFlow.UnsubscribeState flowResults = uf.processWork(getContact(this.theContact.ReportsToId));
		populateResults(flowResults.steps);
		return null;
	}
	
	private Contact getContact(Id contactId)
	{
		return [SELECT Id, Name, Email, Membership_Level__c FROM Contact WHERE Id = :contactId];
	}
	
	private void populateResults(List<FlowFactory.Step> steps)
	{
		this.flowSteps = new List<FlowStep>();
		for(Integer i=0; i<steps.size(); i++)
			this.flowSteps.add(new FlowStep(i+1, steps[i].stepName));
	}
	
	public PageReference deleteAll()
	{
		delete [SELECT Id FROM External_Account__c];
		delete [SELECT Id FROM Mailing_List__c];
		this.flowSteps = new List<FlowStep>();
		return null;
	}
}
