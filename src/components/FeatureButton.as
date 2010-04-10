package components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class FeatureButton extends SimpleButton
	{
		protected var _imageName:String;
		protected var _downState:Sprite;
		protected var _featureCode:String;
		
		public function FeatureButton(imageName:String=null,featureCode:String=null,upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			_imageName = imageName;
			_featureCode = featureCode;
			super(upState, overState, downState, hitTestState);
			init();			
		}
		
		public function get featureCode():String
		{
			return _featureCode;
		}
		
		protected function init():void
		{
			var request:URLRequest;
			var loader:Loader;
			
			// Up
			request = new URLRequest('assets/'+_imageName+'_up.png');
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderUpComplete);
			loader.load(request);

			// Hit
			var hit:Shape = new Shape();
				hit.graphics.lineStyle( 1, 0x00FF00, 0 );
				hit.graphics.beginFill(0x000000,1);
				hit.graphics.drawRect(0,0,110,110);
				hit.graphics.endFill();
			hitTestState = hit;
			
			
			// Over			
			request = new URLRequest('assets/'+_imageName+'_over.png');
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderOverComplete);
			loader.load(request);			
			
			// Down
			request = new URLRequest('assets/'+_imageName+'_down.png');
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderDownComplete);
			loader.load(request);	
		}
			
		protected function onLoaderUpComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			upState = loaderInfo.loader;
			upState.name = _imageName;
		}
		
		protected function onLoaderOverComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			overState = loaderInfo.loader;
		}		
		
		protected function onLoaderDownComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			
			_downState = new Sprite();
			_downState.addChild(loaderInfo.loader);
			
			var format:TextFormat = new TextFormat();
				format.size = 18;
				format.color = 0xffffff;
				format.bold = true;
				format.align = TextAlign.CENTER;
				format.font = "Folks";
			
			var glow:GlowFilter = new GlowFilter();
				glow.color = 0x009245;
				glow.blurX = 10;
				glow.blurY = 10;
				
			var text:TextField = new TextField();
				text.text = _imageName;
				text.embedFonts = true;
				text.x = 0;
				text.y = 50;
				text.filters = new Array(glow);
				text.setTextFormat(format);
			
			_downState.addChild(text);
			
			downState = _downState;
		}			
	}
}