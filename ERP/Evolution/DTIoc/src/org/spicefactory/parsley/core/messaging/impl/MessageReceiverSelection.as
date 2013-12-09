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

package org.spicefactory.parsley.core.messaging.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;

import flash.events.Event;

/**
 * A cached selection of receivers for a particular message type.
 * Will be used by the default MessageRouter implementation as a performance optimization.
 * 
 * @author Jens Halm
 */
public class MessageReceiverSelection {
	
	
	private var _messageType:ClassInfo;
	private var selectorProperty:Property;
	
	private var interceptors:MessageReceiverCollection;
	private var targets:MessageReceiverCollection;
	private var errorHandlers:MessageReceiverCollection;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the type of the message
	 * @param interceptors the interceptors for this selection
	 * @param targets the regular targets for this selection
	 * @param errorHandlers the error handlers for this selection
	 */
	function MessageReceiverSelection (type:ClassInfo, interceptors:Array, targets:Array, errorHandlers:Array) {
		_messageType = type;
		this.interceptors = getReceivers(interceptors, type);
		this.targets = getReceivers(targets, type);
		this.errorHandlers = getReceivers(errorHandlers, type);
		for each (var p:Property in type.getProperties()) {
			if (p.getMetadata(Selector).length > 0) {
				if (selectorProperty == null) {
					selectorProperty = p;
				}
				else {
					throw new ContextError("Class " + type.name + " contains more than one Selector metadata tag");
				}
			}
		}
		if (selectorProperty == null && _messageType.isType(Event)) {
			selectorProperty = _messageType.getProperty("type");
		}
	}
	
	private function getReceivers (receivers:Array, messageType:ClassInfo) : MessageReceiverCollection {
		var collection:MessageReceiverCollection = new MessageReceiverCollection();
		for each (var receiver:MessageReceiver in receivers) {
			if (messageType.isType(receiver.messageType)) {
				collection.addReceiver(receiver);
			}
		}
		return collection;
	}
	
	
	/**
	 * Returns the value of the selector property of the specified message instance.
	 * 
	 * @param message the message instance
	 * @return the value of the selector property of the specified message instance
	 */
	public function getSelectorValue (message:Object) : * {
		if (selectorProperty != null) {
			return selectorProperty.getValue(message);
		}
		else {
			return message.toString();
		}
	}
	
	/**
	 * Returns all regular targets (like handlers or bindings) that match for the specified selector value.
	 * 
	 * @param selectorValue the value of the selector property
	 * @return all regular targets that match for the specified selector value
	 */	
	public function getTargets (selectorValue:*) : Array {
		return targets.getReceicers(selectorValue);
	}
	
	/**
	 * Returns all interceptors that match for the specified selector value.
	 * 
	 * @param selectorValue the value of the selector property
	 * @return all interceptors that match for the specified selector value
	 */	
	public function getInterceptors (selectorValue:*) : Array {
		return interceptors.getReceicers(selectorValue);
	}
	
	/**
	 * Returns all error handlers that match for the specified selector value.
	 * 
	 * @param selectorValue the value of the selector property
	 * @return all error handlers that match for the specified selector value
	 */	
	public function getErrorHandlers (selectorValue:*) : Array {
		return errorHandlers.getReceicers(selectorValue);
	}
	

}
}

import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;

import flash.utils.Dictionary;

class MessageReceiverCollection {
	
	
	private var receiversWithSelector:Array = new Array();
	private var receiversWithoutSelector:Array = new Array();
	private var selectorMap:Dictionary = new Dictionary();
	
	
	public function addReceiver (receiver:MessageReceiver) : void {
		if (receiver.selector == undefined) {
			receiversWithoutSelector.push(receiver);
		}
		else {
			receiversWithSelector.push(receiver);
		}
	}
	
	public function getReceicers (selectorValue:*) : Array {
		var receivers:Array = null;
		if (selectorMap[selectorValue] != undefined) {
			receivers = selectorMap[selectorValue];
		}
		else {
			receivers = new Array();
			selectorMap[selectorValue] = receivers;
			for each (var target:MessageReceiver in receiversWithSelector) {
				if (target.selector == selectorValue) {
					receivers.push(target);
				}
			}
		}
		return receivers.concat(receiversWithoutSelector);
	}
	
	
}
