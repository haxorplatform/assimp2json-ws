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
class ConvertService extends Service
{

	/**
	 * Reference to the main application.
	 */
	public var assimp(get, never):AssimpApp;
	private function get_assimp():AssimpApp { return cast app; }
	
	/**
	 * Path to the process.
	 */
	public var process(get, never):String;	
	private function get_process():String { return assimp.unix ? "../assimp2json/bin/assimp2json" : ""; }
	
	public var cmd(get, never):String;	
	private function get_cmd():String { return assimp.unix ? "sh" : "assimp2json.exe"; }
	
	public var args(get, never):Array<String>;	
	private function get_args():Array<String> { return assimp.unix ? ["-c",process] : []; }
		
	/**
	 * Init.
	 */
	override public function OnCreate():Void 
	{		
		route = new EReg("/convert","");
		persistent = true;
	}
	
	@route("get", "/$")	
	function Convert():Void
	{		
		var d : Dynamic = session.data.json == null ? {} : session.data.json;
		
		if (d.input == null)
		{
			d.input = assimp.unix  ? "../assimp2json/samples/spider.obj" : "Dinosaur.fbx";
		}

		var file_path : String = d.input;
		var file_name : String = file_path.split("/").pop();
		if (file_name.indexOf(".") >= 0) file_name = file_name.split(".")[0];
		
		if (file_name == null) file_name = "JsonModel"; else if (file_name == "") file_name = "JsonModel";
		
		var arg_list : Array<String> = args; 
		arg_list.push(file_path);
		
		Log("Converting args["+arg_list.join(",")+"] to["+file_name+".json]",1);
		
		//Default limit is 8k
		var opt : ChildProcessSpawnOptions = cast { maxBuffer: 1024 * 1024 * 500 };
		
		//Spawn showed to be more reliable
		var cp : Dynamic = ChildProcess.spawn(cmd,arg_list,opt); 
		
		//Working with buffers is best for this kind of operation.
		var buffers : Array<Buffer> = [];
		
		cp.stdout.on("data", function (d:Buffer) 
		{
			buffers.push(d);			
		});
		
		cp.on("error", function(p_error:Error):Void
		{
			Log(p_error);
			session.response.write("fail");
			session.response.end();
		});
		
		cp.on("close", function(p_code:Int)
		{
			Log("Assimp Complete code["+p_code+"]");
			var result : Buffer = Buffer.concat(buffers);
			session.response.setHeader("Content-disposition", "attachment; filename='"+file_name+".json'");
			session.response.setHeader("Content-type", "application/json");
			session.response.setHeader("Content-Length", result.length + "");				
			session.response.write(result);
			session.response.end();
		});		
	}

}