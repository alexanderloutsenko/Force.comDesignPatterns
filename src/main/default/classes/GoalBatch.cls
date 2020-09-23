global with sharing class GoalBatch implements Database.Batchable<sObject>, 
	Database.Stateful, Database.AllowsCallouts
{
	global List<GoalQualifier__c> errorList {get; private set;}

	global GoalBatch()
	{
		this.errorList = new List<GoalQualifier__c>();
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		String query = 'SELECT ';
		query += 'Id, Name, Account__c, Account__r.Name, Contact__c, Contact__r.Name, Lead__c, Lead__r.Name, ';
		query += 'Opportunity__c, Opportunity__r.Name, GoalParticipant__c, GoalParticipant__r.User__c,'; 
		query += 'GoalParticipant__r.User__r.Name, CreatedDate, Status__c '; 
		query += 'FROM GoalQualifier__c '; 
		query += 'WHERE Status__c != \'Complete\' '; 
		query += 'ORDER BY CreatedDate'; 
		
		return Database.getQueryLocator(query);
	}

	// This is called with only one row at a time
	global void execute(Database.BatchableContext BC, List<sObject> objectBatch)
	{
		GoalQualifier__c gq = (GoalQualifier__c) objectBatch[0];

		if(GoalBatchExecute.mockCallout(gq))
			gq.Status__c = 'Complete';
		else
		{
			gq.Status__c = 'Incomplete';
			this.errorList.add(gq);
		}

		update gq;
	}
	
	global void finish(Database.BatchableContext BC)
	{
		if(this.errorList.size() > 0)
		{
			String body = '';
			body += 'The following goals were not processed: \n\n';
			for(GoalQualifier__c gq : this.errorList)
				body += URL.getSalesforceBaseUrl().toExternalForm() + '/' + gq.Id + '\r\n';
			GoalStaticMethods.sendEmail('Goal Errors', body, 'adam.w.purkiss@gmail.com');
		}
	}
}