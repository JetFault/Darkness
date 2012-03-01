package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		private var _runspeed:Number;
		public function Player(x:Number, y:Number)
		{
			super(x, y, null);
			this.x = x;
			this.y = y;
			loadPlayer();
			maxVelocity.x = 40;
			maxVelocity.y = 40;
			_runspeed = 80;
			drag.x = _runspeed * 4;
			drag.y = _runspeed * 4;
		}
		
		private function loadPlayer():void
		{
			super.makeGraphic(10, 10, 0xff007fff);
		}
		
		override public function update():void
		{
			//velocity.x = 0;
			//velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
			
			if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				acceleration.x += drag.x;
			}
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{
				acceleration.x += -drag.x;
			}
			if (FlxG.keys.DOWN || FlxG.keys.S)
			{
				acceleration.y += drag.x;
			}
			if (FlxG.keys.UP || FlxG.keys. W)
			{
				acceleration.y += -drag.x
			}
		}
		
	}

}