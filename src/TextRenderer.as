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
		private var monoX:Number = 180;
		private var monoY:Number = 200;
		private var monoFadeTime:Number = 3;
		private var monoColor:uint = 0xff9696FF;
		private var monoShadow:uint = 0xff333333;
		
		private var timetonames:Number = 6;
		
		public function TextRenderer() 
		{
			textArray = new Array();
		}
		
		public function renderText(text:FlxText,fade:Boolean = false , timetofade:Number = 1):void {
			textArray.push(new Array(text, fade, timetofade, 0, Utils.hill));
			this.add(text);
			text.scrollFactor.x = text.scrollFactor.y = 0;
		}
		
		public function drawMonologue(text:String, fadeTime:Number = -1):void {
			var fText:FlxText = new FlxText(monoX, monoY, 150, text);
			//fText.setFormat("TextFont", 20, 0xffffffff, "left");
			fText.color = monoColor;
			fText.shadow = monoShadow;

			if (fadeTime == -1) {
				fadeTime = this.monoFadeTime;
			}
			renderText(fText, false, fadeTime);
		}
		
		public function drawTitle(text:String):void {
			renderText(new FlxText(10, 10, 200, text), true, timetonames);
		}
		
		override public function update():void {
			var elapsedtime:Number = FlxG.elapsed;
			for (var i:uint = 0; i < textArray.length; i++) {
				if (!textArray[i][1])
					continue;
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
				case Constants.purgatoryLevel:
					drawMonologue("You died on the " + getFloorString(Persistence.floorPlayerDiedOn) + " floor", 5);
					break;
			}
		}
		
		private function getFloorString(floor:Number):String {
			if (floor == 1) {
				return "1st";
			}else if (floor == 2) {
				return "2nd";
			}else if (floor == 3) {
				return "3rd";
			}else if (floor > 3) {
				return String(floor) + "th";
			}
			return "GETFLOORSTRING: INVALID FLOOR";
		}
		
		public function deathText():void {

			/*var maxFloor:uint = 8;

			var myfloor:uint = maxFloor - (FlxG.level - 1);
			
			var suffix:String = "";
			if (myfloor == 1) {
				suffix = "1st floor";
			}else if (myfloor == 2) {
				suffix = "2nd floor";
			}else if (myfloor == 3) {
				suffix = "3rd floor";
			}else if (myfloor > 3) {
				suffix = String(myfloor) + "th floor";
			}
			suffix = "You died on:\n" + suffix;
			var thetext:FlxText = new FlxText(FlxG.width / 2 - 0, FlxG.height / 2 - 0, 100, suffix);
			thetext.scale.x = thetext.scale.y = 2;
			thetext.color = monoColor;
			thetext.shadow = monoShadow;
			thetext.x = FlxG.width / 2 ;//- thetext.width*thetext.scale.x/2;
			thetext.y = FlxG.height / 2 - thetext.height*thetext.scale.y;
			renderText(thetext, true, 6);
			//drawMonologue(suffix);//Sleep*/
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