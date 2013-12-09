package org.spicefactory.parsley.core.scope {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.factory.impl.GlobalFactoryRegistry;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.xml.XmlContextTestBase;

import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;

import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * @author Jens Halm
 */
public class ScopeTest extends XmlContextTestBase {
	
	
	public function testLocalMessages () : void {
		var context:Context = ActionScriptContextBuilder.build(ScopeMessagingTestConfig);
		var r:LocalReceiver = context.getObjectByType(LocalReceiver) as LocalReceiver;
		assertEquals("Unexpected number of total messages", 3, r.getCount());
		assertEquals("Unexpected number of global messages", 1, r.getCount(Event, "global"));
		assertEquals("Unexpected number of local messages", 2, r.getCount(Event, "local"));
	}
	
	public function testCustomScope () : void {
		PassiveSender;
		var configA:XML = <objects xmlns="http://www.spicefactory.org/parsley">
  			<object id="senderA" type="org.spicefactory.parsley.core.scope.PassiveSender"/>
  		</objects>;
		var configB:XML = <objects xmlns="http://www.spicefactory.org/parsley">
  			<object id="senderB" type="org.spicefactory.parsley.core.scope.PassiveSender"/>
  		</objects>;
		var configC:XML = <objects xmlns="http://www.spicefactory.org/parsley">
  			<object id="senderC" type="org.spicefactory.parsley.core.scope.PassiveSender"/>
  			<object id="receiver" type="org.spicefactory.parsley.core.scope.CustomScopeReceiver"/>
  		</objects>;
  		var contextA:Context = getXmlContext(configA);
  		var contextB:Context = getXmlContext(configB, contextA, "custom");
  		var contextC:Context = getXmlContext(configC, contextB);
  		var senderA:EventDispatcher = contextC.getObject("senderA") as EventDispatcher;
  		var senderB:EventDispatcher = contextC.getObject("senderB") as EventDispatcher;
  		var senderC:EventDispatcher = contextC.getObject("senderC") as EventDispatcher;
  		var receiver:CustomScopeReceiver = contextC.getObjectByType(CustomScopeReceiver) as CustomScopeReceiver;
  		senderA.dispatchEvent(new Event("test"));
  		senderB.dispatchEvent(new Event("test"));
  		senderC.dispatchEvent(new Event("test"));
  		assertEquals("Unexpected number of total messages", 6, receiver.getCount());
		assertEquals("Unexpected number of global messages", 3, receiver.getCount(Event, "global"));
		assertEquals("Unexpected number of custom messages", 2, receiver.getCount(Event, "custom"));
		assertEquals("Unexpected number of local messages", 1, receiver.getCount(Event, "local"));
	}
	
	public function testObjectLifecycle () : void {
		HBox;
		VBox;
		var configA:XML = <objects xmlns="http://www.spicefactory.org/parsley">
  			<object type="mx.containers.HBox" lazy="true"/>
  			<object type="mx.containers.VBox" lazy="true"/>
  			<object type="mx.containers.Box" lazy="true"/>
  		</objects>;
		var configB:XML = <objects xmlns="http://www.spicefactory.org/parsley">
  			<object type="mx.containers.HBox" lazy="true"/>
  			<object type="mx.containers.VBox" lazy="true"/>
  			<object type="mx.containers.Box" lazy="true"/>
  		</objects>;
		var configC:XML = <objects xmlns="http://www.spicefactory.org/parsley">
  			<object type="mx.containers.HBox" lazy="true"/>
  			<object type="mx.containers.VBox" lazy="true"/>
  			<object type="mx.containers.Box" lazy="true"/>
  		</objects>;
  		var contextA:Context = getXmlContext(configA);
  		var contextB:Context = getXmlContext(configB, contextA, "custom");
  		var contextC:Context = getXmlContext(configC, contextB);
  		var counter:LifecycleEventCounter = new LifecycleEventCounter();
  		addListener(contextC, ScopeName.GLOBAL, counter.globalListener);
  		addListener(contextC, ScopeName.LOCAL, counter.localListener);
  		addListener(contextC, "custom", counter.customListener);
  		contextC.getAllObjectsByType(Box); // just trigger instantiation of lazy objects
  		assertEquals("Unexpected total count of listener invocations", 30, counter.getCount());
  		assertEquals("Unexpected total count of listeners for HBox", 12, counter.getCount(HBox));
  		assertEquals("Unexpected total count of listeners for VBox", 12, counter.getCount(VBox));
  		assertEquals("Unexpected total count of listeners for HBox-local", 2, counter.getCount(HBox, "local"));
  		assertEquals("Unexpected total count of listeners for HBox-custom", 4, counter.getCount(HBox, "custom"));
  		assertEquals("Unexpected total count of listeners for HBox-global", 6, counter.getCount(HBox, "global"));
  		assertEquals("Unexpected total count of listeners for Box-local", 1, counter.getCount(Box, "local"));
  		assertEquals("Unexpected total count of listeners for Box-custom", 2, counter.getCount(Box, "custom"));
  		assertEquals("Unexpected total count of listeners for Box-global", 3, counter.getCount(Box, "global"));
	}
	
	private function addListener (context:Context, scopeName:String, f:Function) : void {
		var scope:Scope = context.scopeManager.getScope(scopeName);
  		scope.objectLifecycle.addListener(Box, ObjectLifecycle.PRE_INIT, f);
  		scope.objectLifecycle.addListener(HBox, ObjectLifecycle.PRE_INIT, f);
  		scope.objectLifecycle.addListener(VBox, ObjectLifecycle.PRE_INIT, f);
	}

	public function testExtensions () : void {
		GlobalFactoryRegistry.instance.scopeExtensions.addExtension(new ScopeTestExtensionFactory());		
		var context:Context = ActionScriptContextBuilder.build(ScopeMessagingTestConfig);
		var localExtension:ScopeTestExtension
				= context.scopeManager.getScope(ScopeName.LOCAL).extensions.byType(ScopeTestExtension) as ScopeTestExtension;
		var globalExtension:ScopeTestExtension
				= context.scopeManager.getScope(ScopeName.GLOBAL).extensions.byType(ScopeTestExtension) as ScopeTestExtension;
		assertNotNull("Expected extension in global scope", globalExtension);
		assertNotNull("Expected extension in local scope", localExtension);
		assertFalse("Expected two distinct extensions", (globalExtension == localExtension));
	}
}
}

import org.spicefactory.parsley.core.factory.ScopeExtensionFactory;
import org.spicefactory.parsley.core.scope.ScopeTestExtension;
import org.spicefactory.parsley.util.MessageCounter;

import mx.containers.Box;

class ScopeTestExtensionFactory implements ScopeExtensionFactory {
	public function create ():Object {
		return new ScopeTestExtension();
	}
}

class LifecycleEventCounter extends MessageCounter {
	public function globalListener (instance:Box) : void {
		addMessage(instance, "global");
	}
	public function localListener (instance:Box) : void {
		addMessage(instance, "local");
	}
	public function customListener (instance:Box) : void {
		addMessage(instance, "custom");
	}
}

