package  
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Utils 
	{
		
		public static function getDistance(p1:FlxPoint, p2:FlxPoint):Number
		{
			var xDist:Number = p1.x - p2.x;
			var yDist:Number = p1.y - p2.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			return distance;
		}
		
	}

}