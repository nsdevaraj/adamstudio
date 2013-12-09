package com.adams.dt.event
{
    import flash.events.Event;

    public class SprintEvent extends Event
    {   
        public static const SPRINT_DELETE_ROW:String = "deleteRow";
        
        public var sprint:Sprint;
        
        public function SprintEvent(type:String,sprint:Sprint) {
                super(type);
                this.sprint = sprint;
        }

    }
}

