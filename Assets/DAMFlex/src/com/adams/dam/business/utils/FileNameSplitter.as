package com.adams.dam.business.utils
{
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.Categories;
	import com.adams.dam.model.vo.Projects;
	
	public class FileNameSplitter
	{
		public static function splitFileName( str:String ):Object {
			var obj:Object = {};
			var strlength:int = str.length;
			var splitter:int = 0;
			
			for( var i:int = strlength; i >= 0; i-- ) {			
				if( str.charAt( i ) == "." ) {
					splitter = i;
					break;
				}
			}
			
			var filename:String = str.substr( 0, splitter );
			var extension:String = str.substr( ( splitter + 1 ), ( str.length - 1 ) );
			obj.filename = filename;
			obj.extension = extension;
			return obj;
		}
		
		public static function getFileIdGenerator():String {
			var now:Date = new Date();
			var date:String = String( now.date );
			var month:String = String( now.getMonth() );
			var year:String = String( now.fullYear );
			var hours:String = String( now.getHours() );
			var min:String = String( now.getMinutes() );
			var sec:String = String( now.getSeconds() );
			var milliSec:String = String( now.getUTCMilliseconds() );
			return ( date + month + year + hours + min + sec + milliSec );
		}
		
		public static function getDestinationPath( prj:Projects, folderName:String ):String {
			var destinationpath:String;
			
			var domain:Categories = prj.categories.categoryFK.categoryFK;
			var cat1:Categories = prj.categories.categoryFK;
			var cat2:Categories = prj.categories;
			var project:Projects = prj;
			
			destinationpath = folderName + domain.categoryName + "/" + cat1.categoryName + "/" + cat2.categoryName + "/" + StringUtils.compatibleTrim( project.projectName );
			return destinationpath;
		}
	}
}