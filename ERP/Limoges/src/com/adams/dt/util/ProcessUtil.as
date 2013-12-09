package com.adams.dt.util
{
	import com.adams.dt.model.vo.*;
	
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class ProcessUtil
	{
		public static const PONDYTIME:String ='http://www.earthtools.org/timezone/11.976188/79.785461';
		public static const LIMOGESTIME:String ='http://www.earthtools.org/timezone/0.056869/0.104628';
		public static var interval:uint;
		public static var timeDiff:int;
		public static var isCLT:Boolean;
		public static var isIndia:Boolean;
		public static var existFileSelection:Boolean = false;

		public static var month:Array =  ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","sep","Oct","Nov","Dec"]; 
		public static function getFileName( str:String ):String {
			var lastind:int = str.lastIndexOf( '/' ) + 1;
			return str.slice( lastind, str.length );
		}
		
		public static function getDomainsOnly(item:Categories):Boolean {
			var retVal:Boolean = false;
			if ( !item.categoryFK ) {
				retVal = true;
			}
			return retVal;
		}
		
		public static function startTimerFunction(func:Function,timer:int):void{
			stopTimerFunction();
			interval = setInterval(func, timer);
		}
		
		public static function stopTimerFunction():void{
			if (interval)clearInterval(interval);
		}
		
		public static function convertToByteArray( str:String ):ByteArray {
			var _byteArray:ByteArray = new ByteArray();
			_byteArray.writeUTFBytes( str );
			return _byteArray;
		}
		
		
		public static function checkTemplateExist( wTemplates:ArrayCollection, workflowTempId:int ):Boolean {
			for each ( var wTemp:Workflowstemplates in wTemplates ) {
				if( wTemp.workflowTemplateId == workflowTempId ) {
					return true;
				}
			}
			return false;
		}
		
		public static function getWorkflowTemplates(arrc : IList,config:Object):void{
			for each(var wTemp:Workflowstemplates in arrc){
				if(wTemp.optionStopLabel!=null){
					var stoplabel:Array = wTemp.optionStopLabel.split(",");
					for(var i:int=0;i<stoplabel.length;i++){
						var permissionStr:Number = Number(stoplabel[i]);
						switch(int(permissionStr)){
							case WorkflowTemplatePermission.CLOSED:
								config.closeProjectTemplate.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.ANNULATION:
								config.modelAnnulationWorkflowTemplate.addItem(wTemp); 
								break;
							case WorkflowTemplatePermission.FIRSTRELEASE:
								config.firstRelease.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.OTHERRELEASE:
								config.otherRelease.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.FILEACCESS:
								config.fileAccessTemplates.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.MESSAGE:
								config.messageTemplatesCollection.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.VERSIONLOOP:
								config.versionLoop.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.BACKTASK:
								config.backTask.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.ALARM:
								config.alarmTemplatesCollection.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.STANDBY:
								config.standByTemplatesCollection.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.SENDIMPMAIL:
								config.sendImpMailTemplatesCollection.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.PDFREADER:
								config.indReaderMailTemplatesCollection.addItem(wTemp);
								break;
							case WorkflowTemplatePermission.CHECKIMPREMIUR:
								config.checkImpremiurCollection.addItem( wTemp );	
								break;  
							case WorkflowTemplatePermission.IMPVALIDATOR:
								config.impValidCollection.addItem( wTemp );	
								break;
							case WorkflowTemplatePermission.INDVALIDATOR:
								config.indValidCollection.addItem( wTemp );	
								break;
							case WorkflowTemplatePermission.CPVALIDATOR:
								config.CPValidCollection.addItem( wTemp );	
								break;
							case WorkflowTemplatePermission.CPPVALIDATOR:
								config.CPPValidCollection.addItem( wTemp );	
								break;
							case WorkflowTemplatePermission.COMVALIDATOR:
								config.COMValidCollection.addItem( wTemp );	
								break;
							case WorkflowTemplatePermission.AGENCEVALIDATOR:
								config.AGEValidCollection.addItem( wTemp );	
								break;
							default:
								break;
						}
					} 
				}
			}
		} 
		public static function getStatusColl(arrc:IList):void{
			var taskColl:ArrayCollection = new ArrayCollection();
			var projectColl:ArrayCollection = new ArrayCollection();
			var workFLowTempColl:ArrayCollection = new ArrayCollection();
			var eventTypeColl:ArrayCollection = new ArrayCollection();
			for each(var item:Status in arrc){				
				switch(item.type){
					case StatusTypes.TASKSTATUS:
						taskColl.addItem(item);
						break;
					case StatusTypes.PROJECTSTATUS:
						projectColl.addItem(item);
						break;
					case StatusTypes.WORKFLOWTEMPLATETYPE:
						workFLowTempColl.addItem(item);
						break;
					case StatusTypes.EVENTTYPE:
						eventTypeColl.addItem(item);
						break; 
				}
			}
			TaskStatus.taskStatusColl = taskColl;
			ProjectStatus.projectStatusColl = projectColl;
			WorkflowTemplatePermission.workFlowTempStatusColl = workFLowTempColl;
			EventStatus.eventStatusColl = eventTypeColl;
		}
		
		public static function getOtherProfileCode( profileCode:String ):String {
			var returnCode:String;
			if( profileCode == Utils.PERSON_CLIENT ) {
				returnCode = Utils.PERSON_TRAFFIC;
			}
			else {
				returnCode = Utils.PERSON_CLIENT;
			}
			return returnCode;
		}
		
		public static function getMessageTemplate( profileCode:String, messageTemplateCollection:ArrayCollection ):Workflowstemplates {
			for each( var item:Workflowstemplates in  messageTemplateCollection ) {
				if( item.profileObject.profileCode == profileCode ) {
					return item;
				}
			}
			return null;
		}
		
		public static function getWorkflowTemplatesCollection( wTemplates:ArrayCollection,workflowId:int ):ArrayCollection{
			var arrC:ArrayCollection = new ArrayCollection();
			for each ( var wTemp:Workflowstemplates in wTemplates ){
				if( wTemp.workflowFK == workflowId ){
					arrC.addItem( wTemp );
					
				}
			}
			return arrC; 
		}		
	}
}