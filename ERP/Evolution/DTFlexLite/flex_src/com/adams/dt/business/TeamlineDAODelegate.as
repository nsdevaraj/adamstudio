package com.adams.dt.business
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.adams.dt.model.vo.Teamlines;
	import mx.rpc.IResponder;
	public final class TeamlineDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function TeamlineDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.TEAMLINE_SERVICE);	
		}
		
		override public function findByTeamLinesId(profileid:int,projectid:int) : void
		{
			invoke("findByTeamLinesId",profileid , projectid);
		}
		override public function getByProjectId(projectId : int) : void
		{
			invoke("findById",projectId );
		} 
		
		override public function deleteVO(teamline : IValueObject) : void
		{
			invoke("deleteById",teamline );
		}
 
	}
}
