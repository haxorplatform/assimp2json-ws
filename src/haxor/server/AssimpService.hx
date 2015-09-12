package haxor.server;


import js.Node;
import js.node.Buffer;
import js.node.fs.ReadStream;
import js.node.http.IncomingMessage;
import js.node.http.Server;
import js.node.http.ServerResponse;
import js.Error;
import haxe.Json;
import js.node.Url;
import nws.component.net.HttpSession;
import js.node.ChildProcess;

import js.node.Fs;
import nws.controller.service.Service;
/**
 * ...
 * @author Henrique Dias - henrique@gemeos.org
 */
class AssimpService extends Service
{

	/**
	 * Reference to the main application.
	 */
	public var assimp(get, never):AssimpApp;
	private function get_assimp():AssimpApp { return cast app; }
	
	/**
	 * Init.
	 */
	override public function OnCreate():Void 
	{		
		route = new EReg("/assimp","");
		persistent = true;
	}
	
	@route("get", "/convert")	
	function Convert():Void
	{
		var cmd : String = "../assimp2json/bin/assimp2json";

		var d : Dynamic = session.data.json;
		if(d!=null) if (d.input == null) d.input = "../assimp2json/samples/spider.obj";

		cmd += " " + d.input; 

		ChildProcess.execFile("sh", ["-c",cmd], {}, function(p_error:ChildProcessExecError, p_stdout:Dynamic, p_stderr:Dynamic):Void
		{
			if (p_error.code == null) {	
				session.response.write(p_stdout);			
				session.response.end();
			} else {
				session.response.write("error : " + Json.stringify(p_error) + "\n");
				session.response.write("stderr: " + Json.stringify(p_stderr) + "\n");
				session.response.write("stdout: " + Json.stringify(p_stdout) + "\n");
				session.response.end();
			}
		});

	}

}