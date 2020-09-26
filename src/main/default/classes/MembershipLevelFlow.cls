public with sharing class MembershipLevelFlow extends FlowFactory.FlowParent 
{
	// Main Entry
	public MembershipLevelState processWork(Contact c)
	{
		if(c.Email == null) return null;
		
		MembershipLevelState state = new MembershipLevelState(c.Name, c.Email, c.Membership_Level__c);
		FlowFactory.Step step = new FirstStep();
		step.stepName = 'MembershipLevelFlow.FirstStep';
		processSteps(step, state);

		return state;
	}

	// State
	public class MembershipLevelState extends FlowFactory.FlowState
	{
		public String name {get; set;}
		public String email {get; set;}
		public String membershipLevel {get; set;}
		
		public MembershipLevelState(String name, String email, String membershipLevel)
		{
			this.name = name;
			this.email = email;
			this.membershipLevel = membershipLevel;
		}
	}
	
	//-----------
	// Flow Steps
	//-----------
	
	// FirstStep
	public class FirstStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			MembershipLevelState mls = (MembershipLevelState) fs;
			mls.steps.add(this);			
			if(hasExternalAccount(mls))
				this.nextStep = createInstance('MembershipLevelFlow.UpdateExternalAccount');
			else
				this.nextStep = createInstance('MembershipLevelFlow.CreateExternalAccount');

			return this.nextStep;
		}
		
		private Boolean hasExternalAccount(MembershipLevelState mls)
		{
			return ([SELECT count() FROM External_Account__c WHERE Email__c = :mls.email LIMIT 1] == 1);
		}
	}
	
	// UpdateExternalAccount
	public class UpdateExternalAccount extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			MembershipLevelState mls = (MembershipLevelState) fs;
			mls.steps.add(this);
			updateExternal(mls);			
			if(subscribedToMailer(mls))
				this.nextStep = createInstance('MembershipLevelFlow.UpdateMailer');
			else
				this.nextStep = createInstance('MembershipLevelFlow.SubscribeToMailer');

			return this.nextStep;
		}

		private void updateExternal(MembershipLevelState mls)
		{
			External_Account__c ea = [
				SELECT Id, Name, Email__c, Membership_Level__c 
				FROM External_Account__c 
				WHERE Email__c = :mls.email LIMIT 1];
			ea.Membership_Level__c = mls.membershipLevel;
			update ea;
		}
	}
	
	// CreateExternalAccount
	public class CreateExternalAccount extends FlowFactory.Step
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			MembershipLevelState mls = (MembershipLevelState) fs;
			mls.steps.add(this);
			createExternal(mls);
			
			if(subscribedToMailer(mls))
				this.nextStep = createInstance('MembershipLevelFlow.UpdateMailer');
			else
				this.nextStep = createInstance('MembershipLevelFlow.SubscribeToMailer');

			return this.nextStep;
		}
		
		private void createExternal(MembershipLevelState mls)
		{
			insert new External_Account__c(Name = mls.name, Email__c = mls.email, 
				Membership_Level__c = mls.membershipLevel);
		}
	}

	private static Boolean subscribedToMailer(MembershipLevelState mls)
	{
		return ([SELECT count() FROM Mailing_List__c WHERE Email__c = :mls.email LIMIT 1] == 1);
	}
	
	// SubscribeToMailer
	public class SubscribeToMailer extends FlowFactory.Step
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			MembershipLevelState mls = (MembershipLevelState) fs;
			mls.steps.add(this);
			subscribe(mls);
			this.nextStep = createInstance('MembershipLevelFlow.FinalStep');
			return this.nextStep;
		}
		
		private void subscribe(MembershipLevelState mls)
		{
			insert new Mailing_List__c(Name = mls.name, Email__c = mls.email, 
				Membership_Level__c = mls.membershipLevel);
		}
	}
	
	// UpdateMailer
	public class UpdateMailer extends FlowFactory.Step
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			MembershipLevelState mls = (MembershipLevelState) fs;
			mls.steps.add(this);
			updateM(mls);
			this.nextStep = createInstance('MembershipLevelFlow.FinalStep');
			return this.nextStep;
		}
		
		private void updateM(MembershipLevelState mls)
		{
			Mailing_List__c ml = [
				SELECT Id, Name, Email__c, Membership_Level__c 
				FROM Mailing_List__c 
				WHERE Email__c = :mls.email LIMIT 1];
			ml.Membership_Level__c = mls.membershipLevel;
			update ml;
		}
	}

	// FinalStep
	public class FinalStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			MembershipLevelState mls = (MembershipLevelState) fs;
			mls.steps.add(this);
			
			// Finalize State. DML is now possible since no additional callouts will occur.
			
			// Possible final steps include:
			// - Recording details of each of the steps 
			// - Modifying org State based on the results
			// - Logging any errors that occured
			// - Sending notifications of success/failure 
			 
			return null;
		}
	}
}
