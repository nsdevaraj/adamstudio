/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.registry.definition.impl {
	import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.LifecycleListenerRegistry;

import flash.utils.Dictionary;

/**
 * Default implementation of the LifecycleListenerRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultLifecycleListenerRegistry extends AbstractRegistry implements LifecycleListenerRegistry {


	private var listeners:Dictionary = new Dictionary();


	/**
	 * Creates a new instance.
	 * 
	 * @param def the definition of the object this registry is associated with
	 */
	function DefaultLifecycleListenerRegistry (def:ObjectDefinition) {
		super(def);
	}


	/**
	 * @inheritDoc
	 */
	public function addListener (event:ObjectLifecycle, listener:Function) : LifecycleListenerRegistry {
		checkState();
		var arr:Array = listeners[event.key];
		if (arr == null) {
			arr = new Array();
			listeners[event.key] = arr;
		}
		arr.push(listener);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeListener (event:ObjectLifecycle, listener:Function) : LifecycleListenerRegistry {
		checkState();
		var arr:Array = listeners[event.key];
		if (arr == null) {
			return this;
		}
		ArrayUtil.remove(arr, listener);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getListeners (event:ObjectLifecycle) : Array {
		var arr:Array = listeners[event.key];
		return (arr == null) ? [] : arr.concat();
	}
	

}
}

