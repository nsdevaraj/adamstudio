package com.adams.dt.event
{
	import com.adams.dt.model.vo.Companies;
	import com.universalmind.cairngorm.events.UMEvent;
	import mx.rpc.IResponder;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	public final class CompaniesEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_COMPANIESS : String = 'getAllCompanies';
		public static const EVENT_GET_COMPANIES : String = 'getCompanies';
		public static const EVENT_CREATE_COMPANIES : String = 'createCompanies';
		public static const EVENT_CREATE_COMPANIES_SEQ : String = 'createCompaniesSeq';
		public static const EVENT_UPDATE_COMPANIES : String = 'updateCompanies';
		public static const EVENT_DELETE_COMPANIES : String = 'deleteCompanies';
		public static const EVENT_SELECTED_COMPANY: String = 'selectedCompanyfromTool';
		public static const EVENT_SELECT_COMPANIES : String = 'selectCompanies';
		public var companies : Companies;
		
		public function CompaniesEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pCompanies : Companies = null  )
		{
			companies = pCompanies;
			super(pType,handlers,true,false,companies);
		}


	}
}
