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

package org.spicefactory.parsley.core.context.impl {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * Responsible for processing all non-lazy singletons that need to be instantiated upon Context creation.
 * 
 * @author Jens Halm
 */
public class InitializerSequence {
	
	
	private static const log:Logger = LogContext.getLogger(InitializerSequence);
	

	private var queuedInits:Array = new Array();
	private var activeDefinition:RootObjectDefinition;
	private var activeInstance:IEventDispatcher;
	private var parallelInits:Dictionary = new Dictionary();
	private var parallelInitCount:int = 0;
	
	private var context:DefaultContext;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the associated Context
	 */
	function InitializerSequence (context:DefaultContext) {
		this.context = context;
	}


	/**
	 * Adds a definition to this sequence.
	 * 
	 * @param def the definition to add to this sequence
	 */	
	public function addDefinition (def:ObjectDefinition) : void {
		queuedInits.push(def);
	}
	
	/**
	 * Starts processing the definitons that were added to this sequence.
	 */
	public function start () : void {
		var sortFunc:Function = function (def1:RootObjectDefinition, def2:RootObjectDefinition) : int {
			return (def1.order > def2.order) ? 1 : (def1.order < def2.order) ? -1 : 0;
		};
		queuedInits.sort(sortFunc);
		createInstances();
	}
	
	/**
	 * Cancels the initialization sequence.
	 */
	public function cancel () : void {
		if (activeInstance != null) {
			removeListeners(activeInstance, activeInstanceComplete, activeInstanceError);
			activeInstance = null;
			activeDefinition = null;
		}
		for (var instance:Object in parallelInits) {
			removeListeners(instance as IEventDispatcher, parallelInstanceComplete, parallelInstanceError);
		}
		parallelInits = new Dictionary();
		parallelInitCount = 0;
	}

	/**
	 * Indicates whether all definitions of this sequence have completed their initialization.
	 */
	public function get complete () : Boolean {
		return queuedInits.length == 0 && parallelInitCount == 0;
	}
	
	private function createInstances () : void {
		var async:Boolean = false;
		while (!async) {
			if (complete) {
				context.finishInitialization();
				return;
			}
			activeDefinition = queuedInits.shift() as RootObjectDefinition;
			async = (activeDefinition.asyncInitConfig != null);
			try {
				context.getInstance(activeDefinition);
			}
			catch (e:Error) {
				context.destroyWithError("Initialization of " + activeDefinition + " failed", e);
				return;
			}
		}
	}

	/**
	 * Adds a new instance to be watched by this sequence for completion of its asynchronous initialization.
	 * 
	 * @param def the definition of the specified instance
	 * @param instance the instance to watch
	 */
	public function addInstance (def:ObjectDefinition, instance:Object) : void {
		var asyncObj:IEventDispatcher = IEventDispatcher(instance);
		if (def == activeDefinition) {
			asyncObj.addEventListener(def.asyncInitConfig.completeEvent, activeInstanceComplete);
			asyncObj.addEventListener(def.asyncInitConfig.errorEvent, activeInstanceError);
			activeInstance = asyncObj;
		} 
		else {
			/*
			 * Must be an initialization that was not triggered by this class.
			 * Instead it was either tiggered by application code accessing the Context before the
			 * INITIALIZED event or by a dependency of an object that this class initialized.
			 * We remove it from the list of queued inits and let it run in parallel to our queue. 
			 */
			var index:int = queuedInits.indexOf(def);
			if (index != -1) {
				log.warn("Unexpected parallel trigger of async initialization of " + def);
				queuedInits.splice(index, 1);
				parallelInits[instance] = def;
				parallelInitCount++;
				asyncObj.addEventListener(def.asyncInitConfig.completeEvent, parallelInstanceComplete);
				asyncObj.addEventListener(def.asyncInitConfig.errorEvent, parallelInstanceError);
			}
			else {
				// should never happen
				log.error("Unexpected async initialization of " + def);
			}
		}
	}
	
	
	private function activeInstanceComplete (event:Event) : void {
		removeListeners(IEventDispatcher(event.target), activeInstanceComplete, activeInstanceError);
		createInstances();
	}
	
	private function activeInstanceError (event:ErrorEvent) : void {
		removeListeners(IEventDispatcher(event.target), activeInstanceComplete, activeInstanceError);
		context.destroyWithError("Asynchronous initialization of " + activeDefinition + " failed", event);
	}
	
	private function parallelInstanceComplete (event:Event) : void {
		removeListeners(IEventDispatcher(event.target), parallelInstanceComplete, parallelInstanceError);
		removeParallelInit(event.target);
		if (complete) context.finishInitialization();
	}
	
	private function parallelInstanceError (event:ErrorEvent) : void {
		removeListeners(IEventDispatcher(event.target), parallelInstanceComplete, parallelInstanceError);
		var def:ObjectDefinition = removeParallelInit(event.target);
		context.destroyWithError("Asynchronous initialization of " + def + " failed", event);
	}
	
	private function removeParallelInit (instance:Object) : ObjectDefinition {
		var def:ObjectDefinition = parallelInits[instance];
		if (def != null) {
			delete parallelInits[instance];
			parallelInitCount--;
			if (complete) context.finishInitialization();
		}
		else {
			// should never happen
			log.warn("Internal error: Unexpected event for async-init instance of type " + getQualifiedClassName(instance));
		}
		return def;
	}

	private function removeListeners (asyncObj:IEventDispatcher, complete:Function, error:Function) : void {
		asyncObj.addEventListener(Event.COMPLETE, complete);
		asyncObj.addEventListener(ErrorEvent.ERROR, error);			
	}
	
	
}
}
