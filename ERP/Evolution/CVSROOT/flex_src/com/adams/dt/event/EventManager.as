package com.adams.dt.event
{ 
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;    
    public class EventManager
    {
        private static var targetMap:Dictionary = new Dictionary();
         public static function addEvent(target:IEventDispatcher, type:String, listener:Function, ...args ) : void
        {
            var targetEventMap:Dictionary;
                targetEventMap = targetMap[target] == undefined ? new Dictionary : targetMap[target];
                targetEventMap[type] = { listener:listener, args:args };
            targetMap[target] = targetEventMap;
            target.addEventListener( type, onEvent,false,0,true );
        } 
        public static function removeEvent ( target:IEventDispatcher, type:String ) : void
        {
            var targetEventMap:Dictionary = targetMap[target];
            delete targetEventMap[type]; 
            target.removeEventListener( type, onEvent );
        } 
        private static function onEvent ( e:Event ) : void
        {
            var target:IEventDispatcher = e.currentTarget as IEventDispatcher;
            var targetEventMap:Dictionary = targetMap[target]; 
            var listener:Function = targetEventMap[e.type].listener;
            var args:Array = targetEventMap[e.type].args; 
            if (args[0] is Event) args.shift(); 
            args.unshift( e ); 
            listener.apply( target, args );
        } 
    }
}