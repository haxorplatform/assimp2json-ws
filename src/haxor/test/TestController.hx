package haxor.test;
import haxe.Timer;
import haxor.unit.TestUnit;
import js.Node;
import nws.controller.Controller;

/**
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TestController extends TestUnit
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
	
	@TestAsync("Will Timeout Test",1.0)
	@TestDescription("Forces the test to fail by timeout.","Eduardo")
	public function testTimeout(p_callback:String->Void) : Void
	{
		//Delay wait 2s but timeout is 1s
		Timer.delay(function()
		{
			var success :Bool = true;
			var err : String = "";			
			if (!success) err = "We found error :(";			
			p_callback(err);			
		},2000);		
	}
	
	
}