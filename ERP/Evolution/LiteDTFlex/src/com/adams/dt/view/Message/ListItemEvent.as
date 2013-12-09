package com.adams.dt.view.Message
{
	import flash.events.Event;

	public class ListItemEvent extends Event {
		private var _targetItem:Object;

		public function ListItemEvent(type:String, targetItem:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			this._targetItem = targetItem;
			
			super(type, bubbles, cancelable);
		}

		public function get targetItem():Object {
			return this._targetItem
		}

	}
}