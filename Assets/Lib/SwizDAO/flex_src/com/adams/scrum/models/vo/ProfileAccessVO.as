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

	[Bindable]
	public class ProfileAccessVO extends AbstractVO
	{	
		private var _isADM:Boolean;
		private var _isSPO:Boolean;
		private var _isSSM:Boolean;
		private var _isSTM:Boolean;
		private var _isOPE:Boolean;
		
		public static const CREATE:String = 'Create';
		public static const READ:String = 'Read';
		public static const EDIT:String = 'Edit';
		public static const DELETE:String = 'Delete';
		public static const ADMIN:String = 'Admin';

		private var _domainAccessArr:Array = [];
		private var _productAccessArr:Array = [];
		private var _sprintAccessArr:Array = []; 
		private var _eventAccessArr:Array = [];  
		private var _reportAccessArr:Array = [];
		
		private var _storyAccessArr:Array = [];

		public function ProfileAccessVO()
		{
			_domainAccessArr[CREATE] = _domainAccessArr[READ] = _domainAccessArr[EDIT]= _domainAccessArr[DELETE]=_domainAccessArr[ADMIN]=false;
			_productAccessArr[CREATE] = _productAccessArr[READ] = _productAccessArr[EDIT]= _productAccessArr[DELETE]=_productAccessArr[ADMIN]=false;
			_sprintAccessArr[CREATE] = _sprintAccessArr[READ] = _sprintAccessArr[EDIT]= _sprintAccessArr[DELETE]=_sprintAccessArr[ADMIN]=false;
			_eventAccessArr[CREATE] = _eventAccessArr[READ] = _eventAccessArr[EDIT]= _eventAccessArr[DELETE]=_eventAccessArr[ADMIN]=false;
			_reportAccessArr[CREATE] = _reportAccessArr[READ] = _reportAccessArr[EDIT]= _reportAccessArr[DELETE]=_reportAccessArr[ADMIN]=false;
			
			_storyAccessArr[CREATE] = _storyAccessArr[READ] = _storyAccessArr[EDIT]= _storyAccessArr[DELETE]=_storyAccessArr[ADMIN]=false;
		}
		public function get isADM():Boolean
		{
			return _isADM;
		}

		public function set isADM(value:Boolean):void
		{
			_isADM = value;
		}
		
		public function get isOPE():Boolean
		{
			return _isOPE;
		}

		public function set isOPE(value:Boolean):void
		{
			_isOPE = value;
		}

		public function get isSTM():Boolean
		{
			return _isSTM;
		}

		public function set isSTM(value:Boolean):void
		{
			_isSTM = value;
		}

		public function get isSSM():Boolean
		{
			return _isSSM;
		}

		public function set isSSM(value:Boolean):void
		{
			_isSSM = value;
		}
  
		public function get isSPO():Boolean
		{
			return _isSPO;
		}
		
		public function set isSPO(value:Boolean):void
		{
			_isSPO = value;
		} 

		public function get domainAccessArr():Array
		{
			return _domainAccessArr;
		}

		public function set domainAccessArr(value:Array):void
		{
			_domainAccessArr = value;
		}

		public function get productAccessArr():Array
		{
			return _productAccessArr;
		}

		public function set productAccessArr(value:Array):void
		{
			_productAccessArr = value;
		}

		public function get sprintAccessArr():Array
		{
			return _sprintAccessArr;
		}

		public function set sprintAccessArr(value:Array):void
		{
			_sprintAccessArr = value;
		}

		public function get eventAccessArr():Array
		{
			return _eventAccessArr;
		}

		public function set eventAccessArr(value:Array):void
		{
			_eventAccessArr = value;
		}

		public function get reportAccessArr():Array
		{
			return _reportAccessArr;
		}

		public function set reportAccessArr(value:Array):void
		{
			_reportAccessArr = value;
		}
		
		public function get storyAccessArr():Array
		{
			return _storyAccessArr;
		}
		
		public function set storyAccessArr(value:Array):void
		{
			_storyAccessArr = value;
		}


	}
}