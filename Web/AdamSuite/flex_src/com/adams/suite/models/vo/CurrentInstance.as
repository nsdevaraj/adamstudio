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
package com.adams.suite.models.vo
{
	import mx.collections.XMLListCollection;

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
		private var _xml:XML
		
		// Collection used for navigation		
		private var _myXMLC:XMLListCollection;	
		// Sum of all chapters questions
		private var _questions:XMLList;
		private var _isFinishMode:Boolean = false;

		public function get isFinishMode():Boolean
		{
			return _isFinishMode;
		}

		public function set isFinishMode(value:Boolean):void
		{
			_isFinishMode = value;
		}

		
		private var _isResultReviewMode:Boolean = true;

		public function get isResultReviewMode():Boolean
		{
			return _isResultReviewMode;
		}

		public function set isResultReviewMode(value:Boolean):void
		{
			_isResultReviewMode = value;
		}

		private var _isLearnMode:Boolean = true;

		public function get isLearnMode():Boolean
		{
			return _isLearnMode;
		}

		public function set isLearnMode(value:Boolean):void
		{
			_isLearnMode = value;
		}


		public function get notAttList():XMLList
		{
			return _notAttList;
		}

		public function set notAttList(value:XMLList):void
		{
			_notAttList = value;
		}

		public function get myXMLC():XMLListCollection
		{
			return _myXMLC;
		}

		public function set myXMLC(value:XMLListCollection):void
		{
			_myXMLC = value;
		}

		public function get questions():XMLList
		{
			return _questions;
		}

		public function set questions(value:XMLList):void
		{
			_questions = value;
		}

		public function get xml():XML
		{
			return _xml;
		}

		public function set xml(value:XML):void
		{
			_xml = value;
		}

		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}

		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
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
		private var _mainViewStackIndex:int;
		
		
		// Seperate Chapter XML List of Questions 
		public var _chapter1:XMLList;
		public var _chapter2:XMLList;
		public var _chapter3:XMLList;
		public var _chapter4:XMLList;
		public var _chapter5:XMLList; 
		// not attempted questions
		private var _notAttList:XMLList; 
		
		// Chapter arrays to store the status of every question
		public var _chapter1Arr:Array;
		public var _chapter2Arr:Array;
		public var _chapter3Arr:Array;
		public var _chapter4Arr:Array;
		public var _chapter5Arr:Array;
	}
}