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
	import events.NavBarEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class NavigationBar extends Sprite
	{
		protected var _home:NavigationButton;
		protected var _list:NavigationButton;
		protected var _map:NavigationButton;
		protected var _homeUpState:DisplayObject;
		protected var _listUpState:DisplayObject;
		protected var _mapUpState:DisplayObject;
		
		public function NavigationBar()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			_home = new NavigationButton("Home");
			_home.addEventListener(MouseEvent.CLICK,onHomeClick);
			_home.x = 0;
			_home.y = 0;
			_homeUpState = _home.upState;
			
			_list = new NavigationButton("List");
			_list.addEventListener(MouseEvent.CLICK,onListClick);
			_list.x = 160;
			_list.y = 0;
			_listUpState = _list.upState;
			
			_map = new NavigationButton("Map");
			_map.addEventListener(MouseEvent.CLICK,onMapClick);
			_map.x = 320;
			_map.y = 0;
			_mapUpState = _map.upState;
				
			addChild(_home);
			addChild(_list);
			addChild(_map);
		}
		
		public function gotoHome():void
		{
			_home.upState = _home.downState;
			_home.overState = _home.downState;
			_map.upState = _mapUpState;
			_map.overState = _mapUpState;
			_list.upState = _listUpState;
			_list.overState = _listUpState;
			
			var navBarEvent:NavBarEvent = new NavBarEvent(NavBarEvent.HOME_CLICK);
			dispatchEvent(navBarEvent);			
		}
		
		public function gotoList():void
		{
			_list.upState = _list.downState;
			_list.overState = _list.downState;
			_home.upState = _homeUpState;
			_home.overState = _homeUpState;
			_map.upState = _mapUpState;
			_map.overState = _mapUpState;
			
			var navBarEvent:NavBarEvent = new NavBarEvent(NavBarEvent.LIST_CLICK);	
			dispatchEvent(navBarEvent);			
		}
		
		public function gotoMap():void
		{
			_map.upState = _map.downState;
			_map.overState = _map.downState;
			
			_home.upState = _homeUpState;
			_home.overState = _homeUpState;
			_list.upState = _listUpState;
			_list.overState = _listUpState;
			
			var navBarEvent:NavBarEvent = new NavBarEvent(NavBarEvent.MAP_CLICK);
			dispatchEvent(navBarEvent);			
		}

		private function onMapClick(event:MouseEvent):void
		{
			gotoMap();
		}

		private function onListClick(event:MouseEvent):void
		{
			gotoList();
		}

		private function onHomeClick(event:MouseEvent):void
		{
			gotoHome();
		}

	}
}