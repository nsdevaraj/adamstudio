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

package org.spicefactory.parsley.xml.ext {

/**
 * The central registry for custom XML configuration namespaces.
 * 
 * Namespaces have to be created and configured before the first XML configuration file containing tags from
 * that namespace gets loaded.
 * 
 * @author Jens Halm
 */
public class XmlConfigurationNamespaceRegistry {
	

	private static const namespaces:Array = new Array();	

	
	/**
	 * Registers a new XML configuration namespace for the specified URI.
	 * The instance returned by this namespace can be used to configure the namespace,
	 * adding XML-to-Object Mappers for the custom tags.
	 * 
	 * @param uri the URI of the custom XML configuration namespace
	 * @return an instance that can be used to configure the namespace
	 */
	public static function registerNamespace (uri:String) : XmlConfigurationNamespace {
		var ns:XmlConfigurationNamespace = new XmlConfigurationNamespace(uri);
		namespaces.push(ns);
		return ns;
	}
	
	/**
	 * Returns all custom XML configuration namespaces that have been added to the registry.
	 * 
	 * @return all custom XML configuration namespaces that have been added to the registry
	 */
	public static function getRegisteredNamespaces () : Array {
		return namespaces.concat();
	}
	
	
}
}
