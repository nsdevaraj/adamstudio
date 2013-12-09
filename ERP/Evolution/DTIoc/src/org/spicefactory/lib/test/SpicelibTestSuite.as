package org.spicefactory.lib.test {
import flexunit.framework.TestSuite;

import org.spicefactory.lib.expr.ExpressionTest;
import org.spicefactory.lib.logging.LoggingTest;
import org.spicefactory.lib.reflect.ReflectionTestBase;
import org.spicefactory.lib.task.TaskTest;
import org.spicefactory.lib.xml.PropertyMapperTest;

public class SpicelibTestSuite {
	

	public static function suite () : TestSuite {
		var suite:TestSuite = new TestSuite();
		suite.addTest(ReflectionTestBase.suite());
		suite.addTestSuite(ExpressionTest);
		suite.addTestSuite(TaskTest);
		suite.addTestSuite(LoggingTest);
		suite.addTestSuite(PropertyMapperTest);
		return suite;
	}
	
	
}

}