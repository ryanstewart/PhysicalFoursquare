package events
{
	import flash.events.Event;
	
	public class NavBarEvent extends Event
	{
		
		public static const HOME_CLICK:String = "homeClick";
		public static const LIST_CLICK:String = "listClick";
		public static const MAP_CLICK:String = "mapClick";
		
		public function NavBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new NavBarEvent(type, bubbles, cancelable);
		}
	}
}