package com.adams.dt
{
	import com.adams.dt.commands.*;
	import com.adams.dt.model.collections.*;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.service.*;
	import com.adams.dt.signals.*;
	import com.adams.dt.utils.GetVOUtil;
	import com.adams.dt.view.models.*;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class DTContext extends SignalContext
	{
		private const VIEW_PACKAGE:String = "com.adams.dt.view"; 

		override public function startup():void
		{
			viewMapping();
			modelMapping();
			signalMapping();  
			commandMapping(); 
			collectionMapping();
			bootStrap(); 
		}
		private function viewMapping():void
		{
			viewMap.mapPackage(VIEW_PACKAGE);
		}
		private function modelMapping():void
		{
			injector.mapSingleton(CurrentInstanceVO );
			injector.mapSingletonOf(IPersonPresentationModel, PersonPresentationModel );
			injector.mapSingletonOf(IDTService, DTService );
			//injector.mapClass(ICollection, AbstractCollection);
		}
		private function signalMapping():void
		{
			injector.mapSingleton(InitSignal);
			injector.mapSingleton(GetVOUtil);
			injector.mapSingleton(ServiceSignal);
			injector.mapSingleton(ResultSignal);
			injector.mapSingleton(LoginSignal);
			injector.mapSingleton(SignalSequence);
		}
		private function commandMapping():void
		{
			signalCommandMap.mapSignalClass(ResultSignal, ResultCommand);
			signalCommandMap.mapSignalClass(ServiceSignal, AbstractCommand);
			signalCommandMap.mapSignalClass(InitSignal, InitCommand);
			signalCommandMap.mapSignalClass(LoginSignal, LoginCommand);
		} 
		private function bootStrap():void
		{
 			DTApplicationStartedSignal(signalCommandMap.mapSignalClass(DTApplicationStartedSignal, LangCommand, true)).dispatch();
		}  
		
		private function collectionMapping():void
		{
			injector.mapSingleton(LangCollection);
			injector.mapSingleton(LangCollection);                 
			injector.mapSingleton(ProjectCollection);              
			injector.mapSingleton(TaskCollection);                 
			injector.mapSingleton(DefaultTemplateCollection);      
			injector.mapSingleton(DefaultTemplateValueCollection); 
			injector.mapSingleton(GroupCollection);                
			injector.mapSingleton(GroupPersonCollection);          
			injector.mapSingleton(PersonCollection);               
			injector.mapSingleton(ChatCollection);                 
			injector.mapSingleton(CategoryCollection);             
			injector.mapSingleton(CompanyCollection);              
			injector.mapSingleton(ReportsCollection);              
			injector.mapSingleton(EventCollection);                
			injector.mapSingleton(PhaseCollection);                
			injector.mapSingleton(ModuleCollection);               
			injector.mapSingleton(PhasesTemplateCollection);       
			injector.mapSingleton(PropertiesPjCollection);         
			injector.mapSingleton(PropertiesPresetCollection);     
			injector.mapSingleton(ProfileCollection);              
			injector.mapSingleton(StatusCollection);               
			injector.mapSingleton(WorkflowCollection);             
			injector.mapSingleton(WorkflowTemplateCollection);     
			injector.mapSingleton(NoteCollection);                 
			injector.mapSingleton(FileDetailCollection);           
			injector.mapSingleton(TagsCollection);                 
			injector.mapSingleton(TeamTemplateCollection);         
			injector.mapSingleton(TeamlinesTemplateCollection);    
			injector.mapSingleton(TeamlineCollection);             
			injector.mapSingleton(DomainworkflowCollection);       
			injector.mapSingleton(PropPresetsTemplatesCollection); 
			injector.mapSingleton(PresetsTemplatesCollection);     
		} 
	}
}