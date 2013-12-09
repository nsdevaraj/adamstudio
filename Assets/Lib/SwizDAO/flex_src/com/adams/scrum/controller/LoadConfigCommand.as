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
	import air.net.SocketMonitor;
	
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.service.ConfigDetailsDAODelegate;
	import com.adams.scrum.service.NativeMessenger;
	import com.adams.scrum.utils.Utils;
	
	import flash.data.SQLResult;
	import flash.events.StatusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.utils.URLUtil;
	
	
	public class LoadConfigCommand
	{
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		public var delegate:ConfigDetailsDAODelegate = new ConfigDetailsDAODelegate();
		
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
			var result:SQLResult = delegate.getAllConfigDetails();
			var array:Array = [];
			array = result.data as Array;
			if(array!=null){
				var configArrColl:ArrayCollection= new ArrayCollection(array);
				for each(var obj:Object in configArrColl){
					currentInstance.config[obj.Property] = obj.Value;
				} 
			}
			service.serverLocation = currentInstance.config.serverLocation;
			startMonitor(URLUtil.getServerName(service.serverLocation),URLUtil.getPort(service.serverLocation));
			
			service.assignChannelSets();
			if(!service.consumer.subscribed)service.consumer.subscribe();
		}
		private var monitor:SocketMonitor;
		
		private function startMonitor(host:String,port:int):void
		{
			monitor = new SocketMonitor(host,port);
			monitor.addEventListener(StatusEvent.STATUS, checkStatus);
			monitor.pollInterval = 1000; // Every 1/2 second
			monitor.start();         // Monitor for changes in status
		}
		
		private function checkStatus(e:StatusEvent):void {
			if(!monitor.available) { 
				Alert.show('Server Offline',Utils.ALERTHEADER);
			}
		} 
	}
}