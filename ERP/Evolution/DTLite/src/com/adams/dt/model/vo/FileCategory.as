package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	public class FileCategory implements IValueObject
	{
		public function FileCategory()
		{
		}
		public static const CUTOUT:String = "cutout";
		public static const CREATION:String = "creation";
		public static const AGENCE:String = "agence";
		public static const TEXT:String = "text";
		public static const OLDEXE:String = "oldexe";
		public static const LOGOS:String = "logos";
		public static const REFERENCE:String = "reference";

	}
}