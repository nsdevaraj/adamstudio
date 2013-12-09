package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.utils.GetVOUtil;

	public class VersionProcessor extends AbstractProcessor
	{
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		public function VersionProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var version:Versions = vo as Versions;
				version.statusObject = GetVOUtil.getVOObject(version.versionStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
				super.processVO(vo);
			}
		}
	}
}