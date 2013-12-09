package business
{
	import data.Interface.IModel;
	
	public class XmlParser
	{
		private var _xmlData:XML;
		private var dataObj:IModel;
		public function XmlParser(_xml:XML,obj:IModel)
		{	
			_xmlData = _xml;
			dataObj = obj;
			parseXml();
		}
		private function parseXml():void{
			var tableData:XMLList = _xmlData.children();
			var noOfNodes:Number = tableData.length()
			for(var i:int = 0;i<noOfNodes;i++){
				var objVariable:String = unescape(String(XML(tableData[i]).localName()));
				if(dataObj[objVariable]!=null)dataObj[objVariable] = tableData[i];
			}
		}
		
	}
}