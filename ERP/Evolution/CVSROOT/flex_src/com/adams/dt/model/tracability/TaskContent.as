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
		private var _tracPhases:ArrayCollection;
		public var phasesTemplates:ArrayCollection;
		public var creationDate : Object = new Object();
		public var progressDate : Object = new Object();
		public var endDate : Object = new Object();
		public var estimatedDate : Object = new Object();
		public var deliveryDate : Object = new Object();
		public var datesArray : Array;
		public var planDates:Array;
		public var labelsArray:Array;
		public var nowStart : Date;
		public var dispatchingIndex:Object;
		private var gf:GlowFilter = new GlowFilter( 0xFF9933, 1, 5, 5, 3, 3, false, false );
		public var adjustedStartDate:Date;
		
		public function get tracPhases():ArrayCollection {
			return _tracPhases;
		}
        public function set tracPhases( value:ArrayCollection ):void {
			_tracPhases = value;
		}
		
		public function setGlow( parentComp:UIComponent, obj:Object ) : void {
			/* for( var i:int = 0 ; i < parentComp.numChildren;i++ ) {
				if( parentComp.getChildAt( i ).filters != null ) {
						parentComp.getChildAt( i ).filters = null;
				}
				if( parentComp.getChildAt( i ) is ITaskRenderer ) {
					if( ITaskRenderer( parentComp.getChildAt( i ) ).entry.selectionId == obj.selectionIndex ) {
						 if( parentComp.getChildAt( i ).width != 0  ) {
						 	parentComp.getChildAt( i ).filters = [ gf ];
						 } 	
					}
				}
			} */
			dispatchingIndex = obj;
		}
		
		public function createDates( dateCollection:ArrayCollection ):Array {
			var datesArray:Array = [];
			
			phasesTemplates = dateCollection;
			nowStart = Phases( dateCollection.getItemAt( 0 ) ).phaseStart;
			
			var dateCollection_Len:int = dateCollection.length;
			var tracPhase:TracPhase;
			
			for( var i:int = 0; i < dateCollection_Len; i++ ) {
				tracPhase = new TracPhase();
				tracPhase.phaseName = Phases( dateCollection.getItemAt( i ) ).phaseName;
				tracPhase.phaseDate = Phases( dateCollection.getItemAt( i ) ).phaseEndPlanified;
				tracPhase.phaseDurationDays = Phases( dateCollection.getItemAt( i ) ).phaseDuration;
				datesArray.push( tracPhase );
			}
			return datesArray;
		}
		
		public function getPlanifiedDate( refDate:Date, duration:Number ):Date {
			var returnDate:Date;
			returnDate = new Date( refDate.getTime() + ( duration * DateUtil.DAY_IN_MILLISECONDS ) );
			return returnDate;
		}
		
		public function createPlanDates( value:Tasks, selectedIndex:int ) : void {
			var tempArray : Array = [];
			creationDate.date = value.tDateCreation;
			progressDate.date = value.tDateInprogress;
			endDate.date = value.tDateEnd;
			estimatedDate.date = value.tDateEndEstimated;
			deliveryDate.date = value.tDateDeadline;
			tempArray.push( creationDate, progressDate, endDate, estimatedDate, deliveryDate );
			var dateArray:Array = [];
			var headerArry:Array = [];
			for( var i:int = 0; i < tempArray.length; i++ ) {
				if( tempArray[ i ].date != null ) {
					dateArray.push( new Date( tempArray[ i ].date.getTime() ) );
					headerArry.push( _labelsArray[ i ] );
				}
			}
			planDates = dateArray;
			labelsArray = headerArry;
		}
	}	
}
