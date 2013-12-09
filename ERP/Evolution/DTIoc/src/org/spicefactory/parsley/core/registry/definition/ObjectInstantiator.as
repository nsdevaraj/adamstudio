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

package org.spicefactory.parsley.core.registry.definition {
import org.spicefactory.parsley.core.context.Context;

/**
 * An object responsible for creating instances. Such an object may be registered with a
 * <code>ObjectDefinition</code> to delegate the object instantiation instead of simply invoking the constructor.
 * 
 * @author Jens Halm
 */
public interface ObjectInstantiator {
	
	/**
	 * Creates a new instance. The specified Context instance may be used to fetch dependencies
	 * for the new object.
	 * 
	 * @param context the Context that the new instance will belong to
	 * @return a new instance
	 */
	function instantiate (context:Context) : Object;
	
}
}
