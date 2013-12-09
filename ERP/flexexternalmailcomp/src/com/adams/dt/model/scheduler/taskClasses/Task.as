package com.adams.dt.model.scheduler.taskClasses
{
	import com.adams.dt.event.scheduler.LayoutUpdateEvent;
	import com.adams.dt.model.scheduler.periodClasses.TaskNavigator;
	import com.adams.dt.view.scheduler.layouts.ExactFitLayout;
	import com.adams.dt.view.scheduler.layouts.HorizontalDrawLayout;
	import com.adams.dt.view.scheduler.layouts.IHorizontalDrawLayout;
	import com.adams.dt.view.scheduler.layouts.ITaskLayout;
	import com.adams.dt.view.scheduler.layouts.IVerticalDrawLayout;
	import com.adams.dt.view.scheduler.layouts.VerticalDrawLayout;
	import com.adams.dt.view.scheduler.mainViews.PhaseViewer;
	import com.adams.dt.view.scheduler.viewers.HorizontalDrawViewer;
	import com.adams.dt.view.scheduler.viewers.IHorizontalDrawViewer;
	import com.adams.dt.view.scheduler.viewers.IVerticalDrawViewer;
	import com.adams.dt.view.scheduler.viewers.TaskViewer;
	import com.adams.dt.view.scheduler.viewers.VerticalDrawViewer;
	
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	public final class Task
	{
		public var isViewlayersInitialized : Boolean;
		public var navigator : TaskNavigator;
		public var horizontalLinesLayoutImpl : IHorizontalDrawLayout;
		public var verticalLinesLayoutImpl : IVerticalDrawLayout;
		public var horizontalLinesViewerImpl : IHorizontalDrawViewer;
		public var verticalLinesViewerImpl : IVerticalDrawViewer;
		[Bindable]
		public var entryViewer : TaskViewer;
		public var content : UIComponent;
		private var owner : PhaseViewer;
		private var _entryLayoutImpl : ITaskLayout;
		private var _entryLayout : IFactory;
		private var _backgroundLayout : IFactory;
		private var _horizontalLinesLayout : IFactory;
		private var _verticalLinesLayout : IFactory;
		private var _horizontalLinesViewer : IFactory;
		private var _verticalLinesViewer : IFactory;
		public function Task( owner : PhaseViewer )
		{
			this.owner = owner;
		}

		public function initialize() : void
		{
			isViewlayersInitialized = false;
			createTaskLayout();
			createTaskViewer();
			createHorizontalDrawLayout();
			createHorizontalDrawViewer();
			createVerticalDrawLayout();
			createVerticalDrawViewer();
		}

		public function initializeCompileTimeViewLayers() : void
		{
			createTaskViewer();
		}

		public function initializeRuntimeViewLayers() : void
		{
			createTaskLayout();
			createHorizontalDrawLayout();
			createHorizontalDrawViewer();
			createVerticalDrawLayout();
			createVerticalDrawViewer();
			entryLayoutImpl.addEventListener( LayoutUpdateEvent.UPDATE , entryViewer.update , false , 0 , true);
			horizontalLinesLayoutImpl.addEventListener( LayoutUpdateEvent.UPDATE , horizontalLinesViewerImpl.update , false , 0 , true);
			verticalLinesLayoutImpl.addEventListener( LayoutUpdateEvent.UPDATE , verticalLinesViewerImpl.update , false , 0 , true);
			entryLayoutImpl.addEventListener( LayoutUpdateEvent.UPDATE , horizontalLinesLayoutImpl.update , false , 0 , true);
			entryLayoutImpl.addEventListener( LayoutUpdateEvent.UPDATE , verticalLinesLayoutImpl.update , false , 0 , true);
			initializeViewLayerProperties();
		}

		[Bindable]
		public function get entryLayout() : IFactory
		{
			return _entryLayout;
		}

		public function set entryLayout( value : IFactory ) : void
		{
			if( value != null && value != _entryLayout )
			{
				_entryLayout = value;
			}
		}

		[Bindable]
		public function get entryRenderer() : IFactory
		{
			return entryViewer.entryRenderer;
		}

		public function set entryRenderer( value : IFactory ) : void
		{
			if( value != null && value != entryViewer.entryRenderer )
			{
				entryViewer.entryRenderer = value;
			}
		}

		[Bindable]
		public function get horizontalLinesLayout() : IFactory
		{
			return _horizontalLinesLayout;
		}

		public function set horizontalLinesLayout( value : IFactory ) : void
		{
			if( value != null && value != _horizontalLinesLayout )
			{
				_horizontalLinesLayout = value;
			}
		}

		[Bindable]
		public function get horizontalLinesViewer() : IFactory
		{
			return _horizontalLinesViewer;
		}

		public function set horizontalLinesViewer( value : IFactory ) : void
		{
			if( value != null && value != _horizontalLinesViewer )
			{
				_horizontalLinesViewer = value;
			}
		}

		[Bindable]
		public function get verticalLinesLayout() : IFactory
		{
			return _verticalLinesLayout;
		}

		public function set verticalLinesLayout( value : IFactory ) : void
		{
			if( value != null && value != _verticalLinesLayout )
			{
				_verticalLinesLayout = value;
			}
		}

		[Bindable]
		public function get verticalLinesViewer() : IFactory
		{
			return _verticalLinesViewer;
		}

		public function set verticalLinesViewer( value : IFactory ) : void
		{
			if( value != null && value != _verticalLinesViewer )
			{
				_verticalLinesViewer = value;
			}
		}

		public function get entryLayoutImpl() : ITaskLayout
		{
			return _entryLayoutImpl;
		}

		public function set entryLayoutImpl( value : ITaskLayout ) : void
		{
			navigator.entryLayoutImpl = value;
			_entryLayoutImpl = value;
		}

		private function createTaskLayout() : void
		{
			if( _entryLayout == null )
			{
				entryLayout = new ClassFactory( ExactFitLayout );
				entryLayoutImpl = ITaskLayout( _entryLayout.newInstance() );
			}else
			{
				var contentWidth : Number = entryLayoutImpl.contentWidth;
				var contentHeight : Number = entryLayoutImpl.contentHeight;
				var startDate : Date = entryLayoutImpl.startDate;
				var endDate : Date = entryLayoutImpl.endDate;
				var rowHeight : Number = entryLayoutImpl.rowHeight;
				entryLayoutImpl = ITaskLayout( _entryLayout.newInstance() );
				entryLayoutImpl.contentWidth = contentWidth;
				entryLayoutImpl.contentHeight = contentHeight;
				entryLayoutImpl.startDate = startDate;
				entryLayoutImpl.endDate = endDate;
				entryLayoutImpl.rowHeight = rowHeight;
			}
		}

		private function createTaskViewer() : void
		{
			if( entryViewer == null )
			{
				entryViewer = new TaskViewer();
			}
		}

		private function createHorizontalDrawLayout() : void
		{
			if( _horizontalLinesLayout == null )
			{
				horizontalLinesLayout = new ClassFactory( HorizontalDrawLayout );
				horizontalLinesLayoutImpl = IHorizontalDrawLayout( _horizontalLinesLayout.newInstance() );
			}else
			{
				horizontalLinesLayoutImpl = IHorizontalDrawLayout( _horizontalLinesLayout.newInstance() );
			}
		}

		private function createHorizontalDrawViewer() : void
		{
			if( _horizontalLinesViewer == null )
			{
				horizontalLinesViewer = new ClassFactory( HorizontalDrawViewer );
				horizontalLinesViewerImpl = IHorizontalDrawViewer( _horizontalLinesViewer.newInstance() );
			}else
			{
				horizontalLinesViewerImpl = IHorizontalDrawViewer( _horizontalLinesViewer.newInstance() );
			}
		}

		private function createVerticalDrawLayout() : void
		{
			if( _verticalLinesLayout == null )
			{
				verticalLinesLayout = new ClassFactory( VerticalDrawLayout );
				verticalLinesLayoutImpl = IVerticalDrawLayout( _verticalLinesLayout.newInstance() );
			}else
			{
				var timeRanges : IList = verticalLinesLayoutImpl.timeRanges
				var minimumTimeRangeWidth : Number = verticalLinesLayoutImpl.minimumTimeRangeWidth;
				verticalLinesLayoutImpl = IVerticalDrawLayout( _verticalLinesLayout.newInstance() );
				verticalLinesLayoutImpl.timeRanges = timeRanges;
				verticalLinesLayoutImpl.minimumTimeRangeWidth = minimumTimeRangeWidth;
			}
		}

		private function createVerticalDrawViewer() : void
		{
			if( _verticalLinesViewer == null )
			{
				verticalLinesViewer = new ClassFactory( VerticalDrawViewer );
				verticalLinesViewerImpl = IVerticalDrawViewer( _verticalLinesViewer.newInstance() );
			}else
			{
				verticalLinesViewerImpl = IVerticalDrawViewer( _verticalLinesViewer.newInstance() );
			}
		}

		private function initializeViewLayerProperties() : void
		{
			if( entryRenderer == null )
			{
				entryRenderer = entryViewer.entryRenderer;
			}else
			{
				entryViewer.entryRenderer = entryRenderer;
			}

			horizontalLinesViewerImpl.horizontalGridLineThickness = owner.getStyle( "horizontalGridLineThickness" );
			horizontalLinesViewerImpl.horizontalGridLineColor = owner.getStyle( "horizontalGridLineColor" );
			horizontalLinesViewerImpl.horizontalGridLineAlpha = owner.getStyle( "horizontalGridLineAlpha" );
			verticalLinesViewerImpl.verticalGridLineThickness = owner.getStyle( "verticalGridLineThickness" );
			verticalLinesViewerImpl.verticalGridLineColor = owner.getStyle( "verticalGridLineColor" );
			verticalLinesViewerImpl.verticalGridLineAlpha = owner.getStyle( "verticalGridLineAlpha" );
			var entryViewerIndex : int = content.getChildIndex( entryViewer );
			content.addChildAt( UIComponent( horizontalLinesViewerImpl ) , entryViewerIndex );
			content.addChildAt( UIComponent( verticalLinesViewerImpl ) , entryViewerIndex );
		}

		public function initializeEntryLayout() : void
		{
			if( owner.dataProvider != null )
			{
				entryLayoutImpl.dataProvider = IList( owner.dataProvider );
			}
		}
	}
}
