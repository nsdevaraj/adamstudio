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

/**
 * Factory that creates lazy initializing ObjectProvider instances. Those may be used for 
 * registering message receivers or object lifecycle listeners or similar use cases.
 * 
 * @author Jens Halm
 */
public interface ObjectProviderFactory {
	
	
	/**
	 * Creates a provider for the specified type and optional id.
	 * If the id is omitted the Context built for this registry must contain exactly
	 * one instance with a matching type. 
	 * 
	 * @param type the type of the object to provide
	 * @param id the id of the object in the Context this factory is associated with
	 * @return a new ObjectProvider instance
 	 */
	function createProvider (type:Class, id:String = null) : ObjectProvider;
	
	/**
	 * Initializes and validates all providers created by this instance.
	 * 
	 * @throws ContextError if one or more of the providers created by this factory are invalid
	 */
	function initialize () : void;
	
	
}
}
