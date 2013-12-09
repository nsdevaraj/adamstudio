package com.adams.pdf.util
{
	import com.adams.swizdao.util.DateUtils;
	
	import mx.formatters.DateFormatter;
	
	public final class DateUtil
	{
		public static const MINUTE_IN_MILLISECONDS : Number = 60 * 1000;
		public static const HOUR_IN_MILLISECONDS : Number = 60 * 60 * 1000;
		public static const DAY_IN_MILLISECONDS : Number = 24 * 60 * 60 * 1000;
		public static const WEEK_IN_MILLISECONDS : Number = 7 * 24 * 60 * 60 * 1000;
		public static const MONTH_IN_MILLISECONDS : Number = 30 * 24 * 60 * 60 * 1000;
		public static const YEAR_IN_MILLISECONDS : Number = 365 * DAY_IN_MILLISECONDS;
		public static const CENTURY_IN_MILLISECONDS : Number = 100 * 12 * 30 * 24 * 60 * 60 * 1000;
		public static const MILLENIUM_IN_MILLISECONDS : Number = 1000 * 100 * 12 * 30 * 24 * 60 * 60 * 1000;
		
		public static const  MONTHES:Array = [ "January","February","March","April","May","June","July","August","September","October","November","December" ];
		
		public static var dateFormatter:DateFormatter;
		
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
		
		public static function isLeapYear( yearValue:Number ):Boolean {
			var year:Boolean;
			if( ( yearValue % 4 ) == 0 )	{
				year = true;
			}
			return year;
		}
		
		public static function totalNoOfDays( startYear:Number, endYear:Number ):Number {
			var noOfDays:Number = 0;
			for( var i:Number = startYear; i <= endYear; i++ ) {
				if( isLeapYear( i ) ) {
					noOfDays += 366;
				}
				else {
					noOfDays += 365;
				}
			}
			return noOfDays;
		} 
		
		public static function getDaysofMonths( monthIndex:Number, fullYear:Number ):Number {
			var days:Number = 0;
			if( isLeapYear( fullYear ) && ( monthIndex == 1 ) ) {
				days = 29;
			}
			if( !isLeapYear( fullYear ) && ( monthIndex == 1 ) ) {
				days = 28;
			}
			else if( monthIndex == 0 || 
				monthIndex == 2 ||
				monthIndex == 4 ||
				monthIndex == 6 ||
				monthIndex == 7 ||
				monthIndex == 11 ) {
				days = 31;
			}
			else {
				days = 30;
			}		
			return days;	
		}
		
		public static function getMonthOnIndex( index:Number, startYear:Number ):String {
			var month:String = '';
			var year:Number = Math.floor( index / 12 );
			var exceededMonth:Number = index % 12;
			month = MONTHES[ exceededMonth ] +", " + String( startYear + year );
			return month;
		}
		
		public static function getWeekOnIndex( index:Number, startDate:Date ):String {
			return getFormattedDate( new Date( startDate.getTime() + ( index * WEEK_IN_MILLISECONDS ) ) );
		}
		
		public static function getDayOnIndex( index:Number, startDate:Date ):String {
			return getFormattedDate( new Date( startDate.getTime() + ( index * DAY_IN_MILLISECONDS ) ) );
		}
		
		public static function getHourOnIndex( index:Number, startDate:Date ):String {
			var meridian:Array = [ 'am', 'pm' ];
			var hour:String = '';
			var date:Number = Math.floor( index / 24 );
			var exceededDate:Number = index % 24;
			var returnValue:String = '';
			if( exceededDate == 0 ) {
				returnValue = '12' + meridian[ 0 ];
			}
			else if( exceededDate == 12 ) {
				returnValue = '12' + meridian[ 1 ];
			}
			else if( exceededDate <= 11 ) {
				returnValue = exceededDate + meridian[ 0 ];
			}
			else if( exceededDate > 12 ) {
				returnValue = ( exceededDate  % 12 ) + meridian[ 1 ];
			}
			return ( getFormattedDate( new Date( startDate.getTime() + ( date * DAY_IN_MILLISECONDS ) ) ) + ' - ' + returnValue );
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
		
		public static function getFormattedDate( date:Date ):String {
			if( !dateFormatter ) {
				dateFormatter = new DateFormatter();
				dateFormatter.formatString = 'DD/MM/YYYY';
			}
			return dateFormatter.format( date.toDateString() );
		}
		
		public static function getFileIdGenerator():String {
			var now:Date = new Date();
			var date:String = String( now.date );
			var month:String = String( now.getMonth() );
			var year:String = String( now.fullYear );
			var hours:String = String( now.getHours() );
			var min:String = String( now.getMinutes() );
			var sec:String = String( now.getSeconds() );
			var milliSec:String = String( now.getUTCMilliseconds() );
			return ( date + month + year + hours + min + sec + milliSec );
		}
		
		public static function weekEndRemovalOfSelectedDate( startDate:Date, duration:Number ):int {
			var returnValue:int;
			for( var i:Number = 1; i <= duration; i++ ) {
				var tempDate:Date = new Date( startDate.getTime() + ( i * DateUtil.DAY_IN_MILLISECONDS ) );
				if( ( tempDate.day != 0 ) && ( tempDate.day != 6 ) ) {
					returnValue++;
				}
			}
			return returnValue;
		}
		
		public static function dateToString(frenchTime:Date):String{
			return frenchTime.date+'-'+DateUtils.shortmonths[frenchTime.month]+'-'+frenchTime.fullYear+' '+zeroPad(DateUtils.getHoursAmPm(frenchTime.hours).hours)+':'+zeroPad(frenchTime.minutes)+':'+zeroPad(frenchTime.seconds)+ ' '+DateUtils.getHoursAmPm(frenchTime.hours).ampm;
		}
		
		public static function zeroPad(number:int):String {
			var ret:String = ""+number;
			while( ret.length < 2 )
				ret="0" + ret;
			return ret;
		}
		
		public static function weekEndRemovalOfPeriod( startDate:Date, duration:Number ):Date {
			var tempDate:Date = startDate;
			for( var i:Number = 1; i <= duration; i++ ) {
				tempDate = new Date( tempDate.getTime() + DateUtil.DAY_IN_MILLISECONDS );
				while( ( tempDate.day == 0 ) || ( tempDate.day == 6 ) ) {
					tempDate = new Date( tempDate.getTime() + DateUtil.DAY_IN_MILLISECONDS );
				}
			}
			return tempDate;
		}
	}
}