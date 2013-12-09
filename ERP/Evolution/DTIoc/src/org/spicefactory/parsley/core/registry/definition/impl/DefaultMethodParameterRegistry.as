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

package org.spicefactory.parsley.core.registry.definition.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.MethodParameterRegistry;

/**
 * Default implementation of the MethodParameterRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultMethodParameterRegistry extends AbstractParameterRegistry implements MethodParameterRegistry {


	private var _method:Method;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param def the definition of the object this registry is associated with
	 */
	function DefaultMethodParameterRegistry (method:Method, def:ObjectDefinition) {
		super(method, def);
		_method = method;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function get method () : Method {
		return _method;
	}

	/**
	 * @inheritDoc
	 */
	public function addValue (value:*) : MethodParameterRegistry {
		doAddValue(value);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addIdReference (id:String) : MethodParameterRegistry {
		doAddIdReference(id);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addTypeReference (type:ClassInfo = null) : MethodParameterRegistry {
		doAddTypeReference(type);
		return this;
	}

	
}

}
