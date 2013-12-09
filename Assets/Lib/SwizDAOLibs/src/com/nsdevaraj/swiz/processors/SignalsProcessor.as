/*
Copyright 2010 Samuel Ahn

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package com.nsdevaraj.swiz.processors {

	
	import flash.utils.getDefinitionByName;
	
	import org.osflash.signals.IDeluxeSignal;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;  
	import org.swizframework.core.Bean;
	import org.swizframework.processors.BaseMetadataProcessor;
	import org.swizframework.reflection.BaseMetadataTag;
	import org.swizframework.reflection.IMetadataTag;
	import org.swizframework.reflection.MetadataArg;
	import org.swizframework.reflection.MetadataHostMethod;
	import org.swizframework.reflection.MethodParameter;
	import org.swizframework.utils.logging.SwizLogger;

	/**
	 * MediateSignalsProcessor is the Signal version of MediateProcessor. After defining 
	 * Signal or DeluxeSignal Beans, decorate Signal listener methods with the [MediateSignal]
	 * metadata tag and set a bean name ("bean" property) or type ("type" property) which 
	 * is useful when subclassing Signals. "bean" is the default property. You may also use 
	 * the "priority" property for DeluxeSignals. 
	 */ 
	public class SignalsProcessor extends BaseMetadataProcessor {

		protected static const CONTROL_SIGNAL:String = "ControlSignal";
		
		protected static const WILDCARD_PACKAGE:RegExp = /\A(.*)(\.\**)\Z/;
		
		internal var logger:SwizLogger = SwizLogger.getLogger(this);
		
		protected var _signalPackages:String;
		
		public var strictArgumentTypes:Boolean = false;
		
		public function get signalPackages():String {
			return _signalPackages;
		}
		
		public function set signalPackages(value:String):void {
			_signalPackages = value;
		}
		
		public function SignalsProcessor() {
			super([CONTROL_SIGNAL]);
		}
 
		override public function setUpMetadataTag(metadataTag:IMetadataTag, bean:Bean):void {
			var signalBean:Bean = getSignalBean();
			var typeArg:MetadataArg = metadataTag.getArg("type");

			if (signalBean == null) {
				logger.error("[MediateSignalsProcessor] Bean not found for tag {0}", (metadataTag as BaseMetadataTag).asTag);
				return;
			} 
			
			var listener:Function = bean.source[metadataTag.host.name];
			var signals:ISignal;
			if (typeArg) { 
				signals = signalBean.source[typeArg.value];
			}
			if (signals is ISignal) {
				var signal:ISignal = signals as ISignal;
				signal.add(listener);
			} else if (signals is IDeluxeSignal) {
				var deluxeSignal:IDeluxeSignal = signals as IDeluxeSignal;
				var priorityArg:MetadataArg = metadataTag.getArg("priority");
				var priority:int = priorityArg ? int(priorityArg.value) : 0; 
				deluxeSignal.addWithPriority(listener, priority);
			}
		}
						
		override public function tearDownMetadataTag(metadataTag:IMetadataTag, bean:Bean):void {
			var signalBean:Bean = getSignalBean();
			
			if (signalBean) {
				var listener:Function = bean.source[metadataTag.host.name];
				
				var typeArg:MetadataArg = metadataTag.getArg("type");
				var signals:ISignal
				if (typeArg) { 
					signals = signalBean.source[typeArg.value];
				}
				if (signals is ISignal) {
					var signal:ISignal = signals as ISignal;
					signal.remove(listener);
				} else if (signals is IDeluxeSignal) {
					var deluxeSignal:IDeluxeSignal = signals as IDeluxeSignal; 
					deluxeSignal.remove(listener);
				}
			}
		}
 
		private function getSignalBean():Bean {
			var signalBean:Bean = beanFactory.getBeanByType(findClassDefinition(CONTROL_SIGNAL,[signalPackages]))
			return signalBean;
		}
		
		/*
		Lookup logic copied from ClassConstant.
		*/
		private static function findClassDefinition(className:String, packageNames:Array):Class {
			var definition:Class;
			for each(var packageName:String in packageNames) {
				definition = getClassDefinitionByName(packageName + "." + className) as Class;
				if (definition != null) {
					break;
				}
			}
			return definition;
		}
		
		private static function getClassDefinitionByName(className:String):Class {
			var definition:Class;
			try {
				definition = getDefinitionByName(className) as Class;
			} catch (e:Error) {
				// Nothing
			}
			return definition;
		}
		private function isValidHostArguments(hostParameters:Array, signalValueClasses:Array):Boolean {
			// Compare lengths
			if (hostParameters.length != signalValueClasses.length) {
				return false;
			}
			// If strict mode, then check types
			if (strictArgumentTypes) {
				hostParameters.sortOn("index", Array.NUMERIC);
				var ilen:int = signalValueClasses.length;
				var hostParameter:MethodParameter;
				var signalValueClass:Class;
				for (var i:int = 0; i < ilen; i++) {
					signalValueClass = signalValueClasses[i] as Class;
					hostParameter = hostParameters[i] as MethodParameter;
					// It would be nice if this accounted for interface implementations
					if (signalValueClass != hostParameter.type) {
						return false;
					}
				}
			}
			
			return true;
		} 
	}
}