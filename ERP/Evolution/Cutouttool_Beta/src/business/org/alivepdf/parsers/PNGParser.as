package business.org.alivepdf.parsers 

{
	
	import flash.utils.ByteArray;
	
	public final class PNGParser 
	
	{
		
		private var stream:ByteArray;
		public var width:Number;
		public var height:Number;
		public var bpc:Number;
		public var ct:Number;
		public var colspace:String;
		public var parms:String;
		public var type:String;
		public var n:Number;
		public var pal:String;
		public var data:ByteArray;
		
		public function PNGParser ( pStream:ByteArray )
		
		{
			
			data = new ByteArray;
			stream = pStream;
			stream.position = 0;
			
			// read header chunk and PNG signature
			stream.readUnsignedInt();
			stream.readUnsignedInt();
			
			// reand length and type
			stream.readUnsignedInt();
			stream.readUnsignedInt();
			
			// width and height
			width = stream.readInt();
			height = stream.readInt();
			
			// bits per component
			bpc = stream.readByte();
			
			ct = stream.readByte();
			
			if(ct==0) colspace =' DeviceGray';
			else if(ct==2) colspace = 'DeviceRGB';
			else if(ct==3) colspace = 'Indexed';
			//else throw new Error ('Alpha channel not supported');
			else colspace = 'DeviceRGB';
			
			// leap bytes
			stream.readByte();
			stream.readByte();
			stream.readByte();
			
			stream.readUnsignedInt();
			
			parms = '/DecodeParms <</Predictor 15 /Colors '+(ct == 2 ? 3 : 1)+' /BitsPerComponent '+bpc+' /Columns '+width+'>>';
			
			//Scan chunks looking for palette, transparency and image data
			pal='';
			var trns:String ='';
			
			n = stream.readInt();
			type = stream.readUTFBytes(4);
			
			if ( type == 'IDAT' )
			
			{
				
				stream.readBytes ( data, 0, n );
				
				stream.readUnsignedInt();
				
			}
			
		}
		
	}
	
}