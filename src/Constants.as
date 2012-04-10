package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Constants 
	{
	
		//Enemy run speed?
		//DFS Depth?
		//Will putting embedded files in here work?
		
		//Lightning variables
		public static var cameralightningdiff:Number = .3; //in [0,1].  originally 1
		public static var WITHOUTUMBRELLACOLOR:uint = 0x00d5d7ff; //0x00ffffff 0x00b5b7ff
		public static var WITHUMBRELLACOLOR:uint = 0x00c444ff;
		public static var looptime:Number = 15;
		public static var flashduration:Number = 1.5;
		public static var crashtime:Number = .01;
		public static var rumbletime:Number = 1.5;
		public static var soundthreshold:Number = 100;
		public static var functiontype:String = "sequential"; //From ["batch", "sequential"]  Former generates array, latter generates samples on fly
		public static var flashfunctionsequential:Function = Utils.stepwithgauss; //Functions in Utils.as.  Just insert function name here.  All univariate
		public static var flashfunctionbatch:Function = Utils.brownian;
		public static var periodic:Boolean = false;
		public static var crashduration:Number = 6;
		public static var rumbleduration:Number = 8;
		//Player variables
		public static var controlScheme:int  = 2;
		
		
		//Spotlight variables
		public static var scalelight:Boolean = false;
		public static var raytracelight:Boolean = false;
		
		//Darkness variables
		public static var darknesscolor:uint = 0x00000000;
		public static var DEFAULTDARKNESSCOLOR:uint = 0x00000000;
		public static var CLEARDARKNESSCOLOR:uint = 0x00ffffff;
		
		//Item Spawn Chance
		public static var itemSpawnPercent:Number = 10;
		
		//Enemy Placing Percent Location from Player
		public static var enemyPlacePercent:Number = 0.60;
		//Item Placing Percent Location from Player
		public static var itemPlacePercent:Number = 0.40;
		//Exit Placing Percent Location from Player
		public static var exitPlacePercent:Number = 0.75;
		
		public static var EMPTYTILEINDEX:Number = 0;
		
		
	}

}