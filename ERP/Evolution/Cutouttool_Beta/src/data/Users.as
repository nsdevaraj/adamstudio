/**
 * @author K.Sathish Balaji
 * 24-10-2008
 * */
package data
{
	import data.Interface.IModel;
	/**
	 * use to store the User table data
	 * */
	[Bindable]
	public class Users implements IModel
	{
		private var _pk_user:String='';
		private var _firstname:String='';
		private var _lastname:String='';
		private var _userpswd:String='';
		private var _email:String='';
		private var _group_id:String='';
		private var _registration_date:String='';
		private var _company:String='';
		private var _type:String='';
		private var _activated:String='';		
		private var _sessionid:String='';
		private var _activetime:String='';
		private var _logintime:String='';  	 
		public function Users()
		{
		}
		/**
		 * get the pk_user
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get pk_user():String{
			return _pk_user;
		}
		/**
		 * set the pk_user
		 */
		public function set pk_user(str:String):void{
			_pk_user = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the firstname
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get firstname():String{
			return _firstname;
		}
		/**
		 * set the firstname
		 */
		public function set firstname(str:String):void{
			_firstname = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the lastname
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get lastname():String{
			return _lastname;
		}
		/**
		 * set the firstname
		 */
		public function set lastname(str:String):void{
			_lastname = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the userpswd
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get userpswd():String{
			return _userpswd;
		}
		/**
		 * set the userpswd
		 */
		public function set userpswd(str:String):void{
			_userpswd = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the email
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get email():String{
			return _email;
		}
		/**
		 * set the email
		 */
		public function set email(str:String):void{
			_email = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the group_id
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get group_id():String{
			return _group_id;
		}
		/**
		 * set the group_id
		 */
		public function set group_id(str:String):void{
			_group_id = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the registration_date
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get registration_date():String{
			return _registration_date;
		}
		/**
		 * set the registration_date
		 */
		public function set registration_date(str:String):void{
			_registration_date = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the company
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get company():String{
			return _company;
		}
		/**
		 * set the company
		 */
		public function set company(str:String):void{
			_company = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the type
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get type():String{
			return _type;
		}
		/**
		 * set the type
		 */
		public function set type(str:String):void{
			_type = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		
		/**
		 * get the activated
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get activated():String{
			return _activated;
		}
		/**
		 * set the activated
		 */
		public function set activated(str:String):void{
			_activated = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		/**
		 * get the activated
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get sessionid():String{
			return _sessionid;
		}
		/**
		 * set the activated
		 */
		public function set sessionid(str:String):void{
			_sessionid = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		/**
		 * get the activated
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get activetime():String{
			return _activetime;
		}
		/**
		 * set the activated
		 */
		public function set activetime(str:String):void{
			_activetime  = str;
			dispatchEvent(new Event("userDataChanged"));
		}
		/**
		 * get the activated
		 */
		[Bindable(event="userDataChanged",  type="flash.events.Event")] 
		public function get logintime():String{
			return _logintime;
		}
		/**
		 * set the activated
		 */
		public function set logintime(str:String):void{
			_logintime  = str;
			dispatchEvent(new Event("userDataChanged"));
		}

	}
}