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

/**
 * Central registry for all factories responsible for creating the individual services of the Parsley IOC kernel.
 * For each internal service Parsley contains a default implementation, so this registry only needs to be used
 * if custom implementations of one or more services should replace the builtin ones.
 * 
 * <p>Services can be replaced globally through the factory accessible with <code>GlobalFactoryRegistry.instance</code>
 * or just for an individual Context through <code>CompositeContextBuilder.factories</code>.</p>
 * 
 * @author Jens Halm
 */
public interface FactoryRegistry {
	
	
	/**
	 * The factory responsible for creating CompositeContextBuilder instances.
	 */
	function get contextBuilder () : ContextBuilderFactory;
	
	function set contextBuilder (value:ContextBuilderFactory) : void;

	/**
	 * The factory responsible for creating Context instances.
	 */
	function get context () : ContextFactory;

	function set context (value:ContextFactory) : void;

	/**
	 * The factory responsible for creating ObjectLifecycleManager instances.
	 */
	function get lifecycleManager () : ObjectLifecycleManagerFactory;

	function set lifecycleManager (value:ObjectLifecycleManagerFactory) : void;

	/**
	 * The factory responsible for creating ObjectDefinitionRegistry instances.
	 */
	function get definitionRegistry () : ObjectDefinitionRegistryFactory;

	function set definitionRegistry (value:ObjectDefinitionRegistryFactory) : void;

	/**
	 * The factory responsible for creating ViewManager instances.
	 */
	function get viewManager () : ViewManagerFactory;

	function set viewManager (value:ViewManagerFactory) : void;
	
	/**
	 * The factory responsible for creating ScopeManager instances.
	 */
	function get scopeManager () : ScopeManagerFactory;

	function set scopeManager (value:ScopeManagerFactory) : void;
	
	/**
	 * Registry for scope-wide extensions.
	 */
	function get scopeExtensions () : ScopeExtensionRegistry;

	/**
	 * The factory responsible for creating MessageRouter instances.
	 */
	function get messageRouter () : MessageRouterFactory;

	function set messageRouter (value:MessageRouterFactory) : void;

	
}
}
