/*

Copyright (c) @year@ @company.name@, All Rights Reserved 

@author   @author.name@
@contact  @author.email@
@project  @project.name@

@internal 

*/
package @namespace@
{
	
	import com.adams.swizdao.controller.ServiceController;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import @namespace@.model.vo.MapConfigVO;
	
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
		/** <p>
		 * Boot straps the application from context, 
		 * with postconstruct metadata the function is called after Injection is performed.
		 * </p>
 		 */
		[PostConstruct]
		public function execute():void
		{
		/*	
			currentInstance.config.serverLocation =FlexGlobals.topLevelApplication.parameters.serverLocation;
			//'http://'+URLUtil.getServerNameWithPort(FlexGlobals.topLevelApplication.url)+"/webapp/" 
			service.serverLocation = currentInstance.config.serverLocation;
			currentInstance.mapConfig =new MapConfigVO();
			service.assignChannelSets();
			if(!service.consumer.subscribed)service.consumer.subscribe();*/
		} 
	}
}