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
		var textrenderer:TextRenderer;
		[Embed(source = "../bin/data/CloisterBlack.ttf", fontFamily = "TextFont", embedAsCFF="false")] protected var TextFont:String;
		
		
		public function EndState() 
		{
			textrenderer = new TextRenderer();

			/*var titlegroup:FlxGroup = new FlxGroup();
			titlegroup.add(new FlxText(50, 50, 80, "D"));
			titlegroup.add(new FlxText(50, 60, 10, "a"));
			titlegroup.add(new FlxText(50, 70, 10, "r"));
			titlegroup.add(new FlxText(50, 80, 10, "k"));
			titlegroup.add(new FlxText(50, 90, 10, "e"));
			titlegroup.add(new FlxText(50, 100, 10, "n"));
			titlegroup.add(new FlxText(50, 110, 10, "s"));
			titlegroup.add(new FlxText(50, 120, 10, "s"));*/
			
			var levelText:FlxText = new FlxText(0, 0, 70, "Level: End");
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