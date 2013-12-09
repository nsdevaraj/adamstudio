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

package org.spicefactory.parsley.xml {
import org.spicefactory.lib.expr.ExpressionContext;
import org.spicefactory.parsley.core.builder.CompositeContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.factory.impl.GlobalFactoryRegistry;
import org.spicefactory.parsley.xml.builder.XmlObjectDefinitionBuilder;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

/**
 * Static entry point methods for building a Context from XML configuration files.
 * 
 * <p>For details see 
 * <a href="http://www.spicefactory.org/parsley/docs/2.0/manual?page=config&section=xml>3.3 XML Configuration</a>
 * in the Parsley Manual.</p>
 * 
 * @author Jens Halm
 */
public class XmlContextBuilder {
	

	/**
	 * Builds a Context from the specified XML configuration file.
	 * The returned Context instance may not be fully initialized if it requires asynchronous operations.
	 * You can check its state with its <code>configured</code> and <code>initialized</code> properties.
	 * 
	 * @param filename the name of the file that contains the XML configuration
	 * @param viewRoot the initial view root for dynamically wiring view objects
	 * @param parent the parent to use for the Context to build
	 * @param domain the ApplicationDomain to use for reflection
	 * @param expressionContext an ExpressionContext that may contain variables that may be used in the configuration file
	 * @return a new Context instance, possibly not fully initialized yet
	 */		
	public static function build (filename:String, viewRoot:DisplayObject = null, parent:Context = null, 
			domain:ApplicationDomain = null, expressionContext:ExpressionContext = null) : Context {
		return buildAll([filename], viewRoot, parent, domain, expressionContext);		
	}
	
	/**
	 * Builds a Context from the specified XML configuration files.
	 * The returned Context instance may not be fully initialized if it requires asynchronous operations.
	 * You can check its state with its <code>configured</code> and <code>initialized</code> properties.
	 * 
	 * @param filenames the names of the files that contain the XML configuration
	 * @param viewRoot the initial view root for dynamically wiring view objects
	 * @param parent the parent to use for the Context to build
	 * @param domain the ApplicationDomain to use for reflection
	 * @param expressionContext an ExpressionContext that may contain variables that may be used in the configuration file
	 * @return a new Context instance, possibly not fully initialized yet
	 */	
	public static function buildAll (filenames:Array, viewRoot:DisplayObject = null, parent:Context = null, 
			domain:ApplicationDomain = null, expressionContext:ExpressionContext = null) : Context {
		var builder:CompositeContextBuilder = GlobalFactoryRegistry.instance.contextBuilder.create(viewRoot, parent, domain);
		mergeAll(filenames, builder);
		return builder.build();
	}
	
	/**
	 * Merges the specified XML configuration file with the specified composite builder.
	 * 
	 * @param filename the name of the file that contains the XML configuration to be merged into the composite builder
	 * @param builder the builder to add the configuration to
	 * @param expressionContext an ExpressionContext that may contain variables that may be used in the configuration file
	 */
	public static function merge (filename:String, builder:CompositeContextBuilder, 
			expressionContext:ExpressionContext = null) : void {
		mergeAll([filename], builder, expressionContext);
	}

	/**
	 * Merges the specified XML configuration files with the specified composite builder.
	 * 
	 * @param filenames the names of the files that contain the XML configuration to be merged into the composite builder
	 * @param builder the builder to add the configuration to
	 * @param expressionContext an ExpressionContext that may contain variables that may be used in the configuration file
	 */
	public static function mergeAll (filenames:Array, builder:CompositeContextBuilder, 
			expressionContext:ExpressionContext = null) : void {
		builder.addBuilder(new XmlObjectDefinitionBuilder(filenames, expressionContext));
	}
	
	
}
}
