
package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.TeamlineTemplatesEvent;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.TeamTemplates;
	import com.adams.dt.model.vo.Teamlines;
	import com.adams.dt.model.vo.Teamlinestemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public final class TeamlineTemplatesCommand extends AbstractCommand 
	{ 
		private var teamlineTemplatesEvent:TeamlineTemplatesEvent;
		private var teamLineTemplate:Teamlinestemplates;
		
		override public function execute( event : CairngormEvent ) : void {	 
			
			super.execute(event);
			
			teamlineTemplatesEvent = TeamlineTemplatesEvent( event );
			this.delegate = DelegateLocator.getInstance().teamlinetemplateDelegate;
			this.delegate.responder = new Callbacks( result, fault );
			
		    switch(event.type){    
	            case TeamlineTemplatesEvent.EVENT_GET_ALL_TEAMLINETEMPLATES:
	            break; 
	            case TeamlineTemplatesEvent.EVENT_GET_TEAMLINETEMPLATES:
	            	delegate.responder = new Callbacks( findByIdResult, fault );
	             	delegate.findById( TeamTemplates( model.teamTemplatesCollection.getItemAt( 0 ) ).teamTemplateId );
	            break; 
	            case TeamlineTemplatesEvent.EVENT_GETWF_TEAMLINETEMPLATES:
	            	delegate.responder = new Callbacks( findByTempIdResult, fault );
	             	delegate.findById( teamlineTemplatesEvent.teamtemplates.teamTemplateId );
	            break;
	            case TeamlineTemplatesEvent.EVENT_CREATE_TEAMLINETEMPLATES:
	            	delegate.create( teamlineTemplatesEvent.teamlinetemplates );
	            break; 
	            case TeamlineTemplatesEvent.EVENT_BULK_UPDATE_TEAMLINETEMPLATES:
	            	delegate.responder = new Callbacks( bulkUpdateResult, fault );
	             	delegate.bulkUpdate( model.selecteTeamlineTemplateArr );
	            break; 
	            case TeamlineTemplatesEvent.EVENT_UPDATE_TEAMLINETEMPLATES:
	            break; 
	            case TeamlineTemplatesEvent.EVENT_DELETE_TEAMLINETEMPLATES:
	            	delegate.deleteVO( teamlineTemplatesEvent.teamlinetemplates );
	            break;
	            case TeamlineTemplatesEvent.EVENT_DELETE_ALL_TEAMLINETEMPLATES:
	            	if( model.teamLinetemplatesCollection.length > 0 ) {
	        			teamLineTemplate = Teamlinestemplates( model.teamLinetemplatesCollection.getItemAt( 0 ) ); 
	        			deleteSeletedteamLineTemplates( teamLineTemplate );
	        		}
	            break;
	            case TeamlineTemplatesEvent.EVENT_SELECT_TEAMLINETEMPLATES:
	            break;  
	            default:
	            break; 
		    } 
		}
		
		private function deleteSeletedteamLineTemplates( teamentry:Teamlinestemplates ):void {
    		delegate = DelegateLocator.getInstance().teamlinetemplateDelegate;
    		delegate.responder = new Callbacks( deleteSeletedteamLineTempResult, fault );
    		delegate.deleteVO( teamentry ); 
    	}
    	
    	private function deleteSeletedteamLineTempResult( rpcEvent:Object ):void { 
			super.result( rpcEvent );
			model.teamLinetemplatesCollection.removeItemAt( 0 );
    		model.teamLinetemplatesCollection.refresh();
    		if( model.teamLinetemplatesCollection.length > 0 ) {
    			var teamentry:Teamlinestemplates = Teamlinestemplates( model.teamLinetemplatesCollection.getItemAt( 0 ) ); 
    			deleteSeletedteamLineTemplates( teamentry );
    		}
		}
		
		private function bulkUpdateResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
		}
		
		private function findByTempIdResult( rpcEvent:Object ):void { 
			super.result( rpcEvent );
			[ArrayElementType("com.adams.dt.model.vo.Teamlinestemplates")]
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			var tmlineTempBulk:TeamlineTemplatesEvent = new TeamlineTemplatesEvent(TeamlineTemplatesEvent.EVENT_BULK_UPDATE_TEAMLINETEMPLATES);
			model.selecteTeamlineTemplateArr = new ArrayCollection();
			for each(var tmTemp:Teamlinestemplates in arrc){
				var newTmTemp:Teamlinestemplates = new Teamlinestemplates();
				newTmTemp = tmTemp; 
				newTmTemp.teamTemplateFk = model.createdTeamTemplate.teamTemplateId;
				newTmTemp.teamlineTemplateId = 0;
				model.selecteTeamlineTemplateArr.addItem(newTmTemp);
			}
			tmlineTempBulk.dispatch();
		}
		
		private function getProfileId( str:String ):int {
			for each( var pro:Profiles in model.teamProfileCollection ) {
				if( pro.profileCode == str ) {
					return pro.profileId;
				}
			}
			return 0;
		}
		
		private function findByIdResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.teamLinetemplatesCollection = arrc;
			var teamLineArrayCollection:ArrayCollection = new ArrayCollection();
			if( model.referenceProject ) {
				for each( var team:Teamlines in model.referenceTeamline ) {
					var referTeamLines:Teamlines = new Teamlines();
					referTeamLines.profileID = team.profileID;
					referTeamLines.projectID = model.project.projectId; 
					referTeamLines.personID = team.personID; 
					teamLineArrayCollection.addItem( referTeamLines );
				}
			}
			else {
				for each( var item:Teamlinestemplates in model.teamLinetemplatesCollection ) {
					var teamLines:Teamlines = new Teamlines();
					teamLines.profileID = item.profileFk;
					teamLines.projectID = model.project.projectId; 
					teamLines.personID = item.personFk; 
					teamLineArrayCollection.addItem( teamLines );
				} 
			}
			if( model.clientTeamlineId != 0 ) {
				var clientTeamline:Teamlines = new Teamlines();
				clientTeamline.projectID = model.project.projectId;
				clientTeamline.profileID = getProfileId( 'CLT' );
				clientTeamline.personID = model.clientTeamlineId;
				oldItemRemove( clientTeamline, teamLineArrayCollection );
				teamLineArrayCollection.addItem( clientTeamline );
			}
			if( model.currentImpremiuerID != 0 ) {
				var teamLineSep:Teamlines = new Teamlines();
				teamLineSep.projectID = model.project.projectId;
				teamLineSep.profileID = getProfileId( 'EPR' );
				teamLineSep.personID = model.currentImpremiuerID;
				oldItemRemove( teamLineSep, teamLineArrayCollection );
				teamLineArrayCollection.addItem( teamLineSep );
			}
			if( model.currentUserProfileCode != 'TRA' ) {
				var cpp_Person:Teamlines = new Teamlines();
				cpp_Person.projectID = model.project.projectId;
				cpp_Person.profileID = getProfileId( 'CPP' );
				cpp_Person.personID = model.person.personId;
				oldItemRemove( cpp_Person, teamLineArrayCollection );
				teamLineArrayCollection.addItem( cpp_Person );
			}	
			model.teamLineArrayCollection = teamLineArrayCollection;
			super.result( rpcEvent );
		}
		
		private function oldItemRemove( item:Object, dp:ArrayCollection ):void {
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( 'profileID' ) ];
            dp.sort = sort;
	        dp.refresh();  
	        var cursor:IViewCursor =  dp.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				dp.removeItemAt( dp.getItemIndex( cursor.current ) );
			}
		}
	}
}
