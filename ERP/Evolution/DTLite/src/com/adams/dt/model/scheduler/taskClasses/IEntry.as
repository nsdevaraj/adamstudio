package com.adams.dt.model.scheduler.taskClasses
{
	import com.adams.dt.model.tracability.TaskBusinessCard;
	
	import flash.utils.ByteArray;
	public interface IEntry
	{
		function get startDate() : Date;
		function set startDate( value : Date ) : void;
		function get endDate() : Date;
		function set endDate ( value : Date ) : void;
		function get finalTask() : Boolean;
		function set finalTask( value : Boolean ) : void;
		function get phaseBelonging() : int;
		function set phaseBelonging( value : int ) : void;
		function get projectName() : String;
		function set projectName( value : String ) : void;
		function get taskComment() : String;
		function set taskComment( value : String ) : void;
		function get taskFilePath() : String;
		function set taskFilePath( value : String ) : void;
		function get taskLabel() : String;
		function set taskLabel( value : String ) : void;
		function get taskBusinessCard() : TaskBusinessCard;
		function set taskBusinessCard( value : TaskBusinessCard ) : void;
		function get perPicture() : ByteArray;
		function set perPicture( value : ByteArray ) : void;
		function get profileTask() : String;
		function set profileTask( value : String ) : void;
		function get selectionId() : int;
		function set selectionId( value : int ) : void; 
		function get isCurrentTask() : Boolean;
		function set isCurrentTask( value : Boolean ) : void; 
		function get backgroundColor():uint;
		function set backgroundColor( value : uint ) : void; 
	}
}
