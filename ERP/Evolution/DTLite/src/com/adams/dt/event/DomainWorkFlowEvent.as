package com.adams.dt.event
{
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.DomainWorkflow;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
		public class DomainWorkFlowEvent extends UMEvent
		{
			public static const EVENT_CREATE_DOMAIN_WORKLFLOW : String = 'createDomainWorkflow';
			public static const EVENT_GET_ALL_DOMAIN_WORKLFLOW : String ='getAllDomainWorkFlow'
			public static const BULK_UPDATE_DOMAIN_WORKLFLOW : String = 'bulkUpdateDomainWorkflow';
			public var DomainFlow :  DomainWorkflow;
			public var categories :Categories = new Categories();
			public var domainWorkFLowArr:ArrayCollection = new ArrayCollection();
			public function DomainWorkFlowEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pDomainWorkFlow : DomainWorkflow = null  )
			{ 
				DomainFlow = pDomainWorkFlow;
				super(pType,handlers,true,false,DomainFlow);
			}
	
		}
}