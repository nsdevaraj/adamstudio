package com.jherrington.data
{
	/**
	 * The interface for the filtered data input source.
	 * @author Jack Herrington
	 */
	public interface IFilteredData
	{
		/**
		 * Adds a filter
		 * @param filter The filter
		 */
		function addFilter( filter:IDataFilter ) : void;

		/**
		 * Removes a filter
		 * @param filter The filter
		 */
		function removeFilter( filter:IDataFilter ) : void;
	}
}