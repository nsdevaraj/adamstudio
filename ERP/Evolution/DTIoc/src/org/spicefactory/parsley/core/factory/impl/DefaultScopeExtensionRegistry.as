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
import org.spicefactory.parsley.core.factory.ScopeExtensionFactory;
import org.spicefactory.parsley.core.factory.ScopeExtensionRegistry;
import org.spicefactory.parsley.core.scope.ScopeExtensions;
import org.spicefactory.parsley.core.scope.impl.DefaultScopeExtensions;

import flash.utils.Dictionary;

/**
 * Default implementation of the ScopeExtensionRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultScopeExtensionRegistry implements ScopeExtensionRegistry {

	
	private var _parent:ScopeExtensionRegistry;
	private var allScopes:Registry = new Registry();
	private var scopes:Dictionary = new Dictionary();
	
	
	/**
	 * The parent registry to be used to pull additional extensions from.
	 */
	public function set parent (value:ScopeExtensionRegistry) : void {
		_parent = value;	
	}
	
	/**
	 * @inheritDoc
	 */
	public function addExtension (factory:ScopeExtensionFactory, scope:String = null, id:String = null) : void {
		var registry:Registry;
		if (scope == null) {
			registry = allScopes;
		}
		else if (scopes[scope] == undefined) {
			registry = new Registry();
			scopes[scope] = registry;
		}
		else {
			registry = Registry(scopes[scope]);
		}
		registry.addExtension(factory, id);
	}
	
	/**
	 * @inheritDoc
	 */
	public function getExtensions (scope:String) : ScopeExtensions {
		var parentExt:ScopeExtensions = (_parent != null) ? _parent.getExtensions(scope) : null;
		var ext:DefaultScopeExtensions = new DefaultScopeExtensions(parentExt);
		if (scopes[scope] != undefined) {
			var registry:Registry = scopes[scope] as Registry;
			addExtensions(registry, ext);
		}
		addExtensions(allScopes, ext);
		return ext;
	}
	
	private function addExtensions (registry:Registry, ext:DefaultScopeExtensions) : void {
		for each (var factory:ScopeExtensionFactory in registry.withoutId) {
			ext.addExtension(factory.create());
		}
		for (var id:String in registry.byId) {
			var idFactory:ScopeExtensionFactory = ScopeExtensionFactory(registry.byId[id]);
			ext.addExtension(idFactory.create(), id);
		}
	}
	
}
}

import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.factory.ScopeExtensionFactory;

import flash.utils.Dictionary;

class Registry {

	internal var byId:Dictionary = new Dictionary();
	internal var withoutId:Array = new Array();

	public function addExtension (factory:ScopeExtensionFactory, id:String) : void {
		if (id != null) {
			if (byId[id] != undefined) {
				throw new ContextError("Duplicate id for scope extension: " + id);
			}
			byId[id] = factory;
		}
		else {
			withoutId.push(factory);
		}
	}
	
}
