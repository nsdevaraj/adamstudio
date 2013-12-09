package com.adams.dt.model.vo
{
	import mx.collections.IList;
	
	public class SignalVO implements IValueObject
	{
		public function SignalVO(actn:String ='',destn:String ='',
								 desc:Object=null,dbid:int=0,
								 vo:IValueObject=null,dblist:IList=null,
								 nameStr:String='',receiver:Array=null)
		{
			destination = destn; 
			action = actn;
			id=dbid;
			description = desc;
			valueObject = vo;
			List = dblist;
			name =nameStr;
			receivers = receiver;
		}
		private var _receivers:Array;
		public function set receivers (value:Array):void
		{
			_receivers = value;
		}
		
		public function get receivers ():Array
		{
			return _receivers;
		}
		private var _destination:String;
		public function set destination (value:String):void
		{
			_destination = value;
		}

		public function get destination ():String
		{
			return _destination;
		}
		private var _name:String;
		public function set name (value:String):void
		{
			_name = value;
		}

		public function get name ():String
		{
			return _name;
		}
		
		private var _action:String;
		public function set action (value:String):void
		{
			_action = value;
		}

		public function get action ():String
		{
			return _action;
		}
		private var _id:int;
		public function set id (value:int):void
		{
			_id = value;
		}

		public function get id ():int
		{
			return _id;
		}

		private var _valueObject:IValueObject;
		public function set valueObject (value:IValueObject):void
		{
			_valueObject = value;
		}

		public function get valueObject ():IValueObject
		{
			return _valueObject;
		}
		
		private var _List:IList;
		public function set List (value:IList):void
		{
			_List = value;
		}

		public function get List ():IList
		{
			return _List;
		}

		private var _description:Object;
		public function set description (value:Object):void
		{
			_description = value;
		}

		public function get description ():Object
		{
			return _description;
		}
				
	}
}