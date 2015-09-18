package haxor.test;

import js.Node;
import js.node.Fs;
import async.tests.AsyncTestCase;
import haxe.Json;

class TestAsync extends AsyncTestCase
{

	public function testRequest()
	{
		var request = Node.require('request');
		var done = createAsync(onLoaded,5000);

		request('http://localhost:9090/convert/test', function (error, response, body) {
		   	done(response);
		});

	}

	function clean(str:Dynamic):String
	{
		str = StringTools.replace(str,'\t','');
		str = StringTools.replace(str,'\r','');
		str = StringTools.replace(str,'\n','');
		str = StringTools.replace(str,' ','');
		return str.substr(0,50);
	}

    function onLoaded(response:Dynamic) {
    	var data : Dynamic = Fs.readFileSync("./assimp2json/samples/spider.obj.assimp.json", 'utf8');
        assertTrue(clean(response.body)==clean(data));
    }

}