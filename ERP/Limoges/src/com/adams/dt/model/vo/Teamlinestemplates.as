package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;

	[RemoteClass(alias = "com.adams.dt.pojo.Teamlinestemplates")]	
	[Bindable]
	public final class Teamlinestemplates extends AbstractVO
	{
		public function Teamlinestemplates()
		{
		}

		private var _teamlineTemplateId : int;
		public function set teamlineTemplateId (value : int) : void
		{
			_teamlineTemplateId = value;
		}

		public function get teamlineTemplateId () : int
		{
			return _teamlineTemplateId;
		}

		private var _teamTemplateFk : int;
		public function set teamTemplateFk (value : int) : void
		{
			_teamTemplateFk = value;
		}

		public function get teamTemplateFk () : int
		{
			return _teamTemplateFk;
		}

		private var _profileFk : int;
		public function set profileFk (value : int) : void
		{
			_profileFk = value;
		}

		public function get profileFk () : int
		{
			return _profileFk;
		}

		private var _personFk : int;
		public function set personFk (value : int) : void
		{
			_personFk = value;
		}

		public function get personFk () : int
		{
			return _personFk;
		}
		 
	}
}
