package com.adams.dt.business
{
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.UserSQLStatements;
	import com.ericfeminella.sql.dao.AbstractSynchronizedSQLDAO;
	import com.ericfeminella.sql.utils.SQLConnectionHelper;
	
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

		protected var statements:UserSQLStatements;
		private var model:ModelLocator = ModelLocator.getInstance();
		public function LocalFileDetailsDAODelegate()
		{
			var databaseFile:File = model.localeDb;
			var connection:SQLConnection = SQLConnectionHelper.getConnection( model.localeDb.nativePath );
			
			super( connection, databaseFile );
			
			this.statements = new UserSQLStatements( connection );
          	var res: SQLResult = this.executeStatement( statements.createUserTable );
		}

		public function getAllFileDetails(): SQLResult
		{
			return executeStatement( statements.getAllUsers );		
		}
		public function getFileDetails( fileVO:FileDetails ): SQLResult{
		   var result:SQLResult;
		   if( fileVO ) {
			 	result = executeStatement(statements.getUser, fileVO.fileId, fileVO.storedFileName);
		   } 	
           return result;			
		}	
		
		public function getSwfFileDetails( fileVO:FileDetails ): SQLResult{
			
		
            var result: SQLResult = executeStatement( 	statements.getSwfFile, 
            											fileVO.miscelleneous,
            											fileVO.fileId);
            return result;			
		}	 
		
		
		public function getIndFileDetails( fileVO:FileDetails ): SQLResult{
			
		
            var result: SQLResult = executeStatement( 	statements.getIndFile, 
            											fileVO.miscelleneous,
            											fileVO.fileId);
            return result;			
		}	 
		

		public function addFileDetails( fileVO:FileDetails ): SQLResult{
		
           var result: SQLResult = executeStatement( 	statements.addUser, 
            											fileVO.fileName, 
            											fileVO.storedFileName,
            											fileVO.filePath,
            											fileVO.taskId,
            											fileVO.categoryFK,
            											fileVO.projectFK,
            											fileVO.remoteFileFk,
            											fileVO.miscelleneous,
            											fileVO.page);
            
            return result;			
		}		

		public function updateFileDetails( fileVO:FileDetails ): SQLResult
		{
            var result: SQLResult = executeStatement( 	statements.updateUser, 
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

		public function deleteFileDetails( fileVO:FileDetails ): SQLResult
		{
            var result: SQLResult = executeStatement( statements.deleteUser, fileVO.fileId );            
            return result;			
		}		
		
	}
}