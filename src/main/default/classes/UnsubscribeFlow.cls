public with sharing class UnsubscribeFlow extends FlowFactory.FlowParent
{
	// Main Entry
	public UnsubscribeState processWork(Contact c)
	{
		if(c.Email == null) return null;
		
		UnsubscribeState state = new UnsubscribeState(c.Email);
		FlowFactory.Step step = new FirstStep();
		step.stepName = 'UnsubscribeFlow.FirstStep';
		processSteps(step, state);

		return state;
	}

	// State
	public class UnsubscribeState extends FlowFactory.FlowState
	{
		public String email {get; set;}
		
		public UnsubscribeState(String email)
		{
			this.email = email;
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
			UnsubscribeState us = (UnsubscribeState) fs;
			us.steps.add(this);			
			if(subscribedToMailer(us))
				this.nextStep = createInstance('UnsubscribeFlow.Unsubscribe');
			else
				this.nextStep = createInstance('UnsubscribeFlow.FinalStep');

			return this.nextStep;
		}

		private Boolean subscribedToMailer(UnsubscribeState us)
		{
			return ([SELECT count() FROM Mailing_List__c WHERE Email__c = :us.email LIMIT 1] == 1);
		}
	}
	
	// Unsubscribe
	public class Unsubscribe extends FlowFactory.Step
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			UnsubscribeState us = (UnsubscribeState) fs;
			us.steps.add(this);
			unsubscribeEmail(us);
			this.nextStep = createInstance('UnsubscribeFlow.FinalStep');
			return this.nextStep;
		}
		
		private void unsubscribeEmail(UnsubscribeState us)
		{
			delete [SELECT Id FROM Mailing_List__c WHERE Email__c = :us.email];
		}
	}

	// FinalStep
	public class FinalStep extends FlowFactory.Step 
	{
		public override FlowFactory.Step processStep(FlowFactory.FlowState fs)
		{
			UnsubscribeState us = (UnsubscribeState) fs;
			us.steps.add(this);
			return null;
		}
	}
}