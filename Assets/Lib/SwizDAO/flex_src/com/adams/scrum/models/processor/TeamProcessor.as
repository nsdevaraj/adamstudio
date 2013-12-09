package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Profiles;
	import com.adams.scrum.models.vo.Teammembers;
	import com.adams.scrum.models.vo.Teams;
	import com.adams.scrum.utils.GetVOUtil;
	
	import mx.collections.ArrayCollection;

	public class TeamProcessor extends AbstractProcessor
	{
		
		[Inject("profileDAO")]
		public var profileDAO:AbstractDAO;
		
		[Inject("teammemberDAO")]
		public var teammemberDAO:AbstractDAO;
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		public function TeamProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var team:Teams = vo as Teams;
				
				var teamMembers:ArrayCollection = new ArrayCollection();
				for each(var teamMember:Teammembers in team.teamMemberSet){
					var profile:Profiles = GetVOUtil.getVOObject(teamMember.profileFk,profileDAO.collection.items,profileDAO.destination,Profiles) as Profiles;
					var person:Persons = GetVOUtil.getVOObject(teamMember.personFk,personDAO.collection.items,personDAO.destination,Persons) as Persons;  
					team.profileList.addItem( profile );
					team.personList.addItem( person );
					teamMember.personObject = person;
					teamMember.profileObject = profile;
					teamMembers.addItem(teamMember);
				} 
				teammemberDAO.collection.modifyItems(teamMembers);
				super.processVO(vo);
			}
		}
	}
}