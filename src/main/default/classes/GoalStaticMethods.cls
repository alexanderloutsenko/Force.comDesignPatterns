public with sharing class GoalStaticMethods 
{
	public static final String SGOALSCHEDULE = 'GoalSchedule';

	public static GoalSchedule__c getOrCreateGoalSchedule()
	{
		GoalSchedule__c gs = getGoalSchedule();
		
		if(gs == null) // No custom setting record yet
		{
			gs = new GoalSchedule__c(Name = SGOALSCHEDULE);
			insert gs;
		}

		return gs;
	}
	
	public static GoalSchedule__c getGoalSchedule()
	{
		return GoalSchedule__c.getInstance(SGOALSCHEDULE);
	}

    public static Boolean sendEmail(String body)
    {
    	return sendEmail('Debug Info', body, new String[] {'default@emailaddress.com'});
    }

    public static Boolean sendEmail(String subject, String body, String toAddress)
    {
    	return sendEmail(subject, body, new String[] {toAddress});
    }

    public static Boolean sendEmail(String subject, String body, String[] toAddresses)
    {
    	Boolean retVal = false;
    	
        if(canEmail() && subject != null && body != null && toAddresses != null && toAddresses.size() > 0) 
        {
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              mail.setToAddresses(toAddresses);
              mail.setSubject(subject);
              mail.setPlainTextBody(body);
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              retVal = true;
        }
        
        return retVal;
    }
    
	private static Boolean canEmail()
	{
		return (System.Limits.getLimitEmailInvocations() - System.Limits.getEmailInvocations() > 0);
	}
}