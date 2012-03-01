package  
{
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite
	{
		
		public function Enemy(x:Number, y:Number) 
		{
			super(0, 0, null);
			super.x = x;
			super.y = y;
			loadEnemy();
		}
		
		private function loadEnemy():void
		{
			makeGraphic(10, 10, 0xffCD0000);
		}
	}

}