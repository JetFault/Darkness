package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxSprite;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class CollisionController extends BaseController
	{
		private var player:Player;
		private var enemiesreal:FlxGroup;
		private var exit:FlxSprite;
		private var enemieshallucination:FlxGroup;
		private var item:Item;
		private var light:Light;
		private var level:Map;
		private var textRenderer:TextRenderer;
		private var doorsoundplayed:Boolean = false;
		
		[Embed(source = "../bin/data/DoorSlam3.mp3")] protected var DoorSound:Class;
		private var doorSound:FlxSound;
		[Embed(source = "../bin/data/GrandfatherChime2.mp3")] protected var ItemSound:Class;
		private var itemSound:FlxSound;
		
		public function CollisionController(player:Player, enemiesreal:FlxGroup, enemieshallucination:FlxGroup, 
											exit:FlxSprite, item:Item, light:Light, level:Map, textR:TextRenderer) 
		{
			doorSound = FlxG.loadSound(DoorSound, 1.0, false, true);
			itemSound = FlxG.loadSound(ItemSound, 1.0, false, true);
			
			this.player = player;
			this.enemiesreal = enemiesreal;
			this.exit = exit;
			this.enemieshallucination = enemieshallucination;
			this.item = item;
			this.light = light;
			this.level = level;
			this.textRenderer = textR;
			super();
		}
		
		override public function update(): void {
			//Player collides with level
			FlxG.collide(player.getHitbox(), level);
			
			
			
			//Real enemies that tag player kill player
			//if (FlxG.overlap(player, enemiesreal) && player.isAlive()) {
			if(!player.exiting && !player.godmode){
				for (var i:uint = 0; i < enemiesreal.members.length; i++) {
					var e:Enemy = enemiesreal.members[i] as Enemy;
					if (e && FlxG.overlap(player.getHitbox(), e.getHitbox())) {
						//TAG
						//killPlayerByEnemy();
						player.startDemise(e.getMidpoint());
						textRenderer.deathText();
						//...no tagbacks XD
					}
				}
			}
			//}
			
			//Grab item
			if (FlxG.overlap(player.getHitbox(), item) && player.isAlive()) {
				itemSound.play();
				if (item.getItemType() == ItemType.LANTERN)
				{
					light.loadLantern();
					player.loadLantern();
					textRenderer.LighterText();
				}
				if (item.getItemType() == ItemType.CLOCK)
				{
					player.maxVelocity.x = 58;
					player.maxVelocity.y = 58;
					player.setStepLength(20);
					textRenderer.ClockText();
				}
				if (item.getItemType() == ItemType.UMBRELLA)
				{
					textRenderer.UmbrellaText();
				}
				item.kill();
				player.inventory.push(item);
				Persistence.inventory = player.inventory;
			}
			
			//Exit level
			if (FlxG.overlap(player.getHitbox(), exit) && player.isAlive()) {
				player.exiting = true;
				//From purgatory, go back to 8th floor
				if (Persistence.playerIsDead == true)
				{
					FlxG.level = 0;
					Persistence.playerIsDead = false;
				}
				if(!doorsoundplayed){
					doorsoundplayed = true;
					doorSound.play();	
				}
				FlxG.fade(0xff000000, .5, nextLevel);
			}
			super.update();
		}
		
		private function killPlayerByEnemy():void {
			player.kill();
			FlxG.shake();
			Persistence.init();
		}
		
		private function resetLevel():void {
			FlxG.level = 1;
			Persistence.init();
			FlxG.switchState(new PlayState());
		}
		
		private function nextLevel():void {		
				FlxG.level++;
				
				if (Persistence.maxFloorReached > (8 - FlxG.level + 1)) {
					Persistence.maxFloorReached = (8 - FlxG.level + 1);
				}
				
				if(FlxG.level <= 9){
					FlxG.switchState(new PlayState());
				}else {
					//FlxG.switchState(new EndState());
				}
		}
	}

}