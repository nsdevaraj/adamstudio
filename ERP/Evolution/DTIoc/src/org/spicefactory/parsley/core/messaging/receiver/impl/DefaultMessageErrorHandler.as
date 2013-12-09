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
	import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;

/**
 * Default implementation of the MessageErrorHandler interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageErrorHandler extends AbstractMethodReceiver implements MessageErrorHandler {


	private var _errorType:Class;

	
	/**
	 * Creates a new instance.
	 * The target method must have a parameter of type <code>org.spicefactory.parsley.messaging.MessageProcessor</code>
	 * and a second parameter of type Error (or a subtype).
	 * 
	 * @param provider the provider for the actual instance handling the message
	 * @param methodName the name of the method to invoke for matching messages
	 * @param messageType the type of the message this error handler is interested in
	 * @param selector an additional selector value to be used to determine matching messages
	 * @param errorType the type of Error this handler is interested in
	 */
	function DefaultMessageErrorHandler (provider:ObjectProvider, methodName:String, messageType:Class,
			selector:* = undefined, errorType:ClassInfo = null) {
		super(provider, methodName, messageType, selector);
		var params:Array = targetMethod.parameters;
		if (params.length < 1 || params.length > 2) {
			throw new ContextError("Target " + targetMethod 
				+ ": Method must have one or two parameters.");
		}
		if (Parameter(params[0]).type.getClass() != MessageProcessor) {
			throw new ContextError("Target " + targetMethod 
				+ ": First parameter must be of type org.spicefactory.parsley.core.messaging.MessageProcessor.");
			
		}
		if (params.length == 2) {
			var paramType:ClassInfo = Parameter(params[1]).type;
			if (!paramType.isType(Error)) {
				throw new ContextError("Target " + targetMethod 
					+ ": Second parameter must be of type Error or a subtype");
			}
			if (errorType == null) {
				errorType = paramType;
			}
			else if (!errorType.isType(paramType.getClass())) {
				throw new ContextError("Target " + targetMethod
					+ ": Method parameter of type " + paramType.name
					+ " is not applicable to error type " + errorType.name);
			}
			_errorType = errorType.getClass();
		}
		else if (errorType == null) {
			_errorType = Error;
		}			
	}


	/**
	 * @inheritDoc
	 */
	public function get errorType () : Class {
		return _errorType;
	}
	
	/**
	 * @inheritDoc
	 */
	public function handleError (processor:MessageProcessor, error:Error) : void {
		var params:Array = (targetMethod.parameters.length == 2) ? [processor, error] : [processor];
		targetMethod.invoke(targetInstance, params);
	}
	

}
}
