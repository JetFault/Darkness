package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Item extends FlxSprite
	{
		private var player:Player;
		private var level:Map;
		private var itemType:ItemType;
		
		public function Item(x:Number, y:Number, player:Player, level:Map, itemType:ItemType) 
		{
			super.x = x;
			super.y = y;
			this.player = player;
			this.level = level;
			this.itemType = itemType;
			loadItem(itemType);
		}
		
		private function loadItem(itemType:ItemType):void
		{
			if (itemType == ItemType.LANTERN)
			{
				makeGraphic(8, 8, 0xffE0E01B);
			}
		}
		
		public function getItemType():ItemType
		{
			return this.itemType;
		}
		
	}

}