package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.GroupPersonsEvent;
	import com.adams.dt.model.vo.GroupPersons;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.controls.Alert;
	public final class GroupPersonsCommand extends AbstractCommand
	{
		public var groupPersons : GroupPersonsEvent;
		override public function execute( event : CairngormEvent ) : void
		{
			super.execute(event);
			groupPersons = GroupPersonsEvent(event);
			this.delegate = DelegateLocator.getInstance().groupPersonsDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			 switch(event.type){    
			      case GroupPersonsEvent.EVENT_CREATE_GROUPPERSONS:
			      	var gPerson : GroupPersons = GroupPersons(GroupPersonsEvent(event).groupPersons);
			        delegate.create(gPerson);
			      break; 
			      case GroupPersonsEvent.EVENT_BULKUPDATE_GROUPPERSONS:
			      	delegate.bulkUpdate(model.selectedGroupArr);
			       break; 
			      default:
			       break; 
			      }
		}

	}
}