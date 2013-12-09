package com.adams.dt.command.adminproducerconsumer
{
	import com.adams.dt.business.admin.ConsumerAdminDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PersonsEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;  
	
	public final class ConsumerAdminCommand extends AbstractCommand implements IResponder
	{
		private var cursor:IViewCursor;
		private var duplicateArrColl:ArrayCollection = new ArrayCollection();
		override public function execute( event : CairngormEvent ) : void
		{
			var delegate:ConsumerAdminDelegate = new ConsumerAdminDelegate( this );
			var personsEvent : PersonsEvent = PersonsEvent(event);			
			delegate.adminsubscribe(); 
			
		} 		
		public function messageHandlerAdmin( event:MessageEvent ) : void
		{	
			var message:IMessage = event.message as IMessage;			 
			
			if(message.body.pushadminmonitorpersonId!=undefined)
			{
				if(message.body.pushadminuserstatus!="Offline")
				{	
					if(model.person.personId != message.body.pushadminmonitorpersonId)
					{			
						var obj:Object = {};
						obj.adminid = message.body.pushadminmonitorpersonId;
						obj.adminusername = message.body.pushadminmonitorusername;
						obj.adminscreen = message.body.pushadminmonitorscreen;
						obj.adminstatus = message.body.pushadminuserstatus;
						
						if( !checkDuplicateItem( obj ) ) {
							model.modelAdminMonitorArrColl.addItem(obj);
							model.modelAdminMonitorArrColl.refresh();
						}						
					}					
				}
				else
				{
					for( var i : Number = 0; i < model.modelAdminMonitorArrColl.length;i++)
					{
						var str:String = model.modelAdminMonitorArrColl.getItemAt( i ).adminid;
						if(new Number(message.body.pushadminmonitorpersonId) == new Number(str))
						{
							if( checkDuplicateItem( model.modelAdminMonitorArrColl.getItemAt( i ) ) ) {							
								model.modelAdminMonitorArrColl.removeItemAt( i );
							}	
						}					
					} 
					model.modelAdminMonitorArrColl.refresh();
				}
			}
		}
		private function checkDuplicateItem( item:Object ):Boolean 
		{
			var sort:Sort = new Sort(); 
            sort.fields = [new SortField("adminid")];
            model.modelAdminMonitorArrColl.sort = sort;
            model.modelAdminMonitorArrColl.refresh(); 
			cursor =  model.modelAdminMonitorArrColl.createCursor();
			var found:Boolean = cursor.findAny( item );
			if(found)
			{
				if( !checkDuplicateItemName( item ) )
				{
					replaceObject(item);
				}				
			}			
			return found;
       }
       private function checkDuplicateItemName( item:Object ):Boolean 
	   {
			var sort:Sort = new Sort(); 
            sort.fields = [new SortField("adminscreen")];
            model.modelAdminMonitorArrColl.sort = sort;
            model.modelAdminMonitorArrColl.refresh(); 
			cursor =  model.modelAdminMonitorArrColl.createCursor();
			var found:Boolean = cursor.findAny( item );
			return found;			
       }
       
       private function replaceObject(objset:Object):void
		{
			for( var i : Number = 0; i < model.modelAdminMonitorArrColl.length;i++)
			{
				if(new Number(model.modelAdminMonitorArrColl.getItemAt( i ).adminid) == new Number(objset.adminid))
					model.modelAdminMonitorArrColl.getItemAt( i ).adminscreen = objset.adminscreen;
				
			}
		}
	}		
		
}

