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

			if (FlxG.overlap(player, enemiesreal) && player.isAlive()) {
				player.kill();
				FlxG.shake();
			}
			
			if (FlxG.overlap(player, enemieshallucination) && player.isAlive()) {
				for (var i:uint = 0; i < enemieshallucination.members.length; i++) {
					if (FlxG.overlap(player, enemieshallucination.members[i])) {
						enemieshallucination.members[i].kill();
						enemieshallucination.remove(enemieshallucination.members[i]);
					}
				}
			}
			
			if (FlxG.overlap(player, item) && player.isAlive()) {
				if (item.getItemType() == ItemType.LANTERN)
				{
					light.loadLantern();
					item.kill();
					item.destroy();
				}
			}
			
			if (FlxG.overlap(player, exit) && player.isAlive()) {
				player.kill();
			}
			super.update();
		}
		
	}

}