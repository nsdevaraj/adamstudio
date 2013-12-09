package com.adams.dt.model.vo.PDFTool
{
	import com.adams.dt.model.ModelLocator;
	import com.adobe.cairngorm.vo.ValueObject;
	
	import flash.utils.ByteArray;
	[RemoteClass(alias = "com.adams.dt.pojo.Notes")]	
	public final class CommentVO implements ValueObject
	{
		private var _commentDescriptionBlob:Object;
		public function set commentDescriptionBlob (value : Object) : void
		{
			_commentDescriptionBlob = value;
		}

		private var _commentTitle : String;
		public function set commentTitle (value : String) : void
		{
			_commentTitle = value;
		}

		public function get commentTitle () : String
		{
			return _commentTitle;
		}
		
		private var _commentID : int;
		public function set commentID (value : int) : void
		{
			_commentID = value;
		}

		public function get commentID () : int
		{
			return _commentID;
		}

		private var _history : int;
		public function set history (value : int) : void
		{
			_history = value;
		}

		public function get history () : int
		{
			return _history;
		}
		private var _commentX : int;
		public function set commentX (value : int) : void
		{
			_commentX = value;
		}

		public function get commentX () : int
		{
			return _commentX;
		}

		private var _commentY : int;
		public function set commentY (value : int) : void
		{
			_commentY = value;
		}
	
		public function get commentY () : int
		{
			return _commentY;
		}
		
		private var _commentBoxX : int;
		public function set commentBoxX(value : int) : void
		{
			_commentBoxX  = value;
		}

		public function get commentBoxX() : int
		{
			return _commentBoxX;
		}
		
		private var _commentBoxY : int;
		public function set commentBoxY(value : int) : void
		{
			_commentBoxY  = value;
		}

		public function get commentBoxY() : int
		{
			return _commentBoxY;
		}

		private var _commentWidth : int;
		public function set commentWidth (value : int) : void
		{
			_commentWidth = value;
		}

		public function get commentWidth () : int
		{
			return _commentWidth;
		}

		private var _commentHeight : int;
		public function set commentHeight (value : int) : void
		{
			_commentHeight = value;
		}

		public function get commentHeight () : int
		{
			return _commentHeight;
		}

		private var _commentColor : int;
		public function set commentColor (value : int) : void
		{
			_commentColor = value;
		}

		public function get commentColor () : int
		{
			return _commentColor;
		}

		private var _commentDescription :ByteArray;
		public function set commentDescription (value : ByteArray) : void
		{
			_commentDescription = value;
		}

		public function get commentDescription () : ByteArray
		{
			return _commentDescription;
		}
/* 
		private var _commentDesc :String;
		public function set commentDesc (value : String) : void
		{
			_commentDesc = value;
		}

		public function get commentDesc () : String
		{
			return _commentDesc;
		} */
		
		private var _commentStatus :String;
		public function set commentStatus (value : String) : void
		{
			_commentStatus = value;
		}

		public function get commentStatus () : String
		{
			return _commentStatus;
		}
		
		private var _misc :String;
		public function set misc (value : String) : void
		{
			_misc = value;
		}

		public function get misc () : String
		{
			return _misc;
		}
		
		private var _creationDate : Date;
		public function set creationDate (value : Date) : void
		{
			_creationDate = value;
		}

		public function get creationDate () : Date
		{
			return _creationDate;
		}

		private var _createdby : int;
		public function set createdby (value : int) : void
		{
			_createdby = value;
			if(ModelLocator.getInstance().person.personId == value )
			{
				_editable = true;
			} 
		}

		public function get createdby () : int
		{
			return _createdby;
		}
		
		
		private var _filefk:int;
		public function set filefk (value:int):void
		{
			_filefk = value;
		}

		public function get filefk ():int
		{
			return _filefk;
		}


		
		private var _commentType : int;
		public function set commentType (value : int) : void
		{
			_commentType = value;
		}

		public function get commentType () : int
		{
			return _commentType;
		}

		private var _editable : Boolean;
		public function set editable (value : Boolean) : void
		{
			_editable = value;
		}

		public function get editable () : Boolean
		{
			return _editable;
		}

		private var _commentPDFfile : String;
		public function set commentPDFfile (value : String) : void
		{ 
			_commentPDFfile = value;
		}

		public function get commentPDFfile () : String
		{
			return _commentPDFfile;
		}
		
		private var _commentMaximize : Boolean;
		public function set commentMaximize (value : Boolean) : void
		{
			_commentMaximize = value;
		}

		public function get commentMaximize () : Boolean
		{
			return _commentMaximize;
		}

		public static const LINE_COMMENT : Number = 0;
		public static const RECTANGLE_COMMENT : Number = 1;
		public function CommentVO()
		{
		}
		public function update(commentID : int , commentType : int , commentX : int , commentY : int , commentWidth : int , commentHeight : int , commentTitle : String , commentDescription : ByteArray , commentColor : uint , commentPDFfile : String , editable : Boolean , filefk:int,createdBy:int , boxX:Number, boxY:Number, commentMax:Boolean,profile:String,history:int) : void
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
			this.creationDate = ModelLocator.getInstance().currentTime;
			this.filefk = filefk;
			this.createdby = createdBy;
			this.commentBoxX=boxX;
			this.commentBoxY=boxY;
			this.commentMaximize=commentMax;
			this.misc=profile;
			this.history=history;
		}
	}
}
