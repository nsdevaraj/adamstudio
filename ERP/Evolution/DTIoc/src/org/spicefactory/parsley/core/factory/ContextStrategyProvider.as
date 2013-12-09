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
import org.spicefactory.parsley.core.context.provider.ObjectProviderFactory;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycleManager;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.scope.ScopeManager;
import org.spicefactory.parsley.core.view.ViewManager;

import flash.system.ApplicationDomain;

/**
 * Provider to be used by Context instances to obtain their collaborating services.
 * 
 * @author Jens Halm
 */
public interface ContextStrategyProvider {
	
	
	/**
	 * Initializes this provider.
	 * 
	 * @param context the Context for which collaborating services should be provided
	 * @param providerFactory factory responsible for creating ObjectProviders
	 */
	function init (context:Context, providerFactory:ObjectProviderFactory) : void;
	
	/**
	 * The ApplicationDomain to use for reflection.
	 */
	function get domain () : ApplicationDomain;
	
	/**
	 * The ObjectDefinitionRegistry containing all definitions the Context should use.
	 */
	function get registry () : ObjectDefinitionRegistry;
	
	/**
	 * The ObjectLifecycleManager to be used by the Context.
	 */
	function get lifecycleManager () : ObjectLifecycleManager;
	
	/**
	 * The ScopeManager containing all scopes associated with the Context.
	 */
	function get scopeManager () : ScopeManager;
	
	/**
	 * The ViewManager to associate with the Context.
	 */
	function get viewManager () : ViewManager;
	
	/**
	 * Creates a strategy provider for a dynamic child Context of the Context associated with this provider.
	 */
	function createDynamicProvider () : ContextStrategyProvider;
	
	
}
}
