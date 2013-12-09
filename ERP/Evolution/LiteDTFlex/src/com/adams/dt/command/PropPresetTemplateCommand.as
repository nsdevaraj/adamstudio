package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.PropPresetTemplateEvent;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	
	public class PropPresetTemplateCommand extends AbstractCommand 
	{
		private var proPresetTempEvt : PropPresetTemplateEvent;	
		public var propPresetTemp:Proppresetstemplates
		override public function execute( event : CairngormEvent ) : void
		{
			super.execute(event);
			this.delegate = DelegateLocator.getInstance().propPresetTemplateDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			
			 switch(event.type){     
	       		case PropPresetTemplateEvent.EVENT_DELETE_PROPPRESET_TEMPLATE:
	       		trace(model.deleteTemplateColl.length+">>>>>")
       			if(model.deleteTemplateColl.length>0){
    				propPresetTemp = Proppresetstemplates(model.deleteTemplateColl.getItemAt(0)); 
    				deletePropPresetTemplates(propPresetTemp);
    				}
			    break;
				case PropPresetTemplateEvent.EVENT_BULK_UPDATE_PROPPRESET_TEMPLATE:
        			delegate.responder = new Callbacks(bulkUpdateResult,fault);
        			if(model.updateTemplateColl.length > 0 )delegate.bulkUpdate(model.updateTemplateColl);
        		break;
        		case PropPresetTemplateEvent.EVENT_DELETE_PROPPRESET_TEMPLATE_BYID:
        			delegate.deleteVO(PropPresetTemplateEvent(event).prop_PesetTemp);
             	break;
             	case PropPresetTemplateEvent.EVENT_CREATE_PROPPRESET_TEMPLATE:
             		 delegate.responder = new Callbacks(createResult,fault);
		             delegate.create(PropPresetTemplateEvent(event).prop_PesetTemp);
		        break; 
		        case PropPresetTemplateEvent.EVENT_UPDATE_PROPPRESET_TEMPLATE:
		             delegate.update(PropPresetTemplateEvent(event).prop_PesetTemp);
		             
		        break; 
	     		default:
	    		break; 
			}
		}
		public function createResult( rpcEvent : Object ) : void
		{
			Presetstemplates(model.presetTempCollection.getItemAt(0)).propertiesPresetSet.addItem(rpcEvent.result);
		}
		public function bulkUpdateResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var arrC:ArrayCollection = rpcEvent.result as ArrayCollection;
			if(arrC.length>0){ 
				model.currentProjects.presetTemplateFK =  model.currentPresetTemplates;
				model.currentProjects.presetTemplateFK.propertiesPresetSet = arrC;
				updateTaskCollection(arrC); 
			}
			
		}
		private function updateTaskCollection(preset:ArrayCollection):void{
			var tasksCollection:ArrayCollection = new ArrayCollection();
			var domain:Categories = Utils.getDomains(model.currentProjects.categories);
			for each( var item:Object in model.taskCollection ) {
				if( item.domain.categoryId != null ) {
					if( item.domain.categoryId == domain.categoryId ){
						for each( var taskItem:Tasks in item.tasks){
							if(taskItem.projectObject.presetTemplateFK.presetstemplateId == model.currentProjects.presetTemplateFK.presetstemplateId){								
								taskItem.projectObject.presetTemplateFK.propertiesPresetSet = preset
							}
						}
						break;
					}
				}
			}
			model.taskCollection.refresh();
		}
		public function deletePropPresetTemplates(teamentry :Proppresetstemplates) : void {
    		delegate = DelegateLocator.getInstance().propertiespresetsDelegate;
    		delegate.responder = new Callbacks(deletePropPresetTempResult,fault);
    		delegate.deleteVO(teamentry); 
    	}
    	public function deletePropPresetTempResult(rpcEvent : Object) : void
		{ 
			super.result(rpcEvent);
			model.deleteTemplateColl.removeItemAt(0);
    		//model.deleteTemplateColl.refresh();
    		if(model.deleteTemplateColl.length>0){
    			var teamentry:Proppresetstemplates = Proppresetstemplates(model.deleteTemplateColl.getItemAt(0)); 
    			deletePropPresetTemplates(teamentry)
    		}
    		
		}
		public function findPropPresetTempResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
		
		}

	}
}