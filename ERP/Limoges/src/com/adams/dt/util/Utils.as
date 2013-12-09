/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.util
{  
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.swizdao.util.DateUtils;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class Utils
	{
		public static var monthDisplay:Array =  [ 'Jan', 'Fev', 'Mars', 'Avr', 'Mai', 'Juin', 'Juil', 'Aout', 'Sept', 'Oct', 'Nov', 'Dec' ];
		public static var fileSplitter:String =  '//';
		public static const BASICFILETYPE:String ="Basic";
		public static const TASKFILETYPE:String ="Tasks";
		public static const RELEASEFILETYPE:String ="Release";
		public static const NEWPROJENDTASKCODE:String ='P1T02A';
		public static const OPTIONS_PROP:String ='fieldOptionsValue';
		public static const DEFAULT_PROP:String ='fieldDefaultValue';
		public static const TASKSTATUS : String = 'task_status';
		public static const PROJECTSTATUS : String = 'project_status';
		public static const EVENTTYPE : String = 'event_type';
		public static const WORKFLOWTEMPLATETYPE : String = 'workflowtemplate_permissionlabel';
		public static const PHASESTATUS : String = 'phase_status';
		
		public static const SEPERATOR:String = "&#$%^!@";	
		public static const CREATENOTE : String =  "createNote"
		public static const EDITNOTE : String = "editNote"
		public static const REPLYNOTE : String = "replyNote"
		public static const REPLIEDNOTE : String = "repliedNote"
		public static const PDFCONVERSIONFAILED : String = "Files Conversion not done";
		public static const FILESYNC : String = "File does not exist";
		public static const TASKSYNC : String = "The task is in Progress by another team member";
		public static const SELECT_ENTRY : String = "Please select a Entry!"
		public static const DELETE_PERSON : String = "Do you want to delete this person?"
		public static const APPTITLE : String = "Limoges";
		public static const STATUSOFTODOTASK:String = "This Task has already been taken by ";
		public static const TIMESERVERCONNECTION : String ="Time Server, Network not available";
		public static const TRAFFIC_ACCEPTED_DATE:String = "Traffic has Accepted the Following Date "
		public static const CLIENT_ACCEPTED_DATE:String = "Client has Accepted the Following Date "
		public static const ARCHIVE : String = "archived";
		public static const ARCHIVE_MESSAGE : String = "Are you sure, you want to archive the project?";
		public static const ARCHIVE_TASK_MESSAGE : String = "Are you sure, you want to archive the message?";
		public static const REPLY_TASK_MESSAGE : String = "Are you sure, you want to reply the message?";
		public static const ABORT_MESSAGE : String = "Are you sure, you want to abort the project?";
		public static const NEXTTASK_MESSAGE : String = "Are you sure, you want to forward the task?";
		public static const ABORT : String = "aborted";
		public static const ACCEPT_MESSAGE : String = "Are you sure, you want to accept the Suggested Date?";
		public static const REPLY_DEADLINE_MESSAGE : String = "Are you sure, you want to suggest this date?";
		public static const PROJECT_STANDBY:String	="Project Changed into StandBy Status";
		public static const PROJECT_RESUME:String	="Project activated into Progress";
		public static const STANDBY_PROJECT:String = "Are you sure, you want to Change the project into StandBy ?"
		public static const RESUME_PROJECT:String = "Are you sure, you want to Activate the project ?"
		public static const STANDBY:String = "StandBy";
		public static const RESUME:String = "Activate";
		public static const SENDMAIL_MESSAGE : String = "Are you sure, you want to send mail ?";
		
		public static const REPORT_ALERT_MESSAGE : String = "Please fill the  required fields";
		public static const REPORT_VIEW_ALERT_MESSAGE : String = "Select An Item To View";
		public static const REPORT_MODIFY_ALERT_MESSAGE : String = "Select An Item To Modify";
		public static const REPORT_DELETE_MESSAGE:String = "Are you sure, you want to delete the Report ?"
		
		public static const COMPARE_NO_DIFFERENCE_MSG : String = "No difference found.";	
		public static const FILECOMPARISION_OTHER_FORMAT : String = "Please select the other format file";
		public static const PROPERTIES_HIGH : String = "Can't add more values";
		
		// todo: add view index
		public static const MAIN_INDEX:String='Main';
		// todo: add view index
		public static const PROJECT_GENERAL:String='General';
		public static const PROJECT_NOTE:String='Notes';
		public static const PROJECT_FILE:String='Files'	;
		public static const PROJECT_MAIL:String='Mail';
		public static const PROJECT_CORRECTION:String='Correction';
		public static const PROJECT_CORRECTIONREQUEST:String='Correction Request';
		// todo: add key
		public static const COMMENTVOKEY  :String='commentID';
		public static const WORKFLOWSTEMPLATESKEY  :String='workflowTemplateId';
		public static const WORKFLOWSKEY  :String='workflowId';
		public static const TEAMTEMPLATESKEY  :String='teamTemplateId';
		public static const TEAMLINESTEMPLATESKEY  :String='teamlineTemplateId';
		public static const TEAMLINESKEY  :String='teamlineId';
		public static const TASKSKEY  :String='taskId';
		public static const STATUSKEY  :String='statusId';
		public static const REPORTSKEY  :String='reportId';
		public static const REPORTCOLUMNSKEY  :String='reportColumnId';
		public static const PROPPRESETSTEMPLATESKEY  :String='proppresetstemplatesId';
		public static const PROPERTIESPRESETSKEY  :String='propertyPresetId';
		public static const PROPERTIESPJKEY  :String='propertyPjId';
		public static const PROJECTSKEY  :String='projectId';
		public static const PROFILESKEY  :String='profileId';
		public static const PROFILEMODULESKEY  :String='profileModuleId';
		public static const PRESETSTEMPLATESKEY  :String='presetstemplateId';
		public static const PHASESTEMPLATESKEY  :String='phaseTemplateId';
		public static const PERSONSKEY  :String='personId';
		public static const PHASESKEY  :String='phaseId';
		public static const GROUPSKEY  :String='groupId';
		public static const GROUPPERSONSKEY  :String='groupPersonId';
		public static const FILEDETAILSKEY  :String='fileId';
		public static const EVENTSKEY  :String='eventId';
		public static const DOMAINWORKFLOWKEY  :String='domainWorkflowId';
		public static const DEFAULTTEMPLATEVALUEKEY  :String='defaultTemplateValueId';
		public static const COLUMNSKEY  :String='columnId';
		public static const COMPANIESKEY  :String='companyid';
		public static const DEFAULTTEMPLATEKEY  :String='defaultTemplateId';
		public static const CATEGORIESKEY  :String='categoryId';
		
		public static const LIMOGES_PROFILE:String='CLT';
		public static const PONDY_PROFILE:String='TRA';
		// todo: personAction
		public static const PERSONUPDATE:String='personUpdate';
		public static const PERSONADD:String='personADD';
		public static const PERSONDELETE:String='personDelete';
		public static const PERSON_VIEW:String = "personView"
		public static const PERSON_INDEX:String = "person"
		public static const PDFTOOL_INDEX:String = "PDFTool"
		
		public static const SEND_EMAIL:String = 'SENDemail';
		// todo : MessageAction 
		
		public static const TASKLIST_INDEX:String = 'TaskList';
		public static const CORRECTION_INDEX:String = 'Correction';
		public static const NOTES_INDEX:String = 'Notes';
		public static const MESSAGE_INDEX:String = 'Message';
		public static const REPORT_INDEX:String = 'Report';
		public static const GENERAL_INDEX:String = 'General';
		public static const FILE_INDEX:String = 'File';
		public static const NEWPROJECT_INDEX:String = 'NewProject';
		public static const LOGIN_INDEX:String = 'Login';
		public static const PROGRESS_INDEX:String = 'Progress';
		
		public static const PLANNING_INDEX:String = 'ShowPlanning';
		public static const DEADLINEMESSAGE_INDEX:String="DeadlineMessage";
		public static const TRAFFICDEADLINE_GENERAL:String = 'TrafficDeadLineGeneral';
		public static const CLIENT_DEADLINE:String = 'ClientDeadLine';
		public static const TRAFFIC_DEADLINE:String = 'TrafficDeadLine';
		public static const MESSAGE_STANDBY:String = 'Standby';
		public static const MESSAGE_PROJECTCLOSE:String = 'ProjectClose';
		
		// todo: add dao
		public static const PROJECTCORRECTION_INDEX:String='ProjectCorrection';
		public static const MAIL_INDEX:String='Mail';
		public static const ADMIN_INDEX:String='Admin';
		public static const NAVIGATECOMMENT_INDEX:String='NavigateComment';
		public static const PERSONSELECTION_INDEX:String='PersonSelection';
		public static const HEADER_INDEX:String='Header';
		public static const COMMENTVODAO:String = 'commentvoDAO';
		public static const WORKFLOWSTEMPLATESDAO  :String='workflowstemplatesDAO'; 
		public static const WORKFLOWSDAO  :String='workflowsDAO'; 
		public static const TEAMTEMPLATESDAO  :String='teamtemplatesDAO'; 
		public static const TEAMLINESTEMPLATESDAO  :String='teamlinestemplatesDAO'; 
		public static const TEAMLINESDAO  :String='teamlinesDAO'; 
		public static const TASKSDAO  :String='tasksDAO'; 
		public static const STATUSDAO  :String='statusDAO'; 
		public static const REPORTSDAO  :String='reportsDAO'; 
		public static const REPORTCOLUMNSDAO  :String='reportcolumnsDAO'; 
		public static const PROPPRESETSTEMPLATESDAO  :String='proppresetstemplatesDAO'; 
		public static const PROPERTIESPRESETSDAO  :String='propertiespresetsDAO'; 
		public static const PROPERTIESPJDAO  :String='propertiespjDAO'; 
		public static const PROJECTSDAO  :String='projectsDAO'; 
		public static const PROFILESDAO  :String='profilesDAO'; 
		public static const PROFILEMODULESDAO  :String='profilemodulesDAO'; 
		public static const PRESETSTEMPLATESDAO  :String='presetstemplatesDAO'; 
		public static const PHASESTEMPLATESDAO  :String='phasestemplatesDAO'; 
		public static const PERSONSDAO  :String='personsDAO'; 
		public static const PHASESDAO  :String='phasesDAO'; 
		public static const GROUPSDAO  :String='groupsDAO'; 
		public static const GROUPPERSONSDAO  :String='grouppersonsDAO'; 
		public static const FILEDETAILSDAO  :String='filedetailsDAO'; 
		public static const EVENTSDAO  :String='eventsDAO'; 
		public static const DOMAINWORKFLOWDAO  :String='domainworkflowDAO'; 
		public static const DEFAULTTEMPLATEVALUEDAO  :String='defaulttemplatevalueDAO'; 
		public static const COLUMNSDAO  :String='columnsDAO'; 
		public static const COMPANIESDAO  :String='companiesDAO'; 
		public static const DEFAULTTEMPLATEDAO  :String='defaulttemplateDAO'; 
		public static const CATEGORIESDAO  :String='categoriesDAO'; 
		
		//Progress Toggler
		public static const PROGRESS_ON:String = "progressOn"; 
		public static const PROGRESS_OFF:String = "progressOff"; 
		
		public static const NEWORDER_CORRECTION_SCREEN:String = 'P1T01B'; 
		public static const CORRECTIONS_FRONT_SCREEN:String = 'P1T02B'; 
		public static const CORRECTIONS_BACK_SCREEN:String = 'P4T01A'; 
		public static const MESSAGE_SCREEN:String = 'M01'; 
		public static const ARCHIVE_SCREEN:String = 'C01';  
		
		//Previous States
		public static const FROM_TODO:String = 'fromTodo';  
		public static const FROM_MPV:String = 'fromMPV';  
		
		// Person Position 
		public static const PERSON_COMMERCIAL:String = "COM";
		public static const PERSON_CHEFPRODUIT:String = "CHP";
		public static const PERSON_APM:String = "EPR";
		public static const PERSON_TRAFFIC:String = "TRA";
		public static const PERSON_CLIENT:String = "CLT";
		
		public static function addArrcStrictItem( item:Object, arrc:ArrayCollection, sortString:String, modified:Boolean =false ):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue == -1 ) {
				arrc.addItem(item);
			}else{
				if(modified){
					arrc.removeItemAt(returnValue);
					arrc.addItemAt(item, returnValue);
				}
			}
		}
		
		public static function removeArrcItem(item:Object,arrc:ArrayCollection, sortString:String):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue != -1 ) {
				arrc.removeItemAt(returnValue);
			}
		} 
		
		public static function reportLabelFuction( item:Object, property:String, queryArray:ArrayCollection=null ):String {
			var propertyValue:String = '';
			switch ( property ) {
				case 'name':
					propertyValue = item.projectName;
					break;
				case 'refId':
					propertyValue = item.projectName;
					break;
				case 'startDate':
					propertyValue = dateFormat( item.projectDateStart );
					break;
				case 'endDate':
					if( item.projectDateEnd )	propertyValue = dateFormat( item.projectDateEnd );
					break;
				case 'projectId':
					propertyValue = item.projectId.toString();
					break;
				case 'clientCode':
					propertyValue = item.categories.categoryFK.categoryFK.categoryCode;
					break;
				case 'client':
					propertyValue = item.categories.categoryFK.categoryFK.categoryName;
					break;
				case 'content':
					propertyValue = getContentValues( item as Projects );
					break;
				case 'currentProfile':
					propertyValue = item.workflowTemplate.profileObject.profileLabel;
					break;
				case 'currentTaskDateStart':
					if( item.currentTaskDateStart ) propertyValue = dateFormat( item.currentTaskDateStart );
					break;
				case 'currentTaskDelay':
					propertyValue = Math.round( DateUtils.ms2hours( DateUtils.dateDiff( item.currentTaskDateStart ) ) ) + ' Hours';
					break;
				case 'status':
					propertyValue = getStatusLabel( Projects( item ).projectStatusFK );
					break;
				case 'taskStart':
					if( item.taskDateStart ) propertyValue = dateFormat( item.taskDateStart );
					break;
				case 'taskEnd':
					if( item.taskDateEnd )  propertyValue = dateFormat( item.taskDateEnd );
					break;
				case 'Phase4Deadline':
					propertyValue = dateFormat( ( item.phasesCollection.getItemAt( item.phasesCollection.length - 1 ) as Phases ).phaseEndPlanified );
					break;
				case 'pendingTaskPersonName':
					propertyValue = item.finalTask.personDetails.personFirstname;
					break;
				case 'pendingTaskName':
					propertyValue = item.finalTask.workflowtemplateFK.taskLabel;
					break;
				case 'bat_date':
					var batPropValue:String = getPropertyValue( item as Projects, property, false );
					if( batPropValue == 'NULL' ) {
						propertyValue = batPropValue;
					}	
					else {
						propertyValue = DateUtil.dateToString( new Date( batPropValue ) );
					}
					break;
				case 'clt_date':
					propertyValue = DateUtil.dateToString( new Date( getPropertyValue( item as Projects, 'clt_date', false ) ) );
					break;
				case 'currentDeliveryDelay':
					var propPj:Propertiespj = propertyPjForFieldName( 'departure_date_start', item.propertiespjSet );
					if( propPj ) {
						var dateStr:String = propPj.fieldValue; 
						if( ( dateStr != '' ) && dateStr )	{
							dateStr = swapDateMonth( dateStr );
							propertyValue = Math.round( DateUtils.ms2hours( DateUtils.dateDiff( new Date( dateStr ) ) ) ) + ' Hours';
						}
					}
					break;
				case 'delivery_address':
					var str:String = getDeliverSelectedValue( item as Projects, 'deliverygroup' );
					if( str != '' ) {
						var arr:Array = str.split( ',' );
						arr.splice( 0, 4 );
						if( arr.indexOf( 'autre' ) != -1 ) {
							arr.splice( arr.indexOf( 'autre' ), 1, getPropertyValue( item as Projects, 'delivery_address', false ) );
						}
						propertyValue = arr.toString();
					}
					break;
				case 'currentEPRDelay':
				case 'currentAGNDelay':
				case 'currentCOMDelay':
				case 'currentCHPDelay':
				case 'currentCPPDelay':
				case 'currentINDDelay':
				case 'commentFromPreviousTask':
				case 'Phase4Deadline':
					propertyValue = queryResultMapping( item.projectId, queryArray, property ); 
					break;
				default:
					propertyValue = getPropertyValue( item as Projects, property, false );
					break;
			}
			return propertyValue;
		}
		
		public static function queryResultMapping( prjId:int, resultColl:ArrayCollection, header:String ):String {
			for each( var resArr:Array in resultColl ) {
				if ( resArr[ 0 ] == prjId ) {
					if( header == 'currentEPRDelay' ||
						header == 'currentAGNDelay' ||
						header == 'currentCOMDelay' ||
						header == 'currentCHPDelay' ||
						header == 'currentCPPDelay' ||
						header == 'currentINDDelay' ) {
						var profile:String = header.substr( 7, 3 ) + '-';
						return profile + resArr[ 1 ] + ' [' + Math.round( DateUtils.ms2hours( DateUtils.dateDiff( resArr[ 1 ] ) ) ) + ' Hrs]';
					}else if( header == 'commentFromPreviousTask'){
						return unescapeHTML(resArr[ 1 ]);
					}
					return resArr[ 1 ];
				}
			}
			return '';
		}
		
		public static function unescapeHTML( str:String ):String { 
			return str.match(/\w*\</g).join().replace(/\</g,'').replace(/,/g,'')
		}
		
		public static function getPropertyValue( prj:Projects, propertyName:String, isContent:Boolean=false ):String {
			var returnValue:String = '';
			if( prj ) {
				var prjPropList:ArrayCollection = prj.propertiespjSet;
				var prjPropLength:int = prjPropList.length;
				for( var j:int = 0; j < prjPropLength; j++ ) {
					var pjprop:Propertiespj = prjPropList.getItemAt( j ) as Propertiespj;
					if( pjprop.propertyPreset ) {
						if( pjprop.propertyPreset.fieldName  == propertyName ) { 
							if( pjprop.propertyPreset.fieldType == 'popup' ||
								pjprop.propertyPreset.fieldType == 'radio' ||
								pjprop.propertyPreset.fieldType == 'checkbox' ) {
								returnValue = traverseProperties( pjprop.propertyPreset, int( pjprop.fieldValue ) );
							}
							else {
								returnValue = pjprop.fieldValue;
							} 
							if( isContent )	returnValue = pjprop.propertyPreset.fieldLabel + ' ' + returnValue;	
						} 
					}
				}
			}
			return returnValue;
		}
		
		public static function traverseProperties( propPreset:Propertiespresets, fieldValue:int ):String {
			var tempArray:Array = propPreset.fieldOptionsValue.toString().split( "," );
			return tempArray[ fieldValue ];
		} 
		
		public static function dateFormat( date:Date ):String {
			var str:String = date.date + " " + monthDisplay[ date.month ] + " " + date.fullYear;
			return str;
		}
		
		public static function swapDateMonth( str:String ):String {
			var swapMonth:Array = str.split( '/' );
			return swapMonth[ 1 ] + '/' + swapMonth[ 0 ] + '/' + swapMonth[ 2 ]; 
		}
		
		public static function trimFront(value:String):String
		{
			if(value.charAt(0) == " ")
			{
				value = trimFront(value.substr(1));
			}
			return value;
		}
		
		public static function trimBack(value:String):String
		{
			if(value.charAt(value.length-1) == " ")
			{
				value = trimBack(value.substring(0,value.length-1));
			}
			return value;
		}
		
		public static function getContentValues( prj:Projects ):String {
			var dvdArray:Array = [ 'artpro', 'artpro_version', 'illustrator', 'pdf_hd' ];
			var proofArray:Array = [ 'gmg', 'approval', 'approval_colors', 'approval_support' ];
			var resultString:String = '';
			var proofCollection:Array = [];
			var dvdCollection:Array = [];
			for each( var dvd:String in dvdArray ) {
				var pushDVD:String = getPropertyValue( prj, dvd, true );
				if( pushDVD != '' )
					dvdCollection.push( pushDVD );
			}
			for each( var proof:String in proofArray ) {
				var pushPROOF:String = getPropertyValue( prj, proof, true ) ;
				if( pushPROOF != '' ) 
					proofCollection.push( pushPROOF );
			}
			resultString = proofCollection.toString() + '\n' + dvdCollection.toString();
			return resultString; 
		}
		
		public static function getStatusLabel( value:int ):String {
			var statusLabel:String;
			switch( value ) {
				case ProjectStatus.INPROGRESS:
					statusLabel = 'In Progress';
					break;
				case ProjectStatus.STANDBY:
					statusLabel = 'Standby';
					break;
				case ProjectStatus.INCHECKING:
					statusLabel = 'In Checking';
					break;
				case ProjectStatus.INDELIVERY:
					statusLabel = 'In Delivery';
					break;
				case ProjectStatus.URGENT:
					statusLabel = 'Urgent';
					break;
				case ProjectStatus.ABORTED:
					statusLabel = 'Aborted';
					break;
				case ProjectStatus.ARCHIVED:
					statusLabel = 'Archived';
					break;
				case ProjectStatus.WAITING:
					statusLabel = 'Waiting';
					break;
			}
			return statusLabel;
		}
		
		public static function propertyPjForFieldName( str:String, arrc:ArrayCollection ):Propertiespj {
			for each( var item:Propertiespj in arrc ) {
				if( item.propertyPreset.fieldName == str ) {
					return item;
				}
			}
			return null;
		}
		
		public static function getDeliverSelectedValue( prj:Projects, propertyName:String ):String {
			var prjPropList:ArrayCollection = prj.propertiespjSet;
			var prjPropLength:int = prjPropList.length;
			for( var j:int = 0; j < prjPropLength; j++ ) {
				var pjprop:Propertiespj = prjPropList.getItemAt( j ) as Propertiespj;
				if( pjprop.propertyPreset.fieldName  == propertyName ) { 
					return pjprop.fieldValue;
				} 
			}
			return '';
		} 
		public static function getFromName(str:String):String{
			return str.split(Utils.SEPERATOR)[0];
		}
		public static function getComments(str:String):String{
			return str.split(Utils.SEPERATOR)[1];
		}
		public static function getReplyID(str:String):String{
			return str.split(Utils.SEPERATOR)[2];
		} 
		public static function pjParameters(arrc:ArrayCollection):String
		{
			var pjValue:String='';
			var presetFk:String='';
			for each ( var prop:Propertiespj in arrc)
			{
				if(prop.fieldValue!=null && prop.fieldValue.length>0)
				{
					pjValue += prop.fieldValue+';';
					presetFk +=prop.propertyPresetFk+';';
				}
			}
			return pjValue+"#&#"+presetFk;
		}
	}
}