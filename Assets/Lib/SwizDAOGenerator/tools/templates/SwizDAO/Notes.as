/*

Copyright (c) @year@ @company.name@, All Rights Reserved 

@author   @author.name@
@contact  @author.email@
@project  @project.name@

@internal 

*/
package @namespace@.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	import mx.collections.ArrayCollection;
	[Bindable]
	[RemoteClass(alias='@namespace@.dao.entities.@gesture@')]
	public class @gesture@ extends AbstractVO
	{
		private var _@lowerCaseGesture@Id:int; 
		public function @gesture@()
		{
			super();
		}
		public function get @lowerCaseGesture@Id():int
		{
			return _@lowerCaseGesture@Id;
		}

		public function set @lowerCaseGesture@Id(value:int):void
		{
			_@lowerCaseGesture@Id = value;
		}
		
		override public function fill(item:Object):void{ 
			 
		}
	}
}