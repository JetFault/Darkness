package  
{
	import flash.geom.Point;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxPath;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class RandomDFSAI extends EnemyAI 
	{		
		public function RandomDFSAI(self:Enemy, player:Player, map:Map, onpathcompletion:String, depth:Number) 
		{
			super(self, player, map, onpathcompletion, depth);
			this.xpos = 30;
			this.ypos = 2;
		}
		
		override protected function getAutoPath(currentpoint:FlxPoint):Array {
			return Utils.randomDFS(map, depth, currentpoint);
		}
	}
}