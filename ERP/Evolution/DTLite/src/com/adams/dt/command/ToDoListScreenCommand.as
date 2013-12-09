package com.adams.dt.command
{
	import com.adams.dt.event.OpenToDoListScreenEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;
	public final class ToDoListScreenCommand extends AbstractCommand 
	{ 
		private var toDoEvents : OpenToDoListScreenEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	  
			super.execute( event );
			switch( event.type ) {   
				case OpenToDoListScreenEvent.EVENT_OPEN_ORDERSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_ORDERSCREENWITHCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_ORDERSCREEN;
					model.updateProperty = true;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_ORDERRECEPTIONSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_ORDERRECEPTIONSCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_ORDERRECEPTIONSCREEN;
					model.updateProperty = true;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_TECHNICALPREPARATIONSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_TECHNICALPREPARATIONSCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_TECHNICALPREPARATIONSCREEN;
					model.updateProperty = true;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_PROCESSVALIDATIONSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_PROCESSVALIDATIONSCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_PROCESSVALIDATIONSCREEN;
					model.updateProperty = true;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_PREPARATIONTECHNIQUESCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_PREPARATIONTECHNIQUESCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_PREPARATIONTECHNIQUESCREEN;
					model.updateProperty = true;
					break;                               
				case OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_REALISATIONSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONSCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_REALISATIONSCREENCORRECTION;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_CONTOLSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_CONTOLSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_RELECTURESCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_RELECTURESCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_RELECTURESCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTCORRECTIONSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTCORRECTIONSCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_LANCEMENTCORRECTIONSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_REALISATIONCORRECTIONINCOMPLETESCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_REALISATIONCORRECTIONSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_CONTROLCORRECTIONSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_CONTROLCORRECTIONSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_RELECTURECORRECTIONSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_RELECTURECORRECTIONSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_RELECTURECORRECTIONINCOMPLETESCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTLIVRAISONSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_LANCEMENTLIVRAISONSCREENCORRECTION:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_LANCEMENTLIVRAISONSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_DEPARTLIVRAISONSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_DEPARTLIVRAISONSCREEN;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_CLOSEPROJECTSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_CLOSEPROJECTSCREEN;
					model.updateProperty = true;
					break;                                               
				case OpenToDoListScreenEvent.EVENT_OPEN_VIEWMESSAGSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_VIEWMESSAGSCREEN;
					break; 
				case OpenToDoListScreenEvent.EVENT_OPEN_VIEWCLOSESCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_VIEWCLOSESCREEN;
					break; 
				case OpenToDoListScreenEvent.EVENT_OPEN_STANDBYSCREEN:
					model.workflowState =  OpenToDoListScreenEvent.OPEN_VIEWSTANDBYSCREEN;
					break;  
				case OpenToDoListScreenEvent.EVENT_OPEN_VIEWINDPDFSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_VIEWINDPDFSCREENB:
				case OpenToDoListScreenEvent.EVENT_OPEN_VIEWFABPDFSCREEN:
				case OpenToDoListScreenEvent.EVENT_OPEN_VIEWFABPDFSCREENB: 
					model.workflowState =  OpenToDoListScreenEvent.OPEN_VIEWINDMESSAGESCREEN;
					break;                                             
				default:
					break; 
				}
		} 
 	}
}
