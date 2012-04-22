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
		private var renderedteamname:Boolean = false;
		private var dancerrendered:Boolean = false;
		
		public function EndState() 
		{
			FlxG.bgColor = 0xffffffff;//F0F0D2
			textrenderer = new TextRenderer();

			var levelText:FlxText = new FlxText(0, 0, 150, "You have escaped the tower.");
			levelText.x = FlxG.width/ 2 - 65;
			levelText.y = FlxG.height / 2 - 10;
			levelText.color = 0xff000000;
			levelText.scrollFactor.x = levelText.scrollFactor.y = 0;

			textrenderer.renderText(levelText, true, 8);
			
			add(textrenderer);
		}
		
		
		override public function update():void
		{
			textTimer += FlxG.elapsed;
			if (textTimer > 8 && !renderedteamname)
			{
				var text:FlxText = new FlxText(0, 0, 150, "Thank you for playing. \n -Relentless Night Team");
				text.x = FlxG.width / 2 - 60;
				text.y = FlxG.height / 2 + 20;
				text.color = 0xff000000;
				textrenderer.renderText(text, true, 15);
				renderedteamname = true;
				
			}
			if (textTimer > 8 && !dancerrendered) {
				var thedancer:Enemy = new Enemy(FlxG.width / 2-10, FlxG.height / 2 - 40 , null, null, false, EnemyType.DO_NOTHING, "fromcurrentposition");
				thedancer.dance();
				add(thedancer);
				add(thedancer.getController());
				dancerrendered = true;
			}
			
			super.update();
		}
		
		
	}

}