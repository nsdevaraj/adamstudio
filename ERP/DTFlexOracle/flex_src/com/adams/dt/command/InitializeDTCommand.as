package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Pdf2SwfUtil;
	import com.adams.dt.business.util.StringUtils;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.AuthenticationEvent;
	import com.adams.dt.event.ChannelSetEvent;
	import com.adams.dt.event.DomainWorkFlowEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.LangEvent;
	import com.adams.dt.event.LocalDataBaseEvent;
	import com.adams.dt.event.ModuleEvent;
	import com.adams.dt.event.ReportEvent;
	import com.adams.dt.event.TranslationEvent;
	import com.adams.dt.event.loginevent.LogOutEvent;
	import com.adams.dt.event.scheduler.CurrentProjectEvent;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Columns;
	import com.adams.dt.model.vo.DomainWorkflow;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.LoginVO;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.ReportColumns;
	import com.adams.dt.model.vo.Reports;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.serialization.json.JSON;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	public final class InitializeDTCommand extends AbstractCommand 
	{ 
		private var translatorEvent : TranslationEvent;
		private var fileutilEvent : FileDetailsEvent;
		private var reportEvent : ReportEvent;		
		private var domainWorkFlow_Event : DomainWorkFlowEvent;
		private var domainEvent:DomainWorkFlowEvent
		private var loginVO : LoginVO;
		private var channelSet : ChannelSet;
		
		private var fileDetails:FileDetails;
		private var reportsEvent :ReportEvent;
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			var localdelegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();
			var localDataBaseEvent : LocalDataBaseEvent; 
			this.delegate = DelegateLocator.getInstance().languageDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){  
				case ChannelSetEvent.SET_CHANNEL:
					var channel : AMFChannel = new AMFChannel("my-amf" , model.serverLocation + "spring/messagebroker/amf");
					channelSet = new ChannelSet();
					channelSet.addChannel(channel);
					model.channelSet = channelSet;
					var authenticationEvent : AuthenticationEvent = new AuthenticationEvent( ChannelSetEvent( event ).loginVO );
 					authenticationEvent.dispatch();  
					break; 
				case LangEvent.EVENT_GET_ALL_LANGS:
					delegate.responder = new Callbacks(findAllLangResult,fault);
					delegate.findAll();
					break;
				case ReportEvent.EVENT_GET_ALL_REPORTS:
					delegate = DelegateLocator.getInstance().reportsDelegate;
					delegate.responder = new Callbacks(findAllReportResult,fault); 
					delegate.findAll();
					break;  
				case ReportEvent.EVENT_GET_PROFILE_REPORTS:
					reportEvent = ReportEvent(event);
					delegate = DelegateLocator.getInstance().reportsDelegate;
					delegate.responder = new Callbacks(findByIDReportResult,fault);
					if(model.allReports!='true'){
						delegate.findById(reportEvent.profileFk);
					}else{
						delegate.findAll();
					} 					
					break;
				case ReportEvent.EVENT_GET_REFERENCE_REPORTS:
					reportEvent = ReportEvent( event );
					delegate = DelegateLocator.getInstance().reportsDelegate;
					delegate.responder = new Callbacks( referenceReportResult, fault );
					delegate.findById( reportEvent.profileFk );
					break;
				case ReportEvent.EVENT_ORDER_COLUMNS:
					reportEvent = ReportEvent(event);
					delegate = DelegateLocator.getInstance().reportsDelegate;
					for each (var col:Columns in reportEvent.reportentry.columnSet){
					model.orderColumns.addItem(col);
					}
					delegate.responder = new Callbacks(orderReportResult,fault);
					reportEvent.reportentry.columnSet.removeAll();
					delegate.directUpdate(reportEvent.reportentry);
					break;
				case ReportEvent.EVENT_CREATE_REPORTS:
					reportEvent = ReportEvent(event);
					delegate = DelegateLocator.getInstance().reportsDelegate;
					delegate.responder = new Callbacks(insertReportResult,fault);
					delegate.create(reportEvent.reportentry);
					break;
				case ReportEvent.EVENT_UPDATE_COLUMNS:
					reportEvent = ReportEvent(event);
					delegate = DelegateLocator.getInstance().reportsColumnDelegate;
					delegate.bulkUpdate(reportEvent.reportsCollection);
					break;
				case ReportEvent.EVENT_UPDATE_REPORTS:
					reportEvent = ReportEvent(event);
					delegate = DelegateLocator.getInstance().reportsDelegate;
					delegate.responder = new Callbacks(updateReportResult,fault); 
					delegate.bulkUpdate(reportEvent.reportsCollection);
					break;	
				case ReportEvent.EVENT_DELETE_REPORTS:
					reportEvent = ReportEvent(event);
					delegate = DelegateLocator.getInstance().reportsDelegate; 
					delegate.deleteVO(reportEvent.reportentry);
					break;	
			    break; 		  					
				case FileDetailsEvent.EVENT_CONVERT_FILE:
					fileutilEvent = FileDetailsEvent(event);
					delegate = DelegateLocator.getInstance().fileutilDelegate;
					delegate.responder = new Callbacks(conversionResult,fault); 
					fileDetails = fileutilEvent.fileObj; 
					delegate.doConvert(fileutilEvent.PDFfilepath,fileutilEvent.PDFconversionexe);
					break;                   
				case TranslationEvent.GOOGLE_TRANSLATE:
					translatorEvent = TranslationEvent(event);
					delegate = DelegateLocator.getInstance().translateDelegate;
					delegate.responder = new Callbacks(translationResult,fault);
					model.currentTranslation = translatorEvent.translateVO;
					if(model.currentTranslation.sourceLanguage == model.ENGLISH)
					{
						model.textSource = model.currentTranslation.englishText;
						delegate.changetoFrench();
					}else
					{
						model.textSource = model.currentTranslation.frenchText;
						delegate.changetoEnglish();
					}
					break;                   
				case LogOutEvent.EVENT_LOGOUT:
					var loginData : LoginVO = event.data;
					delegate = DelegateLocator.getInstance().logoutDelegate;
					delegate.responder = new Callbacks(logoutResult,fault); 
				
					var logoutEvent : LogOutEvent = LogOutEvent(event);
					model.ChatPerson.loginStatus = "Offline"; 
					logoutResult()
					model.login.userName = "";
					model.login.password = "";
					model.login.userFirstName = "";
					model.dataReach = false;
					model.workflowState = 0;
					model.workflowState = model.LOGIN_FAILED;
					model.channelSet.logout();
					break;                   
				case CurrentProjectEvent.GOTO_CURRENTPROJECT:
					var projName : String = CurrentProjectEvent( event ).projectName;
					var pendingProjectCollection_Len:int=model.projectsCollection.length;
					for( var i : int = 0; i < pendingProjectCollection_Len; i++)
					{
						if( Projects( model.projectsCollection.getItemAt( i ) ).projectName == projName )
						{
							model.currentProjects = Projects( model.projectsCollection.getItemAt( i ) );
						}
					} 
					model.currentMainProject = model.currentProjects;
					model.preloaderVisibility = true;
					model.mainProjectState = 1;
					break;     
				case DomainWorkFlowEvent.EVENT_CREATE_DOMAIN_WORKLFLOW:
					delegate = DelegateLocator.getInstance().domainWorkflowDelegate;
				    delegate.bulkUpdate(DomainWorkFlowEvent(event).domainWorkFLowArr); 
				    break;
				case DomainWorkFlowEvent.BULK_UPDATE_DOMAIN_WORKLFLOW:
					delegate = DelegateLocator.getInstance().domainWorkflowDelegate;
				    delegate.bulkUpdate(DomainWorkFlowEvent(event).domainWorkFLowArr); 
				    break; 
				case DomainWorkFlowEvent.EVENT_GET_ALL_DOMAIN_WORKLFLOW:
				    delegate = DelegateLocator.getInstance().domainWorkflowDelegate;
				    var domainWfEvent:DomainWorkFlowEvent = DomainWorkFlowEvent(event); 
 				    delegate.responder = new Callbacks(getAllDomainWorkFlowResult,fault); 
					delegate.findAll();
				    break; 
				case ModuleEvent.EVENT_GET_ALL_MODULES:
					delegate = DelegateLocator.getInstance().moduleDelegate;
					var moduleEv:ModuleEvent= ModuleEvent(event);
					delegate.responder = new Callbacks(getAllModuleResult,fault); 
					delegate.findById(moduleEv.profile.profileId);
					break;
				default:
					break; 
				}
		} 
		public function orderReportResult( rpcEvent : Object ) : void{
			var reportEvent:ReportEvent = new ReportEvent(ReportEvent.EVENT_UPDATE_COLUMNS);
			var rep:Reports= rpcEvent.result as Reports;
			for each(var col: Columns in model.orderColumns){
				var repcol:ReportColumns = new ReportColumns();
				repcol.reportfk = rep.reportId;
				repcol.columnfk = col.columnId;
				reportEvent.reportsCollection.addItem(repcol);
			}
			reportEvent.dispatch();  
			super.result(rpcEvent);
		}
		public function insertReportResult( rpcEvent : Object ) : void{			
			var arraryColl:ArrayCollection = rpcEvent.result as ArrayCollection;
			super.result(rpcEvent);			
		}
		public function updateReportResult( rpcEvent : Object ) : void{ 
			var returnCollection:ArrayCollection = rpcEvent.result as ArrayCollection; 
			model.reportAllColl = new ArrayCollection();
			for each (var reportObj:Reports in returnCollection){
				for each (var col:Columns in reportObj.columnSet){
					reportObj.headerArray.push(col.columnName);
					reportObj.fieldArray.push(col.columnField);
					reportObj.widthArray.push(col.columnWidth);
					reportObj.booleanArray.push(col.columnFilter);
					reportObj.resultArray.push('');
				}
				model.reportAllColl.addItem(reportObj);
			}  
			super.result(rpcEvent);
		}
		public function deleteReportResult( rpcEvent : Object ) : void{		 
			var returnCollection:ArrayCollection = rpcEvent.result as ArrayCollection; 
			for each (var reportObj:Reports in returnCollection){
				for each (var col:Columns in reportObj.columnSet){
					reportObj.headerArray.push(col.columnName);
					reportObj.fieldArray.push(col.columnField);
					reportObj.widthArray.push(col.columnWidth);
					reportObj.booleanArray.push(col.columnFilter);
					reportObj.resultArray.push('');
				}
				model.reportAllColl.addItem(reportObj);
			}  
			super.result(rpcEvent);
		}
		
		public function getAllModuleResult( rpcEvent : Object ) : void{
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.getAllModules = new ArrayCollection( model.getAllModules.source.concat(arrc.source));
			super.result(rpcEvent);
		}
		
		private function getSpecialWorkFlowsOnly(item:DomainWorkflow):Boolean
	  	{
	  		var retVal : Boolean = false;
			if ( item.domainFk == domainId)
			{ 
				retVal = true;
			}
			return retVal;
	  	}
	  	private var domainId:int
		public function getAllDomainWorkFlowResult( rpcEvent : Object ) : void{
			model.getAllDomainWorkflows = rpcEvent.result as ArrayCollection;
			for each(var domain:Categories in model.collectAllDomains){ 
				domainId = domain.categoryId;
				model.getAllDomainWorkflows.filterFunction = getSpecialWorkFlowsOnly;
	  			model.getAllDomainWorkflows.refresh();
	  			for each(var domainWf:DomainWorkflow in model.getAllDomainWorkflows){
					domain.domainworkflowSet.addItem(domainWf);
				}
				model.getAllDomainWorkflows.filterFunction = null;
				model.getAllDomainWorkflows.refresh();
			}
			super.result(rpcEvent);
		}
		
		public function logoutResult() : void
		{ 
			model.logOutApplication = true;
			model.mainClass.reboot();
		}
		
		public function conversionResult( rpcEvent : Object ) : void
		{
			var returnStr:String = rpcEvent.result as String; 
			if(returnStr.indexOf('OK:')!=-1){
				var lastind:int;
				(model.pdfServerDir.indexOf('.sh')!=-1) ?  lastind=1 : lastind=2;
				var charspl:int;
				(model.pdfServerDir.indexOf('.sh')!=-1) ?  charspl=4 : charspl=5; 
				var convertedSwf:String = returnStr.substring(charspl,returnStr.length-lastind);
				(model.pdfServerDir.indexOf('.sh')!=-1) ?  convertedSwf+=', ' : convertedSwf;
				var convertedSwfArr:Array = convertedSwf.split(",");
				
				if(convertedSwfArr.length==1){
					Alert.show("Files Conversion not done");
				}  
				for( var i:int=0; i<convertedSwfArr.length-1;i++){
					var fileObject:FileDetails = new FileDetails();
					fileObject.fileId = NaN
		          	fileObject.fileName = getFileName(convertedSwfArr[i]);
		          	fileObject.storedFileName = fileObject.fileName;
		    		fileObject.taskId = fileDetails.taskId;
		    		fileObject.categoryFK = 0;
		    		fileObject.fileCategory	= fileDetails.fileCategory;
		    		fileObject.fileDate = model.currentTime;
		    		fileObject.visible = false;
		    		fileObject.sourcePath = fileDetails.sourcePath;
					fileObject.projectFK =  fileDetails.projectFK;
		          	fileObject.filePath = StringUtils.trimSpace( convertedSwfArr[i])//fileDetails.destinationpath+"/"+fileDetails.type+"/"+fileObject.storedFileName;
		          	fileObject.type = fileDetails.type;
		          	fileObject.miscelleneous = fileDetails.miscelleneous;
		          	if(Utils.checkTemplateExist(model.firstRelease,GetVOUtil.getProjectObject(fileDetails.projectFK).workflowFk.workflowId)){
						fileObject.releaseStatus = 1;
					}else if(Utils.checkTemplateExist(model.otherRelease,GetVOUtil.getProjectObject(fileDetails.projectFK).workflowFk.workflowId)){
						fileObject.releaseStatus = 2;
					}
		          	fileObject.page = i+1;
		          	model.fileDetailsToUpdate.addItem(fileObject);
		  		}
			}else{
				Alert.show("Files Conversion not done");
			}
			 Pdf2SwfUtil.loopConvertSWF();
			
		}
		public function getFileName(str:String):String{
			var lastind:int = str.lastIndexOf('/')+1
			return str.slice(lastind,str.length);
		}
		public function findAllLangResult( rpcEvent : Object ) : void
		{ 
			super.result(rpcEvent);
			model.langEntriesCollection = rpcEvent.result as ArrayCollection;
			var sort : Sort = new Sort();
			sort.fields = [new SortField("formid")];
			model.langEntriesCollection.sort = sort;
			model.langEntriesCollection.refresh();
			model.myLoc.langXML = model.langEntriesCollection;
			model.loc = model.myLoc;
			model.appDomain == 'Brennus'? model.loc.language = "En" : model.loc.language = "Fr";
		}
		public function findByIDReportResult( rpcEvent : Object ) : void
		{ 
			if( model.preloaderVisibility )	model.preloaderVisibility = false;
			super.result(rpcEvent);
			model.tabsCollection = new ArrayCollection();
			var returnCollection:ArrayCollection = rpcEvent.result as ArrayCollection;
			for each (var reportObj:Reports in returnCollection){
				for each (var col:Columns in reportObj.columnSet){
					reportObj.headerArray.push(col.columnName);
					reportObj.fieldArray.push(col.columnField);
					reportObj.widthArray.push(col.columnWidth);
					reportObj.booleanArray.push(col.columnFilter);
					reportObj.resultArray.push('');
				}
				model.tabsCollection.addItem(reportObj);
			} 
		}
		
		private function referenceReportResult( rpcEvent : Object ) : void {
			super.result( rpcEvent );
			var returnCollection:ArrayCollection = rpcEvent.result as ArrayCollection;
			for each ( var reportObj:Reports in returnCollection ) {
				for each ( var col:Columns in reportObj.columnSet ) {
					reportObj.headerArray.push( col.columnName );
					reportObj.fieldArray.push( col.columnField );
					reportObj.widthArray.push( col.columnWidth );
					reportObj.booleanArray.push(Boolean( col.columnFilter ) );
				}
				//unwanted AC
				//model.referenceProjectCollection.addItem( reportObj );
			}
		}
		
		public function findAllReportResult( rpcEvent : Object ) : void { 
			super.result(rpcEvent);
			var returnCollection:ArrayCollection = rpcEvent.result as ArrayCollection; 
			for each (var reportObj:Reports in returnCollection){
				for each (var col:Columns in reportObj.columnSet){
					reportObj.headerArray.push(col.columnName);
					reportObj.fieldArray.push(col.columnField);
					reportObj.widthArray.push(col.columnWidth); 
				    reportObj.booleanArray.push(col.columnFilter);
					reportObj.resultArray.push('');
				}
				model.reportAllColl.addItem(reportObj);
			}  
		}
		public function translationResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var rawData : String = String(rpcEvent.result);
			if(JSON.decode(rawData).responseData.translatedText != null)
			{
				var decoded : String = JSON.decode(rawData).responseData.translatedText;
			}else
			{
				decoded = "No support";
			}

			if(model.currentTranslation.sourceLanguage == model.ENGLISH)
			{
				translatorEvent.translateVO.frenchText = decoded;
			}else
			{
				translatorEvent.translateVO.englishText = decoded;
			}
		}			 
 	}
}