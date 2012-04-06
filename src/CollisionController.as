package  
{
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
		private var enemies:FlxGroup;
		private var exit:FlxSprite;
		public function CollisionController(player:Player, enemies:FlxGroup, exit:FlxSprite) 
		{
			this.player = player;
			this.enemies = enemies;
			this.exit = exit;
			super();
		}
		
		override public function update(): void {
			if (FlxG.overlap(player, enemies) && player.isAlive()) {
				player.kill();
				FlxG.shake();
			}
			
			if (FlxG.overlap(player, exit) && player.isAlive()) {
				player.kill();
			}
			super.update();
		}
		
	}

}