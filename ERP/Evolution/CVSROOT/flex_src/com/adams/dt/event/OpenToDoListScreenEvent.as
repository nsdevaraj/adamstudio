package com.adams.dt.event
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public final class OpenToDoListScreenEvent extends UMEvent
	{
		public var vo : IValueObject;
		public static const EVENT_OPEN_ORDERSCREEN : String = 'P1T01A';
		public static const EVENT_OPEN_ORDERSCREENWITHCORRECTION : String = 'P1T01B';
		public static const EVENT_OPEN_ORDERRECEPTIONSCREEN : String = 'P1T02A'; 
		public static const EVENT_OPEN_ORDERRECEPTIONSCREENCORRECTION : String = 'P1T02B';
		public static const EVENT_OPEN_TECHNICALPREPARATIONSCREEN : String = 'P1T03A';
		public static const EVENT_OPEN_TECHNICALPREPARATIONSCREENCORRECTION : String = 'P1T03B';
		public static const EVENT_OPEN_PROCESSVALIDATIONSCREEN : String = 'P2T01A';
		public static const EVENT_OPEN_PROCESSVALIDATIONSCREENCORRECTION : String = 'P2T01B';
		public static const EVENT_OPEN_PREPARATIONTECHNIQUESCREEN : String = 'P3T01A';
		public static const EVENT_OPEN_PREPARATIONTECHNIQUESCREENCORRECTION : String = 'P3T01B';
		public static const EVENT_OPEN_REALISATIONSCREEN : String = 'P3T02A';
		public static const EVENT_OPEN_REALISATIONSCREENCORRECTION : String = 'P3T02B';
		public static const EVENT_OPEN_CONTOLSCREEN : String = 'P3T03A';
		public static const EVENT_OPEN_RELECTURESCREEN : String = 'P4T01A';
		public static const EVENT_OPEN_RELECTURESCREENCORRECTION : String = 'P4T01B';
		public static const EVENT_OPEN_LANCEMENTCORRECTIONSCREEN : String = 'P4T02A';
		public static const EVENT_OPEN_LANCEMENTCORRECTIONSCREENCORRECTION : String = 'P4T02B';
		public static const EVENT_OPEN_REALISATIONCORRECTIONSCREEN : String = 'P4T03A';
		public static const EVENT_OPEN_REALISATIONCORRECTIONINCOMPLETESCREEN : String = 'P4T03B';
		public static const EVENT_OPEN_CONTROLCORRECTIONSCREEN : String = 'P4T04A';
		public static const EVENT_OPEN_RELECTURECORRECTIONSCREEN : String = 'P4T05A';
		public static const EVENT_OPEN_RELECTURECORRECTIONINCOMPLETESCREEN : String = 'P4T05B';
		public static const EVENT_OPEN_LANCEMENTLIVRAISONSCREEN : String = 'P5T01A';
		public static const EVENT_OPEN_LANCEMENTLIVRAISONSCREENCORRECTION : String = 'P5T01B';
		public static const EVENT_OPEN_DEPARTLIVRAISONSCREEN : String = 'P5T02A';
		public static const EVENT_OPEN_CLOSEPROJECTSCREEN : String = 'P5T03A';
		public static const EVENT_OPEN_VIEWMESSAGSCREEN : String = 'M01';
		public static const EVENT_OPEN_VIEWCLOSESCREEN : String = 'C01';
		public static const EVENT_OPEN_STANDBYSCREEN : String = 'SBY';
		public static const EVENT_OPEN_VIEWINDPDFSCREEN : String = 'PDF01A';
		public static const EVENT_OPEN_VIEWINDPDFSCREENB : String = 'PDF01B';
		public static const EVENT_OPEN_VIEWFABPDFSCREEN : String = 'PDF02A';
		public static const EVENT_OPEN_VIEWFABPDFSCREENB : String = 'PDF02B';
		public static var codeArr:Array = ['ORDERRECEPTION','TECHNICALPREPARATION',
		'PROCESSVALIDATION','PREPARATIONTECHNIQUE','REALISATION',
		'LANCEMENTLIVRAISON','DEPARTLIVRAISON','CLOSEPROJECT'];
		public static const OPEN_ORDERSCREEN : int=  15
		public static const OPEN_ORDERRECEPTIONSCREEN : int= 1
		public static const OPEN_TECHNICALPREPARATIONSCREEN : int= 2
		public static const OPEN_PROCESSVALIDATIONSCREEN : int= 3
		public static const OPEN_PREPARATIONTECHNIQUESCREEN : int= 4
		public static const OPEN_REALISATIONSCREEN : int= 5
		public static const OPEN_REALISATIONSCREENCORRECTION : int= 9
		public static const OPEN_CONTOLSCREEN : int= 6
		public static const OPEN_RELECTURESCREEN : int= 7
		public static const OPEN_LANCEMENTCORRECTIONSCREEN : int= 8
		public static const OPEN_REALISATIONCORRECTIONSCREEN : int= 9
		public static const OPEN_CONTROLCORRECTIONSCREEN : int= 10
		public static const OPEN_RELECTURECORRECTIONSCREEN : int= 11
		public static const OPEN_LANCEMENTLIVRAISONSCREEN : int= 12
		public static const OPEN_DEPARTLIVRAISONSCREEN : int= 13
		public static const OPEN_CLOSEPROJECTSCREEN : int= 14
		public static const OPEN_VIEWMESSAGSCREEN : int= 16
		public static const OPEN_VIEWCLOSESCREEN : int= 17
		public static const OPEN_VIEWSTANDBYSCREEN : int= 18
		public static const OPEN_VIEWINDMESSAGESCREEN : int= 19
		
		//P4T03A   
		public function OpenToDoListScreenEvent(ptype : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, vo : IValueObject = null  )
		{
			super(ptype,handlers,true,false,vo);
		
		}
	}
}
