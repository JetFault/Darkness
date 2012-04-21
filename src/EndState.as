package  
{
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
		[Embed(source = "../bin/data/CloisterBlack.ttf", fontFamily = "TextFont", embedAsCFF="false")] protected var TextFont:String;
		
		
		public function EndState() 
		{
			textrenderer = new TextRenderer();

			var levelText:FlxText = new FlxText(0, 0, 70, "You have reached safety.");
			levelText.x = FlxG.width/ 2 - 25;
			levelText.y = FlxG.height / 2 - 25;
			levelText.color = 0xff9696FF;
			levelText.shadow = 0xff333333;
			levelText.scrollFactor.x = levelText.scrollFactor.y = 0;
			
			add(textrenderer);
			textrenderer.renderText(levelText, true, 6);
		}
		
	}

}