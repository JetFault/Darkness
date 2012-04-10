package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Item extends FlxSprite
	{
		[Embed(source = "../bin/data/UmbrellaItem.png")] protected var ImgUmbrella:Class;
		[Embed(source = "../bin/data/LighterItem2.png")] protected var ImgLighter:Class;
		[Embed(source = "../bin/data/ClockItem.png")] protected var ImgClock:Class;
		[Embed(source = "../bin/data/Bamboo.mp3")] protected var SoundUmbrella:Class;
		[Embed(source = "../bin/data/Chant.mp3")] protected var SoundLighter:Class;
		[Embed(source = "../bin/data/GrandfatherClock.mp3")] protected var SoundClock:Class;
		
		private var umbrellaSound:FlxSound;
		private var lighterSound:FlxSound;
		private var clockSound:FlxSound;
		
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
			
			//this.itemType = ItemType.UMBRELLA;//LOLOLOLOL
			
			lighterSound = FlxG.loadSound(SoundLighter);
			umbrellaSound = FlxG.loadSound(SoundUmbrella);
			clockSound = FlxG.loadSound(SoundClock);
			
			var rand:Number = Math.random();
			var quart:Number = 0;
			if 		(rand < .25) 	{ quart = 0; }
			else if (rand < .5)		{ quart = 1; }
			else if (rand < .75) 	{ quart = 2; }
			else 				 	{ quart = 3; }
			angle = 90 * quart;
			
			var point:FlxPoint = Utils.getPointThatCentersObject(level, this);
			super.x = point.x;
			super.y = point.y;
		}
		
		private function loadItem(itemType:ItemType):void
		{
			switch(itemType) {
				case ItemType.LANTERN:
					loadGraphic(ImgLighter, true, true, 5, 7);
					break;
				case ItemType.UMBRELLA:
					loadGraphic(ImgUmbrella, true, true, 9, 18);
					break;
				case ItemType.CLOCK:
					loadGraphic(ImgClock, true, true, 7, 6);
					break;
			}
		}
		
		override public function update():void {
			switch(itemType) {
				case ItemType.LANTERN:
					lighterSound.volume = Utils.getVolume(100, this.getMidpoint(), player.getMidpoint()) * 0.1;
					lighterSound.play();
					break;
				case ItemType.UMBRELLA:
					umbrellaSound.volume = Utils.getVolume(100, this.getMidpoint(), player.getMidpoint()) * 1.0;
					umbrellaSound.play();
					break;
				case ItemType.CLOCK:
					clockSound.volume = Utils.getVolume(100, this.getMidpoint(), player.getMidpoint()) * 0.1;
					clockSound.play();
					break;
			}
			
			
			super.update();
		}
		
		public function getItemType():ItemType
		{
			return this.itemType;
		}
		override public function destroy(): void {
			if (lighterSound.active) {
				lighterSound.stop();
			}
			super.destroy();
		}
		
	}

}