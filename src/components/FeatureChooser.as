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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FeatureChooser extends Sprite
	{
		
		protected var _mtnBtn:FeatureButton;
		protected var _riverBtn:FeatureButton;
		protected var _campBtn:FeatureButton;
		protected var _trailBtn:FeatureButton;
		protected var _lakeBtn:FeatureButton;
		protected var _forestBtn:FeatureButton;
		protected var _glacierBtn:FeatureButton;
		protected var _oceanBtn:FeatureButton;
		
		protected var _lastClickedUp:DisplayObject = null;
		protected var _lastClickedOver:DisplayObject = null;
		
		protected var _featureCode:String;
		
		public function FeatureChooser()
		{
			super();
			init();
		}
		
		public function get featureCode():String
		{
			return _featureCode;
		}
		
		protected function init():void
		{
			//graphics.beginFill(0x000000,1);
			graphics.drawRect(0,0,480,250);
			//graphics.endFill();
			
			_mtnBtn = new FeatureButton('mountain','MT');
			_mtnBtn.x = 0;
			_mtnBtn.y = 0;
			_mtnBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_mtnBtn);
			
			_riverBtn = new FeatureButton('stream','STM');
			_riverBtn.x = 105;
			_riverBtn.y = 0;
			_riverBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_riverBtn);
			
			_campBtn = new FeatureButton('camp','CMP');
			_campBtn.x = 215;
			_campBtn.y = 0;
			_campBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_campBtn);
			
			_trailBtn = new FeatureButton('trail','TRL');
			_trailBtn.x = 320;
			_trailBtn.y = 0;
			_trailBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_trailBtn);
			
			_lakeBtn = new FeatureButton('lake','LK');
			_lakeBtn.x = 0;
			_lakeBtn.y = 105;
			_lakeBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_lakeBtn);
			
			_forestBtn = new FeatureButton('forest','FRST');
			_forestBtn.x = 105;
			_forestBtn.y = 105;
			_forestBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_forestBtn);				
			
			_glacierBtn = new FeatureButton('glacier','GLCR');
			_glacierBtn.x = 215;
			_glacierBtn.y = 105;
			_glacierBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_glacierBtn);			

			_oceanBtn = new FeatureButton('ocean','OCN');
			_oceanBtn.x = 320;
			_oceanBtn.y = 105;
			_oceanBtn.addEventListener(MouseEvent.CLICK,onFeatureClick);
			addChild(_oceanBtn);		
		}

		private function onFeatureClick(event:MouseEvent):void
		{
			if(_lastClickedUp)
			{
				switch(_lastClickedUp.name)
				{
					case "mountain":
						_mtnBtn.upState = _lastClickedUp;
						_mtnBtn.overState =_lastClickedOver
						break;
					case "river":
						_riverBtn.upState = _lastClickedUp;
						_riverBtn.overState = _lastClickedOver;
						break;
					case "camp":
						_campBtn.upState = _lastClickedUp;
						_campBtn.overState = _lastClickedOver;
						break;
					case "trail":
						_trailBtn.upState = _lastClickedUp;
						_trailBtn.overState = _lastClickedOver;
						break;
					case "lake":
						_lakeBtn.upState = _lastClickedUp;
						_lakeBtn.overState = _lastClickedOver;
						break;
					case "forest":
						_forestBtn.upState = _lastClickedUp;
						_forestBtn.overState = _lastClickedUp;
						break;
					case "glacier":
						_glacierBtn.upState = _lastClickedUp;
						_glacierBtn.overState = _lastClickedOver;
						break;
					case "ocean":
						_oceanBtn.upState = _lastClickedUp;
						_oceanBtn.overState = _lastClickedOver;
						break;
				}
			}
			if(_lastClickedUp && _lastClickedUp.name == event.target.imageName)
			{
				event.target.upState = _lastClickedUp;
				_featureCode = null;
			} else {
				_lastClickedUp = event.target.upState as DisplayObject;
				_lastClickedOver = event.target.overState as DisplayObject;
				
				_featureCode = event.target.featureCode;
				event.target.upState = event.target.downState;
				event.target.overState = event.target.downState;
				//_mtnBtn.upState = _mtnBtn.downState;				
			}

		}

		
	}
}