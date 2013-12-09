package com.adams.dt.model.scheduler.dataClasses
{
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Tasks;
	import mx.collections.ArrayCollection;
	public final class PhaseDetails
	{
		private var _phaseCollection : ArrayCollection ;
		private var _taskCollection : Array = [];
		private var _resultCollection : ArrayCollection;
		private var _phaseCheckArray : Array = [];
		[Bindable]
		public function get resultCollection() : ArrayCollection
		{
			return _resultCollection;
		}

		public function set resultCollection( value : ArrayCollection ) : void
		{
			_resultCollection = value;
			getDefinedCollection();
		}

		[Bindable]
		public function get phaseCollection() : ArrayCollection
		{
			return _phaseCollection;
		}

		public function set phaseCollection( value : ArrayCollection ) : void
		{
			_phaseCollection = value;
		}

		[Bindable]
		public function get taskCollection() : Array
		{
			return _taskCollection;
		}

		public function set taskCollection( value : Array ) : void
		{
			_taskCollection = value;
		}

		public function PhaseDetails()
		{
			super();
		}

		private function getDefinedCollection() : void
		{
			_phaseCollection = new ArrayCollection();
			var phaseArray : Array;
			var resultCollection_Len:int=resultCollection.length;
			for( var i : int = 0;i < resultCollection_Len;i++)
			{
				var tempArray : Array = resultCollection.getItemAt(i) as Array;
				var tempArray_Len:int=tempArray.length;
				for(var j : int = 0;j < tempArray_Len;j++)
				{
					if( tempArray[j] is Phases)
					{
						if( phaseChecking( Phases( tempArray[j] ).phaseCode , i ) )
						{
							phaseArray = [];
							phaseArray.push( tempArray[j] );
							phaseCollection.addItem( phaseArray  );
						}
					}else if( tempArray[j] is Tasks)
					{
						phaseArray.push( tempArray[j] );
						_taskCollection.push( tempArray[j] );
					}
				}
			}
		}

		public function phaseChecking( str : String , checkValue : int ) : Boolean
		{
			var returnValue : Boolean = true;
			if( checkValue == 0 )	_phaseCheckArray.push( str );
			else
			{
				var _phaseCheckArray_Len:int=_phaseCheckArray.length;
				for( var i : int = 0;i < _phaseCheckArray_Len;i++)
				{
					if( String( _phaseCheckArray[i] ) == str )
						returnValue = false;
				}

				if( returnValue )
				{
					_phaseCheckArray.push( str );
				}
			}

			return returnValue;
		}

		public function getPhaseDetails( phaseCode : int ) : Object
		{
			return _phaseCollection[ phaseCode ];
		}
	}
}
