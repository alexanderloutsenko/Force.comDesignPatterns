@isTest
private class TestSoftAssert 
{
    static testMethod void testSoftAssert() 
    {
    	TestUtils.softAssertEquals('TEST', null);
    	TestUtils.softAssertEquals(1, 2);
    	TestUtils.softAssertEquals('apples', 'oranges');
    	TestUtils.softAssertEquals(5, 5);
    	TestUtils.softAssertEquals(6, 7);
    	TestUtils.softAssertEquals(6, 6);
    }
}