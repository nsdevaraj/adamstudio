package org.spicefactory.lib.expr {
import org.spicefactory.lib.expr.impl.DefaultExpressionContext;
import org.spicefactory.lib.expr.impl.DefaultVariableResolver;
import org.spicefactory.lib.expr.impl.IllegalExpressionError;
import org.spicefactory.lib.expr.impl.ValueExpression;
import org.spicefactory.lib.reflect.model.ClassB;

import flexunit.framework.TestCase;	

public class ExpressionTest extends TestCase {
	
	
	private var context:ExpressionContext;
	
	
	public override function setUp () : void {
		super.setUp();
		context = new DefaultExpressionContext();
	}
	
	
	public function testLiteralExpression () : void {
		var ex:Expression = context.createExpression("literal");
		assertEquals("Unexpected expression value", "literal", ex.value);
	}
	
	public function testEscapedExpression () : void {
		var ex:Expression = context.createExpression("$\\{escaped}");
		assertEquals("Unexpected expression value", "${escaped}", ex.value);
	}
	
	public function testSimpleValueExpression () : void {
		context.setVariable("foo", 42);
		var ex:Expression = context.createExpression("${foo}");
		assertEquals("Unexpected expression value", 42, ex.value);
	}
	
	public function testSimpleProperty () : void {
		var classB:ClassB = new ClassB("foo");
		classB.readWriteProperty = "xyz";
		context.setVariable("classB", classB);
		var ex:Expression = context.createExpression("${classB.readWriteProperty}");
		assertEquals("Unexpected expression value", "xyz", ex.value);
	}
	
	public function testUnresolvableExpression () : void {
		var ex:Expression = context.createExpression("${foo}");
		try {
			ex.value;
		}
		catch (e:IllegalExpressionError) {
			/* expected */
			return;
		}
		fail("Expected IllegalExpressionError");
	}
	
	public function testChainedVariableResolver () : void {
		var vr:DefaultVariableResolver = new DefaultVariableResolver();
		vr.setVariable("foo", 1);
		context.setVariable("bar", 2);
		context.addVariableResolver(vr);
		var ex1:Expression = context.createExpression("${foo}");
		var ex2:Expression = context.createExpression("${bar}");
		assertEquals("Unexpected expression value", 1, ex1.value);
		assertEquals("Unexpected expression value", 2, ex2.value);
	}
	
	public function testCompositeExpression () : void {
		context.setVariable("foo", 42);
		var ex:Expression = context.createExpression("The Meaning of Life is ${foo}");
		assertEquals("Unexpected expression value", "The Meaning of Life is 42", ex.value);
	}
	
	public function testIllegalInt () : void {
		try {
			context.createExpression("Illegal ${expression");
		} catch (e:IllegalExpressionError) {
			return;
		}
		fail("Expected IllegalExpressionError");
	}
	
	public function testDefaultValue () : void {
		var ve:Expression = ValueExpression(context.createExpression("${foo|'bar'}"));
		assertEquals("Unexpected default value", "bar", ve.value);
	}
	
	public function testNullDefaultValue () : void {
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|null}"));
		assertNull("Expected null default value", ve.defaultValue);
	}
	
	public function testStringDefaultValue () : void {
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|'bar'}"));
		assertEquals("Unexpected default value", "bar", ve.defaultValue);
	}
	
	public function testNumberDefaultValue () : void {
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|23}"));
		assertEquals("Unexpected default value", 23, ve.defaultValue);
	}
	
	public function testExpressionDefaultValue () : void {
		context.setVariable("bar", true);
		var ve:ValueExpression = ValueExpression(context.createExpression("${foo|bar}"));
		assertEquals("Unexpected default value", true, ValueExpression(ve.defaultValue).value);
	}
	
	
}

}