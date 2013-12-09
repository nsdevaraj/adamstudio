package org.spicefactory.parsley.core.dynamiccontext {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.context.impl.DefaultContext;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;
import org.spicefactory.parsley.tag.messaging.MessageHandlerDecorator;

/**
 * @author Jens Halm
 */
public class DynamicContextTest extends ContextTestBase {

	
	public function testAddObject () : void {
		var context:Context = ActionScriptContextBuilder.build(DynamicConfig);
		checkState(context);
		var obj:AnnotatedDynamicTestObject = new AnnotatedDynamicTestObject();
		var dynContext:DynamicContext = context.createDynamicContext();
		var dynObject:DynamicObject = dynContext.addObject(obj);
		validateDynamicObject(dynObject, context);
	}
	
	public function testAddObjectAndDefinition () : void {
		var context:Context = ActionScriptContextBuilder.build(DynamicConfig);
		checkState(context);
		var obj:DynamicTestObject = new DynamicTestObject();
		var dynContext:DynamicContext = context.createDynamicContext();
		var definition:ObjectDefinition = createDefinition(dynContext);
		var dynObject:DynamicObject = dynContext.addObject(obj, definition);
		validateDynamicObject(dynObject, context);		
	}	
	
	public function testAddDefinition () : void {
		var context:Context = ActionScriptContextBuilder.build(DynamicConfig);
		checkState(context);
		var dynContext:DynamicContext = context.createDynamicContext();
		var definition:ObjectDefinition = createDefinition(dynContext);
		var dynObject:DynamicObject = dynContext.addDefinition(definition);
		validateDynamicObject(dynObject, context);
	}
	
	private function validateDynamicObject (dynObject:DynamicObject, context:Context) : void {
		assertNotNull("Unresolved dependency", dynObject.instance.dependency);
		context.scopeManager.dispatchMessage(new Object());
		dynObject.remove();
		context.scopeManager.dispatchMessage(new Object());
		assertEquals("Unexpected number of received messsages", 1, dynObject.instance.getMessageCount());			
	}
	
	private function createDefinition (context:DynamicContext) : ObjectDefinition {
		var registry:ObjectDefinitionRegistry = DefaultContext(context).registry;
		var factory:DefaultObjectDefinitionFactory = new DefaultObjectDefinitionFactory(DynamicTestObject);
		var decorator:MessageHandlerDecorator = new MessageHandlerDecorator();
		decorator.method = "handleMessage";
		factory.decorators.push(decorator);
		var definition:ObjectDefinition = factory.createNestedDefinition(registry);
		definition.properties.addTypeReference("dependency");
		return definition;
	}


	
}
}
