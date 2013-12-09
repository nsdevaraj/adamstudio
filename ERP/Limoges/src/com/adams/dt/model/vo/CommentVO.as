package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	[RemoteClass(alias = "com.adams.dt.pojo.Notes")]	
	[Bindable]
	public final class CommentVO extends AbstractVO
	{
		private var _commentDescriptionBlob:Object;
		
		public function get commentDescriptionBlob():Object
		{
			return _commentDescriptionBlob;
		}

		public function set commentDescriptionBlob(value:Object):void
		{
			_commentDescriptionBlob = value;
		}

		public var commentReplies:ArrayList = new ArrayList();
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
		
		private var _createdby:int;
		public function get createdby():int {
			return _createdby;
		}
		public function set createdby( value:int ):void {
			_createdby = value;
			if( personDetails ) {
				personDetails = null;
			} 
		}
		
		private var _personDetails:Persons;
		public function get personDetails():Persons {
			return _personDetails;
		}
		public function set personDetails( value:Persons ):void {
			if( !_personDetails ) {
				_personDetails = value;
			}
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
		 
	}
}
