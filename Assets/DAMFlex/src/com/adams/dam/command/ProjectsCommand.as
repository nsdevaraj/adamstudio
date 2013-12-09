package com.adams.dam.command
{
	import com.adams.dam.business.DelegateLocator;
	import com.adams.dam.event.FileDetailsEvent;
	import com.adams.dam.event.ProjectsEvent;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.Projects;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public class ProjectsCommand extends AbstractCommand
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _projectsEvent:ProjectsEvent;
		private var handler:IResponder;
		
		override public function execute( event:CairngormEvent ):void {
			super.execute( event );
			
			_projectsEvent = ProjectsEvent( event );
			delegate = DelegateLocator.getInstance().projectsDelegate;
			
			switch( _projectsEvent.type ) {
				case ProjectsEvent.EVENT_GET_ALL_PROJECTS:
					handler = new Callbacks( onGetAllProjectsResult, fault );
					delegate.responder = handler;
					delegate.findPersonsList( model.persons );
					break;
				default :
					break;
			}
		}	
		
		protected function onGetAllProjectsResult( callResult:Object ):void {
			var resultAC:ArrayCollection = callResult.result as ArrayCollection;
			if( !model.totalProjectsCollection ) {
				model.totalProjectsCollection = new ArrayCollection();
			}
			else {
				model.totalProjectsCollection.removeAll();
			}
			 
			for each( var arr:Array in resultAC ) {
				if( arr[ 0 ] is Projects ) {
					model.totalProjectsCollection.addItem( arr[ 0 ] );
				}
			}
			
			model.totalProjectsCollection.refresh();
			
			if( model.loginIndex == 0 ) {
				model.loginIndex = 1;
				model.preloaderVisibility = false;
			}
			super.result( callResult );
		}
	}
}