package com.adams.dt.model.scheduler.util
{
	import com.adams.dt.model.scheduler.periodClasses.IPeriodDescriptor;
	import com.adams.dt.model.scheduler.periodClasses.SimplePeriodDescriptor;
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	public final class PeriodRangeDescriptorUtil
	{
		public static var defaultTimeRangeDescriptor : Array = [ [ 15 *  DateUtil.MINUTE_IN_MILLISECONDS, "L:NNAA" ], [ 1 *  DateUtil.HOUR_IN_MILLISECONDS, "L:NNAA" ], [ 1 * DateUtil.DAY_IN_MILLISECONDS , "DD/MM/YY" ], [ 7 * DateUtil.DAY_IN_MILLISECONDS , "DD/MM/YY" ], 
		   														 [ 1 * DateUtil.MONTH_IN_MILLISECONDS , "MMM YY" ] , [ 1 * DateUtil.YEAR_IN_MILLISECONDS , "YYYY" ] ];
		public static function convertArrayToTimeRangeDescriptor( periodDescriptor : Array ) : IList
		{
			var dataProvider : IList = new ArrayCollection();
			var len : Number = periodDescriptor.length;
			for( var i : Number = 0; i < len; i++)
			{
				var item : Array = periodDescriptor[ i ];
				var entry : IPeriodDescriptor = new SimplePeriodDescriptor();
				entry.date = new Date( item[ 0 ] );
				entry.description = item[ 1 ];
				dataProvider.addItem( entry );
			}

			return dataProvider;
		}

		public static function getDefaultTimeRangeDescriptor() : IList
		{
			return PeriodRangeDescriptorUtil.convertArrayToTimeRangeDescriptor( defaultTimeRangeDescriptor );
		}
	}
}
