
// Font is a free font from DaFonts - http://www.dafont.com/folks.font
package
{
	import com.bit101.components.List;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapType;
	
	import components.FeatureChooser;
	import components.NavigationButton;
	import components.RadiusChooser;
	import components.ToponymList;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.engine.TextElement;
	
	import org.geonames.GeonamesOperation;
	import org.geonames.GeonamesService;
	import org.geonames.Toponym;
	import org.geonames.featurecodes.Hypsographic;
	import org.osmf.display.ScaleMode;
	import org.osmf.proxies.ListenerProxyElement;
	
	[SWF(width='480', height='800', backgroundColor='#ffffff', frameRate='30')]	
	
	public class PhysicalFoursquare extends Sprite
	{
		protected var _map:Map;
		protected var _radiusChooser:RadiusChooser;
		protected var _featureChooser:FeatureChooser;
		protected var _text:TextField;
		protected var _list:List;
		protected var _background:Loader;
		protected var _search:NavigationButton;
		
		[Embed(source="/assets/Folks-Bold.ttf", embedAsCFF="false", fontName="Folks", mimeType="application/x-font")]
		private var Folks:Class;
		
		public function PhysicalFoursquare()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageHeight = 800;
			stage.stageWidth = 480;
			
			_background = new Loader();
			_background.load(new URLRequest('assets/background.png'));
			_background.alpha = .3;
			stage.addChildAt(_background,0);
			
			
			_map = new Map();
			//map.width = stage.width;
			//map.height = stage.height;
			_map.addEventListener(MapEvent.MAP_READY,onMapReady);
			_map.url = "http://blog.digitalbackcountry.com";
			_map.key = "ABQIAAAAEPSnxMQDa8BRcDfJB7EW1hTWCdQ-AJckUnuSppzI_Y_GSzvx2xRP-k43cI98_ddac2yNC8iG9QhgOQ";
			_map.addEventListener(MapMouseEvent.DOUBLE_CLICK,onMapDoubleClick);
			
			_featureChooser = new FeatureChooser();
			_featureChooser.x = 25;
			_featureChooser.y = 0;
			_featureChooser.width = 480;
			_featureChooser.height = 250;
			addChild(_featureChooser);
			//addChild(map);	
			
			
			
			_radiusChooser = new RadiusChooser();
			_radiusChooser.x = 0;
			_radiusChooser.y = 400;
			
			addChild(_radiusChooser);
			
			
			_search = new NavigationButton("Search",480,100);
			_search.x = 0;
			_search.y = 600;
			_search.addEventListener(MouseEvent.CLICK,onSearchClick);
				
			addChild(_search);
			/*
			var list:NavigationButton = new NavigationButton("List");
				list.x = 160;
				list.y = 600;
			
			var map:NavigationButton = new NavigationButton("Map");
				map.x = 320;
				map.y = 600;				
			
			addChild(home);
			addChild(list);
			addChild(map);
			*/
		}
		
		protected function onMapReady(event:MapEvent):void
		{
			_map.setMapType(MapType.PHYSICAL_MAP_TYPE);
			
		}

		protected function onSearchClick(event:MouseEvent):void
		{
			_search.enabled = false;
			
			var radius:Number = _radiusChooser.radius;
			var featureCode:String = _featureChooser.featureCode;

			var service:GeonamesService = new GeonamesService();
			var operation:GeonamesOperation = service.findNearby(41.525736,-109.473889,null,featureCode,radius,15,"FULL");
			operation.addEventListener(Event.COMPLETE,onFindNearbyComplete);
			operation.call();			
		}
		
		protected function onMapDoubleClick(event:MapMouseEvent):void
		{
			var latLng:LatLng = event.latLng;

		}
		
		protected function onFindNearbyComplete(event:Event):void
		{
			var result:Array = GeonamesOperation(event.target).result;
			
			
			_list = new List(null,0,0,result,function(item:Object):String{return item.name + ' -  Type: ' + item.fcodeName + ' Distance: ' + item.distance});
			_list.defaultColor = 0x0b743b;
			_list.rolloverColor = 0xb8d54f;
			_list.selectedColor = 0xb8d54f;
			_list.listItemHeight = 100;
			_list.width = 480;
			_list.height = 700;
			addChild(_list);
			/*
			
			_list.width = 480;
			_list.height = 700;
			addChild(_list);
			*/
			//trace(GeonamesOperation(event.target).result);
		}
	}
}