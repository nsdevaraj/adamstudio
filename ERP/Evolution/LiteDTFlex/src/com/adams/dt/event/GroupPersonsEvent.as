package com.adams.dt.event
{
	import com.adams.dt.model.vo.GroupPersons;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public final class GroupPersonsEvent  extends UMEvent
	{
		public static const EVENT_CREATE_GROUPPERSONS : String = 'createGroupPersons';
		public static const EVENT_BULKUPDATE_GROUPPERSONS :String = 'bulkUpdateGroupPersons'
		public var groupPersons:GroupPersons;
		public var groupPersonColl:ArrayCollection = new ArrayCollection();
		public function GroupPersonsEvent(pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pGroupPersons : GroupPersons = null )
		{
			
			groupPersons = pGroupPersons;
			super(pType,handlers,true,false,groupPersons);
		}

	}
}