package com.adams.dam.business.delegates
{
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.UserSQLStatements;
	import com.adams.dam.model.vo.FileDetails;
	import com.localSQL.dao.AbstractSynchronizedSQLDAO;
	import com.localSQL.utils.SQLConnectionHelper;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;
	
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;


	/*
	 *	UserSQLDAO handles all database requests
	 *
	 *
	*/
	public class LocalFileDetailsDAODelegate extends AbstractSynchronizedSQLDAO
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		protected var statements:UserSQLStatements;
		
		public function LocalFileDetailsDAODelegate()
		{
			var databaseFile:File = model.localDB;
			var connection:SQLConnection = SQLConnectionHelper.getConnection( model.localDB.nativePath );
			
			super( connection, databaseFile );
			
			statements = new UserSQLStatements( connection );
          	var res:SQLResult = executeStatement( statements.createUserTable );
		}

		public function getAllFileDetails():SQLResult {
			return executeStatement( statements.getAllUsers );		
		}
		
		public function getFileDetails( fileVO:FileDetails ):SQLResult {
		   var result:SQLResult;
		   if( fileVO ) {
			 	result = executeStatement( statements.getUser, fileVO.fileId, fileVO.storedFileName );
		   } 	
           return result;			
		}	
		
		public function getSwfFileDetails( fileVO:FileDetails ): SQLResult {
			var result: SQLResult = executeStatement( statements.getSwfFile, fileVO.miscelleneous, 	fileVO.fileId );
            return result;			
		}	 
		
		public function getIndFileDetails( fileVO:FileDetails ):SQLResult {
			var result: SQLResult = executeStatement( statements.getIndFile, fileVO.miscelleneous, fileVO.fileId );
            return result;			
		}	 
		
		public function addFileDetails( fileVO:FileDetails ):SQLResult {
			var result: SQLResult = executeStatement( statements.addUser, 
            											fileVO.fileName, 
            											fileVO.storedFileName,
            											fileVO.filePath,
            											fileVO.taskId,
            											fileVO.categoryFK,
            											fileVO.projectFK,
            											fileVO.remoteFileFk,
            											fileVO.miscelleneous,
            											fileVO.page );
            
            return result;			
		}		

		public function updateFileDetails( fileVO:FileDetails ):SQLResult {
            var result: SQLResult = executeStatement( statements.updateUser, 
            											fileVO.fileName, 
            											fileVO.storedFileName,
            											fileVO.filePath,
            											fileVO.taskId,
            											fileVO.categoryFK,
            											fileVO.projectFK,
            											fileVO.remoteFileFk,
            											fileVO.miscelleneous,
            											fileVO.page,
            											fileVO.fileId );
            
            return result;			
		}		

		public function deleteFileDetails( fileVO:FileDetails ):SQLResult {
            var result: SQLResult = executeStatement( statements.deleteUser, fileVO.fileId );            
            return result;			
		}		
	}
}