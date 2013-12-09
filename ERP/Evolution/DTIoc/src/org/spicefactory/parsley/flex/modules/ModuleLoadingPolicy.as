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

package org.spicefactory.parsley.flex.modules {

/**
 * Enumeration for the policy into which ApplicationDomain modules should be loaded per default.
 * 
 * @author Jens Halm
 */
public class ModuleLoadingPolicy {
	
	
	/**
	 * Constant for the policy where modules are always loaded into a child domain of the current domain.
	 * This is also the default behaviour in the Flex SDK.
	 */
	public static const CHILD_DOMAIN:ModuleLoadingPolicy = new ModuleLoadingPolicy("childDomain");

	/**
	 * Constant for the policy where modules are always loaded into the root domain.
	 */
	public static const ROOT_DOMAIN:ModuleLoadingPolicy = new ModuleLoadingPolicy("rootDomain");

	
	private var _key:String;
	
	/**
	 * @private
	 */
	function ModuleLoadingPolicy (key:String) {
		_key = key;
	}
	
	/**
	 * @private
	 */
	public function toSting () : String {
		return _key;
	}
	
	
}
}
