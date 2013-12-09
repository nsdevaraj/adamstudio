package com.adams.scrum.models.vo
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
		
	[Bindable]
	[RemoteClass(alias = "com.adams.scrum.pojo.Companies")]	
	public class Companies extends AbstractVO
	{
		private var _companyId : int;
		private var _companyname : String;
		private var _companycode : String;
		private var _companylogo : ByteArray;
		private var _companyCategory :String;
		private var _companyAddress :String;
	    private var _companyPostalCode :String;
	    private var _companyCity :String;
	    private var _companyCountry :String;
	    private var _companyPhone:String;	    
		
		public function Companies()
		{
			super();
		}

		public function get companyId() : int
		{
			return _companyId;
		}

		public function set companyId(pData : int) : void
		{
			_companyId = pData;
		}

		public function get companyname() : String
		{
			return _companyname;
		}

		public function set companyname(pData : String) : void
		{
			_companyname = pData;
		}

		public function get companycode() : String
		{
			return _companycode;
		}

		public function set companycode(pData : String) : void
		{
			_companycode = pData;
		}
		
		public function set companylogo(pData : ByteArray) : void
		{
			_companylogo = pData;
		}

		public function get companylogo() : ByteArray
		{
			return _companylogo;
		}
		
		public function set companyCategory(pData : String) : void
		{
			_companyCategory = pData;
		}
		
		public function get companyCategory() : String
		{
			return _companyCategory;
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
		
		public function get companyPhone():String
		{
			return _companyPhone;
		}

		public function set companyPhone( value:String ):void
		{
			_companyPhone = value;
		}
	}
}
