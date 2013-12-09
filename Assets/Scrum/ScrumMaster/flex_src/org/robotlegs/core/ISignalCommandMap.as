package org.robotlegs.core
{
	import org.osflash.signals.ISignal;
	
    public interface ISignalCommandMap
    {
    	function mapSignalClass(signalClass:Class, commandClass:Class, oneShot:Boolean = false):ISignal;
    	
        function mapSignal(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void;

        function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean;

        function unmapSignal(signal:ISignal, commandClass:Class):void;
    }
}
