package org.spicefactory.lib.reflect.model {

import org.spicefactory.lib.reflect.ns.test_namespace;
	
public class ClassB extends ClassA {
	
	
	private var _booleanProperty:Boolean;
	
	test_namespace var filteredVar:String;
	
	private static var staticCnt:int = 0;
	
	
	function ClassB (readOnlyProp:String) {
		super(readOnlyProp);
	}
	
	
	public function get booleanProperty () : Boolean {
		return _booleanProperty;
	}
	
	public function set booleanProperty (value:Boolean) : void {
		_booleanProperty = value;
	}
	
	
	public static function staticMethod (aParam:Boolean) : void {
		staticCnt++;
	}
	
	public static function getStaticMethodCounter () : int {
		return staticCnt;
	}

	
	public static function get staticReadOnlyProperty () : XML {
		return null;
	}
	
	test_namespace function filteredMethod () : void {
		
	}
	
	test_namespace function get filteredProperty () : Object {
		return null;
	}
	
	public function methodWithPrivateClassReturnValue () : Foo {
		return null;
	}
	
	
}

}

class Foo {}
