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

package org.spicefactory.parsley.core.messaging.receiver.command {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * @private 
 * Prepared for inclusion in version 2.2.0.
 * 
 * @author Jens Halm
 */
public class DynamicInstanceProvider implements ObjectProvider {
	
	
	private var definition:ObjectDefinition;
	private var currentInstance:Object;
	
	
	function DynamicInstanceProvider (definition:ObjectDefinition) {
		this.definition = definition;
	}

	
	public function newInstance (context:DynamicContext) : DynamicObject {
		var dynamicObj:DynamicObject = context.addDefinition(definition);
		currentInstance = dynamicObj.instance;
		return dynamicObj;
	}
	
	public function get instance () : Object {
		return currentInstance;
	}
	
	public function get type () : ClassInfo {
		return definition.type;
	}
	
	
}
}
