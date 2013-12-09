package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;

	public final class StatusTypes extends AbstractVO
	{
		public static const TASKSTATUS : String = 'task_status';
		public static const PROJECTSTATUS : String = 'project_status';
		public static const EVENTTYPE : String = 'event_type';
		public static const WORKFLOWTEMPLATETYPE : String = 'workflowtemplate_permissionlabel';
		public static const PHASESTATUS : String = 'phase_status';
		public function StatusTypes()
		{
		}
	}
}
