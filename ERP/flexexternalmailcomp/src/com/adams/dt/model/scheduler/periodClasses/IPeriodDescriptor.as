package com.adams.dt.model.scheduler.periodClasses
{
	public interface IPeriodDescriptor
	{
		function get date() : Date;
		function set date( value : Date ) : void;
		function get description() : Object;
		function set description ( value : Object ) : void;
	}
}
