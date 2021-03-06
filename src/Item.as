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
		[Embed(source = "../bin/data/LighterItem.png")] protected var ImgLighter:Class;
		[Embed(source = "../bin/data/ClockItem.png")] protected var ImgClock:Class;
		[Embed(source = "../bin/data/Bamboo2.mp3")] protected var SoundUmbrella:Class;
		[Embed(source = "../bin/data/Chant.mp3")] protected var SoundLighter:Class;
		[Embed(source = "../bin/data/ClockTick2.mp3")] protected var SoundClock:Class;
		
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
			loadItem();
			
			
			lighterSound = FlxG.loadSound(SoundLighter);
			umbrellaSound = FlxG.loadSound(SoundUmbrella);
			clockSound = FlxG.loadSound(SoundClock);
			
			
			var point:FlxPoint = Utils.getPointThatCentersObject(level, this);
			super.x = point.x;
			super.y = point.y;
		}
		
		private function loadItem():void
		{
			if (itemType == ItemType.LANTERN)
			{
				loadGraphic(ImgLighter);
			}
			if (itemType == ItemType.UMBRELLA) 
			{
				loadGraphic(ImgUmbrella);
			}
			if (itemType == ItemType.CLOCK)
			{
				loadGraphic(ImgClock);
			}
		}
		
		override public function update():void {
			 
			if (itemType == ItemType.LANTERN)
			{
				lighterSound.volume = Utils.getVolume(100, this.getMidpoint(), player.getMidpoint()) * 0.2;
				lighterSound.play();
			}	
			if (itemType == ItemType.UMBRELLA)
			{
				umbrellaSound.volume = Utils.getVolume(100, this.getMidpoint(), player.getMidpoint()) * 1.0;
				umbrellaSound.play();
			}
					
			if (itemType == ItemType.CLOCK)
			{
				clockSound.volume = Utils.getVolume(100, this.getMidpoint(), player.getMidpoint()) * 0.2;
				clockSound.play();
			}
		
			super.update();
		}
		
		public function getItemType():ItemType
		{
			return this.itemType;
		}
		
		override public function kill():void {
			if (lighterSound.active) {
				lighterSound.stop();
			}
			if (umbrellaSound.active) {
				umbrellaSound.stop();
			}
			if (clockSound.active) {
				clockSound.stop();
			}
			super.kill();
		}
		override public function destroy(): void {
			super.destroy();
		}
		
	}
}

