package haxor.test;
import haxe.Timer;
import js.Node;
import nws.controller.Controller;

/**
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TestController extends Controller
{

	@TestAsync("Async Request Test")
	@TestDescription("Validates if a simple request test works.","Eduardo")
	public function testRequest(p_callback:String->Void) : Void
	{
		Timer.delay(function()
		{
			var success :Bool = false;
			var err : String = "";			
			if (!success) err = "We found error :(";			
			p_callback(err);			
		},Std.int(500 + (Math.random() * 2000)));		
	}
	
	@Test("Fail 50%")
	@TestDescription("Simple dumb test 50% of failing.","Eduardo")
	public function testDumb() : String
	{
		return Math.random() < 0.5 ? "Some random error!" : "";
	}
	
	
}