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
package com.adams.swizdao.util {
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.Stage;
	import flash.events.GeolocationEvent;
	import flash.media.CameraUI;
	import flash.media.StageWebView;
	import flash.sensors.Geolocation;
	
	public class FBUtil
	{
	    public static var facebookWebView : Object;
		public static var mobileCam : Object;
		public static var mobileLocation : Object;  
		 
		public static function initGeolocation(onUpdate:Function):void{
			mobileLocation = new Geolocation();
			mobileLocation.addEventListener(GeolocationEvent.UPDATE, onUpdate, false, 0 ,true);
		}
		
		public static function removeGeolocation(onUpdate:Function):void{
			mobileLocation.removeEventListener(GeolocationEvent.UPDATE, onUpdate);
		}
		
		public static function initMobileCam():void{
			mobileCam = new CameraUI();
		}
		
		public static function initfacebookWebView():void{
			facebookWebView = new StageWebView();
		}
		
		public static function faceBookLogin( loginHandler:Function, stg:Stage, permissions:Array, facebookWeb:Object):void{
			FacebookMobile.login(loginHandler, stg, permissions, facebookWeb as flash.media.StageWebView);
		} 
	}
}