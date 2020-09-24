/* TestUtils.txt file to be loaded as Static Resource to your org
{
  "key_value_map" : {
	"SoftAssert" : "on",
	"TestDisableTests.test1" : "on",
	"TestDisableTests.test2" : "on",
	"TestDisableTests.test3" : "on"
  }
}
*/

public with sharing class TestUtils 
{
	public static String currentTest = 'NULL';
	
	public static void softAssertEquals(Object o1, Object o2)
	{
		if(o1 == o2) 
			system.debug('\n\nSoft Assert Succeeded: [' + o1 + ' = ' + o2 + ']\n');
		else 
			system.debug('\n\nSoft Assert Failed: [' + o1 + ' != ' + o2 + ']\n');

		if(!isSoftAssert()) 
			system.assert(o1 == o2);
	}
	
	public static Boolean isSoftAssert()
	{
		return getItemEntry('SoftAssert') == 'on';
	}
	
	public static Boolean isDisabled(String s)
	{
		currentTest = s;
		Boolean retVal = getItemEntry(s) == 'off';
		if(retVal) system.debug('\n\n' + currentTest + ': *** DISABLED ***\n');

		return retVal;
	}
	
	public static void passed()
	{
		system.debug('\n\n' + currentTest + ': *** PASSED ***\n');
	}
	

	// Access static resource
	private class StaticJSON
	{
		public Map<String, String> key_value_map {get; set;}
    }
    
	private static String getItemEntry(String name)
	{
		List<StaticResource> staticResources = 
			[SELECT Body FROM StaticResource WHERE Name = 'TestUtils' LIMIT 1];
		if(staticResources.size() == 0) return null;

		String retVal;
		try
		{
			StaticJSON sJSON = (StaticJSON) 
				JSON.deserialize(staticResources[0].Body.toString(), StaticJSON.class);
			retVal = sJSON.key_value_map.get(name);
		}
		catch(Exception e){}

		return retVal;
	}
}
