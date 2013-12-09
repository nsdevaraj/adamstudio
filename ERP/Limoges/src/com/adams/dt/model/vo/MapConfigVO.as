/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.vo
{ 
	import com.adams.swizdao.util.EncryptUtil;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class MapConfigVO 
	{
		public var autoTimerInterval:int;
		public var timeServer:Number;
		public var encryptorUserName:String;
		public var encryptorPassword:String;
		public var currentProfileCode:String;
		public var updatedPropPjCollection:String;
		public var serverOSWindows:Boolean;
		public var serverLastAccessedAt:Date = new Date();
		public var previousState:String;
		public var isTaskInToDo:Boolean;
		public var firstLoadShow:Boolean;
		
		public var currentPerson:Persons;
		public var currentProject:Projects;
		public var currentTasks:Tasks;
		public var taskCollectionOfCurrentPerson:ArrayCollection;
		
		public var closeTaskCollection:ArrayCollection  = new ArrayCollection();
		//workflow Templates collection based on taskcodes
		public var fileUploadCollection:ArrayCollection  = new ArrayCollection();
		public var closeProjectTemplate:ArrayCollection  = new ArrayCollection();
		public var modelAnnulationWorkflowTemplate:ArrayCollection  = new ArrayCollection();
		public var firstRelease:ArrayCollection  = new ArrayCollection();
		public var otherRelease:ArrayCollection  = new ArrayCollection();
		public var fileAccessTemplates:ArrayCollection  = new ArrayCollection();
		public var messageTemplatesCollection:ArrayCollection  = new ArrayCollection();
		public var versionLoop:ArrayCollection  = new ArrayCollection();
		public var backTask:ArrayCollection  = new ArrayCollection();
		public var standByTemplatesCollection:ArrayCollection  = new ArrayCollection();
		public var alarmTemplatesCollection:ArrayCollection  = new ArrayCollection();
		public var sendImpMailTemplatesCollection:ArrayCollection  = new ArrayCollection();
		public var indReaderMailTemplatesCollection:ArrayCollection  = new ArrayCollection(); 
		public var checkImpremiurCollection:ArrayCollection  = new ArrayCollection();
		public var impValidCollection:ArrayCollection  = new ArrayCollection();
		public var indValidCollection:ArrayCollection  = new ArrayCollection();
		public var CPValidCollection:ArrayCollection  = new ArrayCollection();
		public var CPPValidCollection:ArrayCollection  = new ArrayCollection();
		public var COMValidCollection:ArrayCollection  = new ArrayCollection();
		public var AGEValidCollection:ArrayCollection  = new ArrayCollection();
		public var currentVersionPDFFilePathID:int = 0; // Latest File (eg. Release 2 File), It is used for PDF Reader
		public var previousVersionPDFFilePathID:int = 0; // Previous File (eg. Release 1 File), It is used for PDF Compare
		
		//Pdf and Excel Export
		public var _gridHeaderText:Array = new Array();
		public var _gridDataField:Array = new Array();
	}
}