package com.adams.dt.event
{
	import flash.events.Event;
	import com.adams.dt.model.vo.Companies;
	import com.universalmind.cairngorm.events.UMEvent;

	public class CompaniesEvent extends UMEvent
	{
		
		public static const EVENT_GET_ALL_COMPANIESS:String='getAllCompanies';
		public static const EVENT_GET_COMPANIES:String='getCompanies';
		public static const EVENT_CREATE_COMPANIES:String='createCompanies';
		public static const EVENT_UPDATE_COMPANIES:String='updateCompanies';
		public static const EVENT_DELETE_COMPANIES:String='deleteCompanies';
		public static const EVENT_SELECT_COMPANIES:String='selectCompanies';

		

		public var companies:Companies;
		
		public function CompaniesEvent (pType:String, pCompanies:Companies=null){
			
			companies= pCompanies;
			super(pType);
			
		}
		
		override public function clone():Event{
		
			return new CompaniesEvent(type, companies);
			
		}
 
		
	}

}