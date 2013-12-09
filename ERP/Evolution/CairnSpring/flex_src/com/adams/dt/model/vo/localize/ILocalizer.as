package  com.adams.dt.model.vo.localize
{
	import flash.events.IEventDispatcher;
	import mx.collections.ArrayCollection;
	
	/**
	 * Defines a business delegate.
	 * extends IEventDispatcher class
	 * Interface to implement
	 * so that the views can access localized data			
	 */
	
	[Event(name = "change")]
	public interface ILocalizer extends IEventDispatcher
	{
		/**
		* Gets the language of the ILocalizer.
		* return type String
		*/
		function get language() : String;
		
		/**
		* Sets the language of the ILocalizer.
		* @param String
		*/
		function set language(pLang : String) : void;
		
		/**
		* Gets the langXML of the ILocalizer.
		* return type ArrayCollection
		*/
		function get langXML() : ArrayCollection
		
		/**
		* Sets the langXML of the ILocalizer.
		* @param ArrayCollection
		*/
		function set langXML(pXML : ArrayCollection) : void
		
		/**
		* Gets the getString of the ILocalizer.
		* @param String
		* return type String
		*/
		[Bindable("change")]
		function getString(pKey : String) : String;
	}
}
