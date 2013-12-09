/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf
{
	
	import com.adams.pdf.model.vo.MapConfigVO;
	import com.adams.pdf.view.components.FileUploadTileList;
	import com.adams.swizdao.controller.ServiceController;
	import com.adams.swizdao.model.vo.CurrentInstance;
	
	import flash.events.StatusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.utils.URLUtil;
	
	
	public class BootStrapCommand
	{
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var service:ServiceController; 
		
		[Inject("Basic")]
		public var basicFileUploadTileList:FileUploadTileList;
		
		/** <p>
		 * Boot straps the application from context, 
		 * with postconstruct metadata the function is called after Injection is performed.
		 * </p>
		 */
		[PostConstruct]
		public function execute():void
		{
			//currentInstance.config.serverLocation = 'http://192.168.1.102:8080/PDFTool/'; 
			currentInstance.config.serverLocation ='http://'+URLUtil.getServerNameWithPort(FlexGlobals.topLevelApplication.url)+"/PDFTool/" 
			currentInstance.config.FileServer = 'c://temp/';
			
			currentInstance.mapConfig = new MapConfigVO(); 
			service.serverLocation = currentInstance.config.serverLocation;
			service.assignChannelSets();
			if(!service.consumer.subscribed)service.consumer.subscribe();
			basicFileUploadTileList.serverPath = currentInstance.config.serverLocation;
			basicFileUploadTileList.destinationPath = currentInstance.config.FileServer; 
			currentInstance.mapConfig.autoTimerInterval = parseInt(FlexGlobals.topLevelApplication.parameters.autoTimerInterval) * 60 * 1000;
			currentInstance.mapConfig.timeServer = (FlexGlobals.topLevelApplication.parameters.TimeServer);
			
			currentInstance.config.pdfServerDir = 'c:\\temp\\pdf2swf.bat';
			
			( currentInstance.config.pdfServerDir.indexOf( '.sh' ) == -1 ) ? currentInstance.mapConfig.serverOSWindows=true : currentInstance.mapConfig.serverOSWindows=false;
		} 
	}
}