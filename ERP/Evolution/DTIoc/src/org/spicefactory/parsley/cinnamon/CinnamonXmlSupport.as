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

package org.spicefactory.parsley.cinnamon {
import org.spicefactory.parsley.xml.ext.XmlConfigurationNamespace;
import org.spicefactory.parsley.xml.ext.XmlConfigurationNamespaceRegistry;

/**
 * Provides a static method to initalize the Cinnamon XML tag extension.
 * 
 * @author Jens Halm
 */
public class CinnamonXmlSupport {
	
	
	/**
	 * The XML Namespace of the Cinnamon tag extension.
	 */
	public static const NAMESPACE_URI:String = "http://www.spicefactory.org/parsley/cinnamon";
	
	
	/**
	 * Initializes the Cinnamon XML tag extension.
	 * Must be invoked before the <code>XmlContextBuilder</code> is used for the first time.
	 */
	public static function initialize () : void {
		var ns:XmlConfigurationNamespace = XmlConfigurationNamespaceRegistry.registerNamespace(NAMESPACE_URI);
		ns.addDefaultObjectMapper(ChannelTag, "channel");
		ns.addDefaultObjectMapper(ServiceTag, "service");
	}
	
	
}
}
