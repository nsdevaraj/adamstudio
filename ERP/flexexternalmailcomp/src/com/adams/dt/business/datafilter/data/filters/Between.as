package com.adams.dt.business.datafilter.data.filters
{
	import mx.controls.sliderClasses.Slider;
	/**
	* A filter for values between a minimum and maximum value.
	* 
	* @author Jack Herrington
	* 
	* @example A simple HSlider filter
	<listing version="3.0">
	&lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
	xmlns:df="com.jherrington.data.~~" xmlns:f="com.jherrington.data.filters.~~"&gt;
	...
	&lt;df:FilteredArray id="outData" data="{inData}"&gt;
	&lt;df:filters&gt;
	&lt;f:Between control="{mySlider}" value="{mySlider.values}" field="myfield" /&gt;
	&lt;/df:filters&gt;
	&lt;/df:FilteredArray&gt;
	&lt;mx:HSlider id="mySlider" thumbCount="2" minimum="0" maximum="100" values="[0,100]" /&gt;
	</listing> 
	*
	* @example A range filter using a combo box
	<listing version="3.0">
	&lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
	xmlns:df="com.jherrington.data.~~" xmlns:f="com.jherrington.data.filters.~~"&gt;
	...
	&lt;df:FilteredArray id="outData" data="{inData}"&gt;
	&lt;df:filters&gt;
	&lt;f:Between control="{combo}" value="{[combo.selectedItem.low,combo.selectedItem.high]}" field="myfield" /&gt;
	&lt;/df:filters&gt;
	&lt;/df:FilteredArray&gt;
	...
	&lt;mx:ComboBox id="combo" labelField="label" selectedIndex="0"&gt;
	&lt;mx:dataProvider&gt;
	&lt;mx:Array&gt;
	&lt;mx:Object&gt;&lt;mx:low&gt;0&lt;/mx:low&gt;&lt;mx:high&gt;99&lt;/mx:high&gt;&lt;mx:label&gt;Any&lt;/mx:label&gt;&lt;/mx:Object&gt;
	&lt;mx:Object&gt;&lt;mx:low&gt;0&lt;/mx:low&gt;&lt;mx:high&gt;8&lt;/mx:high&gt;&lt;mx:label&gt;&amp;lt; 8&lt;/mx:label&gt;&lt;/mx:Object&gt;
	&lt;mx:Object&gt;&lt;mx:low&gt;8&lt;/mx:low&gt;&lt;mx:high&gt;10&lt;/mx:high&gt;&lt;mx:label&gt;8 - 10&lt;/mx:label&gt;&lt;/mx:Object&gt;
	&lt;mx:Object&gt;&lt;mx:low&gt;10&lt;/mx:low&gt;&lt;mx:high&gt;99&lt;/mx:high&gt;&lt;mx:label&gt;10+&lt;/mx:label&gt;&lt;/mx:Object&gt;
	&lt;/mx:Array&gt;
	&lt;/mx:dataProvider&gt;
	&lt;/mx:ComboBox&gt;
	</listing> 
	*/	
	public final class Between extends ControlBase
	{
		/**
		* Filters a row from the input data set
		* @param obj The object to filter
		* @return true if the object should be included in the output data set
		*/
		public override function acceptObject( obj : Object ) : Boolean
		{
			var val : Number = Number( obj[field] );
			var sld : Array = value as Array;
			if ( sld == null ) return true;
			return ( val >= sld[0] && val <= sld[1] );
		}
	}
}
