// from https://github.com/dionjwa/nodejs-std/blob/master/test/Test.hx
package haxor.test;

import haxe.Timer;
import sys.FileSystem;

class TestByHaxor
{

	static function main()
	{
		var test_haxor : TestHolistic = new TestHolistic();
		test_haxor.Run("Cool Testing",onComplete);		
	}

    // function called when all tests finish
    static function onComplete(p_success:Bool) 
	{
		Timer.delay(function() { (untyped process).exit(p_success ? 0 : 1); }, 5);
    }

}