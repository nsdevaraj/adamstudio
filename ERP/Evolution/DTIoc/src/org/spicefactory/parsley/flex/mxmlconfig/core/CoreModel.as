package org.spicefactory.parsley.flex.mxmlconfig.core {
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;

[Bindable]
/**
 * @author Jens Halm
 */
public class CoreModel {
	
	
	public var arrayProp:Array;
	
	public var refProp:InjectedDependency;
	
	public var booleanProp:Boolean;

	private var _intProp:int;
	private var _stringProp:String;
	
	
	function CoreModel (cArg1:String, cArg2:int) {
		_stringProp = cArg1;
		_intProp = cArg2;
	}
	
	
	public function get intProp ():int {
		return _intProp;
	}
	
	public function get stringProp ():String {
		return _stringProp;
	}
	
	
}
}
