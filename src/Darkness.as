package  
{
	import org.flixel.*;
	import flash.display.*;
	
	public class Darkness extends FlxGame
	{
		
		public function Darkness() 
		{
			Persistence.init();
			super(400, 300, PlayState, 2);
			//super(320, 240, PlayState, 2);
			//super(800, 600, PlayState, 1);
		}
		
	}

}
