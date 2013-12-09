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
import org.spicefactory.parsley.core.context.provider.ObjectProviderFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.scope.ScopeManager;

import flash.system.ApplicationDomain;

/**
 * Factory responsible for creating ObjectDefinitionRegistry instances.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionRegistryFactory {
	
	
	/**
	 * Creates a new ObjectDefinitionRegistry instance.
	 * 
	 * @param domain the domain to use for reflection
	 * @param scopeManager the ScopeManager associated with this registry
	 * @param providerFactory factory responsible for creating ObjectProvider instances
	 * @return a new ObjectDefinitionRegistry instance
	 */
	function create (domain:ApplicationDomain, scopeManager:ScopeManager, 
			providerFactory:ObjectProviderFactory) : ObjectDefinitionRegistry;
	
	
}
}
