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

package org.spicefactory.parsley.core.messaging.receiver.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 * A regular message handler where individual properties of a matching message are passed to a method on the target instance.
 * 
 * @author Jens Halm
 */
public class MessagePropertyHandler extends AbstractMethodReceiver implements MessageTarget {
	
	
	private var messageProperties:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param provider the provider for the instance that contains the target method
	 * @param methodName the name of the target method that should be invoked
	 * @param messageType the type of the message
	 * @param messageProperties the list of names of properties of the message that should be used as method parameters
	 * @param selector an optional selector value to be used for selecting matching message targets
	 */
	function MessagePropertyHandler (provider:ObjectProvider, methodName:String, messageType:ClassInfo,
			messageProperties:Array, selector:* = undefined) {
		super(provider, methodName, messageType.getClass(), selector);
		checkParamCount(messageProperties);
		setMessageProperties(messageProperties, messageType);
	}

	private function checkParamCount (messageProperties:Array) : void {
		var requiredParams:uint = 0;
		var params:Array = targetMethod.parameters;
		for each (var param:Parameter in params) {
			if (param.required) requiredParams++;
		}
		if (requiredParams > messageProperties.length) {
			throw new ContextError("Number of specified parameter names does not match the number of required parameters of " 
				+ targetMethod + ". Required: " + requiredParams + " - actual: " + messageProperties.length);
			// We'll ignore if the the number of required params is less that needed, 
			// since we can't reflect on varargs in AS3.
		}
	}
	
	private function setMessageProperties (messageProperties:Array, messageType:ClassInfo) : void {
		this.messageProperties = new Array();
		for each (var propertyName:String in messageProperties) {
			var messageProperty:Property = messageType.getProperty(propertyName);
			if (messageProperty == null) {
				throw new ContextError("Message type " + messageType.name 
						+ " does not contain a property with name " + propertyName);	
			}
			else if (!messageProperty.readable) {
				throw new ContextError(messageProperty.toString() + " is not readable");
			}
			this.messageProperties.push(messageProperty);
		}
	}

	
	/**
	 * @inheritDoc
	 */
	public function handleMessage (message:Object) : void {
		var params:Array = new Array();
		for each (var messageProperty:Property in messageProperties) {
			var value:* = messageProperty.getValue(message);
			params.push(value);
		}
		targetMethod.invoke(targetInstance, params);		
	}
	
	
}
}
