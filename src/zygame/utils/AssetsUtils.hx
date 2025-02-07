package zygame.utils;

import haxe.io.Bytes;
#if !hl
import hxd.net.BinaryLoader;
#end

/**
 * 资源工具
 */
class AssetsUtils {
	/**
	 * 载入二进制数据，兼容hashlink，html5
	 * @param path 载入路径
	 * @param success 载入完成事件
	 * @param fail 载入失败事件
	 */
	public static function loadBytes(path:String, success:Bytes->Void, fail:String->Void):Void {
		#if hl
		var data = zygame.utils.hl.AssetsTools.getBytes(path);
		if (data != null) {
			success(data);
		} else {
			fail("load fail:" + path);
		}
		#else
		var loader = new BinaryLoader(path);
		loader.onProgress = function(a, b) {}
		loader.onLoaded = function(data) {
			success(data);
		};
		loader.onError = function(err) {
			fail("load fail:" + path);
		}
		loader.load();
		#end
	}
}
