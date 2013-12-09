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

package org.spicefactory.parsley.core.context.provider {
	
import flash.system.ApplicationDomain;

/**
 * Static utility method to create an ObjectProvider for an existing instance.
 * 
 * @author Jens Halm
 */
public class Provider {
	
	
	/**
	 * Creates an ObjectProvider for an existing instance, simply wrapping it.
	 * Useful if existing instances must be passed to a method that expects an ObjectProvider instance
	 * as a parameter, like most of the methods for registering message receivers for example.
	 * 
	 * @param instance the instance to wrap
	 * @param domain the ApplicationDomain to use for reflecting on the instance
	 * @return a new ObjectProvider wrapping the specified instance 
	 */
	public static function forInstance (instance:Object, domain:ApplicationDomain = null) : ObjectProvider {
		return new SimpleInstanceProvider(instance, domain);
	}
	
	
}
}

import org.spicefactory.lib.reflect.ClassInfo;

import flash.system.ApplicationDomain;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;

class SimpleInstanceProvider implements ObjectProvider {
	
	
	private var _instance:Object;
	private var _type:ClassInfo;
	
	
	function SimpleInstanceProvider (instance:Object, domain:ApplicationDomain = null) {
		_instance = instance;
		_type = ClassInfo.forInstance(instance, domain);
	}
	
	public function get instance () : Object {
		return _instance;
	}
	
	public function get type () : ClassInfo {
		return _type;
	}
	
	
}
