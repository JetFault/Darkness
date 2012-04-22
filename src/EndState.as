package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class EndState extends FlxState 
	{
		public var textrenderer:TextRenderer;
		[Embed(source = "../bin/data/CloisterBlack.ttf", fontFamily = "TextFont", embedAsCFF = "false")] protected var TextFont:String;
		private var player:Player;
		private var enemies:FlxGroup;
		private var enemy:Enemy;
		private var controllers:GameControllers;
		private var playerController:PlayerController;
		private var textTimer:Number = 0;
		
		public function EndState() 
		{
			FlxG.bgColor = 0xffffffff;
			textrenderer = new TextRenderer();

			var levelText:FlxText = new FlxText(0, 0, 150, "You have reached safety.");
			levelText.x = FlxG.width/ 2 - 75;
			levelText.y = FlxG.height / 2 - 50;
			levelText.color = 0xff000000;
			levelText.scrollFactor.x = levelText.scrollFactor.y = 0;

			textrenderer.renderText(levelText, true, 4);
			
			add(textrenderer);
		}
		
		/*
		override public function update():void
		{
			textTimer += FlxG.elapsed;
			if (textTimer > 6)
			{
				var text:FlxText = new FlxText(0, 0, 150, "Thank you for playing. \n -Relentless Night Team");
				text.x = FlxG.width / 2 - 75;
				text.y = FlxG.height / 2 - 25;
				text.color = 0xff000000;
				//textrenderer.renderText(text, true, 6);
			}
		}
		*/
		
	}

}