/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.Persons;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.util.GetVOUtil;

	public class EventsProcessor extends AbstractProcessor
	{   
		
		[Inject("personsDAO")]
		public var personsDAO:AbstractDAO;
		
		public function EventsProcessor()
		{
			super();
		}
		
		//@TODO
		override public function processVO( vo:IValueObject ):void {
			if( !vo.processed ) {
				var eventsvo:Events = vo as Events;
				eventsvo.personDetails = GetVOUtil.getVOObject( eventsvo.personFk, personsDAO.collection.items, personsDAO.destination, Persons ) as Persons;
				super.processVO( vo );
			}
		}
	}
}