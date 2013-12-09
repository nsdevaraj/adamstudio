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
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.scope.ScopeManager;

import flash.system.ApplicationDomain;

/**
 * Factory responsible for creating ScopeManager instances.
 * 
 * @author Jens Halm
 */
public interface ScopeManagerFactory {
	
	
	/**
	 * Creates a new ScopeManager instance.
	 * 
	 * @param context the Context the new ScopeManager will belong to
	 * @param scopeDefs the definitions for the scopes associated with the Context
	 * @param domain the domain to use for reflection
	 * @return a new ScopeManager instance
	 */
	function create (context:Context, scopeDefs:Array, domain:ApplicationDomain) : ScopeManager;
	
	
}
}
