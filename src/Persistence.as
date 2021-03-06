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
		static public var playerIsDead:Boolean = false;
		
		/* Stats */
		static public var floorPlayerDiedOn:uint = 0;
		static public var maxFloorReached:uint = 8;
		static public var numDeaths:uint = 0;
		//Items Held when player died
		static public var itemsHeld:Array = new Array();

		
		/*Level Stuff*/
		//Spawning player proportionate to previous level exit
		static public var startLocRatio:FlxPoint;
		
		public static function init():void {
			numItems = 0;

			while (inventory.length > 0) {
				inventory.pop();
			}		

			itemsSeen = new Array();
			
			startLocRatio = new FlxPoint(0, 0);
		}
		
		public static function initItemsHeld():void {
			itemsHeld = new Array();
		}
		
		public static function fillItemsHeld():void {
			for each(var item:Item in inventory) {
				itemsHeld.push(item.getItemType());
			}
		}
		
	}

}
