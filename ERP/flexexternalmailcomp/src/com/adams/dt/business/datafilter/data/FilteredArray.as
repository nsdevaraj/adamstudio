package com.adams.dt.business.datafilter.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	/**
	* The FilteredArray class provides an observable data source that takes one array as input, as well as a list
	* of filters, then outputs a filtered array to any observers.
	* 
	* @author Jack Herrington
	* 
	* @example A simple data source example
	<listing version="3.0">
	&lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
	xmlns:df="com.jherrington.data.~~" xmlns:f="com.jherrington.data.filters.~~"&gt;
	...
	&lt;df:FilteredArray id="outData" data="{inData}"&gt;
	&lt;df:filters&gt;
	&lt;f:Between control="{mySlider}" value="{mySlider.values}" field="myfield" /&gt;
	&lt;/df:filters&gt;
	&lt;/df:FilteredArray&gt;
	...
	&lt;mx:HSlider id="mySlider" thumbCount="2" minimum="0" maximum="100" values="[0,100]" /&gt;
	...
	&lt;mx:DataGrid dataProvider="{outData}" /&gt;
	</listing> 
	*/
	public final class FilteredArray extends EventDispatcher implements IList , IFilteredData
	{
		/**
		* The 'mark' mode tells the filter to add a new field to each record with a boolean
		* mark value instead of add or removing the record from the output data set.
		* This field is specifed with the 'markField' attribute.
		*/
		public static const MARK : String = "mark";
		/**
		* The 'remove' mode is the default mode. In this mode the filter removes records 
		* that don't fit the filter criteria.
		*/
		public static const REMOVE : String = "remove";
		private var _originalData : Array = [];
		private var _filteredData : Array = [];
		private var _filterList : Array = [];
		private var _mode : String = REMOVE;
		private var _markField : String = "visible";
		/**
		* The mode of the filter. Either 'mark' to mark records. Or 'remove' to add/remove
		* records. The default value is 'remove'.
		*/
		[Inspectable(enumeration = "mark,remove" , defaultValue = "remove")]
		public function set mode( m : String ) : void
		{
			_mode = m;
		}

		/**
		* The mode of the filter. Either 'mark' to mark records. Or 'remove' to add/remove
		* records. The default value is 'remove'.
		*/
		[Inspectable(enumeration = "mark,remove" , defaultValue = "remove")]
		public function get mode( ) : String
		{
			return _mode;
		}

		/**
		* The name of the field that will be set by the filter if it's in 'mark' mode.
		*/
		public function set markField( m : String ) : void
		{
			_markField = m;
		}

		/**
		* The name of the field that will be set by the filter if it's in 'mark' mode.
		*/
		public function get markField( ) : String
		{
			return _markField;
		}

		/**
		* The filters this object should apply to the input data set to create the output
		* data set.
		*/		
		[ArrayElementType("com.jherrington.data.IDataFilter")]
		public function set filters( fls : Array ) : void
		{
			for each ( var f : IDataFilter in fls )
				addFilter( f );
		}

		/**
		* The input data
		*/
		[ArrayElementType("Object")]
		public function set data( dataArray : Array ) : void
		{
			_originalData = dataArray;
			filterData();
		}

		/**
		* The input data
		*/
		[ArrayElementType("Object")]
		public function get data( ) : Array
		{
			return _originalData;
		}

		/**
		* Constructor.
		*/		
		public function FilteredArray()
		{
			super;
		}

		/**
		* Filters the data.
		*/
		private function filterData() : void
		{
			_filteredData = [];
			for each( var obj : Object in _originalData )
			{
				var valid : Boolean = true;
				for each( var f : IDataFilter in _filterList )
				{
					if ( f.acceptObject( obj ) == false )
					{
						valid = false;
						break;
					}
				}

				if ( mode == REMOVE )
				{
					if ( valid )
						_filteredData.push( obj );
				}else
				{
					obj[ markField ] = valid;
					_filteredData.push( obj );
				}
			}

			dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_CHANGE ) );
			dispatchEvent( new CollectionEvent( Event.CHANGE ) );
		}

		/**
		* Handles the filter change event.
		*/		
		private function onFilterChange( event : Event ) : void
		{
			filterData();
		}

		/**
		* Adds a filter
		*/
		public function addFilter( filter : IDataFilter ) : void
		{
			if ( _filterList.indexOf( filter ) < 0 )
			{
				filter.addEventListener( Event.CHANGE , onFilterChange , false , 0 , true);
				_filterList.push( filter );
				filterData();
			}
		}

		/**
		* Removes a filter
		*/
		public function removeFilter( filter : IDataFilter ) : void
		{
		}

		/**
		* Returns the length of the data
		*/
		public function get length() : int
		{
			return _filteredData.length;
		}

		/**
		* Adds an item. But in this object it does nothing.
		*/
		public function addItem(item : Object) : void
		{
		}

		/**
		* Adds an item. But in this object it does nothing.
		*/
		public function addItemAt(item : Object , index : int) : void
		{
		}

		/**
		* Returns the item at the specified index.
		*/		
		public function getItemAt(index : int , prefetch : int = 0) : Object
		{
			return _filteredData[ index ];
		}

		/**
		* Returns the index for the specified item.
		*/
		public function getItemIndex(item : Object) : int
		{
			var ind : int = 0;
			for each ( var obj : Object in _filteredData )
			{
				if ( obj == item ) return ind;
				ind++;
			}

			return - 1;
		}

		/**
		* Handles an item updated notification. Ignored by this class.
		*/
		public function itemUpdated(item : Object , property : Object = null , oldValue : Object = null , newValue : Object = null) : void
		{
		}

		/**
		* Removes all items. Ignored by this class.
		*/
		public function removeAll() : void
		{
		}

		/**
		* Removes an item at a specific location. Ignored by this class.
		*/
		public function removeItemAt(index : int) : Object
		{
			return null;
		}

		/**
		* Sets an item at a specific location. Ignored by this class.
		*/
		public function setItemAt(item : Object , index : int) : Object
		{
			return null;
		}

		/**
		* Converts the filtered data set to an array.
		*/
		public function toArray() : Array
		{
			return _filteredData;
		}
	}
}
