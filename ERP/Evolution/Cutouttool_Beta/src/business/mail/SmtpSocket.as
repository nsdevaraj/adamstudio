package business.mail
{
	import flash.utils.ByteArray;
	import flash.net.Socket;
	import mx.controls.Alert;	
	import mx.managers.CursorManager;
	import flash.events.ProgressEvent; 
	public class SmtpSocket extends Socket{
		public var Host:String;
		public var Port:int;
		public var Username:String;
		public var Password:String;
		public var QuickSubject:String;
		public var recepient:String;
		public var msgBody:String;
		public var frmLbl:String;
		private static var Bit64:Array = new Array(
			'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
			'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
			'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
			'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'
		);
		public function Base64Enc(s:String):String{
			var buf:Array = new Array(3);
			var rtn:String = "";
			var x:int = 0;
			var y:int = s.length;
			var z:int;
			
			while(x < y){
				for(z=0; z < 3; z++){
					buf[z] = (x < y)? s.charCodeAt(x) : -1;
					x++
				}
				
				rtn += Bit64[ buf[0] >> 2];
				if(buf[1] != -1){
					rtn += ( Bit64[ ((buf[0] << 4) & 0x30) | (buf[1] >> 4) ]);
					if(buf[2] != -1){
						rtn += ( Bit64[ ((buf[ 1 ] << 2) & 0x3c) | (buf[ 2 ] >> 6) ]);
						rtn += Bit64[buf[ 2 ] & 0x3F];
					}else{
						rtn += Bit64[((buf[ 1 ] << 2) & 0x3c )];
						rtn += "=";
					}
				}else{
					rtn += Bit64[((buf[ 0 ] << 4 ) & 0x30 )];
					rtn += "=";
					rtn += "=";
				}
			}

			return rtn;
		}

		public function SmtpSocket(){
			addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		public function SendCommand(str:String):void{
			this.writeUTFBytes(str + "\n");
			this.flush();
		}
		private function onSocketData ( pEvt:ProgressEvent ):void{
			var response:String = pEvt.target.readUTFBytes ( pEvt.target.bytesAvailable );
			var reg:RegExp = /^(\d{3})\s([^\r\n]+)/img;
			var result:Object = reg.exec(response);
			
			var code:String = "";
			var msg:String = "";
			
			if(result != null){
				code = result[1];
				msg = result[2];
			}
			//Alert.show("SocketDataCode : " + code);
			//trace("SocketData : " + response + "+.+");
			//Alert.show("SocketMsg: " + msg + "+.+");

			if (code == "220") { //Service Ready,Connected
				CursorManager.setBusyCursor();
				SendCommand("HELO me"); //Send HandShake 
			}else if (code == "250") { 
				SendCommand("AUTH LOGIN");
				//if(msg.indexOf("Hello") > 0){ //HandShake (hello)
				//	SendCommand("AUTH LOGIN");
				//}
			}else if (code == "334") {
				if(msg == "VXNlcm5hbWU6"){ //Username:
					//Y3VzdG9tZXJzZXJ2aWNlQGVtYW50cmFzLmNvbQ== 
					//Alert.show(Base64Enc(Username)+ 'user')
					SendCommand(Base64Enc(Username));
				}else if(msg == "UGFzc3dvcmQ6"){ //Password: 
					//ZW1hbnRyYXM=  
					//Alert.show(Base64Enc(Password))
				    SendCommand(Base64Enc(Password));
				}  
			}else if(code == "535"){
				//Alert.show("Authentication unsuccessful");  
			}else if(code == "502"){ 
				// not implemented 
			}else if (code == "235") { //Authentication successful  
				this.writeUTFBytes ("MAIL FROM: <devaraj@wp.pl>\r\n");
				this.writeUTFBytes ("RCPT TO: <"+recepient+">\r\n");		
				this.writeUTFBytes ("DATA\r\n"); 
				this.writeUTFBytes ("MIME-Version: 1.0\r\n");		 
				this.writeUTFBytes ("From:"+frmLbl+"\r\n");
				this.writeUTFBytes ("To:"+recepient+"\r\n"); 
				this.writeUTFBytes ("Subject: " + QuickSubject + "\r\n");	
				this.writeUTFBytes ("Content-Type: text/plain; charset=ISO-8859-1; format=flowed\r\n");	
				this.writeUTFBytes ("Content-Transfer-Encoding: 7bit\r\n");	
				this.writeUTFBytes ("\r\n");		
				this.writeUTFBytes (msgBody+"\r\n\r\n");	 	
				this.writeUTFBytes (".\r\n");	
				this.flush(); 				
				CursorManager.removeBusyCursor();  
				Alert.show('After purchase, check your mail for product ID ', 'Message');   
			}
			if (msg.indexOf("ok")!=-1) {				 
				//Alert.show('Mail Sent');   
			}
		}
	}
}