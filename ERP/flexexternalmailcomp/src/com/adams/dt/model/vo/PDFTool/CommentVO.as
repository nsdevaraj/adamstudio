package com.adams.dt.model.vo.PDFTool
{
	
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.vo.ValueObject;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	[RemoteClass(alias="com.adams.dt.pojo.Notes")]	
	public class CommentVO implements ValueObject
	{
			
	
		private var _commentTitle:String;
		public function set commentTitle (value:String):void
		{
			_commentTitle = value;
		}

		public function get commentTitle ():String
		{
			return _commentTitle;
		}

		private var _commentID:int;
		public function set commentID (value:int):void
		{
			_commentID = value;
		}

		public function get commentID ():int
		{
			return _commentID;
		}

		private var _commentX:int;
		public function set commentX (value:int):void
		{
			_commentX = value;
		}

		public function get commentX ():int
		{
			return _commentX;
		}

		private var _commentY:int;
		public function set commentY (value:int):void
		{
			_commentY = value;
		}

		public function get commentY ():int
		{
			return _commentY;
		}

		private var _commentWidth:int;
		public function set commentWidth (value:int):void
		{
			_commentWidth = value;
		}

		public function get commentWidth ():int
		{
			return _commentWidth;
		}

		private var _commentHeight:int;
		public function set commentHeight (value:int):void
		{
			_commentHeight = value;
		}

		public function get commentHeight ():int
		{
			return _commentHeight;
		}

		private var _commentColor:int;
		public function set commentColor (value:int):void
		{
			_commentColor = value;
		}

		public function get commentColor ():int
		{
			return _commentColor;
		}

		private var _commentDescription:String;
		public function set commentDescription (value:String):void
		{
			_commentDescription = value;
		}

		public function get commentDescription ():String
		{
			return _commentDescription;
		}

		private var _creationDate:Date;
		public function set creationDate (value:Date):void
		{
			_creationDate = value;
		}

		public function get creationDate ():Date
		{
			return _creationDate;
		}

		private var _createdby:Persons;
		public function set createdby (value:Persons):void
		{
			_createdby = value;
			
			if(ModelLocator.getInstance().person.personId == value.personId ){
				_editable = true;			
			}
		}

		public function get createdby ():Persons
		{
			return _createdby;
		}

		private var _taskfk:Tasks;
		
		public function set taskfk (value:Tasks):void
		{
			_taskfk = value;
			
			
		}

		public function get taskfk ():Tasks
		{
			return _taskfk;
		}

		private var _task:int;
		public function set task (value:int):void
		{
			
			_task = value;
		}

		public function get task ():int
		{
			return _task;
		}

		private var _taskSet:ArrayCollection;
		public function set taskSet (value:ArrayCollection):void
		{
			_taskSet = value;
		}

		public function get taskSet ():ArrayCollection
		{
			return _taskSet;
		}

		private var _commentType:int;
		public function set commentType (value:int):void
		{
			_commentType = value;
		}

		public function get commentType ():int
		{
			return _commentType;
		}


		private var _editable:Boolean;
		public function set editable (value:Boolean):void
		{
			_editable = value;
		}

		public function get editable ():Boolean
		{
			return _editable;
		}
		
		
		private var _commentPDFfile:String;
		public function set commentPDFfile (value:String):void
		{
			_commentPDFfile = value;
		}

		public function get commentPDFfile ():String
		{
			return _commentPDFfile;
		}
		
		public static const LINE_COMMENT:Number = 0;
		public static const RECTANGLE_COMMENT:Number = 1;
		public function CommentVO()
		{
		
		}
		
		public function update(commentID : int , commentType:int, commentX : int, commentY : int, commentWidth : int, commentHeight : int, commentTitle : String, commentDescription : String, commentColor : uint, commentPDFfile : String, editable:Boolean, tasks:Tasks):void
		{
			
			
			this.commentID = commentID;
			
			this.commentType = commentType;
			
			this.commentX = commentX;
			this.commentY = commentY;
						
			this.commentWidth = commentWidth;
			this.commentHeight = commentHeight;
			
			this.commentTitle = commentTitle;
			this.commentDescription = commentDescription;
			
			this.commentColor = commentColor; 
			this.commentPDFfile = commentPDFfile;
			this.creationDate = new Date();
			this.taskfk = tasks;
			this.createdby = ModelLocator.getInstance().person; 
			//this.editable = editable;
			
		}
	}
}