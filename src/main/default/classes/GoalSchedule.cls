global with sharing class GoalSchedule implements Schedulable
{
	public static final String CRON_EXP = '0 0 0-23 * * ?';
	//									   1 2 3    4 5 6
	// 1. 	Seconds
	// 2. 	Minutes
	// 3. 	Hours
	// 4.	Days of month
	// 5.	Month
	// 6.	Day of week
	// 7.	Year (optional)
	
	public interface IGoalSchedule
	{
		void execute(SchedulableContext sc);
	}
	
	global void execute(SchedulableContext sc) 
	{
		Type t = Type.forName('GoalScheduleExecute');
		if(t != null)
		{
			IGoalSchedule gs = (IGoalSchedule) t.NewInstance();
      		gs.execute(sc);
		}
	}

    //static testMethod void testExecute()
   /* @isTest static void testExecute()
	{
		Test.startTest();
		String tmpId = System.schedule('GoalScheduleTest', GoalSchedule.CRON_EXP, new GoalSchedule());
		system.assert(tmpId != null);
		Test.stopTest();
	} */
}