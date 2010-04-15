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
 */

package components
{
	import events.SearchEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.geonames.GeonamesOperation;
	import org.geonames.GeonamesService;
	
	
	public class SearchPage extends Sprite
	{
		protected var _radiusChooser:RadiusChooser;
		protected var _featureChooser:FeatureChooser;
		protected var _search:NavigationButton;
		

		public function get currentLat():Number
		{
			return _currentLat;
		}

		public function set currentLat(value:Number):void
		{
			_currentLat = value;
		}

		public function get currentLng():Number
		{
			return _currentLng;
		}

		public function set currentLng(value:Number):void
		{
			_currentLng = value;
		}

		private var _currentLat:Number = 0;
		private var _currentLng:Number = 0;
		
		public function SearchPage()
		{
			super();
			init();
		}
		
		protected function init():void
		{
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
		}
		
		protected function onSearchClick(event:MouseEvent):void
		{
			_search.enabled = false;
			
			var radius:Number = _radiusChooser.radius;
			var featureCode:String = _featureChooser.featureCode;
			
			var service:GeonamesService = new GeonamesService();
			var operation:GeonamesOperation = service.findNearby(_currentLat,_currentLng,null,featureCode,radius,15,"FULL");
			operation.addEventListener(Event.COMPLETE,onFindNearbyComplete);
			operation.call();			
		}
		
		protected function onFindNearbyComplete(event:Event):void
		{
			var result:Array = GeonamesOperation(event.target).result;
			var searchEvent:SearchEvent = new SearchEvent(SearchEvent.SEARCH_TOPONYMS);
				searchEvent.toponymData = result;
				
			dispatchEvent(searchEvent);
		}
	}
}