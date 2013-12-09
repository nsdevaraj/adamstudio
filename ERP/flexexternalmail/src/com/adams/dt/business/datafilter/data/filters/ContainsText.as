package com.adams.dt.business.datafilter.data.filters
{
	/**
	* A filter for text fields that filters for text provided from the user by a TextInput field.
	* 
	* @author Jack Herrington
	* 
	* @example A simple text filter
	<listing version="3.0">
	&lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
	xmlns:df="com.jherrington.data.~~" xmlns:f="com.jherrington.data.filters.~~"&gt;
	...
	&lt;df:FilteredArray id="outData" data="{inData}"&gt;
	&lt;df:filters&gt;
	&lt;f:ContainsText control="{myTextInput}" value="{myTextInput.text}" field="myfield" /&gt;
	&lt;/df:filters&gt;
	&lt;/df:FilteredArray&gt;
	...
	&lt;mx:TextInput id="myTextInput" /&gt;
	</listing> 
	*
	*/	
	public final class ContainsText extends ControlBase
	{
		/**
		* Filters a row from the input data set
		* @param obj The object to filter
		* @return true if the object should be included in the output data set
		*/
		public override function acceptObject( obj : Object ) : Boolean
		{
			var val : String = String( obj[field] );
			if ( value == null ) return true;
			var cntVal : String = String( value );
			if ( cntVal.length < 1 ) return true;
			var re : RegExp = new RegExp( cntVal , 'i' );
			return ( re.test( val ) );
		}
	}
}
