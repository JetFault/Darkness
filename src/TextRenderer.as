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
		
		//[Embed(source = "../bin/data/Font1.ttf", fontFamily = "TextFont", embedAsCFF = "false")] protected var TextFont:String;
		
		private var textArray:Array;
		private var monoFadeTime:Number = 3;
		private var monoX:Number = 180;
		private var monoY:Number = 200;
		
		private var timetonames:Number = 6;
		
		public function TextRenderer() 
		{
			textArray = new Array();
		}
		
		public function renderText(text:FlxText,fade:Boolean = false , timetofade:Number = 1) {
			textArray.push(new Array(text, fade, timetofade, 0, Utils.hill));
			this.add(text);
			text.scrollFactor.x = text.scrollFactor.y = 0;
		}
		public function drawMonologue(text:String):void {
			var fText:FlxText = new FlxText(monoX, monoY, 150, text);
			//fText.setFormat("TextFont", 20, 0xffffffff, "left");
			fText.color = 0xff9696FF;
			fText.shadow = 0xff333333;
			renderText(fText, false, monoFadeTime);
		}
		public function drawTitle(text:String):void {
			renderText(new FlxText(10, 10, 200, text), true, timetonames);
		}
		
		override public function update():void {
			var elapsedtime:Number = FlxG.elapsed;
			for (var i:uint = 0; i < textArray.length; i++) {
				var thetext:FlxText = textArray[i][0] as FlxText;
				if (!thetext.alive) {
					continue;
				}
				textArray[i][3] += elapsedtime;
				thetext.alpha = Math.min(1, Math.max(0, textArray[i][4]((textArray[i][3]) / textArray[i][2])));
				if (textArray[i][3] >= textArray[i][2]) {
					thetext.kill();
				}
			}
		}
		public function monoLevel(level:Number):void {
			switch (level) {
				case 1:
					drawMonologue("8th floor");
					break;
				case 2:
					drawMonologue("7th floor");
					break;
				case 3:
					drawMonologue("6th floor");
					break;
				case 4:
					drawMonologue("5th floor");
					break;
				case 5:
					drawMonologue("4th floor");
					break;
				case 6:
					drawMonologue("3rd floor");
					break;
				case 7:
					drawMonologue("2nd floor");
					break;
				case 8:
					drawMonologue("1st floor");
					break;
				default:
					drawMonologue("TROLOLOLOLOLOLOL");
					break;
			}
		}
		public function deathText():void {
			//drawMonologue("U MAD?");//Sleep
		}
		public function LighterText():void {
			drawMonologue("Your view becomes clearer.");
		}
		public function UmbrellaText():void {
			drawMonologue("The storm seems to be getting worse...");
		}
		public function ClockText():void {
			drawMonologue("You feel quicker...");
		}
		
	}

}