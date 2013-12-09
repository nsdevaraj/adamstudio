package com.adams.dt.business.util
{
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.event.SMTPEmailEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Companies;
	import com.adams.dt.model.vo.Impremiur;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.dt.model.vo.Reports;
	import com.adams.dt.model.vo.SMTPEmailVO;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Teamlines;
	import com.adams.dt.model.vo.Teamlinestemplates;
	import com.adams.dt.model.vo.WorkFlowset;
	import com.adams.dt.model.vo.Workflowstemplates;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Label;
	import mx.managers.CursorManager;
	
	public class Utils
	{
		[Bindable]
		private static var model:ModelLocator = ModelLocator.getInstance(); 
		
		public static var propertyName:String;
		public static const indGroupId:int = 39;
		
		public static const gXLStemplate:String = "" +
             "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\"> " +
             "<HTML>" +
             "<HEAD>" +
             "    <META HTTP-EQUIV=\"CONTENT-TYPE\" CONTENT=\"application/octet_stream; charset=utf8\">" +
             "    <STYLE>" +
             "        <!-- " +
             "        BODY,DIV,TABLE,THEAD,TBODY,TFOOT,TR,TH,TD,P { font-family:\"Verdana\"; font-size:x-small }" +
             "         -->" +
             "    </STYLE>" +
             "</HEAD>" +
             "<BODY TEXT=\"#000000\">" + 
             "<TABLE Border=\"0\">" +
             "    <TR><TD ColSpan=\"6\"><FONT Size=\"+2\">##TITLE## reports</FONT></TD></TR>" + 
             "    <TR><TD></TD><TD></TD><TD></TD>" + 
             "        <TD ColSpan=\"3\"><FONT Size=\"+3\">##DOMAIN##</FONT></TD></TR>" +
             "    <TR><TD></TD><TD></TD><TD></TD>" + 
             "        <TD ColSpan=\"3\">##DATE##</TD></TR>" +
             "    <TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##TITLE##</FONT></TD></TR>" +
             "</TABLE>" + 
             "<BR>" +																
             "<TABLE FRAME=VOID CELLSPACING=0 COLS=4 RULES=GROUPS BORDER=0>" +
             "    <TR><TD><U>Filters</U></TD>" + 
             "        <TD ColSpan=\"6\">##RESULTS##</TD></TR>" +
             "    ##FILTERS##" +
             "</TABLE>" +
             "<BR>" +
             "<TABLE FRAME=VOID CELLSPACING=0 COLS=4 BORDER=1>" +
             "    <COLGROUP>##COLDESC##</COLGROUP>" +
             "    <TBODY>" +
             "        ##HEADERS##" +
             "        ##ROWS##" +
             "    </TBODY>" +
             "</TABLE>" +
             "<TABLE>" + 
             "<TR><TD></TD><TD></TD><TD><FONT Size=\"+1\">End of report</FONT></TD></TR>" + 
             "</TABLE>" +
             "</BODY>" +
             "</HTML>";
		
		
		public function Utils():void
		{
		}
		public static var monthDisplay:Array =  ['Jan','Fev','Mars','Avr','Mai','Juin','Juil','Aout','Sept','Oct','Nov','Dec'];
		public static const sortMonthColl:ArrayCollection= new ArrayCollection([{Label:"January"},{Label:"February"},{Label:"March"},{Label:"April"},{Label:"May"},{Label:"June"},
																		{Label:"July"},{Label:"August"},{Label:"September"},{Label:"October"},{Label:"November"},{Label:"December"}]);
		public static const sortYearColl:ArrayCollection= new ArrayCollection([{Label:"2007"},{Label:"2008"},{Label:"2009"},{Label:"2010"}]);
		
		public static const MONTH:String = "Month";
		public static const YEAR:String = "Year";
		public static const WEEK:String = "Week";
		public static function getWorkflowTemplates(wTemplates:ArrayCollection,workflowId:int):Workflowstemplates{
			for each (var wTemp:Workflowstemplates in wTemplates){
				if(wTemp.workflowFK == workflowId){
					return wTemp;
					
				}
			}
			return new Workflowstemplates();
		}
		// function to return wfset for given fronttask wftemp id
		public static function getWorkflowTemplatesSet(workflowtempId:int):WorkFlowset{
			var wftSet:WorkFlowset
			// front task is assigned based on given input 
			var frontTask:Workflowstemplates = GetVOUtil.getWorkflowTemplate(workflowtempId);
			// back task associated with front task to be found
			var backTask:Workflowstemplates
			if(frontTask.nextTaskFk){
				wftSet = new WorkFlowset();
				// iteration for finding associated back task
				for each (var wTemp:Workflowstemplates in model.workflowstemplatesCollection){
					// find the wftemp having same next task other than fronttask
					if(wTemp.nextTaskFk == frontTask.nextTaskFk && wTemp!=frontTask){
						backTask = wTemp;
						break;
					}
				}
				//assign back and front task to the VO
				wftSet.frontWFTask = frontTask;
				wftSet.backWFTask = backTask;
				//set the phase id for wfset
				wftSet.phasesId = frontTask.phaseTemplateFK
				//set backid for wfset
				if(backTask != null) {
					wftSet.backWorkFlowId = backTask.workflowTemplateId
				}
				//set frontid for wfset
				if(frontTask != null) {
					wftSet.frontWorkFlowId = frontTask.workflowTemplateId
				}
			}
			return wftSet;
		}
		
		public static function findJumpWFTemplate( id:int ) : Boolean {
			var tempVal:Boolean
			for each (var wTemp:Workflowstemplates in model.workflowstemplatesCollection){
				if(wTemp.jumpToTaskFk != null ) {
					if( wTemp.jumpToTaskFk == GetVOUtil.getWorkflowTemplate( id ) ) {
						tempVal = true
					}
				}
			}
			return tempVal
		}
		public static function getAllWorkflowTemplatesSet(workflowFK:int):ArrayCollection{
			//the whole wflowset array collection to be returned
			var wftSetAc:ArrayCollection = new ArrayCollection();
			// to find the first workflwtemp in a given workflow
			var workflowTemplate:Workflowstemplates = getWorkflowTemplates(model.modelAnnulationWorkflowTemplate,workflowFK);
			// get the first wfset of first wftemp
			var wftSetObj:WorkFlowset= getWorkflowTemplatesSet(workflowTemplate.workflowTemplateId);
			// add the first element
			wftSetAc.addItem(wftSetObj);
			do{ 
				//recursive loop to find consecutive wfset elements
				wftSetObj = getWorkflowTemplatesSet(Workflowstemplates(wftSetObj.frontWFTask).nextTaskFk.workflowTemplateId);
				// if found, add them to the collection
				if(wftSetObj) wftSetAc.addItem(wftSetObj);
			}// recursion will occur only if next wfset obj is found and nexttask is not null
			while((wftSetObj)&& Workflowstemplates(wftSetObj.frontWFTask).nextTaskFk)
			// last element which have next task fk null is added seperately
			wftSetObj = new WorkFlowset();
			// finding the last wfset with single wftemplate
 			wftSetObj.frontWFTask = GetVOUtil.getWorkflowTemplate(wftSetAc.getItemAt(wftSetAc.length-1).frontWFTask.nextTaskFk.workflowTemplateId);
 			wftSetObj.frontWorkFlowId = wftSetObj.frontWFTask.workflowTemplateId
 			wftSetObj.phasesId = wftSetObj.frontWFTask.phaseTemplateFK
 			// adding the parameters required and add it to the collection
			wftSetAc.addItem(wftSetObj);
			return wftSetAc;
		}  
		public static function checkTemplateExist( wTemplates:ArrayCollection, workflowTempId:int ):Boolean {
			for each ( var wTemp:Workflowstemplates in wTemplates ) {
				if( wTemp.workflowTemplateId == workflowTempId ) {
					return true;
				}
			}
			return false;
		}
		
		public static function getWorkflowTemplatesCollection(wTemplates:ArrayCollection,workflowId:int):ArrayCollection{
			var arrC:ArrayCollection = new ArrayCollection();
			for each (var wTemp:Workflowstemplates in wTemplates){
				if(wTemp.workflowFK == workflowId){
					arrC.addItem(wTemp);
					
				}
			}
			return arrC; 
		}
		public static function getClientFK(categories : Categories) : int
		{
			return GetVOUtil.getCompanyObjectCode(getDomains(categories).categoryCode).companyid;
		}
		public static function getClient(categories : Categories) : Companies
		{
			return GetVOUtil.getCompanyObjectCode(getDomains(categories).categoryCode);
		} 
		public static function getDomains(categories : Categories) : Categories
		{
			var tempCategories : Categories = new Categories(); 
			if(categories.categoryFK != null)
			{
				tempCategories = getDomains(categories.categoryFK);
			}else
			{
				return categories;
			}

			return tempCategories;
		}
		
		public static function getCalculatedDate(date:Date,minutes:int):Date{
			date.seconds=+(minutes*60);
			return date;
		}
		public static const milliseconds:int = 1000 * 60; 
		
		public static function getDiffrenceBtDate(startDate:Date,endDate:Date):int{			
			return Math.ceil(( endDate.getTime() - startDate.getTime())/milliseconds);
		}
		public static function dateFormat(date:Date):String{
			var str:String = date.date+" "+monthDisplay[date.month]+" "+date.fullYear;
			return str;
		}
		public static function getPropertyPj( itemId:int,ppj:ArrayCollection):Propertiespj {
			for each(var propPj:Propertiespj in ppj){
				if(propPj.propertyPreset.propertyPresetId == itemId){
					return propPj
				}
			}
			return null;
		}
		
		public static function getPropertyPresetTemp( itemId:int,ppj:ArrayCollection):Proppresetstemplates {
			
			for each(var propPreset:Proppresetstemplates in ppj){
				if(propPreset.propertypresetFK == itemId){
					return propPreset;
				}
			}
			return null;
		}
		
		public static function getName( prj:Projects, str:String ):String {
			var returnValue:String;
			if( str == 'name' ) {
				returnValue = prj.projectName.substring( ( prj.projectName.indexOf( '_' ) + 1 ), prj.projectName.length );
			}
			else if( str == 'id' ) {
				returnValue = prj.projectName.split( '_' )[ 0 ];
			}
			return returnValue;
		} 
		
		public static function todoListUpdate( tasks:Tasks = null ):void {
			if( tasks ) {
				var domain:Categories;
				var isCLT:Boolean;
				if( model.profilesCollection.length > 0 ) {
					if( model.clientCode == 'CLT' ) isCLT = true;
				}  
				if( ( isCLT ) && ( model.appDomain != 'Brennus' ) ) {
					domain = tasks.projectObject.categories;
				}
				else {
					domain = getDomains( tasks.projectObject.categories );	
				}
				
				var taskAdded:Boolean;
				var taskCollection:ArrayCollection = model.taskCollection;
				
				for each( var item:Object in taskCollection ) {
					if( item.domain ) {
						if( item.domain.categoryId == domain.categoryId ) {
							taskAdded = true;
							var projects:Projects = Utils.getSpecificProject( tasks.projectObject.projectId, tasks.projectObject );
							projects.phasesSet = tasks.projectObject.phasesSet; 
							projects.propertiespjSet = tasks.projectObject.propertiespjSet;
							projects.categories = tasks.projectObject.categories
							projects.wftFK = tasks.projectObject.wftFK;
							projects.currentTaskDateStart = tasks.projectObject.currentTaskDateStart;
							projects.taskDateStart = tasks.projectObject.taskDateStart;
							projects.taskDateEnd = tasks.projectObject.taskDateEnd;
							tasks.projectObject = projects;
							var removeIndex:int = isDuplicateTask( tasks, item.tasks );
							if( removeIndex != -1 ) {
								item.tasks.removeItemAt( removeIndex );
								item.tasks.addItem( tasks );
								item.tasks.refresh();
							}
							else {
								item.tasks.addItem( tasks );
								item.tasks.refresh();
							}
							var modelIndex:int = isDuplicateTask( tasks, model.tasks );
							if( modelIndex != -1 ) {
								model.tasks.removeItemAt( modelIndex );
								model.tasks.addItem( tasks );
								model.tasks.refresh();
							}
							else {
								model.tasks.addItem( tasks );
								model.tasks.refresh();
							}
							break;
						}
					}
				}
				
				if( !taskAdded ) {
					var object:Object = new Object();
					var coll:ArrayCollection = new ArrayCollection();
					object[ 'domain' ] = domain;
					object[ 'tasks' ] = coll;
					var prj:Projects = Utils.getSpecificProject( tasks.projectObject.projectId, tasks.projectObject ); 			
					prj.categories = tasks.projectObject.categories;
					prj.phasesSet = tasks.projectObject.phasesSet;
					prj.propertiespjSet = tasks.projectObject.propertiespjSet;
					tasks.projectObject = prj;
					coll.addItem( tasks );
					model.tasks.addItem( tasks );
					coll.refresh();
					taskCollection.addItem( object );
					taskCollection.refresh();
				}
				if( model.currentTasks ) {
					if( model.currentTasks.taskId == tasks.taskId ) {
						model.currentTasks.projectObject = tasks.projectObject;
					}
				}
				model.taskCollection.list = taskCollection.list;
				model.taskCollection.refresh();
				model.domainCollection.addItem( domain );
			}
		}
		
		public static function isDuplicateTask( tasks:Tasks, arrC:ArrayCollection ):int {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'taskId' ) ];
            arrC.sort = sort;
	        arrC.refresh();  
	        var cursor:IViewCursor = arrC.createCursor();
			var found:Boolean = cursor.findAny( tasks );	
			if( found ) {
				return arrC.getItemIndex( cursor.current );
			}
			return -1;
		} 
		
		public static var tempPrj:Projects;
		public static function refreshPendingCollection( prj:Projects ):void {
			trace("refreshPendingCollection calling");	
			if( prj.categories.categoryFK ) {
				trace("refreshPendingCollection calling if");
				refreshProject( prj );
			}
			else if( prj.categoryFKey != 0 ) {
				trace("refreshPendingCollection calling else"); 
				tempPrj = prj;
				var categoryEvent:CategoriesEvent = new CategoriesEvent( CategoriesEvent.EVENT_GET_CATEGORIES );
				categoryEvent.categoryId = prj.categoryFKey;
				categoryEvent.dispatch(); 
			} 
			model.projectsCollection.refresh();
		}
		
		public static function currentProfileUpdation( totalCollection:ArrayCollection, propString:Array ):void {
			for each( var item:Object in totalCollection ) {
				if( item.hasOwnProperty( 'currentProfile' ) )
					item.currentProfile = GetVOUtil.getWorkflowTemplate( getDashboardProject( item ).wftFK ).profileObject.profileLabel;
				if( item.hasOwnProperty( 'currentTaskDateStart' ) )
					item.currentTaskDateStart = getDashboardProject( item ).currentTaskDateStart;
				if( item.hasOwnProperty( 'currentTaskDelay' ) )
					item.currentTaskDelay = Math.round( DateUtils.ms2hours( DateUtils.dateDiff( getDashboardProject( item ).currentTaskDateStart ) ) ) + ' Hours';
				if( item.hasOwnProperty( 'currentDeliveryDelay' ) ) {
					var dateStr:String = swapDateMonth( item.currentDeliveryDelay );
					item.currentTaskDelay = Math.round( DateUtils.ms2hours( DateUtils.dateDiff( new Date( dateStr ) ) ) ) + ' Hours';
				}
			}
		}
		
		public static function refreshProject(prj:Projects ):void{	
			if( !checkDuplicateItem( prj, model.projectsCollection, "projectId" ) ) {
				model.projectsCollection.addItem( prj );
			}
			// Done By Deepan			
			var currentCategory2:Categories = prj.categories;
			var currentCategory1:Categories = currentCategory2.categoryFK;
			var domain:Categories = currentCategory1.categoryFK;
			currentCategory2.domain = domain;
			if( !checkDuplicateItem( domain, model.domainCollection1, "categoryId" ) ) {
				model.domainCollection1.addItem( domain );	
			}
			if( !checkDuplicateItem( currentCategory1, model.catagory1, "categoryId" ) ) {
				model.catagory1.addItem( currentCategory1 );	
				var childSet:ArrayCollection = new ArrayCollection();
				childSet.addItem( currentCategory2 );
				currentCategory1.childCategorySet = childSet;
			}
			else {
				if( !checkDuplicateItem( currentCategory2, currentCategory1.childCategorySet, "categoryId" ) ) {
					currentCategory1.childCategorySet.addItem( currentCategory2 );
				}
			}
			if( !checkDuplicateItem( currentCategory2, model.catagory2, "categoryId" ) ) {
				model.catagory2.addItem( currentCategory2 );	
				var projectCollection:ArrayCollection = new ArrayCollection();
				projectCollection.addItem( prj );
				currentCategory2.projectSet = projectCollection;
			}
			else {
				if( !checkDuplicateItem( prj, currentCategory2.projectSet, "projectId" ) ) {
					currentCategory2.projectSet.addItem( prj );
				}
			} 
			model.pendingCurrentDomain = domain;	
			model.domainCollection1.refresh(); 
			model.projectsCollection.refresh();
		}
		
		public static function checkDuplicateItem( item:Object, dp:ArrayCollection, sortString:String ):Boolean {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( sortString ) ];
            if( !dp.sort ){
	       	 	dp.sort = sort;
	        	dp.refresh();  
	        }
			var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( ( found ) && ( sortString == 'projectId' ) ) {
				Projects( item ).categories.projectSet = Projects( cursor.current ).categories.projectSet;
				dp.removeItemAt( dp.getItemIndex( cursor.current ) );
				found = false;
			}
			return found;
		}
		
		public static function swapDateMonth( str:String ):String {
			var swapMonth:Array = str.split( '/' );
			return swapMonth[ 1 ] + '/' + swapMonth[ 0 ] + '/' + swapMonth[ 2 ]; 
		}
		
		public static function setTableData( dataCollection:ArrayCollection, propertySet:Array,querySet:Array ):ArrayCollection {
			var loopLength:int = dataCollection.length;
			var arrCollectionBase:ArrayCollection = new ArrayCollection();
			for( var i:int = 0; i < loopLength; i++ ) {
				var projectObj:Projects = Projects( dataCollection.getItemAt( i ) );
				var obj:Object = {};
				makeData( projectObj, obj, propertySet, querySet );
				arrCollectionBase.addItem( obj );
			}
			return arrCollectionBase;
		}
		
		public static function makeData( projectObj:Projects, obj:Object, propertySet:Array, querySet:Array ):void {
			obj[ 'projectId' ] = projectObj.projectId;
			obj['Status'] = projectObj.projectStatusFK;
			for( var j:int = 0; j < propertySet.length; j++ ) {
				if( propertySet[ j ] == 'name' ) {
					obj[ propertySet[ j ] ] = projectObj.projectName.substring( ( projectObj.projectName.indexOf( '_' ) + 1 ), projectObj.projectName.length );
				}
				else if( propertySet[ j ] == 'refId' ) {
					obj[ propertySet[ j ] ] = projectObj.projectName.split( '_' )[ 0 ];
				} 
				else if( propertySet[ j ] == 'startDate' ) {
					obj[ propertySet[ j ] ] = dateFormat( projectObj.projectDateStart );
				}
				else if( propertySet[ j ] == 'endDate' ) {
					if( projectObj.projectDateEnd )	obj[ propertySet[ j ] ] = dateFormat( projectObj.projectDateEnd );
					else	obj[ propertySet[ j ] ] = '';
				}
				else if( propertySet[ j ] == 'projectId' ) {
					obj[ propertySet[ j ] ] = projectObj.projectId;
				}
				else if( propertySet[ j ] == 'clientCode' ) {
					obj[ propertySet[ j ] ] = Categories( getDomains( projectObj.categories ) ).categoryCode;
				}
				else if( propertySet[ j ] == 'client' ) {
					obj[ propertySet[ j ] ] = Categories( getDomains( projectObj.categories ) ).categoryName;
				}
				else if( propertySet[ j ] == 'content' ) {
					obj[ propertySet[ j ] ] = getContentValues( projectObj );
				}
				else if( propertySet[ j ] == 'currentProfile' ) { 
					obj[ propertySet[ j ] ] = GetVOUtil.getWorkflowTemplate( projectObj.wftFK ).profileObject.profileLabel;
				} 
				else if( propertySet[ j ] == 'currentTaskDateStart' ) { 
					if( projectObj.currentTaskDateStart ) {
						obj[ propertySet[ j ] ] = dateFormat( projectObj.currentTaskDateStart );
					}
					else	obj[ propertySet[ j ] ] = '';
				}
				else if( propertySet[ j ] == 'currentTaskDelay' ) { 
					obj[ propertySet[ j ] ] = Math.round( DateUtils.ms2hours( DateUtils.dateDiff( projectObj.currentTaskDateStart ) ) ) + ' Hours';
				}
				else if( propertySet[ j ] == 'status' ) { 
					obj[ propertySet[ j ] ] = projectObj.projectStatusFK;
				}
				else if( propertySet[ j ] == 'taskStart' ) { 
					if( projectObj.taskDateStart ) {
						obj[ propertySet[ j ] ] = dateFormat( projectObj.taskDateStart );
					}
					else	obj[ propertySet[ j ] ] = '';
				}
				else if( propertySet[ j ] == 'taskEnd' ) { 
					if( projectObj.taskDateEnd ) {
						obj[ propertySet[ j ] ] = dateFormat( projectObj.taskDateEnd );
					}
					else	obj[ propertySet[ j ] ] = '';
				}
				else if( propertySet[ j ] == 'Phase4Deadline' ) { 
					obj[ propertySet[ j ] ] = dateFormat(( projectObj.phasesSet.getItemAt( projectObj.phasesSet.length - 1 ) as Phases ).phaseEndPlanified);
				} 
				else if( propertySet[ j ] == 'pendingTaskPersonName' ) { 
					obj[ propertySet[ j ] ] = GetVOUtil.getPersonObject( projectObj.finalTask.personFK ).personFirstname;
				}
				else if( propertySet[ j ] == 'pendingTaskName' ) {
					obj[ propertySet[ j ] ] = projectObj.finalTask.workflowtemplateFK.taskLabel;
				}
				else if( propertySet[ j ] == 'currentTaskDelay' ) { 
					obj[ propertySet[ j ] ] = Math.round( DateUtils.ms2hours( DateUtils.dateDiff( projectObj.finalTask.tDateCreation ) ) ) +' Hours';
				}
				else if( propertySet[ j ] == 'currentDeliveryDelay' ) {
					var propPj:Propertiespj = propertyPjForFieldName( 'departure_date_start', projectObj.propertiespjSet );
					if( propPj ) {
						var dateStr:String = propPj.fieldValue; 
						if( ( dateStr != '' ) && dateStr )	{
							dateStr = swapDateMonth( dateStr );
							obj[ propertySet[ j ] ] = Math.round( DateUtils.ms2hours( DateUtils.dateDiff( new Date( dateStr ) ) ) ) + ' Hours';
						}
					}
				}
				else if( propertySet[ j ] == 'delivery_address' ) {
					var str:String = getDeliverSelectedValue( projectObj, 'deliverygroup' );
					if( str != '' ) {
						var arr:Array = str.split(',');
						arr.splice( 0,4 );
						if( arr.indexOf( 'autre' ) != -1 ) {
							arr.splice( arr.indexOf( 'autre' ), 1, getPropertyValue( projectObj, propertySet[ j ], false ) );
						}
						obj[ propertySet[ j ] ] = arr.toString();
					}
					else {
						obj[ propertySet[ j ] ] = '';
					}
				}
				else {
					obj[ propertySet[ j ] ] = getPropertyValue( projectObj, propertySet[ j ], false );
					if( querySet[ j ] != '0' && querySet[ j ] != '1' ) {
						obj[ propertySet[ j ] ] = queryResultMapping( projectObj.projectId, j, propertySet[ j ] ); 
					}  
				}
			}
		} 
		
		public static function queryResultMapping( prjId:int, colIndex:int, header:String ):String {
			var resultColl:ArrayCollection = model.currentReport.resultArray[ colIndex ] as ArrayCollection;
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
		public static function unescapeHTML(str:String):String{ 
 			return str.match(/\w*\</g).join().replace(/\</g,'').replace(/,/g,'')
		}
		public static function modifyTableData( prj:Projects, propertySet:Array, querySet:Array,obj:Object, total:ArrayCollection ):void {
			if( obj ) {
				makeData( prj, obj, propertySet, querySet );
			}
			currentProfileUpdation( total, propertySet );
		}
		
		public static function getPropertyValue( prj:Projects, propertyName:String, isContent:Boolean=false ):String {
			var returnValue:String = '';
			var prjPropList:ArrayCollection = prj.propertiespjSet;
			var prjPropLength:int = prjPropList.length;
			for( var j:int = 0;j < prjPropLength;j++ ) {
				var pjprop:Propertiespj = prjPropList.getItemAt( j ) as Propertiespj;
				if( pjprop.propertyPreset.fieldName  == propertyName ) { 
					if( pjprop.propertyPreset.fieldType == 'popup' ||
					    pjprop.propertyPreset.fieldType == 'radio' ||
					    pjprop.propertyPreset.fieldType == 'checkbox' ) {
					    returnValue = traverseProperties( pjprop.propertyPreset.propertyPresetId, int( pjprop.fieldValue ) );
					}
					else {
						returnValue = pjprop.fieldValue;
					}
					if( propertyName == 'departure_date_start' || propertyName == 'departure_date_end' ) {
						if( returnValue && returnValue != '' ) { 
							returnValue = dateFormat( new Date( swapDateMonth( returnValue ) ) );
						}	
					}
					if( isContent )	returnValue = pjprop.propertyPreset.fieldLabel+' '+returnValue;	
				} 
			}
			return returnValue;
		}
		
		
		public static function traverseProperties( propertyId:int, fieldValue:int ):String {
			var returnValue:String;
			var dp:ArrayCollection = model.propertiespresetsCollection;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( "propertyPresetId" ) ];
            if(dp.sort == null){
           	 	dp.sort = sort;
            	dp.refresh(); 
            }
            var item:Object = { propertyPresetId:propertyId };
            var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );
			if( found ) {
				var ppt:Proppresetstemplates = checkTemplate(cursor.current as Propertiespresets)
					var tempArray:Array
					var tempString:String
				if(ppt == null){
					tempString =  Propertiespresets( cursor.current ).fieldOptionsValue.toString();
					tempArray = tempString.split(",");
				}else{
					tempString =  ppt.fieldOptionsValue.toString();
					tempArray = tempString.split(",");
				}
				returnValue = tempArray[ fieldValue ];
			}
			if( returnValue == null )	returnValue = '';
			return returnValue;
		} 
		public static function checkTemplate( preset:Propertiespresets ):Proppresetstemplates {
			for each( var item:Proppresetstemplates in model.currentProjects.presetTemplateFK.propertiesPresetSet ) {
				if( preset.propertyPresetId == item.propertypresetFK ) {
					if(item.companyFK){
						return item;
					} 
				}
			}
			return null;
		}	
		public static function getImpremiur( id:int ):String {
 			var resultValue:String;
 			for each( var imp:Impremiur in model.ImpremiurCollection ) {
 				if( imp.impremiurId == id ) {
 					resultValue = imp.impremiurLabel;
 					break;
 				}
 			}
 			return resultValue;
 		}
 		
 		public static function getImpremiurLabel( id:int ):Impremiur {
 			var resultValue:Impremiur;
 			for each( var imp:Impremiur in model.ImpremiurCollection ) {
 				if( imp.impremiurId == id ) {
 					resultValue = imp;
 					break;
 				}
 			}
 			return resultValue;
 		}
 		
 		public static function matchingProjects( dataCollection:ArrayCollection ):ArrayCollection {
			var resultCollection:ArrayCollection = new ArrayCollection();
			for( var i:int = 0; i < dataCollection.length; i++ ) {
				var prjId:int = dataCollection.getItemAt( i ).projectId; 
				for( var j:int = 0; j < model.projectsCollection.length; j++ ) {
					if( prjId == Projects( model.projectsCollection.getItemAt( j ) ).projectId ) {
						resultCollection.addItem( model.projectsCollection.getItemAt( j ) );
					}
				}
			}
			return resultCollection;
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
			resultString = proofCollection.toString()+'\n'+dvdCollection.toString();
			return resultString; 
		}
		
		public static function onMonthSelect( selectedIndex:int, dateString:String ):Boolean {
			var returnValue:Boolean;
			var dateArray:Array = dateString.split( "/", 3 );
			var todayBoolean:Boolean = datesChange( new Date( dateArray[ 2 ], dateArray[ 1 ], dateArray[ 0 ] ) ); 
			if( selectedIndex == 1 ) {
				if( todayBoolean )	returnValue = false;
				else	returnValue = true;	
			}
			else if( selectedIndex == 2  ) {
				if( todayBoolean )	returnValue = todayBoolean;
				else	returnValue = false;
			}
			return returnValue;
		}
		
		public static function datesChange( objDate:Date ):Boolean {
			var refDate:Date;
			var found:Boolean;
			refDate = model.currentTime;	
			if( DateUtil.dateCompare( objDate, refDate ) == 0 ) {
				found = true;	
			}
			return found;
		}
		 
		public static function setChartProvider( str:String, sourceAc:ArrayCollection ):ArrayCollection {
			var resultArrayCollection:ArrayCollection = new ArrayCollection();  
		 	if( sourceAc != null ){
				var resultArray:Array = [];
				var resultIndArray:Array = [];
				for ( var i:int = 0; i < sourceAc.length; i++ ) {
					var obj:Object = new Object();
					if( sourceAc.getItemAt( i ) != null ) {
						var storedValue:String = sourceAc.getItemAt( i )[ str ];
						if( resultArray.indexOf( storedValue ) == -1 ) {
							resultArray.push( storedValue );
							resultIndArray[ storedValue ] = resultArrayCollection.length;
							obj.IMP = storedValue;
							obj.PrjCount = 1;
							resultArrayCollection.addItem( obj );
						}
						else{
							var oldObj:Object = resultArrayCollection.getItemAt( resultIndArray[ storedValue ] );
							oldObj.PrjCount = oldObj.PrjCount + 1;
						}	
					}
				}
		 	}
		 	return resultArrayCollection; 
		}
		
		public static function getSpecificProject( prjId:int, item:Projects ):Projects {
			var returnValue:Projects;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'projectId' ) ];
            if( !model.projectsCollection.sort ) {
           	 	model.projectsCollection.sort = sort;
            	model.projectsCollection.refresh(); 
            }  
			var cursor:IViewCursor = model.projectsCollection.createCursor();
			item.projectId = prjId;
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = cursor.current as Projects;
			}
			else {
				returnValue = item;
			}	
			return returnValue;
		} 
		
		public static function projectMap( obj:Object, arrc:ArrayCollection ):Object {
			var returnValue:Object;
			var sort:Sort = new Sort(); 
		    sort.fields = [ new SortField( 'projectId' ) ];
		    arrc.sort = sort;
		    arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( obj );	
			if( found ) {
				returnValue = cursor.current;
			} 	
			return returnValue;
		}
		
		public static function getDashboardProject( obj:Object ):Projects {
			var returnValue:Projects;
			for each( var prj:Projects in model.projectsCollection ) {
				if( obj.projectId == prj.projectId ) {
					returnValue = prj;
					break;
				}	
			}
			return returnValue;
		}
		
		public static function modifyItem( item:Object, arrc:ArrayCollection, sortString:String ):int {
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
		    sort.fields = [ new SortField( sortString ) ];
		    arrc.sort = sort;
		    arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			return returnValue;
		}
		
		public static function modifyItems( oldList:IList, newList:IList, sortString:String ):ArrayCollection {
			for ( var i:int = 0; i < newList.length; i++ ) {
				var isItem:int =  modifyItem( newList.getItemAt( i ), oldList as ArrayCollection, sortString );
				if( isItem != -1 ) {
					oldList.removeItemAt( isItem );
					oldList.addItemAt( newList.getItemAt( i ), isItem );
				}
				else {
					oldList.addItem( newList.getItemAt( i ) );
				}	
			}
			return oldList as ArrayCollection;
		}
		
	    
		public static function createTaskMail(teamLineCollection:ArrayCollection,init:Boolean =false):void{ 
        	try
        	{     	
        		var projectName:String;
        		var taskLabel:String;
        		var currentPersonArr:Array = [];
        		if(init){
        			var workflowTemplate:Workflowstemplates = getWorkflowTemplates(model.modelAnnulationWorkflowTemplate,model.project.workflowFK);
        			for each(var teamLineTemplate : Teamlinestemplates in model.teamLinetemplatesCollection)
					{
						if(workflowTemplate.nextTaskFk.profileFK==teamLineTemplate.profileFk)
	        			currentPersonArr.push(teamLineTemplate.personFk);
					}
	        		projectName = model.project.projectName;
	        		taskLabel = workflowTemplate.nextTaskFk.taskLabel;
        		}else{
	        		for each (var teamLine:Teamlines in teamLineCollection){
	        			if(model.createdTask.workflowtemplateFK.profileFK ==teamLine.profileID)
	        			currentPersonArr.push(teamLine.personID)
	        		}
	        		projectName = model.createdTask.projectObject.projectName;
	        		taskLabel = model.createdTask.workflowtemplateFK.taskLabel
        		} 
				var message:String = "Une nouvelle tache est en attente de votre traitement dans Doctrack.<br>";
				var postmessage:String  = "<br>Type : "+taskLabel+"<br>Project : "+projectName
				var urlText:String = message+postmessage;
				var msgSentTo:String=''
				for(var i:int =0; i<currentPersonArr.length; i++){
					var personId:int = currentPersonArr[i];
        			
        			//-----------NEW SERVER EMAIL ADD START------------------------
        			//SMTPUtil.mail(GetVOUtil.getPersonObject(personId).personEmail,"Nouvelle tache Doctrack: "+projectName,urlText);
					
					var eEvent:SMTPEmailEvent = new SMTPEmailEvent( SMTPEmailEvent.EVENT_CREATE_SMTPEMAIL );
					var _smtpvo:SMTPEmailVO = new SMTPEmailVO();
					_smtpvo.msgTo = GetVOUtil.getPersonObject(personId).personEmail;
					_smtpvo.msgSubject = "Nouvelle tache Doctrack: "+projectName;   
					_smtpvo.msgBody = urlText;
					eEvent.smtpvo = _smtpvo;
					eEvent.dispatch(); 
					//-----------END ------------------------
        			
        			msgSentTo+=(GetVOUtil.getPersonObject(personId).personEmail + ' mail sent')
        		}
        	}
        	catch(r:Error)
        	{
        		CursorManager.removeBusyCursor(); 
        	}
        }
        
        public static function getProfileId( code:String ):int {
        	for each( var item:Profiles in model.teamProfileCollection	) {
        		if( item.profileCode == code ) {
        			return item.profileId; 
        		}
        	}
        	return -1;
        }
        
        public static function getTeamlineOnPersonFK( personId:int, profileId:int ):Teamlines {
        	for each( var item:Teamlines in model.teamlLineCollection 	) {
        		if( ( item.personID == personId ) && ( item.profileID == profileId ) ) {
        			return item; 
        		}
        	}
        	return null;
        }
        
        public static function getDeliveryPerson( id:int, arrc:ArrayCollection ):Persons {
        	for each( var item:Persons in arrc ) {
        		if( item.personId == id ) {
        			return item;
        		}
        	}
        	return null;
        } 
        /**
	    * To check the personLogin Availiability.
	    */
        public static function checkPersonLogin(str:String):Boolean {
        	var retValue:Boolean
        	for each( var totalPerson:Persons in model.personsArrCollection.source ) {
        		if( totalPerson.personLogin == str ) {
        			retValue = true;
        			break;
        		}
        	}
        	return retValue;
        }
        public static function getDeliverSelectedValue( prj:Projects, propertyName:String ):String {
        	var prjPropList:ArrayCollection = prj.propertiespjSet;
			var prjPropLength:int = prjPropList.length;
			for( var j:int = 0;j < prjPropLength;j++ ) {
				var pjprop:Propertiespj = prjPropList.getItemAt( j ) as Propertiespj;
				if( pjprop.propertyPreset.fieldName  == propertyName ) { 
					return pjprop.fieldValue;
				} 
			}
			return '';
        }
        
        public static function getProfilePerson( str:String ):Persons {
        	for each( var team:Teamlines in model.teamlLineCollection ) {
        		if( team.profileID == Utils.getProfileId( str ) ) {
					return getPersonOnFilterApply( team.personID );
				}
			}
			return new Persons();
        } 
        
        public static function getPersonOnFilterApply( personId:int ):Persons {
        	for each( var item:Persons in model.personsArrCollection.source ) {
        		if( item.personId == personId ) {
        			return item;
        		}
        	}
        	return new Persons();
        }
        
        public static function propertyPjForFieldName( str:String, arrc:ArrayCollection ):Propertiespj {
        	for each( var item:Propertiespj in arrc ) {
        		if( item.propertyPreset.fieldName == str ) {
        			return item;
        		}
        	}
        	return null;
        }
        
        public static function getAvailability( prop:Proppresetstemplates, companyFK:int ):Boolean {
    		var retVal:Boolean;
			var selectedPresetTemp:Presetstemplates = Presetstemplates(model.presetTempCollection.getItemAt( 0 ) );
			var _selectedPropPresTempColl:ArrayCollection = selectedPresetTemp.propertiesPresetSet;
			 	for each ( var PropPresetTemp:Proppresetstemplates in _selectedPropPresTempColl ) {
			 		if( PropPresetTemp.propertypresetFK == prop.propertypresetFK ) {
			 			if( PropPresetTemp.companyFK == companyFK) { 
			 				retVal = true;
			 			}
			 		}
			 	}
		 	return retVal;
		 } 
		public static function assignValidation(validationName:String,actionName:String,projectsPropertiespjSet:ArrayCollection):Propertiespj
		{
			var propPreset:Propertiespresets = getPropPreset( validationName );
			var cppvalidPropertyPj:Propertiespj = Utils.getPropertyPj( propPreset.propertyPresetId,projectsPropertiespjSet );
			if(cppvalidPropertyPj!=null){
				if(actionName == "Next")
					cppvalidPropertyPj.fieldValue = "2";
				else
					cppvalidPropertyPj.fieldValue = "1";
			}
			return cppvalidPropertyPj;
		} 
		
		public static function getPropPreset( value:String ):Propertiespresets {
			for each( var item:Propertiespresets in model.propertiespresetsCollection ) {
				if( item.fieldName == value ) {
					return item;
				}
			}
			return null;
		} 
		
		public static function getPropertyString( value:String ):String {
    		var returnValue:String;
    		switch( value ) {
    			case 'CHP':
    				returnValue ="chp_validation";
    			break;
    			case 'CPP':
    				returnValue ="cpp_validation";
    			break;
    			case 'EPR':
    				returnValue ="imp_validation";
    			break;
    			case 'IND':
    				returnValue ="ind_validation";
    			break;
    			case 'AGN':
    				returnValue ="agn_validation";
    			break;
    			case 'COM':
    				returnValue ="comm_validation";
    			break;	    			
    			default:
    			break;
    		}
    		return returnValue;
    	}	
	   public static function getWorkflowstemplates( value:String ):Workflowstemplates {
		   for each( var item:Workflowstemplates in model.workflowstemplatesCollection ) {
		    if( item.taskCode == value ) {
		     return item;
		    }
		   }
		   return null;
	  } 
	  public static function getProjTaskWorfFlowFK( value:int ):Tasks {
		   for each( var item:Tasks in model.currentProjectTasksCollection ) {
		    if( item.workflowtemplateFK.workflowTemplateId == value ) {
		     return item;
		    }
		   }
		   return null;
	  }
	  public static function checkDuplicateReportItem( item:Object, dp:ArrayCollection, sortString:String ):Boolean {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( sortString ) ];
            if( !dp.sort ){
	       	 	dp.sort = sort;
	        	dp.refresh();  
	        }
			var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( ( found ) && ( sortString == 'reportId' ) ) {
				Reports( item ).reportId = Reports( cursor.current ).reportId;
				dp.removeItemAt( dp.getItemIndex( cursor.current ) );
				found = false;
			}
			return found;
		}
	}
}