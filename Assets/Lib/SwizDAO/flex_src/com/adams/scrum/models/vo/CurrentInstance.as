/*
 * Copyright 2010 @nsdevaraj
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.adams.scrum.models.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class CurrentInstance extends AbstractVO
	{
		/**
		 * Constructor, to store the values to be shared across views.
		 * 
		 */ 
		public function CurrentInstance()
		{ 
		}  
		
		public function get serverLastAccessedAt():Date
		{
			return _serverLastAccessedAt;
		}

		public function set serverLastAccessedAt(value:Date):void
		{
			_serverLastAccessedAt = value;
		}

		public function get idle():Boolean
		{
			var timeStamp:Date = new Date();
			var diffmillisecs:int =  -(serverLastAccessedAt.time - timeStamp.time);
			var diffmins:int = diffmillisecs/60000;
			(diffmins>1)? _idle=true: _idle=false;  
			return _idle;
		}

		public function get historyOpenState():String
		{
			return _historyOpenState;
		}
		
		public function set historyOpenState(value:String):void
		{
			_historyOpenState = value;
		}

		public function get sprintOpenState():String
		{
			return _sprintOpenState;
		}

        private var _teamViewState:String
		public function get teamViewState():String
		{
			return _teamViewState;
		}

		public function set teamViewState(value:String):void
		{
			_teamViewState = value;
		}

		public function set sprintOpenState(value:String):void
		{
			_sprintOpenState = value;
		}

		public function get currentTicket():Tickets
		{
			return _currentTicket;
		}

		public function set currentTicket(value:Tickets):void
		{
			_currentTicket = value;
		}

		public function get productOpenState():String
		{
			return _productOpenState;
		}

		public function set productOpenState(value:String):void
		{
			_productOpenState = value;
		}

		public function get currentTeam():Teams
		{
			return _currentTeam;
		}

		public function set currentTeam(value:Teams):void
		{
			_currentTeam = value;
		}

		public function get currentStory():Stories
		{
			return _currentStory;
		}

		public function set currentStory(value:Stories):void
		{
			_currentStory = value;
		}

		public function get currentTheme():Themes
		{
			return _currentTheme;
		}

		public function set currentTheme(value:Themes):void
		{
			_currentTheme = value;
		}

		public function get currentSprint():Sprints
		{
			return _currentSprint;
		}

		public function set currentSprint(value:Sprints):void
		{
			_currentSprint = value;
		}

		public function get currentProfile():Profiles
		{
			return _currentProfile;
		}

		public function set currentProfile(value:Profiles):void
		{
			_currentProfile = value;
		}

		public function get currentPerson():Persons
		{
			return _currentPerson;
		}

		public function set currentPerson(value:Persons):void
		{
			_currentPerson = value;
		}

		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}

		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
		}
		
		public function get currentDomain():Domains
		{
			return _currentDomain;
		}
		
		public function set currentDomain(value:Domains):void
		{
			_currentDomain = value;
		}
		
		public function get currentProducts():Products
		{
			return _currentProducts;
		}
		
		public function set currentProducts(value:Products):void
		{
			_currentProducts = value;
		}
		public function get currentVersion():Versions
		{
			return _currentVersion;
		}
		
		public function set currentVersion(value:Versions):void
		{
			_currentVersion = value;
		}
 
		private var _config:ConfigVO = new ConfigVO();
		public function set config (value:ConfigVO):void
		{
			_config = value;
		}
		
		public function get config ():ConfigVO
		{
			return _config;
		} 
		private var _productState:String = new String();
		public function get productState():String
		{
			return _productState;
		}
		
		public function set productState(value:String):void
		{
			_productState = value;
		}
		private var _scrumState:String = new String();
		public function get scrumState():String
		{
			return _scrumState;
		}
		
		public function set scrumState(value:String):void
		{
			_scrumState = value;
		}
		private var _sprintState:String = new String();
		public function get sprintState():String
		{
			return _sprintState;
		}
		
		public function set sprintState(value:String):void
		{
			_sprintState = value;
		}
		
		public function get currentProfileAccess():ProfileAccessVO
		{
			return _currentProfileAccess;
		}
		
		public function set currentProfileAccess(value:ProfileAccessVO):void
		{
			_currentProfileAccess = value;
		}
		
		public function get currentTicketsCollection():ArrayCollection
		{
			return _currentTicketsCollection;
		}
		
		public function set currentTicketsCollection(value:ArrayCollection):void
		{
			_currentTicketsCollection = value;
		}
		
		private var _historyOpenState:String;
		private var _sprintOpenState:String;
		private var _productOpenState:String;
		private var _mainViewStackIndex:int;
		private var _currentPerson:Persons = new Persons();
		private var _currentProfile:Profiles = new Profiles();
		private var _currentDomain:Domains = new Domains();		
		private var _currentProducts:Products = new Products();
		private var _currentVersion:Versions = new Versions();
		private var _currentTheme:Themes = new Themes();
		private var _currentSprint:Sprints = new Sprints();
		private var _currentStory:Stories = new Stories();
		private var _currentTeam:Teams = new Teams();
		private var _currentTicket:Tickets = new Tickets();
		
		private var _serverLastAccessedAt:Date = new Date();
		private var _idle:Boolean;
		private var _currentProfileAccess:ProfileAccessVO = new ProfileAccessVO();
		
		private var _currentTicketsCollection:ArrayCollection = new ArrayCollection();
	}
}