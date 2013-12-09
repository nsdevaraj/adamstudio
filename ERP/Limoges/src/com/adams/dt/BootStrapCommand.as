/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt
{
	import com.adams.dt.model.vo.*;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.view.components.FileUploadTileList;
	import com.adams.swizdao.controller.ServiceController;
	import com.adams.swizdao.model.vo.CurrentInstance;
	
	import mx.core.FlexGlobals;
	
	
	public class BootStrapCommand
	{
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var service:ServiceController; 
		
		[Inject("Basic")]
		public var basicFileUploadTileList:FileUploadTileList;
		
		[Inject("Tasks")]
		public var taskFileUploadTileList:FileUploadTileList;
		
		[Inject("Release")]
		public var releaseFileUploadTileList:FileUploadTileList;
		
		public static var isDebugMode:Boolean = false; 
		/** <p>
		 * Boot straps the application from context, 
		 * with postconstruct metadata the function is called after Injection is performed.
		 * </p>
		 */
		[PostConstruct]
		public function execute():void
		{
			currentInstance.config.serverLocation =FlexGlobals.topLevelApplication.parameters.serverLocation;
			//'http://'+URLUtil.getServerNameWithPort(FlexGlobals.topLevelApplication.url)+"/webapp/" 
			currentInstance.config.FileServer = FlexGlobals.topLevelApplication.parameters.FileServer;
			
			CONFIG::DEBUG
			{
				isDebugMode = true;
			}
			currentInstance.mapConfig = new MapConfigVO();
			if(isDebugMode){
				service.serverLocation = currentInstance.config.serverLocation;
				service.assignChannelSets();
				if(!service.consumer.subscribed)service.consumer.subscribe();
			}else{
				currentInstance.mapConfig.currentPerson = new Persons();
				currentInstance.mapConfig.currentProject = new Projects();
				currentInstance.mapConfig.currentTasks = new Tasks();
			}
			
			basicFileUploadTileList.serverPath = currentInstance.config.serverLocation;
			basicFileUploadTileList.destinationPath = currentInstance.config.FileServer; 
			taskFileUploadTileList.serverPath = currentInstance.config.serverLocation;
			taskFileUploadTileList.destinationPath = currentInstance.config.FileServer; 
			releaseFileUploadTileList.serverPath = currentInstance.config.serverLocation;
			releaseFileUploadTileList.destinationPath = currentInstance.config.FileServer; 
			currentInstance.mapConfig.autoTimerInterval = parseInt(FlexGlobals.topLevelApplication.parameters.autoTimerInterval) * 60 * 1000;
			currentInstance.mapConfig.timeServer = (FlexGlobals.topLevelApplication.parameters.TimeServer);
			ProcessUtil.timeDiff = currentInstance.mapConfig.timeServer * 60 * 60 * 1000;
			currentInstance.config.pdfServerDir = FlexGlobals.topLevelApplication.parameters.pdfServerDir;
			( currentInstance.config.pdfServerDir.indexOf( '.sh' ) == -1 ) ? currentInstance.mapConfig.serverOSWindows=true : currentInstance.mapConfig.serverOSWindows=false;
			var currentTimeZone:Date = new Date();
			if(currentTimeZone.timezoneOffset == -330){
			  ProcessUtil.isIndia = true; 
			}
		} 
	}
}