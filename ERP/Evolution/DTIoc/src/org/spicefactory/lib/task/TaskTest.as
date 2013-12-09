package org.spicefactory.lib.task {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.utils.Dictionary;

import org.spicefactory.lib.task.enum.TaskState;
import org.spicefactory.lib.task.events.TaskEvent;
import org.spicefactory.lib.task.ResultTask;
import org.spicefactory.lib.util.Command;

import flexunit.framework.TestCase;

public class TaskTest extends TestCase {


	private var eventCounter:EventCounter;
	private var expectedState:TaskState;
	private var expectedEvents:Result;



	private function startTask (eventType:String, expectedState:TaskState,
			listener:Function = null,
			cancelable:Boolean = false, restartable:Boolean = false,
			suspendable:Boolean = false, skippable:Boolean = false, 
			timeout:uint = 0) : TimerTask {
		this.expectedState = expectedState;
		if (listener == null) listener = onTestComplete;
		var tt:TimerTask = new TimerTask(150, cancelable, restartable, suspendable, skippable, timeout);
		tt.addEventListener(eventType, addAsync(listener, 500));
		eventCounter = new EventCounter(tt);
		tt.start();
		return tt;
	}
	
	private function startSequential (tasks:Array, eventType:String, expectedState:TaskState,
			listener:Function = null, timeout:uint = 0) : TaskGroup {
		return startGroup(new SequentialTaskGroup(), tasks, eventType, expectedState, listener, timeout);
	}
	
	private function startConcurrent (tasks:Array, eventType:String, expectedState:TaskState,
			listener:Function = null, timeout:uint = 0) : TaskGroup {
		return startGroup(new ConcurrentTaskGroup(), tasks, eventType, expectedState, listener, timeout);
	}
	
	private function startGroup (tg:TaskGroup, tasks:Array, eventType:String, expectedState:TaskState,
			listener:Function = null, timeout:uint = 0) : TaskGroup {
		for each (var t:Task in tasks) {
			tg.addTask(t);
		}
		this.expectedState = expectedState;
		if (listener == null) listener = onTestComplete;
		tg.addEventListener(eventType, addAsync(listener, 500));
		eventCounter = new EventCounter(tg);
		tg.timeout = timeout;
		tg.start();
		return tg;
	}

	
	public function testCompleteRestartable () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		startTask(TaskEvent.COMPLETE, TaskState.INACTIVE, null, true, true);
	}
	
	public function testCompleteNonRestartable () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		startTask(TaskEvent.COMPLETE, TaskState.FINISHED, null, true, false);
	}
	
	public function testIllegalRestart () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		startTask(TaskEvent.COMPLETE, TaskState.FINISHED, onTestIllegalRestart, true, false);
	}
	
	public function testCancel () : void {
		expectedEvents = new Result(1, 0, 1, 0, 0, 0);
		var t:Task = startTask(TaskEvent.CANCEL, TaskState.INACTIVE, null, true, true);
		t.cancel();
	}
	
	public function testIllegalCancel () : void {
		expectedEvents = new Result(1, 0, 0, 0, 0, 0);
		startTask(TaskEvent.START, TaskState.ACTIVE, onTestIllegalCancel, false, true);
	}
	
	public function testSuspendResume () : void {
		expectedEvents = new Result(1, 0, 0, 0, 1, 1);
		var t:Task = startTask(TaskEvent.RESUME, TaskState.ACTIVE, null, true, true, true);
		assertTrue("Task should be suspendable", t.suspendable);		
		assertTrue("Task could not be suspended", t.suspend());		
		assertTrue("Task could not be resumed", t.resume());		
	}
	
	public function testError () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		var t:TimerTask = startTask(ErrorEvent.ERROR, TaskState.FINISHED, null);
		t.dispatchError("Expected Error");		
	}
	
	public function testSkip () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var t:Task = startTask(TaskEvent.COMPLETE, TaskState.INACTIVE, null, true, true);
		t.skip();
	}
	
	public function testIllegalSkip () : void {
		expectedEvents = new Result(1, 0, 0, 0, 0, 0);
		startTask(TaskEvent.START, TaskState.ACTIVE, onTestIllegalSkip);
	}
	
	public function testTimeout () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		startTask(ErrorEvent.ERROR, TaskState.FINISHED, null, false, false, false, false, 80);	
	}
	
	
	public function testEmptySequentialComplete () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		startSequential([], TaskEvent.COMPLETE, TaskState.INACTIVE);
	}
	
	public function testEmptyConcurrentComplete () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		startConcurrent([], TaskEvent.COMPLETE, TaskState.INACTIVE);
	}
	
	public function testSequentialComplete () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		// child tasks are not restartable so we expect FINISHED state
		startSequential([tt1, tt2], TaskEvent.COMPLETE, TaskState.FINISHED);
	}
	
	public function testConcurrentComplete () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		// child tasks are not restartable so we expect FINISHED state
		startConcurrent([tt1, tt2], TaskEvent.COMPLETE, TaskState.FINISHED);
	}
	
	public function testRestartableSequentialComplete () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, false, true);
		var tt2:TimerTask = new TimerTask(150, false, true);
		startSequential([tt1, tt2], TaskEvent.COMPLETE, TaskState.INACTIVE);
	}
	
	public function testCancelSequential () : void {
		expectedEvents = new Result(1, 0, 1, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, true);
		var tt2:TimerTask = new TimerTask(150, true);
		var tg:TaskGroup = startSequential([tt1, tt2], TaskEvent.CANCEL, TaskState.FINISHED);
		tg.cancel();
		assertEquals("Unexpected state for child 1", TaskState.FINISHED, tt1.state);
		assertEquals("Unexpected state for child 2", TaskState.INACTIVE, tt2.state);
	}
	
	public function testCancelConcurrent () : void {
		expectedEvents = new Result(1, 0, 1, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, true);
		var tt2:TimerTask = new TimerTask(150, true);
		var tg:TaskGroup = startConcurrent([tt1, tt2], TaskEvent.CANCEL, TaskState.FINISHED);
		tg.cancel();
		assertEquals("Unexpected state for child 1", TaskState.FINISHED, tt1.state);
		assertEquals("Unexpected state for child 2", TaskState.FINISHED, tt2.state);
	}
	
	public function testIllegalCancelSequential () : void {
		expectedEvents = new Result(1, 0, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		startSequential([tt1, tt2], TaskEvent.START, TaskState.ACTIVE, onTestIllegalCancel);
	}
	
	public function testIllegalCancelConcurrent () : void {
		expectedEvents = new Result(1, 0, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		startConcurrent([tt1, tt2], TaskEvent.START, TaskState.ACTIVE, onTestIllegalCancel);
	}
	
	public function testSuspendResumeSequential () : void {
		expectedEvents = new Result(1, 0, 0, 0, 1, 1);
		var tt1:TimerTask = new TimerTask(150, false, false, true);
		var tt2:TimerTask = new TimerTask(150, false, false, true);
		var tg:TaskGroup = startSequential([tt1, tt2], TaskEvent.RESUME, 
				TaskState.ACTIVE);
		assertTrue("TaskGroup should be suspendable", tg.suspendable);
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);		
		assertEquals("Unexpected state of child Task", TaskState.INACTIVE, tt2.state);		
		assertTrue("TaskGroup could not be suspended", tg.suspend());	
		assertEquals("Unexpected state of child Task", TaskState.SUSPENDED, tt1.state);	
		assertTrue("TaskGroup could not be resumed", tg.resume());		
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);	
	}
	
	public function testSuspendResumeConcurrent () : void {
		expectedEvents = new Result(1, 0, 0, 0, 1, 1);
		var tt1:TimerTask = new TimerTask(150, false, false, true);
		var tt2:TimerTask = new TimerTask(150, false, false, true);
		var tg:TaskGroup = startConcurrent([tt1, tt2], TaskEvent.RESUME, 
				TaskState.ACTIVE);
		assertTrue("TaskGroup should be suspendable", tg.suspendable);
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);		
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);		
		assertTrue("TaskGroup could not be suspended", tg.suspend());	
		assertEquals("Unexpected state of child Task", TaskState.SUSPENDED, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.SUSPENDED, tt2.state);	
		assertTrue("TaskGroup could not be resumed", tg.resume());		
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);	
	}
	
	public function testErrorSequential () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		startSequential([tt1, tt2], ErrorEvent.ERROR, TaskState.FINISHED);
		tt1.dispatchError("Expected Error");
	}
	
	public function testErrorConcurrent () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		startConcurrent([tt1, tt2], ErrorEvent.ERROR, TaskState.FINISHED);
		tt1.dispatchError("Expected Error");
	}
	
	public function testSkipSequential () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, false, false, false, true);
		var tt2:TimerTask = new TimerTask(150, false, false, false, true);
		var tg:TaskGroup = startSequential([tt1, tt2], TaskEvent.COMPLETE, 
				TaskState.FINISHED);
		assertTrue("TaskGroup should be skippable", tg.skippable);
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);		
		assertEquals("Unexpected state of child Task", TaskState.INACTIVE, tt2.state);		
		assertTrue("TaskGroup could not be suspended", tg.skip());	
		assertEquals("Unexpected state of child Task", TaskState.FINISHED, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.INACTIVE, tt2.state);		
	}
	
	public function testSkipConcurrent () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, false, false, false, true);
		var tt2:TimerTask = new TimerTask(150, false, false, false, true);
		var tg:TaskGroup = startConcurrent([tt1, tt2], TaskEvent.COMPLETE, 
				TaskState.FINISHED);
		assertTrue("TaskGroup should be skippable", tg.skippable);
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);		
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);		
		assertTrue("TaskGroup could not be suspended", tg.skip());	
		assertEquals("Unexpected state of child Task", TaskState.FINISHED, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.FINISHED, tt2.state);		
	}
	
	public function testIllegalSkipSequential () : void {
		expectedEvents = new Result(1, 0, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		startSequential([tt1, tt2], TaskEvent.START, TaskState.ACTIVE, onTestIllegalSkip);
	}
	
	public function testIllegalSkipConcurrent () : void {
		expectedEvents = new Result(1, 0, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		startConcurrent([tt1, tt2], TaskEvent.START, TaskState.ACTIVE, onTestIllegalSkip);
	}
	
	public function testTimeoutSequential () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		var tt1:TimerTask = new TimerTask(150, false, false, false, false, 80);
		var tt2:TimerTask = new TimerTask(150);
		startSequential([tt1, tt2], ErrorEvent.ERROR, TaskState.FINISHED);
	}
	
	public function testTimeoutConcurrent () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		var tt1:TimerTask = new TimerTask(150, false, false, false, false, 80);
		var tt2:TimerTask = new TimerTask(150);
		startConcurrent([tt1, tt2], ErrorEvent.ERROR, TaskState.FINISHED);
	}
	
	public function testParentTimeoutSequential () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		var tt1:TimerTask = new TimerTask(1000, true);
		var tt2:TimerTask = new TimerTask(150, true);
		startSequential([tt1, tt2], ErrorEvent.ERROR, TaskState.FINISHED, null, 200);
	}
	
	public function testParentTimeoutConcurrent () : void {
		expectedEvents = new Result(1, 0, 0, 1, 0, 0);
		var tt1:TimerTask = new TimerTask(1000, true);
		var tt2:TimerTask = new TimerTask(150, true);
		startConcurrent([tt1, tt2], ErrorEvent.ERROR, TaskState.FINISHED, null, 200);
	}
		
	public function testIgnoreTimeoutSequential () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, false, false, false, false, 80);
		var tt2:TimerTask = new TimerTask(150);
		var tg:TaskGroup = startSequential([tt1, tt2], TaskEvent.COMPLETE, 
				TaskState.FINISHED);
		tg.ignoreChildErrors = true;
	}
	
	public function testIgnoreTimeoutConcurrent () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, false, false, false, false, 80);
		var tt2:TimerTask = new TimerTask(150);
		var tg:TaskGroup = startConcurrent([tt1, tt2], TaskEvent.COMPLETE, 
				TaskState.FINISHED);
		tg.ignoreChildErrors = true;
	}
	
	public function testTaskGroupContext () : void {
		var outerGroup:TaskGroup = new SequentialTaskGroup();
		var innerGroup:TaskGroup = new ConcurrentTaskGroup();
		var task:Task = new TimerTask(100);
		innerGroup.addTask(task);
		outerGroup.addTask(innerGroup);
		outerGroup.data = 7;
		assertEquals("Unexpected context value", 7, outerGroup.data);
		assertEquals("Unexpected context value", 7, innerGroup.data);
		assertEquals("Unexpected context value", 7, task.data);
		innerGroup.data = "foo";
		assertEquals("Unexpected context value", 7, outerGroup.data);
		assertEquals("Unexpected context value", "foo", innerGroup.data);
		assertEquals("Unexpected context value", "foo", task.data);	
		task.data = true;	
		assertEquals("Unexpected context value", 7, outerGroup.data);
		assertEquals("Unexpected context value", "foo", innerGroup.data);
		assertEquals("Unexpected context value", true, task.data);	
	}
	
	public function testAddTaskToRunningConcurrent () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		var tg:TaskGroup = startConcurrent([tt1], TaskEvent.COMPLETE, 
				TaskState.FINISHED);
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);		
		assertEquals("Unexpected state of child Task", TaskState.INACTIVE, tt2.state);		
		assertTrue("Task could not be added to TaskGroup", tg.addTask(tt2));	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);		 				
	}
	
	public function testAddTaskWhileDoStartExecutes () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tg:TaskGroup = new ConcurrentTaskGroup();
		var tAdded:Task = new NonRestartableCommandTask(new Command(childTask2));
		var t:Task = new NonRestartableCommandTask(new Command(childTask1, [tg, tAdded]));
		var t2:Task = new NonRestartableCommandTask(new Command(childTask2));
		startGroup(tg, [t, t2], TaskEvent.COMPLETE, TaskState.FINISHED);
		assertEquals("Unexpected state of child Task", TaskState.FINISHED, t.state);		
		assertEquals("Unexpected state of child Task", TaskState.FINISHED, t2.state);		
		assertEquals("Unexpected state of dynamically added child Task", TaskState.FINISHED, tAdded.state);		
	}
	
	private function childTask1 (group:TaskGroup, t:Task) : void {
		group.addTask(t);
	}

	private function childTask2 () : void {  } 
	
	public function testRemoveTaskFromRunningConcurrent () : void {
		expectedEvents = new Result(1, 0, 1, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150, true);
		var tt2:TimerTask = new TimerTask(150, true);
		var tg:TaskGroup = startConcurrent([tt1, tt2], TaskEvent.CANCEL, 
				TaskState.FINISHED);
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);		
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);		
		assertTrue("Task could not be removed from TaskGroup", tg.removeTask(tt2));	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);
		assertTrue("TaskGroup could not be canceled", tg.cancel());		
		assertEquals("Unexpected state of child Task", TaskState.FINISHED, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);	
	}
	
	public function testRemoveTaskFromRunningSequential () : void {
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		var tt1:TimerTask = new TimerTask(150);
		var tt2:TimerTask = new TimerTask(150);
		var tg:TaskGroup = startSequential([tt1, tt2], TaskEvent.COMPLETE, 
				TaskState.FINISHED);	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);		
		assertEquals("Unexpected state of child Task", TaskState.INACTIVE, tt2.state);	
		assertTrue("Task could not be removed from TaskGroup", tg.removeTask(tt1));	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt1.state);	
		assertEquals("Unexpected state of child Task", TaskState.ACTIVE, tt2.state);		
	}
	
	public function testResultTask () : void {
		var t:ResultTask = new SimpleResultTask();
		eventCounter = new EventCounter(t);
		expectedState = TaskState.INACTIVE;
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		t.start();
		validate(Task(t));
		assertEquals("Unexpected result property", "foo", t.result);
	}
	
	public function testResultTaskWithContextProperty () : void {
		var t:ResultTask = new SimpleResultTask("test");
		var tg:TaskGroup = new SequentialTaskGroup();
		tg.data = new Dictionary();
		tg.addTask(t);
		eventCounter = new EventCounter(tg);
		expectedState = TaskState.INACTIVE;
		expectedEvents = new Result(1, 1, 0, 0, 0, 0);
		tg.start();
		validate(Task(tg));
		assertEquals("Unexpected result property", "foo", tg.data.test);
	}

	
	private function onTestIllegalRestart (event:Event) : void {
		validate(Task(event.target));
		assertFalse("Task should not be restartable", Task(event.target).start());
	}
	
	private function onTestIllegalCancel (event:Event) : void {
		validate(Task(event.target));
		assertFalse("Task should not be cancelable", Task(event.target).cancel());
	}
	
	private function onTestIllegalSkip (event:Event) : void {
		validate(Task(event.target));
		assertFalse("Task should not be skippable", Task(event.target).skip());
	}
			
	
	private function onTestComplete (event:Event) : void {
		validate(Task(event.target));
	}
	
	
	private function validate (t:Task) : void {
		assertEquals("Unexpected state of Task", expectedState, t.state);
		var r:Result = expectedEvents;
		assertEquals("Unexpected count of START events", r.start, eventCounter.getCount(TaskEvent.START)); 		
		assertEquals("Unexpected count of COMPLETE events", r.complete, eventCounter.getCount(TaskEvent.COMPLETE)); 		
		assertEquals("Unexpected count of CANCEL events", r.cancel, eventCounter.getCount(TaskEvent.CANCEL)); 		
		assertEquals("Unexpected count of ERROR events", r.error, eventCounter.getCount(ErrorEvent.ERROR)); 		
		assertEquals("Unexpected count of SUSPEND events", r.suspend, eventCounter.getCount(TaskEvent.SUSPEND)); 		
		assertEquals("Unexpected count of RESUME events", r.resume, eventCounter.getCount(TaskEvent.RESUME)); 		
	}



}
}

import org.spicefactory.lib.task.util.CommandTask;
import org.spicefactory.lib.task.ResultTask;
import org.spicefactory.lib.util.Command;

class Result {
	
	
	public var start:uint;
	public var complete:uint;
	public var cancel:uint;
	public var error:uint;
	public var suspend:uint;
	public var resume:uint;
	
	function Result (start:uint, complete:uint, cancel:uint, error:uint,
			suspend:uint, resume:uint) {
		this.start = start;
		this.complete = complete;
		this.cancel = cancel;
		this.error = error;
		this.suspend = suspend;
		this.resume = resume;
	}
	
	
}

class NonRestartableCommandTask extends CommandTask {
	
	public function NonRestartableCommandTask (command:Command, name:String = "[CommandTask]") {
		super(command, name);
		setRestartable(false);
	}
	
}

class SimpleResultTask extends ResultTask {
	
	
	function SimpleResultTask (propName:String = null) {
		super(propName);
	}
	
	protected override function doStart () : void {
		setResult("foo");
	}
	
	
}


