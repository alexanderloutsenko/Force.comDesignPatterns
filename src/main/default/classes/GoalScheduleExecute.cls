public with sharing class GoalScheduleExecute implements GoalSchedule.IGoalSchedule
{
	public void execute(SchedulableContext sc)
	{
		processQueue();
	}
	
	public static void processQueue()
	{
		// Only launch if we've got records in the queue
		if([SELECT count() FROM GoalQualifier__c WHERE Status__c != 'Complete' LIMIT 1] == 1)
		{
			GoalSchedule__c gs = GoalStaticMethods.getOrCreateGoalSchedule();
			
			// Make sure a batch isn't already processing
			if(gs.BatchId__c == null || (gs.BatchId__c != null && [
				SELECT count() 
				FROM AsyncApexJob 
				WHERE (Status = 'Queued' OR Status = 'Processing' OR Status = 'Preparing') 
				AND Id = :gs.BatchId__c] == 0))
			{
				// Make sure we've got a batch slot available to work with
				if(([SELECT count() FROM AsyncApexJob WHERE Status = 'Queued' OR Status = 'Processing' OR Status = 'Preparing'] < 5))
				{
					GoalBatch gb = new GoalBatch();
					gs.BatchId__c = Database.executeBatch(gb, 1); // One object per batch
					update gs;
				}
			}
		}
	}
}