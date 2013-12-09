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

package org.spicefactory.parsley.core.builder {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.factory.FactoryRegistry;

/**
 * Responsible for building Context instances using one or more ObjectDefinitionBuilder instances.
 * 
 * <p>A composite builder may be used when combining multiple configuration mechanisms like MXML or XML
 * into a single Context. It is also used by all short cut entry points that only use a single
 * configuration mechanism under the hood. So under the hood an implementation of this interface
 * is always responsible for starting a Context initialization process.</p>
 * 
 * <p>Example usage:</p>
 * 
 * <pre><code>var builder:CompositeContextBuilder = new DefaultCompositeContextBuilder();
 * FlexContextBuilder.merge(BookStoreConfig, builder);
 * XmlContextBuilder.merge("logging.xml", builder);
 * builder.build();</code></pre>	 
 * 
 * @author Jens Halm
 */
public interface CompositeContextBuilder {
	
	/**
	 * Adds an ObjectDefinitionBuilder.
	 * 
	 * @param builder the builder to add
	 */
	function addBuilder (builder:ObjectDefinitionBuilder) : void;
	
	/**
	 * Adds a new scope for the Context created by this builder.
	 * The new scope will be added to the scopes which may be inherited from a parent Context.
	 * 
	 * @param name the name of the scope
	 * @param inherited whether child Contexts should inherit this scope
	 */
	function addScope (name:String, inherited:Boolean) : void;
	
	/**
	 * The factories to be used by this builder.
	 * For all factories that are not explicitly specified for this builder the
	 * corresponding factory will be fetched from the <code>GlobalFactoryRegistry</code>.
	 */
	function get factories () : FactoryRegistry;
	
	/**
	 * Builds the Context, using all definition builders that were added with the addBuilder method.
	 * The returned Context instance may not be fully initialized if it requires asynchronous operations.
	 * You can check its state with its <code>configured</code> and <code>initialized</code> properties.
	 * 
	 * @return a new Context instance, possibly not fully initialized yet
	 */
	function build () : Context;
	
}
}
