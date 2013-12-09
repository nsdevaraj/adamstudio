package com.adams.dt.model.vo 
{
	import com.adams.dt.utils.GetVOUtil;

	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.DefaultTemplate')]
	public class DefaultTemplate implements IValueObject
	{ 
		private var _defaultTemplateId:int;
		public function set defaultTemplateId ( value : int ) : void
		{
			_defaultTemplateId = value;
		}

		public function get defaultTemplateId () : int
		{
			return _defaultTemplateId;
		}
		
		private var _defaultTemplateLabel:String;
		public function set defaultTemplateLabel ( value : String ) : void
		{
			_defaultTemplateLabel = value;
		}

		public function get defaultTemplateLabel () : String
		{
			return _defaultTemplateLabel;
		}
		private var _companyObject:Companies;
		public function get companyObject():Companies
		{
			if(_companyObject == null)
			_companyObject =  GetVOUtil.getVOObject(_companyFK,GetVOUtil.companyList,'companyid',Companies) as Companies;
			return _companyObject;
		}
		
		public function set companyObject(value:Companies):void
		{
			_companyObject = value;
			_companyFK = value.companyid;
		}
		private var _companyFK:int;
		public function set companyFK ( value : int ) : void
		{
			_companyFK = value;
			companyObject =  GetVOUtil.getVOObject(value,GetVOUtil.companyList,'companyid',Companies) as Companies;
		}

		public function get companyFK () : int
		{
			return _companyFK;
		}
		
		public function DefaultTemplate()
		{
			super()
		}
	}
}