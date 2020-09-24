@isTest
private class TestDisableTests 
{
    static testMethod void test1() 
    {
		if(TestUtils.isDisabled('TestDisableTests.test1')) return;
		TestUtils.passed();
    }
    static testMethod void test2() 
    {
		if(TestUtils.isDisabled('TestDisableTests.test2')) return;
		TestUtils.passed();
    }
    static testMethod void test3() 
    {
		if(TestUtils.isDisabled('TestDisableTests.test3')) return;
		TestUtils.passed();
    }
}