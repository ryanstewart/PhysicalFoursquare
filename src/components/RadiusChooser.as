package components
{
	import assets.radius;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class RadiusChooser extends Sprite
	{
		protected var _x:Number;
		protected var _y:Number;
		protected var _shape:Sprite;
		protected var _text:TextField;
		protected var _format:TextFormat;
		protected var _glow:GlowFilter;
		
		protected var _radius:Number;
		
		public function RadiusChooser()
		{
			super();
			init()
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		protected function init():void
		{
			
			var alphas:Array = [1, 1, 1, 1];
			var colors:Array = [0x007b48, 0x52a770, 0xa4d397, 0xedeabf];			
			var ratios:Array = [0, 0x55, 0xAA, 0xFF];
			var matrix:Matrix = new Matrix();	
				matrix.createGradientBox( 30, 30, 90 * ( Math.PI / 180 ) );
//			
//			graphics.lineStyle( 5, 0x000000 );
//			// graphics.beginFill( 0xFF0000 );
//			graphics.beginGradientFill( GradientType.LINEAR, colors, alphas, ratios, matrix );  
//			graphics.drawRoundRect( 0, 0, 290, 190, 25, 25 );
//			graphics.endFill();
//					
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,480,100);
			graphics.endFill();
			
			//var radiusGraphic:radius;
			//	radiusGraphic.x = 225;
			
			//addChild(radiusGraphic);
		
			_shape = new Sprite();
			_shape.x = 240;

			_shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			_shape.graphics.drawCircle(0,0,30);
			_shape.graphics.endFill();
			addChild(_shape);

			_format = new TextFormat();
			_format.size = 18;
			_format.color = 0xffffff;
			_format.bold = true;
			_format.align = TextAlign.CENTER;
			_format.font = "Folks";
			
			_glow = new GlowFilter();
			_glow.color = 0x009245;
			_glow.blurX = 3;
			_glow.blurY = 3;
			
			_text = new TextField();
			_text.width = 200;
			_text.x = 140;
			_text.y = 0;
			_text.text = 'Radius: 1 km';
			_text.selectable = false;
			_text.filters = new Array(_glow);
			_text.setTextFormat(_format);
			
			addChild(_text);
			
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}

		private function onMouseDown(event:MouseEvent):void
		{
			_x = event.stageX;
			_y = event.stageY;
		}

		private function onMouseMove(event:MouseEvent):void
		{
			if(event.buttonDown)
			{
				var scale:Number = Math.min(Math.max(Math.abs(_x - event.stageX)/10,1),6);
				var roundTo:Number = Math.pow(10,2);				
				
				_radius = Math.round(roundTo*scale)/roundTo;
				_text.text = 'Radius: ' + _radius.toString() + ' km'; 
				_text.setTextFormat(_format);
				_shape.scaleX = Math.min(scale,6);
				_shape.scaleY = Math.min(scale,6);
			}
		}
	}
}