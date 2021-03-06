/*
 * Copyright 2010 @nsdevaraj
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.adams.scrum.controller
{
	
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.service.NativeMessenger;
	import com.adams.scrum.utils.Utils;
	
	import flash.events.StatusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.utils.URLUtil;
	
	
	public class LoadConfigCommand
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
			currentInstance.config.serverLocation ='http://62.193.234.4:8180/SwizDAO/';// 'http://'+URLUtil.getServerNameWithPort( FlexGlobals.topLevelApplication.url)+"/SwizDAO/";
			currentInstance.config.FileServer = FlexGlobals.topLevelApplication.parameters.FileServer; 
			currentInstance.config.VersionServer =''// FlexGlobals.topLevelApplication.parameters.VersionServer; 			
			
			Utils.version = currentInstance.config.VersionServer;
			service.serverLocation = currentInstance.config.serverLocation;			
			service.assignChannelSets();
			if(!service.consumer.subscribed)service.consumer.subscribe();
		} 
	}
}