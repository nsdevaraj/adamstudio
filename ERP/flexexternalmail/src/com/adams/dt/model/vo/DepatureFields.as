package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;	
	[Bindable]
	public final class DepatureFields implements IValueObject
	{
		public var artpro:String='';
		public var artpro_version:String;
		public var illustrator:String;
		public var illustrator_version:String;
		public var pdf_hd:String=''
		public var gmg:String=''
		public var approval:String=''
		public var approval_colors:String=''
		public var approval_support:String=''
		
		

		public function DepatureFields():void
		{
		}
	}
}
