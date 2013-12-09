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

package org.spicefactory.parsley.core.view.impl {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.events.ContextBuilderEvent;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.events.ViewConfigurationEvent;
import org.spicefactory.parsley.core.view.ViewManager;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * Default implementation of the ViewManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultViewManager implements ViewManager {


	private static const log:Logger = LogContext.getLogger(DefaultViewManager);
	
	private static const LEGACY_CONFIGURE_EVENT:String = "configureIOC";
	
	private var _viewRootRemovedEvent:String = Event.REMOVED_FROM_STAGE;
	private var _componentRemovedEvent:String = Event.REMOVED_FROM_STAGE;
	private var _componentAddedEvent:String = ViewConfigurationEvent.CONFIGURE_VIEW;

	private var parent:Context;
	private var domain:ApplicationDomain;
	private var viewRoots:Array = new Array();
	private var viewContext:DynamicContext;
	
	
	private static const globalViewRootRegistry:Dictionary = new Dictionary();
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the Context view components should be dynamically wired to
	 * @param domain the ApplicationDomain to use for reflection
	 */
	function DefaultViewManager (context:Context, domain:ApplicationDomain) {
		this.parent = context;
		this.domain = domain;
	}


	private function initialize () : void {
		viewContext = parent.createDynamicContext();
		viewContext.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}
	
	private function contextDestroyed (event:ContextEvent) : void {
		viewContext.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		for each (var view:DisplayObject in viewRoots) {
			handleRemovedViewRoot(view);	
		}
		viewRoots = new Array();
	}
	
	/**
	 * @inheritDoc
	 */
	public function addViewRoot (view:DisplayObject) : void {
		log.info("Add view root: {0}/{1}", view.name, getQualifiedClassName(view));
		if (viewContext == null) initialize();
		if (globalViewRootRegistry[view] != undefined) {
			// we do not allow two view managers on the same view, but we allow switching them
			log.info("Switching ViewManager for view root '{0}'", view);
			var vm:ViewManager = globalViewRootRegistry[view];
			vm.removeViewRoot(view);
		}
		globalViewRootRegistry[view] = this;
		addListeners(view);
		viewRoots.push(view);
	}

	private function viewRootRemoved (event:Event) : void {
		removeViewRoot(DisplayObject(event.target));
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeViewRoot (view:DisplayObject) : void {
		var index:int = viewRoots.indexOf(view);
		if (index > -1) {
			log.info("Remove view root: {0}/{1}", view.name, getQualifiedClassName(view));
	 		handleRemovedViewRoot(view);
			viewRoots.splice(index, 1);
			if (viewRoots.length == 0) {
				log.info("Last view root removed from ViewManager - Destroy Context");
				parent.destroy();
			}
		}
	}
	
	private function addListeners (viewRoot:DisplayObject) : void {
		viewRoot.addEventListener(viewRootRemovedEvent, viewRootRemoved);
		viewRoot.addEventListener(componentAddedEvent, componentAdded);
		viewRoot.addEventListener(LEGACY_CONFIGURE_EVENT, componentAdded);
		viewRoot.addEventListener(ContextBuilderEvent.BUILD_CONTEXT, contextCreated);
	}
	
	private function handleRemovedViewRoot (viewRoot:DisplayObject) : void {
	 	viewRoot.removeEventListener(viewRootRemovedEvent, viewRootRemoved);
		viewRoot.removeEventListener(componentAddedEvent, componentAdded);
		viewRoot.removeEventListener(LEGACY_CONFIGURE_EVENT, componentAdded);
		viewRoot.removeEventListener(ContextBuilderEvent.BUILD_CONTEXT, contextCreated);
		delete globalViewRootRegistry[viewRoot];
	}
	
	
	private function contextCreated (event:ContextBuilderEvent) : void {
		if (event.domain == null) {
			event.domain = domain;
		}
		if (event.parent == null) {
			event.parent = parent;
		}
		event.stopImmediatePropagation();
	}
	
	
	private function componentAdded (event:Event) : void {
		event.stopImmediatePropagation();
		var target:Object = (event is ViewConfigurationEvent) 
				? ViewConfigurationEvent(event).configurationTarget : event.target;
		log.debug("Add object '{0}' to view Context", target);
		if (target is IEventDispatcher) {
			IEventDispatcher(target).addEventListener(componentRemovedEvent, componentRemoved);
		}
		viewContext.addObject(target);
	}
	
	private function componentRemoved (event:Event) : void {
		var view:IEventDispatcher = IEventDispatcher(event.target);
		log.debug("Remove object '{0}' from view Context", view);
		view.removeEventListener(componentRemovedEvent, componentRemoved);
		viewContext.removeObject(view);
	}
	
	
	/**
	 * @copy org.spicefactory.parsley.core.factory.ViewManagerFactory#viewRootRemovedEvent
	 */
	public function get viewRootRemovedEvent () : String {
		return _viewRootRemovedEvent;
	}
	
	public function set viewRootRemovedEvent (viewRootRemovedEvent:String) : void {
		_viewRootRemovedEvent = viewRootRemovedEvent;
	}
	
	/**
	 * @copy org.spicefactory.parsley.core.factory.ViewManagerFactory#componentRemovedEvent
	 */
	public function get componentRemovedEvent () : String {
		return _componentRemovedEvent;
	}
	
	public function set componentRemovedEvent (componentRemovedEvent:String) : void {
		_componentRemovedEvent = componentRemovedEvent;
	}
	
	/**
	 * @copy org.spicefactory.parsley.core.factory.ViewManagerFactory#componentAddedEvent
	 */
	public function get componentAddedEvent () : String {
		return _componentAddedEvent;
	}
	
	public function set componentAddedEvent (componentAddedEvent:String) : void {
		_componentAddedEvent = componentAddedEvent;
	}
	
	
}
}
