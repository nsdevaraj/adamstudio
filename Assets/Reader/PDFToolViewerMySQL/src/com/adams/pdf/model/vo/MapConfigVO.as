/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.model.vo
{ 
	import mx.collections.ArrayCollection;

	[Bindable]
	public class MapConfigVO 
	{
		public var currentPerson:Persons;
		public var serverOSWindows:Boolean;
		public var autoTimerInterval:int;
		public var timeServer:Number;
		public var encryptorUserName:String;
		public var encryptorPassword:String;
		public var fileUploadCollection:ArrayCollection  = new ArrayCollection();
		public var secondUploadCollection:ArrayCollection  = new ArrayCollection();

		public var firstFileID:int = -1;
		public var secondFileID:int = -1;
		public var firstCollection:ArrayCollection  = new ArrayCollection();
		public var secondCollection:ArrayCollection  = new ArrayCollection();
		
		public var isFileIdAvalable:Boolean = false;
	}
}