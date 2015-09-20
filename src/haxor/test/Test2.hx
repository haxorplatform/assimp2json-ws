// from https://github.com/dionjwa/nodejs-std/blob/master/test/Test.hx
package haxor.test;

import sys.FileSystem;

class Test2
{

	static function main()
	{
		var test_haxor : TestHaxor = new TestHaxor();		
		test_haxor.Run("Cool Testing",onComplete);		
	}

    // function called when all tests finish
    static function onComplete(p_success:Bool) 
	{
		(untyped process).exit(p_success ? 0 : 1);
    }

}