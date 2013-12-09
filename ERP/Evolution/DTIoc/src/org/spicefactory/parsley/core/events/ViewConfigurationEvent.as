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
 
package org.spicefactory.parsley.core.events {
import flash.events.Event;

/**
 * Event that fires when a view component wishes to get added to the IOC container.
 * 
 * @author Jens Halm
 */
public class ViewConfigurationEvent extends Event {


	/**
	 * Constant for the type of bubbling event fired when a view component wishes to get 
	 * added to the IOC container that is associated with the nearest parent in the view hierarchy.
	 * 
	 * @eventType configureView
	 */
	public static const CONFIGURE_VIEW : String = "configureView";
	
	
	private var explicitTarget:Object;
	
	
	/**
	 * Creates a new event instance.
	 */
	public function ViewConfigurationEvent (target:Object = null) {
		super(CONFIGURE_VIEW, true);
		this.explicitTarget = target;
	}		
	
	public function get configurationTarget () : Object {
		return (explicitTarget == null) ? target : explicitTarget;
	}
		
		
}
	
}