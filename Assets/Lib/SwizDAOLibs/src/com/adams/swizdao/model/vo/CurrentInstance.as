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
package com.adams.swizdao.model.vo
{
	
	
	[Bindable]
	public class CurrentInstance extends AbstractVO
	{   
		
		public function get waitingForServerResponse():Boolean
		{
			return _waitingForServerResponse;
		}
		
		public function set waitingForServerResponse(value:Boolean):void
		{
			_waitingForServerResponse = value;
		}
		
		public function get serverLastAccessedAt():Date
		{
			return _serverLastAccessedAt;
		}
		
		public function set serverLastAccessedAt(value:Date):void
		{
			_serverLastAccessedAt = value;
		}
		
		public function get idle():Boolean
		{
			var timeStamp:Date = new Date();
			var diffmillisecs:int =  -(serverLastAccessedAt.time - timeStamp.time);
			var diffmins:int = diffmillisecs/60000;
			(diffmins>1)? _idle=true: _idle=false;  
			return _idle;
		}
		
		
		
		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}
		
		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
		}
		
		private var _config:ConfigVO = new ConfigVO();
		public function set config (value:ConfigVO):void
		{
			_config = value;
		}
		
		public function get config ():ConfigVO
		{
			return _config;
		} 
		private var _mapConfig:Object;
		public function set mapConfig (value:Object):void
		{
			_mapConfig = value;
		}
		
		public function get mapConfig ():Object
		{
			return _mapConfig;
		} 
		private var _mainViewStackIndex:int;
		private var _serverLastAccessedAt:Date = new Date();
		private var _idle:Boolean; 
		private var _waitingForServerResponse:Boolean;
	}
}