package com.adams.dt.business.chat
{
	import com.adams.dt.business.AbstractDelegate;
	import com.adams.dt.business.IDAODelegate;
	import com.adams.dt.business.Services;
	import com.adams.dt.model.vo.Chat;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class ChatDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function ChatDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.CHAT_SERVICE );
		}
		override public function findByChatListDelegate(chatvo : IValueObject) : void
		{
			var chat:Chat = Chat(chatvo);
			invoke("findChatUserList",chat.senderId , chat.senderId , chat.receiverId , chat.receiverId , chat.projectFk);
		}
		override public function findProjectId(projectId : int) : void
		{
			invoke("findProjectId",projectId);
		}
	}
}
