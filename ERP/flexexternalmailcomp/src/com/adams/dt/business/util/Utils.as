package com.adams.dt.business.util
{
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.Categories;
	//import com.adams.dt.model.vo.Impremiur;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class Utils
	{
		[Bindable]
		private static var model:ModelLocator = ModelLocator.getInstance(); 
		
		public static var propertyName:String;
		
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
             "<TABLE FRAME=VOID CELLSPACING=0 COLS=4 RULES=GROUPS BORDER=1>" +
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
		public static var monthDisplay:Array =  ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","sep",	"Oct","Nov","Dec"];
		public static function getWorkflowTemplates(wTemplates:ArrayCollection,workflowId:int):Workflowstemplates{
			for each (var wTemp:Workflowstemplates in wTemplates){
				if(wTemp.workflowFK == workflowId){
					return wTemp;
					
				}
			}
			return new Workflowstemplates();
		}
		public static function checkTemplateExist(wTemplates:ArrayCollection,workflowTempId:int):Boolean{
			for each (var wTemp:Workflowstemplates in wTemplates){
				if(wTemp.workflowTemplateId == workflowTempId){
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
			var str:String = monthDisplay[date.month]+"-"+date.date+"-"+date.fullYear;
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
		public static function getName(name:String):Array{
			var array:Array = [];
			/* for (var i:int = 0;i<name.length;i++){
				if(name.charAt(i)=="_"){
					var tempstr:String = name.substring(0,i);
					var remstr:String = name.substring(i+1,name.length);
					array = [tempstr,remstr]
				}	
			} */
			var name_ref:Array = name.split('_')
			array[0] = name_ref[0]
			array[1] = name.slice(name.indexOf('_')+1,name.length);
			return array;
		} 
		public static function todoListUpdate():void{
			var tasks:Tasks = pushtask;
			if(tasks!=null){
				var domain:Categories;
				var isCLT:Boolean;
				if(model.profilesCollection.length>0){
					//if(model.clientCode == 'CLT') isCLT = true
				}  
				if(isCLT){
					domain = tasks.projectObject.categories;
				}else{
					domain = getDomains(tasks.projectObject.categories);	
				}
				
				var taskCollection:ArrayCollection = new ArrayCollection();
				var taskAdded:Boolean;
				taskCollection = model.taskCollection
				
				for each( var item:Object in taskCollection ) {
					if( item.domain.categoryId != null ) {
						if( item.domain.categoryId == domain.categoryId ){
							taskAdded = true;
							var checkProject:Projects = new Projects();
							checkProject.projectId = tasks.projectObject.projectId;
							var projects:Projects = GetVOUtil.getProjectObject(tasks.projectObject.projectId); 
							projects.propertiespjSet = tasks.projectObject.propertiespjSet;
							tasks.projectObject = projects;
							item.tasks.addItem( tasks );
							model.tasks.addItem( tasks );						
							item.tasks.refresh();
							break;
						}
					}
				}
				if( !taskAdded ){
					var object:Object = new Object();
					var coll:ArrayCollection = new ArrayCollection();
					object['domain'] = domain;
					object['tasks'] = coll;
					var checkProject:Projects = new Projects();
					checkProject.projectId = tasks.projectObject.projectId;
					var projects:Projects = GetVOUtil.getProjectObject(tasks.projectObject.projectId); 			
					projects.propertiespjSet = tasks.projectObject.propertiespjSet;
					tasks.projectObject = projects;
					coll.addItem(tasks);
					model.tasks.addItem( tasks );
					coll.refresh();
					taskCollection.addItem( object );
					taskCollection.refresh();
				}
				if(model.currentTasks!=null){
					if(model.currentTasks.taskId == tasks.taskId){
						model.currentTasks.projectObject = tasks.projectObject;
					}
				}
				model.taskCollection.list = taskCollection.list;
				model.taskCollection.refresh();
				model.domainCollection.addItem( domain ); 
			}
		}
		public static var pushtask:Tasks
		public static var tempPrj:Projects
		public static function refreshPendingCollection( prj:Projects ):void {
			if(prj.categories.categoryFK != null){
				refreshProject(prj)
			}
			else if(prj.categoryFKey!=0) { 
					tempPrj = prj
					/* var categoryEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_CATEGORIES);
					categoryEvent.categoryId = prj.categoryFKey;
					categoryEvent.dispatch()  */
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
            dp.sort = sort;
            dp.refresh(); 
			var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( ( found ) && ( sortString == 'projectId' ) ) {
				Projects( item ).categories.projectSet = Projects( cursor.current ).categories.projectSet;
				dp.removeItemAt( dp.getItemIndex( cursor.current ) );
				found = false;
			}
			return found;
		}
	
		public static function setTableData( dataCollection:ArrayCollection, headerSet:Array, propertySet:Array, matchingCollection:Array ):ArrayCollection {
			var loopLength:int = dataCollection.length;
			var arrCollectionBase:ArrayCollection = new ArrayCollection();
			for( var i:int = 0; i < loopLength; i++ ) {
				var projectObj:Projects = Projects( dataCollection.getItemAt( i ) );
				var obj:Object = {};
				makeData( projectObj, obj, propertySet, headerSet );
				matchingCollection[ model.projectsCollection.getItemIndex( projectObj ) ] = obj ;
				arrCollectionBase.addItem( obj );
			}
			return arrCollectionBase;
		}
		
		public static function makeData( projectObj:Projects, obj:Object, propertySet:Array, headerSet:Array ):void {
			for( var j:int = 0; j < propertySet.length; j++ ) {
				if( propertySet[ j ] == 'name' ) {
					obj[ headerSet[ j ] ] = projectObj.projectName;
				}
				else if( propertySet[ j ] == 'imp' ) {
					//obj[ headerSet[ j ] ] = getImpremiur( projectObj.presetTemplateFK.impremiurfk );
				}
				else if( propertySet[ j ] == 'startDate' ) {
					obj[ headerSet[ j ] ] = projectObj.projectDateStart.toString();
				}
				else if( propertySet[ j ] == 'endDate' ) {
					obj[ headerSet[ j ] ] = projectObj.projectDateEnd.toString();
				}
				else if( propertySet[ j ] == 'projectId' ) {
					obj[ headerSet[ j ] ] = projectObj.projectId;
				}
				else if( propertySet[ j ] == 'clientCode' ) {
					obj[ headerSet[ j ] ] = Categories( getDomains( projectObj.categories ) ).categoryCode;
				}
				else if( propertySet[ j ] == 'client' ) {
					obj[ headerSet[ j ] ] = Categories( getDomains( projectObj.categories ) ).categoryName;
				}
				else if( propertySet[ j ] == 'content' ) {
					obj[ headerSet[ j ] ] = getContentValues( projectObj );
				}
				else {
					obj[ headerSet[ j ] ] = getPropertyValue( projectObj, propertySet[ j ], false );
				}
			}
		} 
		
		public static function modifyTableData( headerSet:Array, propertySet:Array, matchingCollection:Array ):void {
			var index:int = model.projectsCollection.getItemIndex( model.currentProjects );
			if( matchingCollection != null ) {
				if( matchingCollection[ index ] != undefined ) {
					makeData( model.currentProjects, matchingCollection[ index ], propertySet, headerSet );
				}	
			}
		}
		
		public static function getPropertyValue( prj:Projects, propertyName:String, isContent:Boolean ):String {
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
					if( isContent )	returnValue = pjprop.propertyPreset.fieldLabel  + ' '+ returnValue;	
				} 
			}
			return returnValue;
		}
		
		public static function traverseProperties( propertyId:int, fieldValue:int ):String {
			var returnValue:String;
			var dp:ArrayCollection = model.propertiespresetsCollection;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( "propertyPresetId" ) ];
            dp.sort = sort;
            dp.refresh(); 
            var item:Propertiespresets = new Propertiespresets();
            item.propertyPresetId = propertyId;
            var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );
			if( found ) {
				var tempString:String =  Propertiespresets( cursor.current ).fieldOptionsValue.toString();
				var tempArray:Array = tempString.split(",");
				returnValue = tempArray[ fieldValue ];
			}
			if( returnValue == null )	returnValue = '';
			return returnValue;
		} 
		/* public static function getImpremiur( id:int ):String {
 			var resultValue:String;
 			for each( var imp:Impremiur in model.ImpremiurCollection ) {
 				if( imp.impremiurId == id ) {
 					resultValue = imp.impremiurLabel;
 					break;
 				}
 			}
 			return resultValue;
 		} */
 		
 		public static function matchingProjects( dataCollection:ArrayCollection ):ArrayCollection {
			var resultCollection:ArrayCollection = new ArrayCollection();
			for( var i:int = 0; i < dataCollection.length; i++ ) {
				var prjName:String = dataCollection.getItemAt( i ).ReferenceName; 
				for( var j:int = 0; j < model.projectsCollection.length; j++ ) {
					if( prjName == Projects( model.projectsCollection.getItemAt( j ) ).projectName ) {
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
	}
}