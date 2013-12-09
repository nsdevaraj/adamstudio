/*
 * Copyright 2007 the original author or authors.
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
 
package org.spicefactory.lib.util {

/**
 * A CommandChain executes multiple Commands sequentially. 
 * CommandChain is itself a subclass of Command (Composite Design Pattern) and
 * can be part of other CommandChains.
 * 
 * @author Jens Halm
 */
public class CommandChain extends Command {
	
	
	private var commands:Array;

	/**
	 * Creates a new empty CommandChain.
	 */
	public function CommandChain () {
		super(executeChain);
		commands = new Array();
	}
	
	/**
	 * Adds the specified Command to this CommandChain.
	 * 
	 * @param com the Command to add
	 */
	public function addCommand (com:Command) : void {
		commands.push(com);
	}
	
	/**
	 * Removes the specified Command from this CommandChain.
	 * 
	 * @param com the Command to remove
	 */
	public function removeCommand (com:Command) : void {
		var index:int = commands.indexOf(com);
		if (index >= 0) commands.splice(index, 1);
	}
	
	/**
	 * Checks whether this CommandChain is empty (does not contain any Commands).
	 * 
	 * @return true if this CommandChain does not contain any Commands
	 */
	public function isEmpty () : Boolean {
		return (commands.length == 0);
	}
	
	/**
	 * Removes all Commands from this CommandChain.
	 */
	public function clear () : void {
		commands = new Array();
	}
	
	private function executeChain () : void {
		for (var i:int = 0; i < commands.length; i++) {
			Command(commands[i]).execute();
		}
	}
	
	/**
	 * Creates a clone of this CommandChain.
	 * 
	 * @return a new CommandChain that contains the same Command as this CommandChain
	 */
	public function clone () : CommandChain {
		var cc:CommandChain = new CommandChain();
		cc.commands = commands.concat();
		return cc;
	}
	
}

}