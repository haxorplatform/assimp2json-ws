// from https://github.com/dionjwa/nodejs-std/blob/master/test/Test.hx
package haxor.test;

import sys.FileSystem;
import haxe.unit.TestRunner;
import haxor.test.TestBugs;

class Test
{

	static function main()
	{
		untyped TestRunner.print = console.log;

		if (haxe.macro.Compiler.getDefine("nodejs") != "1") {
			throw "nodejs compiler flag not defined";
		}

		var runner = new TestRunner();
		//runner.add(new TestSys());
		//runner.add(new TestNode());
		runner.add(new TestBugs());
		// your can add others TestCase here

		// Run them and and exit with the right return code
		var success = runner.run();
		(untyped process).exit(success ? 0 : 1);
	}
}