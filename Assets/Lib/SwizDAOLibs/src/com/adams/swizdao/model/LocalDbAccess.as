package com.adams.swizdao.model {
	import com.adams.swizdao.dao.IAbstractDAO;
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.model.vo.LocalSQLStatements;
	import com.adams.swizdao.model.vo.SignalVO;

	import org.osflash.signals.Signal;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import flash.data.SQLColumnSchema;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	public class LocalDbAccess 
	{
		protected var databaseFile:File;
		protected var connection:SQLConnection; 
		protected var statement:LocalSQLStatements;
		protected var dbSchema:SQLSchemaResult;
		protected var addStatement:SQLStatement
		protected var _listUpdate:Boolean;
		private var _listCollection:ArrayCollection;
		
		public static const FROM_LOCAL:String = "fromLocal";
		
		private var _resultSignal:Signal;
		public function get resultSignal():Signal {
			return _resultSignal;
		}
		
		public function LocalDbAccess()
		{
			_resultSignal = new Signal();
			statement = new LocalSQLStatements();
			openSQLConnection();
		}
		
		protected function openSQLConnection():void {
			if( !connection ) {
				connection = new SQLConnection();
				connection.addEventListener( SQLEvent.OPEN, connectionOpenHandler );
				connection.addEventListener( SQLErrorEvent.ERROR, connectionOpenErrorHandler );
			}
			connection.open( databaseFile );
		}
		
		protected function connectionOpenHandler( event:SQLEvent=null ):void {
			try{
				connection.loadSchema();
				dbSchema = connection.getSchemaResult();
			}catch(er:Error){
				createSchema();
			}
		}
		
		protected function createSchema():void {
			
		}
		
		protected function connectionOpenErrorHandler( event:SQLErrorEvent ):void {
			
		}
		
		public function createTable( tableName:String , args:String ):void {
			var readStatement:SQLStatement;
			readStatement = statement.createTable( tableName, args );
			readStatement.sqlConnection = connection;
			readStatement.execute();
		}
		
		public function readList( tableName:String, dao:IAbstractDAO, clz:Class, signal:SignalVO, property:String = null, value:Object = null ):void {
			var readStatement:SQLStatement;
			if( !property ) {
				readStatement = statement.getList( tableName );
			}
			else {
				readStatement = statement.getItem( tableName, property, value );
			}
			readStatement.sqlConnection = connection;
			readStatement.execute();
			var readAllResult:SQLResult = readStatement.getResult();
			var resultObj:Object;
			if( readAllResult ) {
				updateDAO( readAllResult.data, dao, clz );
				resultObj = makingResultHandlerObject( readAllResult.data, clz );
			}
			signal.processor.processCollection( dao.collection.items );
			signal.description = LocalDbAccess.FROM_LOCAL;
			_resultSignal.dispatch( resultObj, signal );
		}
		
		public function readItem( tableName:String, item:Object, dao:IAbstractDAO, clz:Class, signal:SignalVO ):void {
			var readStatement:SQLStatement = statement.getItem( tableName, dao.destination, item[ dao.destination ] );
			readStatement.sqlConnection = connection;
			readStatement.execute();
			var readResult:SQLResult = readStatement.getResult();
			var resultObj:Object;
			if( readResult ) {
				updateDAO( readResult.data, dao, clz );
				resultObj = makingResultHandlerObject( readResult.data, clz );
				if( resultObj.length > 0 ) {
					resultObj = resultObj.getItemAt( 0 );
				}
				else {
					resultObj = null;
				}
			}
			signal.processor.processCollection( dao.collection.items );
			signal.description = LocalDbAccess.FROM_LOCAL;
			_resultSignal.dispatch( resultObj, signal );
		}
		
		public function updateItem():void {
			
		}
		
		public function addList( tableName:String, collection:IList, dao:IAbstractDAO, clz:Class, signal:SignalVO ):void {
			_listCollection = new ArrayCollection();
			_listUpdate = true;
			for each( var item:Object in collection ) {
				addItem( tableName, item, dao, clz, signal );
			}
			_listUpdate = false;
			readList( tableName, dao, clz, signal );
		}
		
		public function addItem( tableName:String, item:Object, dao:IAbstractDAO, clz:Class, signal:SignalVO ):void {
			var tableSchema:SQLTableSchema = getTableSchema( tableName );
			var property:Array = [];
			var colon:Array = [];
			var values:Array = [];
			for each( var column:SQLColumnSchema in tableSchema.columns ) {
				if( !column.primaryKey ) {
					property.push( column.name );
					colon.push( ":" + column.name );
					values.push( item[ column.name ] );
				}
			}
			addStatement = statement.insertItem( tableName, property, colon, values );
			addStatement.sqlConnection = connection;
			addStatement.execute(); 
		}
		
		public function deleteItem( tableName:String, item:Object, dao:IAbstractDAO, clz:Class, signal:SignalVO ):void {
			var deleteStatement:SQLStatement = statement.deleteItem( tableName, dao.destination, item[ dao.destination ] );
			deleteStatement.sqlConnection = connection;
			deleteStatement.execute();
			dao.collection.removeItem( item );
			signal.processor.processCollection( dao.collection.items );
			signal.description = LocalDbAccess.FROM_LOCAL;
			_resultSignal.dispatch( null, signal );
		}
		
		public function deleteList( tableName:String, dao:IAbstractDAO, clz:Class, signal:SignalVO ):void {
			var deleteAllStatement:SQLStatement = statement.deleteList( tableName );
			deleteAllStatement.sqlConnection = connection;
			deleteAllStatement.execute();
			dao.collection.removeAll();
			signal.processor.processCollection( dao.collection.items );
			signal.description = LocalDbAccess.FROM_LOCAL;
			_resultSignal.dispatch( null, signal );
		}
		
		public function removeAllLocalValues( tableName:String, signal:SignalVO ):void {
			var deleteAllStatement:SQLStatement = statement.deleteList( tableName );
			deleteAllStatement.sqlConnection = connection;
			deleteAllStatement.execute();
			signal.description = LocalDbAccess.FROM_LOCAL;
			_resultSignal.dispatch( null, signal );
		}
		
		protected function updateDAO( result:Array, dao:IAbstractDAO, clz:Class ):void {
			for each( var item:Object in result ) {
				var vo:IValueObject = new clz();
				for( var property:String in item ) {
					if( item[ property ] == '' ) {
						vo[ property ] = null;
					}
					else {
						vo[ property ] = item[ property ];
					}
				}
				dao.collection.addItem( vo );
			}
		}
		
		protected function makingResultHandlerObject( result:Array, clz:Class ):Object {
			var resultCollection:ArrayCollection = new ArrayCollection();
			for each( var item:Object in result ) {
				var vo:IValueObject = new clz();
				for( var property:String in item ) {
					if( item[ property ] == '' ) {
						vo[ property ] = null;
					}
					else {
						vo[ property ] = item[ property ];
					}
				}
				resultCollection.addItem( vo );
			}	
			return resultCollection;
		}
		
		protected function getTableSchema( tableName:String ):SQLTableSchema {
			for each( var item:SQLTableSchema in dbSchema.tables ) {
				if( item.name == tableName ) {
					return item;
				}
			}
			return null;
		}
	}
}