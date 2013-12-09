package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	[RemoteClass(alias = "com.adams.dt.pojo.Profiles")]	
	[Bindable]
	public final class Profiles extends AbstractVO
	{
		private var _profileBckgdImageBlob:Object;
		public function set profileBckgdImageBlob (value : Object) : void
		{
			_profileBckgdImageBlob = value;
		}
		
		public function get profileBckgdImageBlob () : Object
		{
			return _profileBckgdImageBlob;
		}
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
		
		 private var _profileColor : uint;
		public function set profileColor (value : uint) : void
		{
			_profileColor = value;
		}

		public function get profileColor () : uint
		{
			return _profileColor;
		} 
		
		/* private var _profileColor : String;
		public function set profileColor (value : String) : void
		{
			_profileColor = value;
		}

		public function get profileColor () : String
		{
			return _profileColor;
		} */
		
		
		
		private var _profileCode : String;
		public function set profileCode (value : String) : void
		{
			_profileCode = value;
			/* switch(value){
				case 'ADM':  
							profileColor = 0x000000
							break;
				case 'CLT':  
							profileColor = 0x405418
							break;
				case 'FAB':  
							profileColor = 0x2c1854
							break;
				case 'TRA':  
							profileColor = 0x185452
							break;
				case 'OPE':  
							profileColor = 0x185435
							break;
				case 'EPR':  
							profileColor = 0x541854
							break;
				case 'AGN':  
							profileColor = 0x543818
							break;
				case 'COM':  
							profileColor = 0x544818
							break;
				case 'CHP':  
							profileColor = 0x183054
							break;
				case 'CPP':  
							profileColor = 0x54181a
							break;																											
							
			} 	 */		
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
		
		public function Profiles()
		{
		}
	}
}
