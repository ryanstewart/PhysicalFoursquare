/**
 * Ryan Stewart - http://blog.digitalbackcountry.com
 * ryan@adobe.com
 *  
 * This project was created to show off a Flash application on mobile devices.
 * It was customized to run for the screen size of the Nexus One but should work
 * on any other device that supports Flash.
 * 
 * ----------------------------------------------------------------------------
 *  "THE BEER-WARE LICENSE" (Revision 42):
 * <ryan@adobe.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return 
 * 															=Ryan Stewart
 * ----------------------------------------------------------------------------
 * 
 * Huge thanks to Tim Walling (http://www.timwalling.com/) for help with the Foursquare API 
 * and his excellent AS3 library for it.
 * 
 * Thanks to Serge Jespers for the HTML5 Geolocation code
 * http://www.webkitchen.be/2010/03/05/the-html5-flash-marriage-geolocation/
 * 
 * This project uses the following libraries/projects:
 * 	- minimalcomps (http://code.google.com/p/minimalcomps/)
 * 	- Google Maps AS3 API (http://code.google.com/apis/maps/documentation/flash/)
 * 	- Google Maps Flash Utils (http://code.google.com/p/gmaps-utility-library-flash/)
 *	- TweenLite (http://www.greensock.com/tweenlite/)
 *  - foursquare-as3 (http://code.google.com/p/foursquare-as3/)
 *  - GeonamesAS3 (http://github.com/ryanstewart/GeonamesAS3)
 *  - oauth-as3 (http://code.google.com/p/oauth-as3/)
 * 
 * The Folks font is a free font from DaFonts - http://www.dafont.com/folks.font
*/
 
package
{
	import com.bit101.components.List;
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapAction;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.extras.markermanager.GridBounds;
	import com.google.maps.extras.markermanager.MarkerManager;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.styles.FillStyle;
	import com.greensock.TweenLite;
	import com.timwalling.foursquare.FoursquareOperation;
	import com.timwalling.foursquare.FoursquareRequestFormat;
	import com.timwalling.foursquare.FoursquareService;
	import com.timwalling.foursquare.FoursquareVenue;
	
	import components.NavigationBar;
	import components.Pages;
	import components.SearchPage;
	
	import events.NavBarEvent;
	import events.SearchEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.TextElement;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.geonames.GeonamesOperation;
	import org.geonames.GeonamesService;
	import org.geonames.Toponym;
	import org.geonames.featurecodes.Hypsographic;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;

	
	[SWF(width='480', height='800', backgroundColor='#ffffff', frameRate='30')]	
	
	public class PhysicalFoursquare extends Sprite
	{
		protected var _map:Map;
		protected var _markerManager:MarkerManager;
		protected var _mapContainer:Sprite;
		protected var _text:TextField;
		protected var _list:List;
		protected var _background:Loader;
		protected var _navBar:NavigationBar;
		protected var _search:SearchPage;
		protected var _holdingSprite:Sprite;
		protected var _holdingText:TextField;
		protected var _currentPage:Number = Pages.SEARCH_PAGE;
		
		protected var _currentLat:Number;
		protected var _currentLng:Number;
		
		protected var _foursquareService:FoursquareService;
		protected var _selectedToponym:Toponym;
		
		// OAuth stchuff - thanks Shannon and Tim
		protected var _requestToken:String = "http://foursquare.com/oauth/request_token";
		protected var _accessToken:String = "http://foursquare.com/oauth/access_token";
		protected var _authorize:String = "http://foursquare.com/oauth/authorize";
		protected var _authExchange:String = "http://api.foursquare.com/v1/authexchange";
		
		// User specific data - This uses a UserData class that I didn't add to the source.
		protected var _foursquareKey:String = UserData.YOUR_FOURSQUARE_KEY_HERE;
		protected var _foursquareSecret:String = UserData.YOUR_FOURSQUARE_SECRET_HERE;
		protected var _foursquareUsername:String = UserData.YOUR_FOURSQUARE_USERNAME_HERE;
		protected var _foursquarePassword:String = UserData.YOUR_FOURSQUARE_PASSWORD_HERE;
		protected var _googleMapsKey:String = UserData.YOUR_GOOGLE_MAP_KEY_HERE;
		
		
		private var _consumer:OAuthConsumer;
		private var _token:OAuthToken;
		
		[Embed(source="/assets/Folks-Bold.ttf", embedAsCFF="false", fontName="Folks", mimeType="application/x-font")]
		private var Folks:Class;
		
		public function PhysicalFoursquare()
		{
			super();
			preinit();
		}
		
		// OAuth methods
		private function preinit():void
		{
			_consumer = new OAuthConsumer(_foursquareKey,_foursquareSecret);
			
			var oauthRequest:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_MEHTOD_GET, _authExchange, 
				{fs_username:_foursquareUsername,fs_password:_foursquarePassword},_consumer);
			var requestUrl:String = oauthRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(), OAuthRequest.RESULT_TYPE_URL_STRING);
			var request:URLRequest = new URLRequest(requestUrl);
			
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onOAuthLoginComplete);
			loader.load(request);
			
		}
		
		private function onOAuthLoginComplete(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var credentials:XML = new XML(loader.data);
			
			_token = new OAuthToken(credentials.oauth_token, credentials.oauth_token_secret);
			
			_foursquareService = new FoursquareService();
			_foursquareService.consumer = _consumer;
			_foursquareService.token = _token;
			
			init();			
		}
		
		protected function init():void
		{
			
			if (ExternalInterface.available) {
				//check if external interface is available
				try {
					// add Callback for the passGEOToSWF Javascript function
					ExternalInterface.addCallback("passGEOToSWF", onPassGEOToSWF);
				} catch (error:SecurityError) {
					// Alert the user of a SecurityError
				} catch (error:Error) {
					// Alert the user of an Error
				}
			}
			
			ExternalInterface.call("getGEO");
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageHeight = 800;
			stage.stageWidth = 480;
			
			_background = new Loader();
			_background.load(new URLRequest('assets/background.png'));
			_background.alpha = .3;
			stage.addChildAt(_background,0);
			
			_navBar = new NavigationBar();
			_navBar.x = 0;
			_navBar.y = 700;
			_navBar.addEventListener(NavBarEvent.HOME_CLICK,onNavBarHomeClick);
			_navBar.addEventListener(NavBarEvent.LIST_CLICK,onNavBarListClick);
			_navBar.addEventListener(NavBarEvent.MAP_CLICK,onNavBarMapClick);		
			
			addChild(_navBar);

			// Map
			_mapContainer = new Sprite();
			_mapContainer.x = 960;
			_mapContainer.y = 0;
			_mapContainer.graphics.beginFill(0x000000,1);
			_mapContainer.graphics.drawRect(0,960,480,700);
			_mapContainer.graphics.endFill();
			
			_map = new Map();
			_map.key = _googleMapsKey;
			//_map.url = 
			_map.setSize(new Point(480,700));
			_map.addEventListener(MapEvent.MAP_PREINITIALIZE,onMapPreinit);
			_map.addEventListener(MapEvent.MAP_READY,onMapReady);
			//_map.url = "http://blog.digitalbackcountry.com";
			_map.addEventListener(MapMouseEvent.DOUBLE_CLICK,onMapDoubleClick);
			
			_mapContainer.addChild(_map);
			
			var zoomIn:Sprite = new Sprite();
				zoomIn.graphics.beginFill(0x000000,1);
				zoomIn.graphics.drawEllipse(0,0,100,100);
				zoomIn.graphics.endFill();
				zoomIn.alpha = .5;
				zoomIn.addEventListener(MouseEvent.CLICK,function(event:Event):void{_map.zoomIn()});
			
			var inText:TextField = new TextField()
				inText.width = 100;
				inText.height = 100;
				inText.x = 0;
				inText.y = 0;
				inText.text = '+';
				inText.selectable = false;
				inText.setTextFormat(new TextFormat(null,100,0xffffff,false,false,false,null,null,TextAlign.CENTER));
				
				zoomIn.addChild(inText);	

			_mapContainer.addChild(zoomIn);
			
			var zoomOut:Sprite = new Sprite();
				zoomOut.graphics.beginFill(0x000000,1);
				zoomOut.graphics.drawEllipse(0,115,100,100);
				zoomOut.graphics.endFill();
				zoomOut.alpha = .5;
				zoomOut.addEventListener(MouseEvent.CLICK,function(event:Event):void{_map.zoomOut()});	
				
			var outText:TextField = new TextField()
				outText.width = 100;
				outText.height = 100;
				outText.x = 0;
				outText.y = 100;
				outText.text = '-';
				outText.selectable = false;
				outText.setTextFormat(new TextFormat(null,200,0xffffff,false,false,false,null,null,TextAlign.CENTER));
				
				zoomOut.addChild(outText);				
				
			_mapContainer.addChild(zoomOut);
			addChild(_mapContainer);			
			
			// List
			_list = new List(null,480,0,new Array(),function(item:Object):String{return item.name + ' -  Type: ' + item.fcodeName + '-  Distance: ' + item.distance + ' km'});
			_list.defaultColor = 0x0b743b;
			_list.rolloverColor = 0xb8d54f;
			_list.selectedColor = 0xb8d54f;
			_list.listItemHeight = 50;
			_list.width = 480;
			_list.height = 700;
			_list.alpha = .75;
			_list.addEventListener(Event.SELECT,onSelect);
			addChild(_list);			
			
			// Search
			_search = new SearchPage();
			_search.x = 0;
			_search.y = 0;
			_search.addEventListener(SearchEvent.SEARCH_TOPONYMS,onSearchToponyms);
			
			addChild(_search);

			// Holder sprite
			_holdingSprite = new Sprite();
			_holdingSprite.x = 0;
			_holdingSprite.y = 0;
			_holdingSprite.alpha = .75;
			_holdingSprite.graphics.beginFill(0x000000,1);
			_holdingSprite.graphics.drawRect(0,0,480,800);
			_holdingSprite.graphics.endFill();
			
			_holdingText = new TextField();
			_holdingText.text = "Acquiring Location";
			_holdingText.embedFonts = true;
			_holdingText.setTextFormat(new TextFormat("Folks",24,0xffffff,null,null,null,null,null,TextAlign.CENTER));
			_holdingText.width = 480;
			_holdingText.height = 800;
			_holdingText.y = 380;
			_holdingSprite.addChild(_holdingText);
			
			addChild(_holdingSprite);
		}

		
		// Nav Bar methods
		private function onNavBarMapClick(event:NavBarEvent):void
		{
			switch( _currentPage )
			{
				case Pages.LIST_PAGE:
					TweenLite.to(_list,1,{x:-480,y:0});
					TweenLite.to(_mapContainer,1,{x:0,y:0});
					break;
				case Pages.SEARCH_PAGE:
					TweenLite.to(_search,1,{x:-960,y:0});
					TweenLite.to(_list,1,{x:-480,y:0});
					TweenLite.to(_mapContainer,1,{x:0,y:0});
					break;
			}
			_currentPage = Pages.MAP_PAGE;
		}

		private function onNavBarListClick(event:NavBarEvent):void
		{
			switch( _currentPage )
			{
				case Pages.SEARCH_PAGE:
					TweenLite.to(_search,1,{x:-480,y:0});
					TweenLite.to(_list,1,{x:0,y:0});
					break;
				case Pages.MAP_PAGE:
					TweenLite.to(_search,1,{x:-480,y:0});
					TweenLite.to(_list,1,{x:0,y:0});
					TweenLite.to(_mapContainer,1,{x:480,y:0});
					break;
			}
			_currentPage = Pages.LIST_PAGE;
		}

		private function onNavBarHomeClick(event:NavBarEvent):void
		{
			switch( _currentPage )
			{
				case Pages.LIST_PAGE:
					TweenLite.to(_list,1,{x:480,y:0});
					TweenLite.to(_search,1,{x:0,y:0});
					break;
				case Pages.MAP_PAGE:
					TweenLite.to(_list,1,{x:480,y:0});
					TweenLite.to(_mapContainer,1,{x:960,y:0});
					TweenLite.to(_search,1,{x:0,y:0});
					break;
			}			
			_currentPage = Pages.SEARCH_PAGE;
		}

		// Map methods
		protected function onMapPreinit(event:MapEvent):void
		{
			var mapOptions:MapOptions = new MapOptions();
				mapOptions.mapType = MapType.PHYSICAL_MAP_TYPE;
				mapOptions.zoom = 13;
			
			_map.setInitOptions(mapOptions);
			
		}
		
		protected function onMapReady(event:MapEvent):void
		{
			//_map.addControl(new ZoomControl());	
		}
		
		protected function onMapDoubleClick(event:MapMouseEvent):void
		{
			var latLng:LatLng = event.latLng;

		}
		
		
		// Search methods
		private function onSearchToponyms(event:SearchEvent):void
		{	
			_list.removeAll();
			if(_markerManager)
			{
				_markerManager.clearMarkers();
			}

			var arr:Array = event.toponymData;
			var arrLen:int = arr.length;
			var arrMarkers:Array = new Array();
			
			for(var i:int=0; i<arrLen; i++)
			{
				_list.addItem(arr[i]);
				var infoWindowOptions:InfoWindowOptions = new InfoWindowOptions();
					infoWindowOptions.content = arr[i].name;
				var marker:Marker = new Marker(new LatLng(arr[i].lat,arr[i].lng));
					marker.addEventListener(MapMouseEvent.CLICK,function(event:MapMouseEvent):void{event.target.openInfoWindow(infoWindowOptions)});
				arrMarkers.push(marker);
			}
			
			_navBar.gotoList();
			
			_markerManager = new MarkerManager(_map,{maxZoom:9})
			_markerManager.addMarkers(arrMarkers,9);
			_markerManager.refresh();
				
			//_map.setSize(bounds.getSize());
			
			_navBar.dispatchEvent(new NavBarEvent(NavBarEvent.LIST_CLICK));		
		}
	
		// Geolocation methods
		public function onPassGEOToSWF(lat:Number,lng:Number):void
		{
			_search.currentLat = lat;
			_search.currentLng = lng;
			
			var currentPos:LatLng = new LatLng(lat,lng);
			
			var markerOpt:MarkerOptions = new MarkerOptions();
				markerOpt.fillStyle = new FillStyle({color:0x0101DF});
			var marker:Marker = new Marker(currentPos);
				marker.setOptions(markerOpt);
				
			_map.setCenter(currentPos);
			_map.addOverlay(marker);
			
			_holdingSprite.removeChild(_holdingText);
			removeChild(_holdingSprite);
		}

		
		// Foursquare methods
		private function onSelect(event:Event):void
		{

			_selectedToponym = _list.selectedItem as Toponym;
		
			_foursquareService.format = FoursquareRequestFormat.XML;
			
			var operation4sq:FoursquareOperation = _foursquareService.findVenues(_selectedToponym.lat.toString(),_selectedToponym.lng.toString(),5,_selectedToponym.name);
			operation4sq.addEventListener(Event.COMPLETE,on4sqSearchComplete);
			operation4sq.execute();
				
		}

		
		
		private function on4sqSearchComplete(event:Event):void
		{
			var venues:XMLList = XML(FoursquareOperation(event.target).data).children().children();
			var operation4sq:FoursquareOperation;
			
			if( venues.length() == 1 )
			{
				operation4sq = _foursquareService.checkin(venues[0].id); 
				operation4sq.addEventListener(Event.COMPLETE,onCheckinComplete);
				operation4sq.execute();
			} else {
				var venue:FoursquareVenue = new FoursquareVenue(_selectedToponym.name);
					venue.geolat = _selectedToponym.lat;
					venue.geolong = _selectedToponym.lng;
					
				operation4sq = _foursquareService.addVenue(venue);
				operation4sq.addEventListener(Event.COMPLETE,onAddVenueComplete);
				operation4sq.execute();
				
			}			
		}
		
		private function onCheckinComplete(event:Event):void
		{
			var holdingText:TextField = new TextField();
				holdingText.text = "Checked In \n (click to dismiss)";
				holdingText.embedFonts = true;
				holdingText.setTextFormat(new TextFormat("Folks",24,0xffffff,null,null,null,null,null,TextAlign.CENTER));
				holdingText.width = 480;
				holdingText.height = 800;
				holdingText.y = 380;
				
			_holdingSprite.addChild(holdingText);	
			_holdingSprite.addEventListener(MouseEvent.CLICK,onHoldingSpriteClick);
			
			addChild(_holdingSprite);
			
		} 		
		
		private function onAddVenueComplete(event:Event):void
		{
			var data:XML = XML(event.target.data);
			var operation4sq:FoursquareOperation = _foursquareService.checkin(data.id);
				operation4sq.addEventListener(Event.COMPLETE,onCheckinComplete);
				operation4sq.execute();			
		}
		
		// Random
		
		private function onHoldingSpriteClick(event:MouseEvent):void
		{
			_holdingSprite.removeEventListener(MouseEvent.CLICK,onHoldingSpriteClick);
			removeChild(_holdingSprite);
		}
	}
}