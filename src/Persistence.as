package  
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Darkness
	 */
	public class Persistence 
	{
		/*Items*/
		static public var numItems:uint;
		static public var inventory:Array = new Array();		
		static public var itemsSeen:Array;
		
		/*Level Stuff*/
		static public var startLocRatio:FlxPoint;
		
		public static function init():void {
			numItems = 0;
			for (var i:int = 0; i < inventory.length; i++)
			{
				inventory.pop();
			}			
			itemsSeen = new Array();
			
			startLocRatio = new FlxPoint(0, 0);
		}		
		
	}

}