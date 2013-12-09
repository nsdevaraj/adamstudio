package model
{
	import mx.collections.XMLListCollection;

	[Bindable]
	public class StaticModel
	{
		public static var pagesList:XML = new XML();
		public static var currentPage:Object = new Object();
		public static var mobileWidth:Number = 0;
		public static var mobileHeight:Number = 0;
		public static var firstTime:Boolean = true;
		public static var isPortraitWide:Boolean = false;
	}
}