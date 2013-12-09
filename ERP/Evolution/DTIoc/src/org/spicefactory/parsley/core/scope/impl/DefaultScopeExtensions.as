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

package org.spicefactory.parsley.core.scope.impl {
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.scope.ScopeExtensions;

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * Default implementation of the ScopeExtensions interface.
 * 
 * @author Jens Halm
 */
public class DefaultScopeExtensions implements ScopeExtensions {


	private var parent:ScopeExtensions;
	private var extById:Dictionary = new Dictionary();
	private var allExt:Array = new Array();


	/**
	 * Creates a new instance.
	 * 
	 * @param parent the parent instance to obtain additional extensions from
	 */
	function DefaultScopeExtensions (parent:ScopeExtensions) {
		this.parent = parent;
	}

	
	/**
	 * Adds an extension for this scope.
	 * 
	 * @param ext the extension instance to add
	 * @param id the optional id the extension should be registered with
	 */
	public function addExtension (ext:Object, id:String = null) : void {
		if (id != null) {
			extById[id] = ext;
		}
		allExt.push(ext);
	}

	/**
	 * @inheritDoc
	 */
	public function byType (type:Class) : Object {
		var result:Object = null;
		for each (var ext:Object in allExt) {
			if (ext is type) {
				if (result != null) {
					throw new ContextError("More than one scope extension registered for type " 
							+ getQualifiedClassName(type));
				}
				result = ext; 
			}
		}
		if (result == null) {
			if (parent != null) {
				return parent.byType(type);
			}
			else {
				throw new ContextError("No scope extension registered for type " 
							+ getQualifiedClassName(type));
			}
		}
		return result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function byId (id:String) : Object {
		if (extById[id] != undefined) {
			return extById[id];
		}
		else if (parent != null) {
			return parent.byId(id);
		}
		throw new ContextError("No scope extension registered with id " + id);
	}
	
	
}
}
