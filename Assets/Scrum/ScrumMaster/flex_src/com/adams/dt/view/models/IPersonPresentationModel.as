package com.adams.dt.view.models
{
	import com.adams.dt.model.vo.CurrentInstanceVO;
	import com.adams.dt.model.vo.Projects;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public interface IPersonPresentationModel
	{
		function get persons():ArrayCollection;
		function set persons(v:ArrayCollection):void
		function clickHandler(event:MouseEvent):void
		function get currentInstance():CurrentInstanceVO
		function set currentInstance(value:CurrentInstanceVO):void	
		function get projectName():String
		function set projectName(v:String):void
		function projectUpdate(prj:Projects):void
	}
}