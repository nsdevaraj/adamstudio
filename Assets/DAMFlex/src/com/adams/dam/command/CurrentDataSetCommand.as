package com.adams.dam.command
{
	import com.adams.dam.event.CurrentDataSetEvent;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.Projects;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class CurrentDataSetCommand extends AbstractCommand
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _currentDatasetEvent:CurrentDataSetEvent;
		
		override public function execute( event:CairngormEvent ):void {
			super.execute( event );
			
			_currentDatasetEvent = CurrentDataSetEvent( event );
			
			switch( _currentDatasetEvent.type ) {
				case CurrentDataSetEvent.EVENT_SET_PROJECTS:
					model.project = _currentDatasetEvent.project;
					break;
				default :
					break;
			}
		}	
	}
}