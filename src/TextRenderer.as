package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class TextRenderer extends FlxGroup 
	{
		
		private var textArray:Array;
		public function TextRenderer() 
		{
			textArray = new Array();
		}
		
		public function renderText(text:FlxText,fade:Boolean = false , timetofade:Number = 1) {
			textArray.push(new Array(text, fade, timetofade, 0, Utils.hill));
			this.add(text);
			text.scrollFactor.x = text.scrollFactor.y = 0;
		}
		
		override public function update():void {
			var elapsedtime:Number = FlxG.elapsed;
			for (var i:uint = 0; i < textArray.length; i++) {
				var thetext:FlxText = textArray[i][0] as FlxText;
				if (!thetext.alive) {
					continue;
				}
				textArray[i][3] += elapsedtime;
				trace(textArray[i][3]);
				thetext.alpha = Math.min(1, Math.max(0, textArray[i][4]((textArray[i][3]) / textArray[i][2])));
				if (textArray[i][3] >= textArray[i][2]) {
					thetext.kill();
				}
			}
		}
		
	}

}