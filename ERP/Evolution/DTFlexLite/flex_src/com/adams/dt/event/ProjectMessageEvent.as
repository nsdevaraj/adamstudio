package com.adams.dt.event
{
	import com.adams.dt.model.vo.Tasks;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public final class ProjectMessageEvent extends UMEvent
	{
		public static const EVENT_SEND_MESSAGETOALL : String = 'sendMessageToAll';
		public var tasks:Tasks = new Tasks();
		public var subject:String = new String();
		public var body:String = new String();
		public function ProjectMessageEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false)
		{
			super(pType,handlers,true,false);
		}

	}
}
