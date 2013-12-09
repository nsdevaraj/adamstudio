package com.adams.dt.model.vo.localize
{
	import com.adams.dt.model.vo.LangEntries;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	
	/**
	 * Defines a business delegate.
	 * extends EventDispatcher class and implements ILocalizer class
	 * Interface to implement
	 * so that the views can access localized data			
	 */
	[Event(name = "change")]	
	[Bindable]
	public final class Localizer extends EventDispatcher implements ILocalizer
	{
		/**
     	 * String _language variable.
     	 */
		private var _language : String;
		
		/**
     	 * ArrayCollection _langXML variable.
     	 */
		private var _langXML : ArrayCollection;
		
		/**
     	 * IViewCursor cursor variable.
     	 */
		private var cursor : IViewCursor;
		
		/**
     	 * Localizer class instance create.
     	 */
		private static var instance : Localizer;
		public function Localizer()
		{
			if(instance != null) throw new Error("Localizer is a Singleton");
		}

		/**
     	 * Localizer class instance create.
     	 */
		public static function getInstance() : Localizer
		{
			if(instance == null) instance = new Localizer();
			return instance ;
		}

		/**
	     * Method Name getString.
		 * @param pKey String value pass
		 * search language value disply
		 * return type String
	     */	
		[Bindable("change")]	
		public function getString(pKey : String) : String
		{
			if(langXML == null) return "...";
			var s : String = '';
			var le : LangEntries = new LangEntries();
			le.formid = pKey
			var found : Boolean = cursor.findAny(le);
			if (found)
			{
				_language == 'En' ? s = LangEntries(cursor.current).englishlbl : s = LangEntries(cursor.current).frenchlbl;
			}else
			{
				s = '...';
			}
			if(pKey == null) return '..' ;
			if(s == "") return pKey ;
			return s;
		}

		/**
		* Gets the langXML of the Localizer.
		* return type ArrayCollection
		*/
		public function get langXML() : ArrayCollection
		{
			return _langXML;
		}
		
		/**
		* Sets the langXML of the Localizer.
		* @param ArrayCollection
		*/
		public function set langXML(pXML : ArrayCollection) : void
		{
			_langXML = pXML;
			cursor = _langXML.createCursor();
			dispatchEvent(new Event("change"));
		}

		/**
		* Gets the language of the Localizer.
		* return type String
		*/
		public function get language() : String
		{
			return _language;
		}
		
		/**
		* Sets the language of the Localizer.
		* @param String
		*/
		public function set language(pLg : String) : void
		{
			_language = pLg;
			dispatchEvent(new Event("change"));
		}
	}
}
