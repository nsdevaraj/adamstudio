package com.adams.dt.model.vo
{ 	
	import com.adams.dt.utils.GetVOUtil;

	[RemoteClass(alias = "com.adams.dt.pojo.Phases")]	
	[Bindable]
	public final class Phases implements IValueObject
	{
		private var _phaseId : int;
		public function set phaseId (value : int) : void
		{
			_phaseId = value;
		}

		public function get phaseId () : int
		{
			return _phaseId;
		}

		private var _phaseCode : String;
		public function set phaseCode (value : String) : void
		{
			_phaseCode = value;
		}

		public function get phaseCode () : String
		{
			return _phaseCode;
		}

		private var _phaseName : String;
		public function set phaseName (value : String) : void
		{
			_phaseName = value;
		}

		public function get phaseName () : String
		{
			return _phaseName;
		}

		private var _phaseStatus : int;
		public function set phaseStatus (value : int) : void
		{
			_phaseStatus = value;
		}

		public function get phaseStatus () : int
		{
			return _phaseStatus;
		}
			
		private var _phaseStart : Date = new Date();
		public function set phaseStart (value : Date) : void
		{
			_phaseStart = value;
		}

		public function get phaseStart () : Date
		{
			return _phaseStart;
		}

		private var _phaseEndPlanified : Date;
		public function set phaseEndPlanified (value : Date) : void
		{
			_phaseEndPlanified = value;
		}

		public function get phaseEndPlanified () : Date
		{
			return _phaseEndPlanified;
		}

		private var _phaseEnd : Date;
		public function set phaseEnd (value : Date) : void
		{
			_phaseEnd = value;
		}

		public function get phaseEnd () : Date
		{
			return _phaseEnd;
		}

		private var _phaseDuration : int;
		public function set phaseDuration (value : int) : void
		{
			_phaseDuration = value;
		}

		public function get phaseDuration () : int
		{
			return _phaseDuration;
		}

		private var _phaseDelay : int;
		public function set phaseDelay (value : int) : void
		{
			_phaseDelay = value;
		}

		public function get phaseDelay () : int
		{
			return _phaseDelay;
		}
 
		private var _projectFk : int;
		public function set projectFk (value : int) : void
		{
			_projectFk = value;
			projectObject =  GetVOUtil.getVOObject(value,GetVOUtil.projectList,'projectId',Projects) as Projects;
		}

		public function get projectFk () : int
		{
			return _projectFk;
		}
		
		private var _projectObject:Projects;
		public function set projectObject(value : Projects) : void
		{
			_projectObject = value;
			_projectFk = value.projectId;
		}
		
		public function get projectObject() : Projects
		{
			if(_projectObject ==null)
			_projectObject =  GetVOUtil.getVOObject(_projectFk,GetVOUtil.projectList,'projectId',Projects) as Projects;
			return _projectObject;
		}
		private var _phaseTemplateFK : int;
		public function set phaseTemplateFK (value : int) : void
		{
			_phaseTemplateFK = value;
			phaseTemplateObject =  GetVOUtil.getVOObject(value,GetVOUtil.phaseTemplateList,'phaseTemplateId',Phasestemplates) as Phasestemplates;
		}

		public function get phaseTemplateFK () : int
		{
			return _phaseTemplateFK;
		}
		private var _phaseTemplateObject:Phasestemplates
		public function get phaseTemplateObject():Phasestemplates
		{
			if(_phaseTemplateObject ==null)
			_phaseTemplateObject =  GetVOUtil.getVOObject(_phaseTemplateFK,GetVOUtil.phaseTemplateList,'phaseTemplateId',Phasestemplates) as Phasestemplates;
			return _phaseTemplateObject;
		}
		
		public function set phaseTemplateObject(value:Phasestemplates):void
		{
			_phaseTemplateObject = value;
			_phaseTemplateFK = value.phaseTemplateId;
			phaseName = value.phaseName;
			phaseStatus = PhaseStatus.WAITING;
			phaseTemplateFK = value.phaseTemplateId;
			var phsstr:String;
			value.phaseTemplateId>9 ? phsstr ="P0" :phsstr="P00"
			value.phaseTemplateId>99 ? phsstr ="P":null; 
			phaseCode = phsstr + value.phaseTemplateId;
			phaseDuration = value.phaseDurationDays;
			phaseDelay = 0;
			
		}
		public function Phases()
		{
		}
	}
}
