package com.jherrington.data.filters
{
	/**
	 * Filters based on an exact text match.
	 * 
	 * @author Jack Herrington
	 * 
	 * @example A simple checkbox filter
<listing version="3.0">
&lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
   xmlns:df="com.jherrington.data.~~" xmlns:f="com.jherrington.data.filters.~~"&gt;
...
&lt;df:FilteredArray id="outData" data="{inData}"&gt;
&lt;df:filters&gt;
  &lt;f:TextMatch control="{combo}" value="{combo.selecteditem.value}" field="myfield" /&gt;
&lt;/df:filters&gt;
&lt;/df:FilteredArray&gt;
...
&lt;mx:ComboBox id="combo" labelField="label"&gt;
  &lt;mx:dataProvider&gt;
    &lt;mx:Array&gt;
      &lt;mx:Object&gt;&lt;mx:value&gt;&lt;/mx:value&gt;&lt;mx:label&gt;Any&lt;/mx:label&gt;&lt;/mx:Object&gt;
      &lt;mx:Object&gt;&lt;mx:value&gt;vala&lt;/mx:value&gt;&lt;mx:label&gt;Value A&lt;/mx:label&gt;&lt;/mx:Object&gt;
      &lt;mx:Object&gt;&lt;mx:value&gt;valb&lt;/mx:value&gt;&lt;mx:label&gt;Value B&lt;/mx:label&gt;&lt;/mx:Object&gt;
    &lt;/mx:Array&gt;
  &lt;/mx:dataProvider&gt;
&lt;/mx:ComboBox&gt;
</listing> 
	 */
	public class TextMatch extends ControlBase
	{
		/**
		 * Filters a row from the input data set
		 * @param obj The object to filter
		 * @return true if the object should be included in the output data set
		 */
		public override function acceptObject( obj:Object ) : Boolean {
			var val:String = String( obj[field] );
			if ( value == null ) return true;
			var cntVal:String = String( value );
			if ( cntVal.length < 1 ) return true;
			return ( val.localeCompare(cntVal) == 0 );
		}
	}
}