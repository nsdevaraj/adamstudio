package com.adams.dt.util
{
	public class GridUtils
	{
		
		public static const YEAR_MODE:String = 'Year';
		public static const MONTH_MODE:String = 'Month';
		public static const WEEK_MODE:String = 'Week';
		public static const DAY_MODE:String = 'Day';
		public static const HOUR_MODE:String = 'Hour';
		public static const MINUTE_MODE:String = 'Minute';
		
		public static const MAX_YEAR_IN_SINGLVIEW:Number = 1;
		public static const MAX_MONTH_IN_SINGLVIEW:Number = 3;
		public static const MAX_WEEK_IN_SINGLVIEW:Number = 4;
		public static const MAX_DAY_IN_SINGLVIEW:Number = 7;
		public static const MAX_HOUR_IN_SINGLVIEW:Number = 6;
		public static const MAX_MINUTE_IN_SINGLVIEW:Number = 15;
		
		public static function getItem( mode:String, startIndex:Number, gridStartDate:Date ):Object {
			var returnObject:Object;
			switch( mode ) {
				case YEAR_MODE:
					returnObject = gridStartDate.fullYear + startIndex;
					break;
				case MONTH_MODE:
					returnObject = DateUtil.getMonthOnIndex( startIndex, gridStartDate.fullYear );
					break;
				case WEEK_MODE:
					returnObject = DateUtil.getWeekOnIndex( startIndex, gridStartDate );
					break;
				case DAY_MODE:
					returnObject = DateUtil.getDayOnIndex( startIndex, gridStartDate );
					break;
				case HOUR_MODE:
					returnObject = DateUtil.getHourOnIndex( startIndex, gridStartDate );
					break;
				case MINUTE_MODE:
					break;
				default:
					break;
			}
			return returnObject;
		}
		
		public static function availableColumns( startIndex:Number, length:Number ):Array {
			var coloumnsArray:Array = [];
			for( var i:Number = startIndex; i <= length; i++ ) {
				coloumnsArray.push( i );
			}
			return coloumnsArray;
		}
	}
}