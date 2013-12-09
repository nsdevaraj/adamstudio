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

package org.spicefactory.parsley.core.factory.impl {
import org.spicefactory.parsley.core.factory.ScopeExtensionRegistry;
import org.spicefactory.parsley.core.factory.ScopeManagerFactory;
import org.spicefactory.parsley.core.factory.ContextBuilderFactory;
import org.spicefactory.parsley.core.factory.ContextFactory;
import org.spicefactory.parsley.core.factory.FactoryRegistry;
import org.spicefactory.parsley.core.factory.MessageRouterFactory;
import org.spicefactory.parsley.core.factory.ObjectDefinitionRegistryFactory;
import org.spicefactory.parsley.core.factory.ObjectLifecycleManagerFactory;
import org.spicefactory.parsley.core.factory.ViewManagerFactory;

/**
 * Local registry for all factories responsible for creating the individual services of the Parsley IOC kernel.
 * For each internal service Parsley contains a default implementation, so this registry only needs to be used
 * if custom implementations of one or more services should replace the builtin ones.
 * 
 * <p>The local registry is usually accessible through <code>CompositeContextBuilder</code> and allows to register
 * factories which are just responsible for the single Context under construction. For registering factories
 * globally <code>GlobalFactoryRegistry</code> should be used.</p>
 * 
 * @author Jens Halm
 */
public class LocalFactoryRegistry implements FactoryRegistry {

	
	private var _contextBuilder:ContextBuilderFactory;
	private var _context:ContextFactory;
	private var _lifecycleManager:ObjectLifecycleManagerFactory;
	private var _definitionRegistry:ObjectDefinitionRegistryFactory;
	private var _viewManager:ViewManagerFactory;
	private var _scopeManager:ScopeManagerFactory;
	private var _messageRouter:MessageRouterFactory;
	private var _scopeExtensions:DefaultScopeExtensionRegistry = new DefaultScopeExtensionRegistry();
	
	private var parent:FactoryRegistry;
	

	/**
	 * Activates this registry and passes the parent registry that should be used for all factories
	 * not explicitly specified on this local registry.
	 * 
	 * @param parent the parent registry
	 */
	public function activate (parent:FactoryRegistry) : void {
		this.parent = parent;
		_scopeExtensions.parent = parent.scopeExtensions;
	}

	
	/**
	 * @inheritDoc
	 */
	public function get contextBuilder () : ContextBuilderFactory {
		return (_contextBuilder != null) ? _contextBuilder : (parent != null) ? parent.contextBuilder : null;
	}

	/**
	 * @inheritDoc
	 */
	public function get context () : ContextFactory {
		return (_context != null) ? _context : (parent != null) ? parent.context : null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get lifecycleManager () : ObjectLifecycleManagerFactory {
		return (_lifecycleManager != null) ? _lifecycleManager : (parent != null) ? parent.lifecycleManager : null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get definitionRegistry () : ObjectDefinitionRegistryFactory {
		return (_definitionRegistry != null) ? _definitionRegistry : (parent != null) ? parent.definitionRegistry : null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get scopeManager () : ScopeManagerFactory {
		return (_scopeManager != null) ? _scopeManager : (parent != null) ? parent.scopeManager : null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get viewManager () : ViewManagerFactory {
		return (_viewManager != null) ? _viewManager : (parent != null) ? parent.viewManager : null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get messageRouter () : MessageRouterFactory {
		return (_messageRouter != null) ? _messageRouter : (parent != null) ? parent.messageRouter : null;
	}
	
	public function set contextBuilder (value:ContextBuilderFactory) : void {
		_contextBuilder = value;
	}
	
	public function set context (value:ContextFactory) : void {
		_context = value;
	}
	
	public function set lifecycleManager (value:ObjectLifecycleManagerFactory) : void {
		_lifecycleManager = value;
	}
	
	public function set definitionRegistry (value:ObjectDefinitionRegistryFactory) : void {
		_definitionRegistry = value;
	}
	
	public function set scopeManager (value:ScopeManagerFactory) : void {
		_scopeManager = value;
	}
	
	public function set viewManager (value:ViewManagerFactory) : void {
		_viewManager = value;
	}
	
	public function set messageRouter (value:MessageRouterFactory) : void {
		_messageRouter = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get scopeExtensions () : ScopeExtensionRegistry {
		return _scopeExtensions;
	}
	
}
}

