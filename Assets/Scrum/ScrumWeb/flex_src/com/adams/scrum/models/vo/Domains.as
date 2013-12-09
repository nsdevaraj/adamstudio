package com.adams.scrum.models.vo
{
	import com.adams.scrum.dao.AbstractDAO;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias='com.adams.scrum.pojo.Domains')]
	public class Domains extends AbstractVO
	{
		private var _domainCode:String;
		private var _domainId:int;
		private var _domainName:String;
		
		[ArrayElementType("com.adams.scrum.models.vo.Products")]
		private var _productSet:ArrayCollection = new ArrayCollection();
		public function Domains()
		{
			super();
		}
		 
		
		public function get domainCode():String
		{
			return _domainCode;
		}
		
		public function set domainCode(value:String):void
		{
			_domainCode = value;
		}
		
		public function get domainId():int
		{
			return _domainId;
		}
		
		public function set domainId(value:int):void
		{
			_domainId = value;
		}
		
		public function get domainName():String
		{
			return _domainName;
		}
		
		public function set domainName(value:String):void
		{
			_domainName = value;
		}
		
		public function get productSet():ArrayCollection
		{
			return _productSet;
		}
		
		public function set productSet(value:ArrayCollection):void
		{
			_productSet = value;
		}
	}
}