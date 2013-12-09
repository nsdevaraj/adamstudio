package com.adams.dt.business.datafilter.data
{
	import flash.events.IEventDispatcher;
	/**
	* The interface for all data filters that can be used by the IFilteredData data source.
	* @author Jack Herrington
	*/	
	public interface IDataFilter extends IEventDispatcher
	{
		/**
		* Filters a row from the input data set
		* @param obj The object to filter
		* @return true if the object should be included in the output data set
		*/
		function acceptObject( obj : Object ) : Boolean;
	}
}
