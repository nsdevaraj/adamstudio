package com.jherrington.data.filters
{
	/**
	 * Filters against an array field in the input data. If one of the items in the group is checked on
	 * then a record must have that value in the array field in order to pass. This is an 'AND' filter.
	 * 
	 * @author Jack Herrington
	 * 
	 * @example A simple checkbox filter
<listing version="3.0">
&lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
   xmlns:df="com.jherrington.data.~~" xmlns:f="com.jherrington.data.filters.~~"&gt;
...
&lt;mx:Object id="featureList"&gt;
  &lt;mx:featurea&gt;&lt;mx:Boolean&gt;false&lt;/mx:Boolean&gt;&lt;/mx:featurea&gt;
  &lt;mx:featureb&gt;&lt;mx:Boolean&gt;false&lt;/mx:Boolean&gt;&lt;/mx:featureb&gt;
&lt;/mx:Object&gt;
...
&lt;df:FilteredArray id="outData" data="{inData}"&gt;
&lt;df:filters&gt;
  &lt;f:GroupMatch control="{[checkA,checkB]}" value="{featureList}" field="myfield" /&gt;
&lt;/df:filters&gt;
&lt;/df:FilteredArray&gt;
...
&lt;mx:CheckBox id="checkA" label="Feature A" selected="false" change="{featureList.featurea=checkA.selected}" /&gt;
&lt;mx:CheckBox id="checkB" label="Feature B" selected="false" change="{featureList.featureb=checkB.selected}" /&gt;
</listing> 
	 */
	public class GroupMatch extends ControlBase
	{
		/**
		 * Filters a row from the input data set
		 * @param obj The object to filter
		 * @return true if the object should be included in the output data set
		 */
		public override function acceptObject( obj:Object ) : Boolean {
			if ( value == null ) return true;

			var objValues:Array = obj[field] as Array;

			for( var key:String in value ) {
				if ( value[key] == true ) {
					var found:Boolean = false;
					for each( var obv:String in objValues ) {
						if ( obv.localeCompare( key ) == 0 ) {
							found = true;
							break;
						}
					}
					if ( found == false )
						return false;
				}
			}

			return true;
		}
	}
}