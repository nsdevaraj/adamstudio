package com.adams.dt.event.catagoryselection
{
	import com.universalmind.cairngorm.events.UMEvent;
	public final class catagoryBreadCrumb extends UMEvent
	{
		public function catagoryBreadCrumb( CatbreadArray : Array , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false) : void
		{
			super ( catagoryEvent.CATAGORYBREAD_DATA);
			super.data = CatbreadArray;
		}
	}
}
