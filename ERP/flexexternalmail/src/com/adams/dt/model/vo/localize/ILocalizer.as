package  com.adams.dt.model.vo.localize
{
	import flash.events.IEventDispatcher;
	import mx.collections.ArrayCollection;
	/*
	Interface to implement
	so that the views can access localized data
	*/
	[Event(name = "change")]
	public interface ILocalizer extends IEventDispatcher
	{
		function get language() : String;
		function set language(pLang : String) : void;
		function get langXML() : ArrayCollection
		function set langXML(pXML : ArrayCollection) : void
		[Bindable("change")]
		function getString(pKey : String) : String;
	}
}
