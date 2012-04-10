package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
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
		public function CollisionController(player:Player, enemiesreal:FlxGroup, enemieshallucination:FlxGroup, exit:FlxSprite, item:Item, light:Light) 
		{
			this.player = player;
			this.enemiesreal = enemiesreal;
			this.exit = exit;
			this.enemieshallucination = enemieshallucination;
			this.item = item;
			this.light = light;
			super();
		}
		
		override public function update(): void {
			//Real enemies that tag player kill player
			
			if (FlxG.overlap(player, enemiesreal) && player.isAlive()) {
				for (var i:uint = 0; i < enemiesreal.members.length; i++) {
					var e:Enemy = enemiesreal.members[i] as Enemy;
					if (FlxG.overlap(player.getHitbox(), e.getHitbox())) {
						player.kill();
						FlxG.shake();
					}
				}
			}
			
			//Hallucinations that tag player stay alive
			if (FlxG.overlap(player, enemieshallucination) && player.isAlive()) {
				for (var i:uint = 0; i < enemieshallucination.members.length; i++) {
					var e:Enemy = enemieshallucination.members[i] as Enemy;
					if (FlxG.overlap(player.getHitbox(), e.getHitbox())) {
						enemieshallucination.members[i].kill();
						enemieshallucination.remove(enemieshallucination.members[i]);
					}
				}
			}
			
			//Real enemies that tag light are attracted to player
			if (FlxG.overlap(light, enemiesreal)) {
				for (var i:uint = 0; i < enemiesreal.members.length; i++) {
					if (FlxG.overlap(light, enemiesreal.members[i])) {
						var e:Enemy = enemiesreal.members[i] as Enemy;
						if (Utils.getDistance(light.getMidpoint(), e.getMidpoint()) < 40*light.scale.x) { //Assumes light.scale.x == light.scale.y
							var ctrl:EnemyController = e.getController() as EnemyController;
							ctrl.setPlayerVisible();
						}
					}
				}
			}
			
			//Hallucinations that tag light die
			if (FlxG.overlap(light, enemieshallucination)) {
				for (var i:uint = 0; i < enemieshallucination.members.length; i++) {
					if (FlxG.overlap(light, enemieshallucination.members[i])) {
						var e:Enemy = enemieshallucination.members[i] as Enemy;
						if (Utils.getDistance(light.getMidpoint(), e.getMidpoint()) < 15*light.scale.x) { //Assumes light.scale.x == light.scale.y
							enemieshallucination.members[i].kill();
							enemieshallucination.remove(enemieshallucination.members[i]);
						}
					}
				}
			}
			
			
			//Grab item
			if (FlxG.overlap(player.getHitbox(), item) && player.isAlive()) {
				if (item.getItemType() == ItemType.LANTERN)
				{
					light.loadLantern();
				}
				/*
				if (item.getItemType() == ItemType.CLOCK)
				{
					player.maxVelocity.x = 62;
					player.maxVelocity.y = 62;
				}*/
				item.kill();
				player.inventory.push(item);
			}
			
			//Exit level
			if (FlxG.overlap(player.getHitbox(), exit) && player.isAlive()) {				
				player.kill();
				FlxG.level++;
				FlxG.switchState(new PlayState());
			}
			super.update();
		}
		
		private function killPlayerByEnemy() {
			player.kill();
			FlxG.shake();
		}
		
	}

}