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

package org.spicefactory.parsley.task {
import org.spicefactory.lib.task.Task;
import org.spicefactory.parsley.core.builder.CompositeContextBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.factory.impl.GlobalFactoryRegistry;

import flash.display.DisplayObject;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.system.ApplicationDomain;

/**
 * Wraps a CompositeContextBuilder to adapt it to the Task Framework.
 * Instances of this class can be used in Spicelib TaskGroups in case the initialization process of your application
 * involves more asynchronous operations than just Parsley Context initialization.
 * 
 * @author Jens Halm
 */
public class CompositeContextBuilderTask extends Task {

	
	private var _builder:CompositeContextBuilder;
	private var _context:Context;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param viewRoot the initial view root to manage for the Context this instance creates
	 * @param parent the Context to use as a parent for the Context this instance creates
	 * @param domain the ApplicationDomain to use for reflecting on configured objects.
	 */
	function CompositeContextBuilderTask (viewRoot:DisplayObject = null, parent:Context = null, domain:ApplicationDomain = null) {
		_builder = GlobalFactoryRegistry.instance.contextBuilder.create(viewRoot, parent, domain);
	}
	
	
	/**
	 * The Context this builder created. This property is null before <code>TaskEvent.COMPLETE</code>
	 * has fired.
	 */
	public function get context () : Context {
		return _context;
	}
	
	/**
	 * Adds an ObjectDefinitionBuilder that should participate in creating the internal ObjectDefinitionRegistry.
	 * 
	 * @param builder the builder to add
	 */
	public function addBuilder (builder:ObjectDefinitionBuilder) : void {
		_builder.addBuilder(builder);
	}
	
	/**
	 * @private
	 */
	protected override function doStart () : void {
		_context = _builder.build();
		if (!_context.initialized) {
			_context.addEventListener(ContextEvent.INITIALIZED, contextInitialized);		
			_context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);		
			_context.addEventListener(ErrorEvent.ERROR, contextError);	
		}
		else {
			complete();	
		}
	}
	
	private function contextInitialized (event:Event) : void {
		context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		complete();
	}
	
	private function contextDestroyed (event:Event) : void {
		// Destroyed before being fully initialized - interpreting this as cancellation
		cancel();
	}
	
	private function contextError (event:ErrorEvent) : void {
		error(event.text);
	}
	

}

}
