package com.adams.dam.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias = "com.adams.dt.pojo.Profiles")]	
	[Bindable]
	public final class Profiles implements IValueObject
	{
		private var _profileBckgdImageBlob:Object;
		public function set profileBckgdImageBlob( value:Object ):void {
			_profileBckgdImageBlob = value;
		}
		
		private var _profileId:int;
		public function set profileId( value:int ):void {
			_profileId = value;
		}
		public function get profileId():int {
			return _profileId;
		}

		private var _profileLabel:String;
		public function set profileLabel( value:String ):void {
			_profileLabel = value;
		}
		public function get profileLabel():String {
			return _profileLabel;
		}
		
		 private var _profileColor:uint;
		public function set profileColor( value:uint ):void {
			_profileColor = value;
		}
		public function get profileColor():uint {
			return _profileColor;
		} 
		
		private var _profileCode:String;
		public function set profileCode( value:String ):void {
			_profileCode = value;
		}
		public function get profileCode():String {
			return _profileCode;
		}

		private var _profileBckgdImage:ByteArray;
		public function set profileBckgdImage( value:ByteArray ):void {
			_profileBckgdImage = value;
		}
		public function get profileBckgdImage():ByteArray {
			return _profileBckgdImage;
		} 
		
		private var _PersonArrSet:ArrayCollection = new ArrayCollection();
		public function set PersonArrSet( value:ArrayCollection ):void {
			_PersonArrSet = value;
		}
		public function get PersonArrSet():ArrayCollection {
			return _PersonArrSet;
		}
		
		public function Profiles()
		{
			
		}
	}
}
