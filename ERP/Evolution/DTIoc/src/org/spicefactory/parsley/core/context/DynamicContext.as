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

package org.spicefactory.parsley.core.context {
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * Special Context type that allows objects to be added and removed dynamically.
 * Will be used internally for any kind of short-lived objects, like views or commands, but can also
 * be used to build custom extensions.
 * 
 * <p>Objects that get added to a Context dynamically behave almost the same like regular managed objects.
 * They can act as receivers or senders of messages, they can have lifecycle listeners and injections can 
 * be performed for them. The only exception is that these objects may not be used as the source of an 
 * injection as they can be added and removed to and from the Context at any point in time so that
 * the validation that comes with dependency injection would not be possible.</p>
 * 
 * <p>The recommended way of creating a dynamic context is using <code>Context.createDynamicContext</code>
 * so that the necessary sharing of collaborating objects is guaranteed.</p>
 * 
 * @author Jens Halm
 */
public interface DynamicContext extends Context {
	
	/**
	 * Creates an object from the specified definition and dynamically adds it to the Context.
	 * 
	 * @param definition the definition to create an object from
	 * @return an instance representing the dynamically created object and its definition
	 */
	function addDefinition (definition:ObjectDefinition) : DynamicObject;

	/**
	 * Dynamically adds the specified object to the Context.
	 * 
	 * @param instance the object to add to the Context
	 * @param definition optional definition to apply to the existing instance
	 * @return an instance representing the dynamically created object and its definition
	 */
	function addObject (instance:Object, definition:ObjectDefinition = null) : DynamicObject;
	
	/**
	 * Removes the specified object from the Context. This method may be used
	 * for objects added with <code>addObject</code> as well as for those added with
	 * <code>addDefinition</code>. This has the same effect as calling <code>DynamicObject.remove</code>.
	 * 
	 * @param instance the instance to remove from this dynamic context
	 */
	function removeObject (instance:Object) : void;
	
}

}
