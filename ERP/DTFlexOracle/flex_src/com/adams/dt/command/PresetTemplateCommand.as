package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.PresetTemplateEvent;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	
	public class PresetTemplateCommand extends AbstractCommand
	{
		private var presetEvent : PresetTemplateEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			presetEvent = event as PresetTemplateEvent;
			this.delegate = DelegateLocator.getInstance().presetTeamplateDelegate
			this.delegate.responder = new Callbacks(result,fault);
		    switch(event.type){    
		    	case PresetTemplateEvent.EVENT_CREATE_PRESET_TEMPLATE:
		       		delegate.create(PresetTemplateEvent(event).preTemplate);
		        	break; 
		        case PresetTemplateEvent.EVENT_UPDATE_PRESET_TEMPLATE:
		       		delegate.update(PresetTemplateEvent(event).preTemplate);
		        	break;
		        case PresetTemplateEvent.EVENT_GET_PRESET_TEMPLATEID:
		        	delegate.responder = new Callbacks(getPresetTemplate,fault);
		       		delegate.findById(presetEvent.presetTemplatesId);
		        	break;
		        case PresetTemplateEvent.EVENT_GETALL_PRESETTEMPLATE:
		        	delegate.responder = new Callbacks(findAll,fault);
		       		delegate.findAll();
		        	break;
		        	
		        default:
	    			break; 
		    }  
			
		}
		public function findAll( rpcEvent : Object ) : void
		{ 
			var arrC:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.presetTempCollection =  arrC; 			
			super.result(rpcEvent);
		}
		public function getPresetTemplate( rpcEvent : Object ) : void
		{ 
			super.result(rpcEvent);
			var arrC:ArrayCollection = rpcEvent.result as ArrayCollection; 
			var presettemplate:Presetstemplates = arrC.getItemAt(0) as Presetstemplates;
			var updatePresettemplate:Presetstemplates = GetVOUtil.getPresetTemplateObject(presettemplate.presetstemplateId);
			updatePresettemplate.propertiesPresetSet = presettemplate.propertiesPresetSet;
			model.propertiespresetsCollection.refresh();
			
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
	}
}