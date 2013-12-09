package com.adams.dt.event
{
	import com.adams.dt.model.vo.Reports;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class ReportEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_REPORTS : String = 'getAllReports';
		public static const EVENT_GET_PROFILE_REPORTS : String = 'getProfileReports';
		public static const EVENT_GET_REFERENCE_REPORTS : String = 'getReferenceReports';
		public static const EVENT_CREATE_REPORTS : String = 'createReports';
		public static const EVENT_UPDATE_REPORTS : String = 'updateReports';
		public static const EVENT_ORDER_COLUMNS : String = 'orderColumns';
		public static const EVENT_UPDATE_COLUMNS : String = 'updateColumns';
		public static const EVENT_DELETE_REPORTS : String = 'deleteReports';
		
		public var reportentry :Reports;
		public var profileFk :int;
		public var reportsCollection : ArrayCollection = new ArrayCollection();
		public function ReportEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, preport : Reports = null )
		{
			reportentry = preport;
			super(pType,handlers,true,false,reportentry);
		}
	}
}
