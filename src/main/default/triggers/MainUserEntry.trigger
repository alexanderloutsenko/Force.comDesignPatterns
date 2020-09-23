trigger MainUserEntry on User (after delete, after insert, after update, before delete, before insert, before update) 
{
	TriggerDispatcher.entry(new TriggerDispatcher.TriggerParameters(Trigger.isBefore, Trigger.isAfter, Trigger.isDelete, 
		Trigger.isInsert, Trigger.isUpdate, Trigger.isExecuting, Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap));
}