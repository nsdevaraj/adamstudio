package org.robotlegs.base
{
    import flash.utils.Dictionary;

    import org.osflash.signals.*;
    import flash.utils.Dictionary;
    import flash.utils.describeType;

    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.ISignalCommandMap;

    public class SignalCommandMap implements ISignalCommandMap
    {
        protected var injector:IInjector;
        protected var signalMap:Dictionary;
        protected var verifiedCommandClasses:Dictionary;

        public function SignalCommandMap(injector:IInjector)
        {
			this.injector = injector;
            signalMap = new Dictionary(false);
            verifiedCommandClasses = new Dictionary( false );
        }
        
        
        public function mapSignalClass(signalClass:Class, commandClass:Class, oneShot:Boolean = false):ISignal
        {
            var signal:ISignal = injector.instantiate(signalClass);
            injector.mapValue(signalClass, signal);
            mapSignal(signal, commandClass, oneShot);
            return signal;
        }

        public function mapSignal(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void
        {
            verifyCommandClass( commandClass );
            if ( hasSignalCommand( signal, commandClass ) )
                return;
            var signalCommandMap:Dictionary = signalMap[signal] = signalMap[signal] || (signalMap[signal] = new Dictionary(false));
			var callback:Function = function(a:*=null, b:*=null, c:*=null, d:*=null, e:*=null, f:*=null, g:*=null):void
			{
				routeSignalToCommand(signal, arguments, commandClass, oneShot);
			};

		    signalCommandMap[commandClass] =  callback;	
			signal.add(callback);
        }

        public function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean
        {
            var callbacksByCommandClass:Dictionary = signalMap[signal];
            if (callbacksByCommandClass == null) return false;
            var callback:Function = callbacksByCommandClass[commandClass];
			if (callback == null) return false;
            return true;
        }

        public function unmapSignal(signal:ISignal, commandClass:Class):void
        {
            var callbacksByCommandClass:Dictionary = signalMap[signal];
			if (callbacksByCommandClass == null) return;
            var callback:Function = callbacksByCommandClass[commandClass];
			if (callback == null) return;
			signal.remove( callbacksByCommandClass[commandClass] );
            delete callbacksByCommandClass[commandClass];
        }

        protected function routeSignalToCommand(signal:ISignal, valueObjects:Array, commandClass:Class, oneshot:Boolean):void
        {
			var value:Object;
			for each( value in valueObjects )
			{
				injector.mapValue( value.constructor, value );
			}

			var command:Object = injector.instantiate(commandClass);

			for each( value in valueObjects )
			{
				injector.unmap( value.constructor );
			}
			
			command.execute( );
			
            if (oneshot)
			{
				unmapSignal( signal, commandClass );
			}
        }
				
        protected function verifyCommandClass(commandClass:Class):void
        {
            if ( !verifiedCommandClasses[commandClass] )
            {
                verifiedCommandClasses[commandClass] = describeType( commandClass ).factory.method.(@name == "execute").length() == 1;
                if ( !verifiedCommandClasses[commandClass] )
                {
                    throw new ContextError(ContextError.E_COMMANDMAP_NOIMPL + ' - ' + commandClass);
                }
            }
        }
    }
}
