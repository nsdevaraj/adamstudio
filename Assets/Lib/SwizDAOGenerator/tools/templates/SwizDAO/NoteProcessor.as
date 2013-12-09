/*

Copyright (c) @year@ @company.name@, All Rights Reserved 

@author   @author.name@
@contact  @author.email@
@project  @project.name@

@internal 

*/
package @namespace@.model.processor
{
	import @namespace@.model.AbstractDAO;
	import @namespace@.model.vo.@gesture@;
	
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.model.processor.AbstractProcessor;

	public class @gesture@Processor extends AbstractProcessor
	{   
		public function @gesture@Processor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var @lowerCaseGesture@vo:@gesture@ = vo as @gesture@;
				super.processVO(vo);
			}
		}
	}
}