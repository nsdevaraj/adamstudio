package com.adams.dt.view.components.todolistscreens
{
	import flash.events.IEventDispatcher;
	/**
	 * Interface, implemented in TodoList.as
	 */
	public interface ITodoList extends IEventDispatcher
	{
		function gotoPrevTask():void;        
		function gotoNextTask():void;
		function gotoLoopTask():void;
		function jumpTo():void;
		function updateProperties():void;
		function get property():Object;
		function set property( value:Object ):void 
	}
}
