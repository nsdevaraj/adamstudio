package com.jherrington.data.filters
{
	import com.jherrington.data.IDataFilter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.controls.Alert;

	/**
	 * The base class for all of the filters.
	 * @author Jack Herrington
	 */	
	public class ControlBase extends EventDispatcher implements IDataFilter
	{
		private var _control:Object = null;

		private var _value:Object = null;

		private var _field:String = null;
		
		/**
		 * The control, or array of controls, to monitor for changes.
		 */
		public function get control( ) : Object {
			return _control;
		}

		/**
		 * The control, or array of controls, to monitor for changes.
		 */
		public function set control( c:Object ) : void {
			_control = c;
			if ( _control as IEventDispatcher ) {
				_control.addEventListener(Event.CHANGE, onChange);
			}
			if ( _control as Array ) {
				for each ( var cn:IEventDispatcher in _control ) {
					cn.addEventListener(Event.CHANGE, onChange);
				}
			}
		}

		/**
		 * The value to use from the control object for the filter.
		 */
		public function get value( ) : Object {
			return _value;
		}

		/**
		 * The value to use from the control object for the filter.
		 */
		public function set value( v:Object ) : void {
			_value = v;
		}
		
		/**
		 * The input field to filter on.
		 */
		public function get field( ) : String {
			return _field;
		}

		/**
		 * The input field to filter on.
		 */
		public function set field( f:String ) : void {
			_field = f;
		}
		
		/**
		 * Constructor.
		 * @remarks This class should not be instantiated. You should use on of the derived classes. Or 
		 * derive your own filter class from this class.
		 */
		public function ControlBase()
		{
		}
		
		/**
		 * Filters a row from the input data set
		 * @param obj The object to filter
		 * @return true if the object should be included in the output data set
		 */
		public virtual function acceptObject( obj:Object ) : Boolean {
			return true;
		}
		
		protected virtual function onChange( event:Event ) : void {
			dispatchEvent( new Event( Event.CHANGE ) );
		}
	}
}