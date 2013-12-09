package com.adams.dt.model.vo
{
 	import com.adams.dt.utils.GetVOUtil;

	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.Sprints')]
	public final class Sprints implements IValueObject
	{
		
		private var _domainFK:int;
		public function set domainFK (value:int):void
		{
			_domainFK = value;
			categoryObject = GetVOUtil.getVOObject(value,GetVOUtil.categoryList,'categoryId',Categories) as Categories;
		}

		public function get domainFK ():int
		{
			return _domainFK;
		}
		private var _categoryObject : Categories;
		public function set categoryObject (value : Categories) : void
		{
			_categoryObject = value; 
			_domainFK = value.categoryId;
		}
		
		public function get categoryObject () : Categories
		{ 
			if(_categoryObject ==null)
			_categoryObject = GetVOUtil.getVOObject(_domainFK,GetVOUtil.categoryList,'categoryId',Categories) as Categories;
			return _categoryObject;
		}
		private var _sprintId:int;
		public function set sprintId (value:int):void
		{
			_sprintId = value;
		}

		public function get sprintId ():int
		{
			return _sprintId;
		}

		private var _sprintTask:Tasks;
		public function set sprintTask (value:Tasks):void
		{
			_sprintTask = value;
		}

		public function get sprintTask ():Tasks
		{
			return _sprintTask;
		}

		private var _taskDate:Date;
		public function set taskDate (value:Date):void
		{
			_taskDate = value;
		}

		public function get taskDate ():Date
		{
			return _taskDate;
		}

		private var _taskTimeSpent:Number;
		public function set taskTimeSpent (value:Number):void
		{
			_taskTimeSpent = value;
		}

		public function get taskTimeSpent ():Number
		{
			return _taskTimeSpent;
		}

		private var _yesterToday:String;
		public function set yesterToday (value:String):void
		{
			_yesterToday = value;
		}

		public function get yesterToday ():String
		{
			return _yesterToday;
		}
		private var _taskComments:String;
		public function set taskComments (value:String):void
		{
			_taskComments = value;
		}

		public function get taskComments ():String
		{
			return _taskComments;
		}


		
		public function Sprints()
		{
		}
	}
}