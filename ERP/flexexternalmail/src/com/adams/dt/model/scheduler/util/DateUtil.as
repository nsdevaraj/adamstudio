package com.adams.dt.model.scheduler.util
{
	import flash.utils.getTimer;
	
	public final class DateUtil
	{
		public static const MINUTE_IN_MILLISECONDS : Number = 60 * 1000;
		public static const HOUR_IN_MILLISECONDS : Number = 60 * 60 * 1000;
		public static const DAY_IN_MILLISECONDS : Number = 24 * 60 * 60 * 1000;
		public static const WEEK_IN_MILLISECONDS : Number = 7 * 24 * 60 * 60 * 1000;
		public static const MONTH_IN_MILLISECONDS : Number = 30 * 24 * 60 * 60 * 1000;
		public static const YEAR_IN_MILLISECONDS : Number = 12 * 30 * 24 * 60 * 60 * 1000;
		public static const CENTURY_IN_MILLISECONDS : Number = 100 * 12 * 30 * 24 * 60 * 60 * 1000;
		public static const MILLENIUM_IN_MILLISECONDS : Number = 1000 * 100 * 12 * 30 * 24 * 60 * 60 * 1000;
		public static function clearTime( date : Date ) : Date
		{
			date.hours = 0;
			date.minutes = 0;
			date.seconds = 0;
			date.milliseconds = 0;
			return date;
		}

		public static function copyDate( date : Date ) : Date
		{
			return new Date( date.getTime() );
		}

		public static function setTime( date : Date , time : Number ) : Date
		{
			date.hours = Math.floor(( time / (1000 * 60 * 60)) % 24);
			date.minutes = Math.floor(( time / (1000 * 60)) % 60);
			date.seconds = Math.floor(( time / 1000) % 60);
			date.milliseconds = Math.floor( time % 1000);
			return date;
		}

		public static function addTime( date : Date , time : Number ) : Date
		{
			date.milliseconds += time;
			return date;
		}

		public static function setCurrentDate( date : Date , milliSeconds : Number , refNo : Number , startValue : Number ) : Date
		{
			var currentDate : Date;
			if( milliSeconds == DateUtil.YEAR_IN_MILLISECONDS )
			{
				currentDate = new Date( refNo * ( 366 * DateUtil.DAY_IN_MILLISECONDS ) + startValue );
			}else if( milliSeconds == DateUtil.MONTH_IN_MILLISECONDS )
			{
				var noOfDays : Number = 0;
				var yearValue : Number;
				var refNo_Len:int=refNo;
				for( var i : int = 0; i < refNo_Len; i++)
				{
					noOfDays += DateUtil.traceMonth( ( i % 12 ) , date.fullYear , date );
				}

				currentDate = new Date( ( noOfDays * DateUtil.DAY_IN_MILLISECONDS ) + startValue );
			}

			return currentDate;
		}

		public static function traceMonth( monthIndex : Number , yearValue : Number , date : Date ) : Number
		{
			var noOfDays : Number;
			if( ( monthIndex == 3 ) || ( monthIndex == 5 ) || ( monthIndex == 8 ) || ( monthIndex == 10 ) )
			{
				noOfDays = 30;
			}else if( monthIndex == 1 )
			{
				var leapYear : Boolean = DateUtil.isLeapYear( yearValue );
				if( leapYear )	noOfDays = 29;
				else noOfDays = 28;
			}else
			{
				noOfDays = 31;
			}

			return noOfDays;
		}

		public static function isLeapYear( yearValue : Number ) : Boolean
		{
			var year : Boolean;
			if( ( yearValue % 4 ) == 0 )	year = true;
			return year;
		}
		
		public static function dateCompare( date1:Date, date2:Date ):Number {
			var result : Number = -1;
			var date1Timestamp:Number = date1.getDate();
			var	date2Timestamp:Number = date2.getDate();
			if( date1Timestamp == date2Timestamp ) 
		    	result = 0;
		   	return result;
		}
		
		public static function weekCompare( date1:Date, date2:Date ):Number {
			var result : Number = -1;
			var date1Timestamp:Number = date1.getTime();
			var	date2Timestamp:Number = date2.getTime();
			var compareTime:Number = new Date( date2Timestamp - DateUtil.WEEK_IN_MILLISECONDS ).getTime();
			if( ( date1Timestamp >= compareTime) && ( date1Timestamp <= date2Timestamp ) ) 
		    	result = 0;
		    return result;
		}
		
		public static function monthCompare( date1:Date, date2:Date ):Number {
			var result : Number = -1;
			var date1Timestamp:Number = date1.getMonth();
			var	date2Timestamp:Number = date2.getMonth();
			if( date1Timestamp == date2Timestamp ) 
		    	result = 0;
		    return result;
		}
		
		public static function yearCompare( date1:Date, date2:Date ):Number {
			var result : Number = -1;
			var date1Timestamp:Number = date1.getFullYear();
			var	date2Timestamp:Number = date2.getFullYear();
			if( date1Timestamp == date2Timestamp ) 
		    	result = 0;
		    return result;
		}
		
	}
}
