package com.adams.dt.model.vo.localize
{
	import com.adams.dt.model.vo.LangEntries;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	[Event(name = "change")]	
	[Bindable]
	public final class Localizer extends EventDispatcher implements ILocalizer
	{
		private var _language : String;
		private var _langXML : ArrayCollection;
		private var cursor : IViewCursor;
		private static var instance : Localizer;
		public function Localizer()
		{
			if(instance != null) throw new Error("Localizer is a Singleton");
		}

		public static function getInstance() : Localizer
		{
			if(instance == null) instance = new Localizer();
			return instance ;
		}

		/*
		string search method
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
				_language == 'En' ? s = LangEntries(cursor.current).englishlbl : s = String(LangEntries(cursor.current).frenchlbl);
			}else
			{
				s = '...';
			}
			if(pKey == null) return '..' ;
			if(s == "") return pKey ;
			return s;
		}

		public function get langXML() : ArrayCollection
		{
			return _langXML;
		}

		public function set langXML(pXML : ArrayCollection) : void
		{
			_langXML = pXML;
			cursor = _langXML.createCursor();
			dispatchEvent(new Event("change"));
		}

		public function get language() : String
		{
			return _language;
		}

		public function set language(pLg : String) : void
		{
			_language = pLg;
			dispatchEvent(new Event("change"));
		}
	}
}
