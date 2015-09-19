package haxor.test;
import haxe.Timer;
import haxor.server.AssimpApp;
import nws.Resource.MetaData;

/**
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TestAssimpApp extends AssimpApp
{

	/**
	 * Entry point.
	 */
	static function main():Void { new TestAssimpApp(); }
	
	/**
	 * Reference to the test container.
	 */
	public var test : TestController;
	
	/**
	 * Init.
	 */
	override public function OnInitialize():Void 
	{
		
		super.OnInitialize();
		
		test = cast CreateChild("test", TestController);
		
		Timer.delay(function()
		{
			test.Run("Assimp Test Suit");
		}, 2000);
	}
	
	
}