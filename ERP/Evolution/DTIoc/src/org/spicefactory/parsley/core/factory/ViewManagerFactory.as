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

package org.spicefactory.parsley.core.factory {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.view.ViewManager;

import flash.system.ApplicationDomain;

/**
 * Factory responsible for creating ViewManager instances.
 * 
 * @author Jens Halm
 */
public interface ViewManagerFactory {
	

	/**
	 * The event type that view roots dispatch to signal that they should no longer be managed
	 * by this instance. The default is <code>Event.REMOVED_FROM_STAGE</code>.
	 * The effect is the same as calling <code>removeViewRoot</code> for the view dispatching the event.
	 * This event does not need to be a bubbling event.
	 */
	function get viewRootRemovedEvent () : String;
	
	function set viewRootRemovedEvent (value:String) : void;

	/**
	 * The event type that view components dispatch to signal that they wish to be
	 * removed from the Context. The default is <code>Event.REMOVED_FROM_STAGE</code>.
	 * This event does not need to be a bubbling event.
	 */
	function get componentRemovedEvent () : String;
	
	function set componentRemovedEvent (value:String) : void;

	/**
	 * The bubbling event type that view components dispatch to signal that they wish to be
	 * added to the Context. The default is <code>ViewConfigurationEvent.CONFIGURE_VIEW</code>.
	 * This event has to bubble so that the view roots managed by this instance can listen for it.
	 */
	function get componentAddedEvent () : String;
	
	function set componentAddedEvent (value:String) : void;
	
	/**
	 * Creates a new ViewManager instance.
	 * 
	 * @param context the Context the new ViewManager will belong to
	 * @param domain the domain to use for reflection
	 * @return a new ViewManager instance
	 */
	function create (context:Context, domain:ApplicationDomain) : ViewManager;

	
}
}
