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

package org.spicefactory.parsley.core.registry {
	import org.spicefactory.parsley.core.registry.definition.ObjectInstantiator;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.model.AsyncInitConfig;
import org.spicefactory.parsley.core.registry.definition.MethodRegistry;
import org.spicefactory.parsley.core.registry.definition.LifecycleListenerRegistry;
import org.spicefactory.parsley.core.registry.definition.ConstructorArgRegistry;
import org.spicefactory.parsley.core.registry.definition.PropertyRegistry;

/**
 * Represents the configuration for a single object definition.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinition {
	
	
	/**
	 * The type of the configured object.
	 */
	function get type () : ClassInfo;


	/**
	 * The object responsible for creating instances from this definition.
	 * If this property is not null the <code>constructorArgs</code> will be ignored.
	 */
	function get instantiator () : ObjectInstantiator;
	
	function set instantiator (value:ObjectInstantiator) : void;

	
	/**
	 * The values to be used as constructor arguments when creating instances from this definition.
	 */
	function get constructorArgs () : ConstructorArgRegistry;
	
	/**
	 * The property values to set when configuring instances created from this definition.
	 */
	function get properties () : PropertyRegistry;
	
	/**
	 * The methods for which method injection should be performed when configuring instances created from this definition.
	 */
	function get injectorMethods () : MethodRegistry;

	
	/**
	 * The lifecycle listeners to process for instances created from this definition.
	 */
	function get objectLifecycle () : LifecycleListenerRegistry;

	/**
	 * The method to invoke on the configured object after it has been fully initialized.
	 */
	function get initMethod () : String;

	function set initMethod (name:String) : void;

	/**
	 * The method to invoke on the configured object before it gets destroyed and removed from the Context.
	 */
	function get destroyMethod () : String;

	function set destroyMethod (name:String) : void;

	
	/**
	 * The configuration for asynchronously initializing objects.
	 */
    function get asyncInitConfig () : AsyncInitConfig;
    
    function set asyncInitConfig (config:AsyncInitConfig) : void;
	

	/**
	 * Freezes this object definition. After calling this method any attempt to modify this definition will
	 * lead to an Error.
	 */
	function freeze () : void;
	
	/**
	 * Indicates whether this definition has been frozen. When true any attempt to modify this definition will
	 * lead to an Error.
	 */	
	function get frozen () : Boolean;

	
}

}
