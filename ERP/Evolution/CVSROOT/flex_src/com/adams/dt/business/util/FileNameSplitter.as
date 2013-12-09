package com.adams.dt.business.util
{
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Projects;
	
	public class FileNameSplitter
	{
		public function FileNameSplitter()
		{
		} 
			
		public static function splitFileName(str:String):Object{
			var obj:Object = new Object();
			var strlength:int = str.length;
			var splitter:int=0;
			for (var i:int=strlength;i>=0;i--){			
				if(str.charAt(i)=="."){
					splitter = i;
					break;
				}
			}
			
			var filename:String = str.substr(0,splitter);
			var extension:String = str.substr(splitter+1,str.length-1);
			obj.filename = filename;
			obj.extension = extension;
			return obj;
		}
		
		public static function getUId():String{
			var date:Date = ModelLocator.getInstance().currentTime;
			return date.getTime().toString();
		}
		
		public static function getDestinationPath( prj:Projects, folderName:String ):String {
			var destinationpath:String;
			
			var domain:Categories = Utils.getDomains( prj.categories );
			var cat1:Categories = prj.categories.categoryFK;
			var cat2:Categories = prj.categories;
			var project:Projects = prj;
			
			//destinationpath = folderName + domain.categoryName + "/" + cat1.categoryName + "/" + cat2.categoryName + "/" + StringUtils.compatibleTrim( project.projectName );
			destinationpath = folderName + domain.categoryName + "/" + cat1.categoryName + "/" + cat1.categoryFK.categoryName + "/" + StringUtils.compatibleTrim( project.projectName );
			return destinationpath;
		}
		
	}
}