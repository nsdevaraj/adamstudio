/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.util.GetVOUtil;

	public class WorkflowstemplatesProcessor extends AbstractProcessor
	{   
		
		[Inject("profilesDAO")]
		public var profileDAO:AbstractDAO;
		
		public function WorkflowstemplatesProcessor()
		{
			super();
		}
		
		//@TODO
		override public function processVO( vo:IValueObject ):void {
			if( !vo.processed ) {
				var workflowstemplatesvo:Workflowstemplates = vo as Workflowstemplates;
				workflowstemplatesvo.profileObject = GetVOUtil.getVOObject( workflowstemplatesvo.profileFK, profileDAO.collection.items, profileDAO.destination, Profiles ) as Profiles;
				super.processVO( vo );
			}
		}
	}
}