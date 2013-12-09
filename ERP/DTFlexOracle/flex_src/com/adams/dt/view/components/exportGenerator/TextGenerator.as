package com.adams.dt.view.components.exportGenerator
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.model.ModelLocator;
	
	import flash.net.FileReference;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	public class TextGenerator
	{
		
		[Bindable]
	    public var model:ModelLocator = ModelLocator.getInstance();
		private var _textContent:String;
		private var _textBytes:ByteArray = new ByteArray();	
		public function createTextFile( textColl:ArrayCollection ,projectsComments:String):void
		{
			_textContent = '';
			_textContent+= Utils.getDomains(model.currentProjects.categories).categoryName + '\t\t\t\t Date :' +( model.currentTime ).toDateString();
			_textContent += '\r\n';
	   		_textContent += 'Project Name : '+model.currentProjects.projectName;
	   		_textContent += '\r\n';
	   		_textContent += GetVOUtil.getPhaseTemplateObject(GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).phaseTemplateFK).phaseName + ' PHASE';
	   		_textContent += '\r\n';
	   		_textContent += GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).taskLabel;
 			_textContent += '\r\n';
  			_textContent += '\r\n';
  			_textContent+= 'Notes : ' +projectsComments;
  			for each( var exportTextObj:Object in textColl)
		  	{
		  		_textContent += '\r\n';
        		_textContent += '\r\n';
        		_textContent += exportTextObj.Category + ":\t ";
        		_textContent += '\r\n';
        		getContent( exportTextObj.properties)
		  	}
		  	Capabilities.os.search("Mac") >= 0  ? _textBytes.writeMultiByte( _textContent, "macintosh" ) : _textBytes.writeMultiByte( _textContent, "utf-8" ); 
			var fileRef:FileReference = new FileReference();
			fileRef.save(_textBytes ,  model.currentProjects.projectName +"_reports.txt");
		}
		
		public function getContent( textArr:Array ):void
		{
			for( var j:int = 0; j < textArr.length; j++ ) {
				_textContent += "\t " +textArr[j].Field + " = "+textArr[j].Value;
			    _textContent += '\r\n';
			}
				
				
		}

	}
}