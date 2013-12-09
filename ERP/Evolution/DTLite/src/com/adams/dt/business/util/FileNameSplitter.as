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
			trace("\n\n getDestinationPath categoryId :"+prj.categories.categoryId+" , categoryName :"+prj.categories.categoryName);
			trace("getDestinationPath categoryFK.categoryId :"+prj.categories.categoryFK.categoryId+" , categoryFK.categoryId :"+prj.categories.categoryFK.categoryName);
			trace("getDestinationPath categoryFK.categoryFK.categoryId :"+prj.categories.categoryFK.categoryFK.categoryId+" , categoryFK.categoryFK.categoryId :"+prj.categories.categoryFK.categoryFK.categoryName);

			var domain:Categories = Utils.getDomains( prj.categories );
			trace("getDestinationPath domain categoryId :"+domain.categoryId+" , domain categoryName :"+domain.categoryName);
			var cat1:Categories = prj.categories.categoryFK;
			trace("getDestinationPath cat1 categoryId :"+cat1.categoryId+" , cat1 categoryName :"+cat1.categoryName);
			trace("getDestinationPath cat1 categoryFK categoryId:"+cat1.categoryFK.categoryId+" , cat1 categoryFK categoryName :"+cat1.categoryFK.categoryName);
			var cat2:Categories = prj.categories;
			trace("getDestinationPath cat2 categoryId :"+cat2.categoryId+" , cat2 categoryName :"+cat2.categoryName);
			var project:Projects = prj;
			trace("getDestinationPath project categoryId:"+project.categories.categoryId+" , project categoryName:"+project.categories.categoryName);
			
			//destinationpath = folderName + domain.categoryName + "/" + cat1.categoryName + "/" + cat2.categoryName + "/" + StringUtils.compatibleTrim( project.projectName );
			destinationpath = folderName + domain.categoryName + "/" + cat1.categoryName + "/" + cat1.categoryFK.categoryName + "/" + StringUtils.compatibleTrim( project.projectName );
			trace("getDestinationPath destinationpath:"+destinationpath);

			return destinationpath;
		}
		
	}
}