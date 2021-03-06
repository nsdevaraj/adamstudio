package com.adams.dt.model.vo
{
	
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Profiles")]	
	[Bindable]
	public final class Profiles implements IValueObject
	{
		private var _profileId : int;
		public function set profileId (value : int) : void
		{
			_profileId = value;
		}

		public function get profileId () : int
		{
			return _profileId;
		}

		private var _profileLabel : String;
		public function set profileLabel (value : String) : void
		{
			_profileLabel = value;
		}

		public function get profileLabel () : String
		{
			return _profileLabel;
		}

		private var _profileCode : String;
		public function set profileCode (value : String) : void
		{
			_profileCode = value;
		}

		public function get profileCode () : String
		{
			return _profileCode;
		}

		private var _profileBckgdImage : ByteArray;
		public function set profileBckgdImage (value : ByteArray) : void
		{
			_profileBckgdImage = value;
		}

		public function get profileBckgdImage () : ByteArray
		{
			return _profileBckgdImage;
		} 
		
		private var _PersonArrSet : ArrayCollection = new ArrayCollection();
		public function set PersonArrSet (value : ArrayCollection) : void
		{
			_PersonArrSet = value;
		}

		public function get PersonArrSet () : ArrayCollection
		{
			return _PersonArrSet;
		}
		
		private var _destination:String;
		public function get destination():String {
			return _destination;
		}
		public function set destination( value:String ):void {
			_destination = value;
		}
		
		public function Profiles()
		{
		}
	}
}
