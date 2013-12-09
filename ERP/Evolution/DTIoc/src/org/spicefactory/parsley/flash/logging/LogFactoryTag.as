/*
 * Copyright 2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.parsley.flash.logging {
import org.spicefactory.lib.flash.logging.FlashLogFactory;
import org.spicefactory.lib.flash.logging.LogLevel;
import org.spicefactory.lib.flash.logging.impl.DefaultLogFactory;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;

import flash.utils.getQualifiedClassName;

/**
 * Represents the factory XML tag.
 * 
 * @author Jens Halm
 */
public class LogFactoryTag {
	
	
	/**
	 * The id of the log factory.
	 */
	public var id:String;
	
	/**
	 * The type of the log factory, defaults to DefaultLogFactory.
	 */
	public var type:Class = DefaultLogFactory;
	
	/**
	 * Indicates whether the log factory produced by this tag should be set as the factory for the LogContext class.
	 */
	public var context:Boolean = true;
	
	/**
	 * The root log level to be used for all loggers that don't have a level set explicitly.
	 */
	public var rootLevel:LogLevel = LogLevel.TRACE;
	
	
	/**
	 * The appenders to add to the factory.
	 */
	public var appenders:Array;
	
	/**
	 * The loggers to add to the factory.
	 */
	public var loggers:Array;
	
	
	[Inject]
	/**
	 * The Context this tag belongs to.
	 */
	public var contextRef:Context;
	
	
	
	[Factory]
	/**
	 * Creates a new log factory, processing the properties of this tag class.
	 * 
	 * @return a new log factory instance
	 */
	public function createLogFactory () : FlashLogFactory {
		var fObj:Object = new type();
		if (!(fObj is FlashLogFactory)) {
			throw new ContextError("Object of type " + getQualifiedClassName(fObj) 
					+ " does not implement FlashLogFactory");
		}
		var factory:FlashLogFactory = fObj as FlashLogFactory;
		factory.setRootLogLevel(rootLevel);
		for each (var appenderTag:AppenderTag in appenders) {
			factory.addAppender(appenderTag.createAppender(contextRef));
		}
		for each (var loggerTag:LoggerTag in loggers) {
			factory.addLogLevel(loggerTag.name, loggerTag.level);
		}
		factory.refresh();		
		if (context) {
			LogContext.factory = factory;
		}
		return factory;
	}
	
	
}
}
