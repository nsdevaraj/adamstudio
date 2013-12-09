package com.adams.dam.model
{
	import com.adams.dam.model.vo.Persons;
	import com.adams.dam.model.vo.Projects;
	import com.adobe.cairngorm.model.ModelLocator;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.ChannelSet;
	
	[Bindable]
	public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator
	{
		private static var modelLocator:com.adams.dam.model.ModelLocator;
		
		public static function getInstance():com.adams.dam.model.ModelLocator {
			if ( !modelLocator ) {
				modelLocator = new com.adams.dam.model.ModelLocator();
			}	
			return modelLocator;
		}
		
		public function ModelLocator() 
		{
			if ( com.adams.dam.model.ModelLocator.modelLocator ) {
				throw new Error( "Only one ModelLocator instance should be instantiated" );
			}	
		}
		
		public var mainClass:Object;
		public var parentFolderName:String;
		public var channelSet:ChannelSet;
		public var serverLocation:String;
		public var encryptor:EncryptUtil = new EncryptUtil();
		public var encryptorUserName:String;
		public var encryptorPassword:String;
		public var pdfServerDir:String; 
		public var pdfConversion:Boolean;
		
		
		public var loginIndex:int;
		public var successfulLogin:Boolean;
		public var userName:String;
		public var time:Date = new Date();
		public var persons:Persons;
		public var project:Projects;
		public var preloaderVisibility:Boolean;
		
		public var totalFileDetailsCollection:ArrayCollection;
		public var totalPersonsCollection:ArrayCollection; 
		public var totalProjectsCollection:ArrayCollection; 
		public var totalCategoriesCollection:ArrayCollection; 
		
		public var domainCollection:ArrayCollection;
		public var categoryOneCollection:ArrayCollection;
		public var categoryTwoCollection:ArrayCollection;
		public var categoryFilterList:ArrayCollection;
		
		public var filesToDownload:ArrayCollection = new ArrayCollection();
		public var filesToUpload:ArrayCollection = new ArrayCollection();
		public var fileDetailsToUpload:ArrayCollection = new ArrayCollection();
		public var swfFileDetailsToUpload:ArrayCollection = new ArrayCollection();
		
		public var localDB:File = File.userDirectory.resolvePath( "DTFlexV1.db" );
		public var FileServer:String;
		public var bgUploadFile:BackGroundUpload = new BackGroundUpload();
		public var bgDownloadFile:BackGroundDownload = new BackGroundDownload();
		
		public var uploadCompleted:Boolean;
	}    
}