package org.spicefactory.parsley.flex.logging {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.logging.flex.FlexLogFactory;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.xml.XmlContextTestBase;

import mx.logging.ILoggingTarget;

public class FlexLoggingXmlTagTest extends XmlContextTestBase {

	
	
	FlexLoggingXmlSupport.initialize();
	
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley"
		xmlns:log="http://www.spicefactory.org/parsley/flex/logging"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://www.spicefactory.org/parsley http://www.spicefactory.org/parsley/schema/2.0/parsley-core.xsd http://www.spicefactory.org/parsley/flex/logging http://www.spicefactory.org/parsley/schema/2.0/parsley-logging-flex.xsd"
		>
		<log:target id="debugTarget" type="org.spicefactory.parsley.flex.logging.LogCounterTarget" level="debug">
			<log:filter>log.debug.*</log:filter>		
		</log:target>
		<log:target id="infoTarget" type="org.spicefactory.parsley.flex.logging.LogCounterTarget" level="info">
			<log:filter>log.info.*</log:filter>		
		</log:target>
		<log:target id="warnTarget" type="org.spicefactory.parsley.flex.logging.LogCounterTarget" level="warn">
			<log:filter>foo.*</log:filter>		
		</log:target>
		<log:target id="errorTarget" type="org.spicefactory.parsley.flex.logging.LogCounterTarget" level="error">
			<log:filter>log.error.*</log:filter>		
		</log:target>
		<log:target id="fatalTarget" type="org.spicefactory.parsley.flex.logging.LogCounterTarget" level="fatal">
			<log:filter>log.fatal.*</log:filter>		
		</log:target>
	</objects>;	
	
	
	public function testLogTargetConfig () : void {
		LogCounterTarget.reset();
		LogContext.factory = new FlexLogFactory(); // not necessary in application code, but this test runs together with Flash Logging Tests
		var context:Context = getXmlContext(config);
		checkState(context);
		checkObjectIds(context, ["debugTarget", "infoTarget", "warnTarget", "errorTarget", "fatalTarget"], ILoggingTarget);	
		logAllLevels();
	}
	
	
	private function logAllLevels () : void {
		basicLoggerTest("foo", 3);
		basicLoggerTest("foo.other", 3);
		basicLoggerTest("other", 0);
		basicLoggerTest("log.debug", 5);
		basicLoggerTest("log.info", 4);
		basicLoggerTest("log.error", 2);
		basicLoggerTest("log.fatal", 1);
	}
	
	private function basicLoggerTest (name:String, count:uint) : void {
		var msg:String = "The message does not matter";
		var logger:Logger = LogContext.getLogger(name);
		logger.debug(msg);
		logger.info(msg);
		logger.warn(msg);
		logger.error(msg);
		logger.fatal(msg);
		assertEquals("Unexpected log count - logger: " + name, count, LogCounterTarget.getCount(name));
	}

	
}

}