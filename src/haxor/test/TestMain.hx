// from https://github.com/dionjwa/nodejs-std/blob/master/test/Test.hx
package haxor.test;


import sys.FileSystem;
import haxe.unit.TestRunner;
import haxor.test.TestBugs;
import haxor.test.TestAsync;
import async.tests.AsyncTestRunner;


class TestMain
{

	public static var success : Bool;

	static function main()
	{
		untyped TestRunner.print = console.log;

		if (haxe.macro.Compiler.getDefine("nodejs") != "1") {
			throw "nodejs compiler flag not defined";
		}
		
		var runner = new TestRunner();
		runner.add(new TestBugs());
		success = runner.run();

        var r = new async.tests.AsyncTestRunner(onComplete);
        r.add(new TestAsync());
        r.run();
	}

    // function called when all tests finish
    static function onComplete() 
	{
		(untyped process).exit(success ? 0 : 1);
    }

}