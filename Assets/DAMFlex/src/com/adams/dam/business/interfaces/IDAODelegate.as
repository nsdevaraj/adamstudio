package com.adams.dam.business.interfaces
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	public interface IDAODelegate extends IResponderAware
	{			
		function login( username:String, password:String ):void;	
		function findAll():void;	
		function create( vo:IValueObject ):void;
		function update( vo:IValueObject ):void;
		function bulkUpdate( collection:ArrayCollection ):void;
		function findByMailFileId( id:int ):void;
		function findPersonsList( project:IValueObject ):void;
		function doUpload( bytes:ByteArray, fileName:String, filePath:String ):void;
		function doDownload( fileName:String ):void;
		function doConvert( filePath:String, exe:String ):void;
		function copyDirectory( frompath:String, topath:String ):void;
	}
}
