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
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 * A regular message handler where the message is simply passed to a method on the target instance.
 * 
 * @author Jens Halm
 */
public class MessageHandler extends AbstractMethodReceiver implements MessageTarget {
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param provider the provider for the instance that contains the target method
	 * @param methodName the name of the target method that should be invoked
	 * @param selector an optional selector value to be used for selecting matching message targets
	 * @param messageType the type of the message or null if it should be autodetected by the parameter of the target method
	 */
	function MessageHandler (provider:ObjectProvider, methodName:String, selector:* = undefined, messageType:ClassInfo = null) {
		super(provider, methodName, getMessageType(provider, methodName, messageType), selector);
	}
	

	private function getMessageType (provider:ObjectProvider, methodName:String, 
			messageType:ClassInfo = null) : Class {
		var targetMethod:Method = provider.type.getMethod(methodName);
		if (targetMethod == null) {
			throw new ContextError("Target instance of type " + provider.type.name 
					+ " does not contain a method with name " + targetMethod);
		}
		var params:Array = targetMethod.parameters;
		if (params.length > 1) {
			throw new ContextError("Target " + targetMethod  
				+ ": At most one parameter allowed for a MessageHandler.");
		}
		if (params.length == 1) {
			var paramType:ClassInfo = Parameter(params[0]).type;
			if (messageType == null) {
				return paramType.getClass();
			}
			else if (!messageType.isType(paramType.getClass())) {
				throw new ContextError("Target " + targetMethod
					+ ": Method parameter of type " + paramType.name
					+ " is not applicable to message type " + messageType.name);
			}
		}
		else if (messageType == null) {
			return Object;
		}			
		return messageType.getClass();
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function handleMessage (message:Object) : void {
		var params:Array = (targetMethod.parameters.length == 1) ? [message] : [];
		targetMethod.invoke(targetInstance, params);
	}
	
	
}
}
