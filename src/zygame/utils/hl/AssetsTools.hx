package zygame.utils.hl;

import hxd.File;
import haxe.io.Bytes;

/**
	Hashlink的资源工具
**/
class AssetsTools {
	#if android
	@:hlNative("Java_org_haxe_HashLinkActivity")
	private static function getAssetBytes(path:String):hl.Bytes {
		return null;
	}

	@:hlNative("Java_org_haxe_HashLinkActivity")
	private static function tmpSize():Int {
		return 0;
	}
	#end

	/**
	 * 通过路径获取二进制数据
	 * @param path 
	 * @return Bytes
	 */
	static public function getBytes(path:String):Bytes {
		#if android
		var bytes = getAssetBytes(path);
		if (bytes == null)
			return null;
		var tmpSize = tmpSize();
		return bytes.toBytes(tmpSize);
		#elseif ios
		trace("ios load file:", path);
		return File.getBytes("assets/" + path);
		#elseif mac
		var root = Sys.programPath();
		root = root.substr(0, root.lastIndexOf("/"));
		return File.getBytes(root + "/../Resources/" + path);
		#elseif hl
		return File.getBytes(path);
		#else
		return null;
		#end
	}
}
