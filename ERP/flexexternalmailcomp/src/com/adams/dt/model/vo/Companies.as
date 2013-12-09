package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Companies")]	
	[Bindable]
	public final class Companies implements IValueObject
	{
		private var _personsSet : ArrayCollection;
		private var _companyid : int;
		private var _companyname : String;
		private var _companycode : String;
		private var _companylogo : ByteArray;
		private var _companyCategory :String;
		private var _companyAddress :String;
	    private var _companyPostalCode :String;
	    private var _companyCity :String;
	    private var _companyCountry :String;
		public function Companies()
		{
		}

		public function get personsSet() : ArrayCollection
		{
			return _personsSet;
		}

		public function set personsSet(pData : ArrayCollection) : void
		{
			_personsSet = pData;
		}

		public function get companyid() : int
		{
			return _companyid;
		}

		public function set companyid(pData : int) : void
		{
			_companyid = pData;
		}

		public function get companyname() : String
		{
			return _companyname;
		}

		public function set companyname(pData : String) : void
		{
			_companyname = pData;
		}
		public function get companyCategory() : String
		{
			return _companyCategory;
		}


		public function get companycode() : String
		{
			return _companycode;
		}

		public function set companycode(pData : String) : void
		{
			_companycode = pData;
		}

		public function get companylogo() : ByteArray
		{
			return _companylogo;
		}
		public function set companyCategory(pData : String) : void
		{
			_companyCategory = pData;
		}
 
		public function set companylogo(pData : ByteArray) : void
		{
			_companylogo = pData;
		}
		
		public function get companyAddress() : String
		{
			return _companyAddress;
		}

		public function set companyAddress(pData : String) : void
		{
			_companyAddress = pData;
		}

		public function get companyPostalCode() : String
		{
			return _companyPostalCode;
		}

		public function set companyPostalCode(pData : String) : void
		{
			_companyPostalCode = pData;
		}
			
		public function get companyCity() : String
		{
			return _companyCity;
		}

		public function set companyCity(pData : String) : void
		{
			_companyCity = pData;
		}

		public function get companyCountry() : String
		{
			return _companyCountry;
		}

		public function set companyCountry(pData : String) : void
		{
			_companyCountry = pData;
		}

	}
}
