package com.adams.dt.model.vo
{
	import com.adams.dt.utils.GetVOUtil;

	[RemoteClass(alias = "com.adams.dt.pojo.Chat")]	
	[Bindable]
	public final class Chat implements IValueObject
	{
		private var _chatId : int;
		public function set chatId (value : int) : void
		{
			_chatId = value;
		}

		public function get chatId () : int
		{
			return _chatId;
		}
		
		
		private var _projectObject:Projects;
		public function set projectObject(value : Projects) : void
		{
			_projectObject = value;
			_projectFk = value.projectId;	
		}
		
		public function get projectObject() : Projects
		{
			if(_projectObject==null)
			_projectObject =  GetVOUtil.getVOObject(_projectFk,GetVOUtil.projectList,'projectId',Projects) as Projects;
			return _projectObject;
		}
		private var _senderId : int;
		public function set senderId (value : int) : void
		{
			_senderId = value;
		}

		public function get senderId () : int
		{
			return _senderId;
		}

		private var _senderName : String;
		public function set senderName (value : String) : void
		{
			_senderName = value;
		}

		public function get senderName () : String
		{
			return _senderName;
		}

		private var _description : String;
		public function set description (value : String) : void
		{
			_description = value;
		}

		public function get description () : String
		{
			return _description;
		}

		private var _receiverId : int;
		public function set receiverId (value : int) : void
		{
			_receiverId = value;
		}

		public function get receiverId () : int
		{
			return _receiverId;
		}

		private var _receiverName : String;
		public function set receiverName (value : String) : void
		{
			_receiverName = value;
		}

		public function get receiverName () : String
		{
			return _receiverName;
		}

		private var _chatDateentry : Date;
		public function set chatDateentry (value : Date) : void
		{
			_chatDateentry = value;
		}

		public function get chatDateentry () : Date
		{
			return _chatDateentry;
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
 
		public function Chat()
		{
		}
	}
}
