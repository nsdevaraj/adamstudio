package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.LoginUtils;
	import com.adams.dt.event.PropertiespresetsEvent;
	import com.adams.dt.event.WorkflowsEvent;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	public final class PropertiesPresetsCommand extends AbstractCommand 
	{  
		private var profileCode : String = null;
		//private var allReports : String = null;
		//private var categoryId : int = NaN;
		private var propertiespresetsEvent : PropertiespresetsEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			propertiespresetsEvent = PropertiespresetsEvent(event);
			this.delegate = DelegateLocator.getInstance().propertiespresetsDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){     
				case PropertiespresetsEvent.EVENT_BULK_UPDATE_PROPERTIESPRESETS:
					delegate.bulkUpdate(propertiespresetsEvent.propertiespresetsColl);
				 	break;
 
				 case PropertiespresetsEvent.EVENT_CREATE_PROPERTIESPRESETS:
				 	delegate.create(propertiespresetsEvent.propertiespresets);
				 	break; 
				 case PropertiespresetsEvent.EVENT_UPDATE_PROPERTIESPRESETS:
					delegate.update(propertiespresetsEvent.propertiespresets);
				 	break; 
				 case PropertiespresetsEvent.EVENT_DELETE_PROPERTIESPRESETS:
				    delegate.deleteVO(propertiespresetsEvent.propertiespresets);
				 	break; 
				 case PropertiespresetsEvent.EVENT_SELECT_PROPERTIESPRESETS:
				 	delegate.select(propertiespresetsEvent.propertiespresets);
				 	break; 
				 case PropertiespresetsEvent.EVENT_GET_ALLPROPERTY:
				 	if(model.profilesCollection.length>0){
				 			
					    if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode =='CLT')
						{
							trace("CLT ");
							var workflowevent : WorkflowsEvent = new WorkflowsEvent(WorkflowsEvent.EVENT_GET_WORKFLOWS);
							workflowevent.dispatch();
						}else if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode == 'TRA'||GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode == 'FAB')
						{
							trace("TRA ");
							var allworkflowevent : WorkflowsEvent = new WorkflowsEvent(WorkflowsEvent.EVENT_GET_ALL_WORKFLOWSS);
				  			allworkflowevent.dispatch();
						}
				 	}
					delegate.responder = new Callbacks(findAllResult,fault);
					delegate.findAll();
				 	break; 
					//Use this for making all the login sequence in server side; comment the above line;
				  case PropertiespresetsEvent.EVENT_GET_CONTAINERLOGIN:
				  	if(model.profilesCollection.length>0){	
					    profileCode = GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode;
				 	}
				 	trace("PropertiespresetsEvent.EVENT_GET_CONTAINERLOGIN calling");
					this.delegate = DelegateLocator.getInstance().pagingDelegate;
				 	delegate.responder = new Callbacks(findAllContainerResult,fault);
				 	//getHomeList(int personId,String profileCode,int domainFk,String allReports, int profilesFk) throws Exception {
					var domainCategoryId : int = model.domain.categoryId;
					var allReports : String = model.allReports;	
					var defaultProfileId : int = model.person.defaultProfile;					
					delegate.getHomeList(model.person.personId,profileCode,domainCategoryId,allReports,defaultProfileId);
				 	break;	
				default:
					break; 
				}
		} 
		public function getAllPropertiesPresetsResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.propertiespresetsCollection = rpcEvent.result as ArrayCollection;
		} 
		public function findAllResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.propertiespresetsCollection = rpcEvent.result as ArrayCollection;
			for each( var techPropPrest:Propertiespresets in rpcEvent.result as ArrayCollection ) {
				if(techPropPrest.editablePropertyPreset == 1) {
					if(techPropPrest.fieldType =="popup"){
						techPropPrest.fieldDefaultValue = String( 0 );
					}
					model.techPropPresetCollection.addItem(techPropPrest);
				}
			}
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'propertyPresetId' ) ];
			model.propertiespresetsCollection.sort = sort;
			model.propertiespresetsCollection.refresh();
		}
		
		private function findAllContainerResult( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			var containerUtils: LoginUtils  = new LoginUtils();
			var resultArrColl : ArrayCollection = new ArrayCollection();
			resultArrColl  = rpcEvent.result as ArrayCollection;
			
			trace("*******************************************************************************************");
			trace("findAllContainerResult resultArrColl:"+resultArrColl.length);			
			trace("*******************************************************************************************");
			
			 var propertyAllList:ArrayCollection 		= resultArrColl.getItemAt(0) as ArrayCollection;
			trace("propertyAllList :"+propertyAllList.length);
			var presetTemplatesAllList:ArrayCollection 	= resultArrColl.getItemAt(1) as ArrayCollection;
			trace("presetTemplatesAllList :"+presetTemplatesAllList.length);
			var workflowAllList:ArrayCollection 		= resultArrColl.getItemAt(2) as ArrayCollection;
			trace("workflowAllList :"+workflowAllList.length);
			//var projectCountList:ArrayCollection 		= resultArrColl.getItemAt(3) as ArrayCollection;
			var prjAllList:ArrayCollection 				= resultArrColl.getItemAt(3) as ArrayCollection;
			trace("prjAllList :"+prjAllList.length);
			var tasksAllList:ArrayCollection 			= resultArrColl.getItemAt(4) as ArrayCollection;
			trace("tasksAllList :"+tasksAllList.length);
			var taskMaxList:ArrayCollection 		    = resultArrColl.getItemAt(5) as ArrayCollection;
			trace("taskMaxList :"+taskMaxList.length);
			var reportAllList:ArrayCollection 		    = resultArrColl.getItemAt(6) as ArrayCollection;
			trace("reportAllList :"+reportAllList.length);
			var columnAllList:ArrayCollection 		    = resultArrColl.getItemAt(7) as ArrayCollection;
			trace("columnAllList :"+columnAllList.length); 
			
			containerUtils.findAllPropertyResult( propertyAllList ); //EVENT_GET_ALLPROPERTY
			containerUtils.findAllPresettemplate( presetTemplatesAllList ); //EVENT_GETALL_PRESETTEMPLATE
			containerUtils.findAllWorkflows( workflowAllList ); //EVENT_GET_WORKFLOWS & EVENT_GET_ALL_WORKFLOWSS
			//containerUtils.projCountResult( projectCountList ); //EVENT_GET_PROJECT_COUNT
			containerUtils.getAllProjectResult( prjAllList ); //EVENT_GET_PROJECTS
			containerUtils.getTasksResult( tasksAllList ); //EVENT_GET_PROJECTS
			containerUtils.getMaxTaskResult( taskMaxList ); //CREATE_MAX_TASKSID
			containerUtils.findAllReportResult( reportAllList ); //EVENT_GET_PROFILE_REPORTS
			containerUtils.findAllColumnResult( columnAllList ); //EVENT_GET_ALL_COLUMNS		
			 
		}	 
	}
}
