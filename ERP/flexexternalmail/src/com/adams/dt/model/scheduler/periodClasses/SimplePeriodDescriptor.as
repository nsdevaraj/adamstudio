package com.adams.dt.model.scheduler.periodClasses
{
	public final class SimplePeriodDescriptor implements IPeriodDescriptor
	{
		private var _date : Date;
		private var _description : Object;
		public function get date() : Date
		{
			return _date;
		}

		public function set date( value : Date ) : void
		{
			_date = value;
		}

		public function get description() : Object
		{
			return _description;
		}

		public function set description ( value : Object ) : void
		{
			_description = value;
		}
	}
}
