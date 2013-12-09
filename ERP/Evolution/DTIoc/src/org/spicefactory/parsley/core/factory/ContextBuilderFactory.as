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

package org.spicefactory.parsley.core.factory {
import org.spicefactory.parsley.core.builder.CompositeContextBuilder;
import org.spicefactory.parsley.core.context.Context;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

/**
 * Factory responsible for creating CompositeContextBuilder instances.
 * 
 * @author Jens Halm
 */
public interface ContextBuilderFactory {
	
	
	/**
	 * Creates a new CompositeContextBuilder instance.
	 * 
	 * @param viewRoot the initial view root to be passed to the ViewManager
	 * @param parent the parent of the Context to be created
	 * @param domain the domain to use for reflection
	 * @return a new CompositeContextBuilder instance
	 */
	function create (viewRoot:DisplayObject = null, parent:Context = null, domain:ApplicationDomain = null) : CompositeContextBuilder;
	
	
}
}
