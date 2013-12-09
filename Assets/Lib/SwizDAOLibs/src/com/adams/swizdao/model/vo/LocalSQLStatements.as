package com.adams.swizdao.model.vo {
	import flash.data.SQLStatement;
	
	public class LocalSQLStatements
	{ 
		public function getList( tableName:String ):SQLStatement {
			var getAllStatement:SQLStatement = new SQLStatement(); 
			getAllStatement.text = "SELECT * FROM " + tableName;
			return getAllStatement;
		}
		
		public function createTable( tableName:String, args:String ):SQLStatement {
			var getAllStatement:SQLStatement = new SQLStatement(); 
			getAllStatement.text = "CREATE TABLE IF NOT EXISTS " + tableName+ " ("+ args +")";
			return getAllStatement;
		}
		
		public function getItem( tableName:String, propertyName:String, value:Object ):SQLStatement {
			var getStatement:SQLStatement = new SQLStatement();
			getStatement.text = "SELECT * FROM " + tableName + " WHERE " + propertyName +" = " + value;
			return getStatement;
		}
		
		public function insertItem( tableName:String, propertyNames:Array, colonNames:Array, values:Array ):SQLStatement {
			var insertItemStatement:SQLStatement = new SQLStatement();
			insertItemStatement.text = "INSERT INTO " + tableName + " (" + propertyNames.toString() + ")" + " VALUES" + " (" + colonNames.toString() +")";
			for( var i:int = 0; i < colonNames.length; i++ ) {
				insertItemStatement.parameters[ colonNames[ i ] ] = values[ i ];
			}
			return insertItemStatement;
		}
		
		public function deleteItem( tableName:String, propertyName:String, value:Number ):SQLStatement {
			var deleteStatement:SQLStatement = new SQLStatement();
			deleteStatement.text = "DELETE FROM " + tableName + " WHERE " + propertyName +" = " + value;
			return deleteStatement;
		}
		
		public function deleteList( tableName:String ):SQLStatement {
			var deleteAllStatement:SQLStatement = new SQLStatement();
			deleteAllStatement.text = "DELETE FROM " + tableName;
			return deleteAllStatement;
		}
	}
}
