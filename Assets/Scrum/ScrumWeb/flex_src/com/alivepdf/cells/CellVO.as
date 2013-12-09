package com.alivepdf.cells
{
	import com.alivepdf.colors.IColor;
	import com.alivepdf.fonts.IFont;
	import com.alivepdf.links.ILink;

	/**
	 * the Cell VO is a description of a Text Cell to be rendered to PDF
	 * 
	 */
	public class CellVO
	{
		public var x:Number;
		public var y:Number;
		public var color:IColor;
		public var width:Number;
		public var height:Number;
		public var font:IFont;
		public var fontSizePt:Number;
		public var underlined:Boolean;
		public var text:String;
		public var border:Boolean = false;
		public var fill:Number = 0;
		public var link:ILink;
	}
}