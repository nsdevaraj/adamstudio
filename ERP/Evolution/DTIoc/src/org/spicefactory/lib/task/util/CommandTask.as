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
 
package org.spicefactory.lib.task.util {
import org.spicefactory.lib.task.Task;
import org.spicefactory.lib.util.Command;

/**
 * Task implementation that wraps a synchronous Command. Useful if you need to add some kind
 * of synchronous operation to a <code>TaskGroup</code>.
 * 
 * @author Jens Halm
 */	
public class CommandTask extends Task {
	
		
	private var command:Command;
	
	
	/**
	 * Creates a new Task that wraps the specified synchronous Command.
	 * 
	 * @param com the Command to execute when the Task is started
	 * @param name an optional name for this CommandTask for log output
	 */
	public function CommandTask (command:Command, name:String = "[CommandTask]") {
		super();
		setName(name);
		this.command = command;
	}
	
	/**
	 * @private
	 */
	protected override function doStart () : void {
		command.execute();
		complete();
	}
			
		
}
	
}