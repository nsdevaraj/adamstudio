package com.adams.dt.model.tracability
{
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Tasks;
	
	import flash.filters.GlowFilter;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	[Bindable]
	public final class TaskContent
	{
		private var _holidays : Array = ["Tue Apr 21 2009 00:00:00 AM" , "Mon Apr 27 2009 00:00:00 AM" , "Wed Apr 29 2009 00:00:00 AM" , "Fri May 8 2009 00:00:00 AM"];
		private var _labelsArray:Array = [ "CreationDate", "Inprogress Date", "End Date", "Estimated Date", "Delivery Date"];
		private var _tracPhases : ArrayCollection;
		public var phasesTemplates : ArrayCollection;
		public var creationDate : Object = new Object();
		public var progressDate : Object = new Object();
		public var endDate : Object = new Object();
		public var estimatedDate : Object = new Object();
		public var deliveryDate : Object = new Object();
		public var datesArray : Array;
		public var planDates:Array;
		public var nowStart : Date;
		public var dispatchingIndex:Object;
		private var gf:GlowFilter = new GlowFilter( 0xFF9933, 1, 5, 5, 3, 3, false, false );
		
		public function get tracPhases() : ArrayCollection
		{
			return _tracPhases;
		}

		public function set tracPhases( value : ArrayCollection ) : void
		{
			_tracPhases = value;
		}
		
		public function setGlow( parentComp:UIComponent, obj:Object ) : void {
			for( var i:int = 0 ; i < parentComp.numChildren;i++ ) {
				if( parentComp.getChildAt( i ).filters != null ) {
						parentComp.getChildAt( i ).filters = null;
				}
 
			}
			dispatchingIndex = obj;
		}
		
		public function createDates( dateCollection : ArrayCollection, enableValue:Boolean ) : Array {
			var datesArray : Array = [];
			phasesTemplates = dateCollection;
			nowStart = Phases( dateCollection.getItemAt( 0 ) ).phaseStart;
			var dateCollection_Len:int=dateCollection.length;
			var tracPhase : TracPhase;
			for( var i : int = 0; i < dateCollection_Len;i++) {
				var refDate : Date;
				tracPhase = new TracPhase();
				tracPhase.phaseName = Phases( dateCollection.getItemAt( i ) ).phaseName;
				if( i == 0 ) {
					refDate = Phases( dateCollection.getItemAt( i ) ).phaseStart;
				}
				else {
					refDate = TracPhase( datesArray[ i - 1 ] ).phaseDate;
				}
				tracPhase.phaseDurationDays = Phases( dateCollection.getItemAt( i ) ).phaseDuration;
				tracPhase.phaseDelay = Phases( dateCollection.getItemAt( i ) ).phaseDelay;
				if( Phases( dateCollection.getItemAt( 0 ) ).phaseEnd ) {
					if( Phases( dateCollection.getItemAt( i ) ).phaseEnd )
						tracPhase.phaseDate = new Date( Phases( dateCollection.getItemAt( i ) ).phaseEnd.getTime() - ( tracPhase.phaseDelay * DateUtil.DAY_IN_MILLISECONDS ) );
					else
						tracPhase.phaseDate = getPlanifiedDate( refDate, ( tracPhase.phaseDurationDays - tracPhase.phaseDelay ) );	 
				}
				else {
					tracPhase.phaseDate = getPlanifiedDate( refDate, tracPhase.phaseDurationDays );
				}
				datesArray.push( tracPhase );
			}
			return datesArray;
		}
		
		public function getPlanifiedDate( refDate:Date, duration:Number ):Date {
			var returnDate:Date;
			//var addPeriod : Number = addingWeekends( new Date( refDate.getTime() + DateUtil.DAY_IN_MILLISECONDS ) , duration );
			returnDate = new Date( refDate.getTime() + ( duration * DateUtil.DAY_IN_MILLISECONDS ) );
			return returnDate;
		}
		
		public function createPlanDates( value : Tasks, selectedIndex:int ) : void {
			var tempArray : Array = [];
			creationDate.date = value.tDateCreation;
			progressDate.date = value.tDateInprogress;
			endDate.date = value.tDateEnd;
			estimatedDate.date = value.tDateEndEstimated;
			deliveryDate.date = value.tDateDeadline;
			tempArray.push( creationDate, progressDate, endDate, estimatedDate, deliveryDate );
			var sortArray:Array = [];
			for( var i:int = 0; i < tempArray.length; i++ ) {
				if( tempArray[ i ].date != null ) {
					sortArray.push( tempArray[ i ].date.getTime() );
				}
			}
			sortArray.sort( Array.NUMERIC );
			var finalArray:Array = []; 
			for( var j:int = 0; j < sortArray.length; j++ ) {
				var obj:Object = new Object();
				obj.date = new Date( sortArray[ j ] );
				if( selectedIndex == 0 )	obj.dateLabel = _labelsArray[ j ];	
				else	obj.dateLabel = datesHeadAssign( sortArray[ j ], value );
				finalArray.push( obj );
			}
			planDates = finalArray;
		}
		
		private function datesHeadAssign( value:Number, task:Tasks ):String {
			var dateHead:String;
			switch( value ) {
				case task.tDateCreation.getTime():
					dateHead = 'CreationDate';
				break;	
				case task.tDateInprogress.getTime():
					dateHead = 'Inprogress Date';
				break;
				case task.tDateEnd.getTime():
					dateHead = 'End Date';
				break;
				case task.tDateEndEstimated.getTime():
					dateHead = 'Estimated Date';
				break;
				case task.tDateDeadline.getTime():
					dateHead = 'Deadline Date';
				break;
				default:
				break;
			}
			return dateHead;
		}
		
		public function addingWeekends( refDate : Date , noOfDays : Number ) : Number
		{
			var period : Number;
			if( noOfDays < 0 )
			{
				period = noOfDays * ( - 1);
				for( var j : int = (period * ( - 1)); j > 0;j--)
				{
					var incrementDate : Date = new Date ( refDate );
					if( ( incrementDate.day == 6 ) || ( incrementDate.day == 0 ) )
					{
						period = period + 1;
					}else
					{
						period = addingGeneralHolidays( incrementDate , period ) ;
					}

					refDate = new Date( ( incrementDate.getTime() - DateUtil.DAY_IN_MILLISECONDS ) );
				}

				period = period * ( - 1);
			}else
			{
				period = noOfDays;
				for( var i : int = 0; i < period;i++)
				{
					var diminishDate : Date = new Date ( refDate );
					if( ( diminishDate.day == 6 ) || ( diminishDate.day == 0 ) )
					{
						period = period + 1;
					}else
					{
						period = addingGeneralHolidays( diminishDate , period ) ;
					}

					refDate = new Date( ( diminishDate.getTime() + DateUtil.DAY_IN_MILLISECONDS ) );
				}
			}

			return period;
		}

		private function addingGeneralHolidays( refDate : Date , noOfDays : Number ) : Number
		{
			var period : Number = noOfDays;
			var _holidays_Len:int=_holidays.length;
			for( var i : int = 0; i < _holidays_Len; i++)
			{
				var equalDate : Date = new Date( _holidays[i] );
				if( refDate.getTime() == equalDate.getTime() )
				{
					period = period + 1;
					break;
				}
			}

			return period;
		}

		public function removingWeekends( refDate : Date , noOfDays : Number ) : Number
		{
			var period : Number;
			if( noOfDays < 0 )
			{
				period = noOfDays * ( - 1);
				for( var j : int = (noOfDays * ( - 1)); j > 0;j--)
				{
					var incrementDate : Date = new Date ( refDate );
					if( ( incrementDate.day == 6 ) || ( incrementDate.day == 0 ) )
					{
						period = period - 1;
					}else
					{
						period = removingGeneralHolidays( incrementDate , period ) ;
					}

					refDate = new Date( ( incrementDate.getTime() - DateUtil.DAY_IN_MILLISECONDS ) );
				}

				period = period * ( - 1);
			}else
			{
				period = noOfDays;
				var noOfDays_Len:int=noOfDays;
				for( var i : int = 0; i < noOfDays_Len;i++)
				{
					var diminishDate : Date = new Date ( refDate );
					if( ( diminishDate.day == 6 ) || ( diminishDate.day == 0 ) )
					{
						period = period - 1;
					}else
					{
						period = removingGeneralHolidays( diminishDate , period ) ;
					}

					refDate = new Date( ( diminishDate.getTime() + DateUtil.DAY_IN_MILLISECONDS ) );
				}
			}

			return period;
		}

		private function removingGeneralHolidays( refDate : Date , noOfDays : Number ) : Number
		{
			var period : Number = noOfDays;
			var _holidays_Len:int=_holidays.length;
			for( var i : int = 0; i < _holidays_Len; i++)
			{
				var equalDate : Date = new Date( _holidays[i] );
				if( refDate.getTime() == equalDate.getTime() )
				{
					period = period - 1;
					break;
				}
			}

			return period;
		}
	}
}
