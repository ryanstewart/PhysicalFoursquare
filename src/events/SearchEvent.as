package events
{
	import flash.events.Event;
	
	public class SearchEvent extends Event
	{
		
		public static const SEARCH_TOPONYMS:String = "searchToponyms";
		
		public var toponymData:Array = null;
		
		public function SearchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new SearchEvent(type, bubbles, cancelable);
		}
	}
}