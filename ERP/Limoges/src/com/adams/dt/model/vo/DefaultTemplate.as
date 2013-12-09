package com.adams.dt.model.vo 
{
	import com.adams.swizdao.model.vo.AbstractVO;

	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.DefaultTemplate')]
	public class DefaultTemplate extends AbstractVO
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
		
		private var _companyFK:int;
		public function set companyFK ( value : int ) : void
		{
			_companyFK = value;
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