package zygame.core;

import haxe.macro.Compiler;
import zygame.display.FPSDebug;
import h2d.Scene.ScaleMode;
import zygame.utils.ScaleUtils;
import hxd.App;

/**
 * 启动类
 */
class Start extends App {
	public static var current:Start;

	/**
	 * 启动类入口
	 * @param c 启动类
	 * @param hdwidth 适配宽度
	 * @param hdheight 适配高度
	 * @param debug 是否开启调试，如果开启调试，左上角会显示`zygame.display.FPSDebug`对象
	 */
	public static function initApp(c:Class<Dynamic>, hdwidth:Float, hdheight:Float, debug:Bool = false):Void {
		trace("Start.initApp");
		#if android
		// 先不要那么着急初始化
		current = Type.createInstance(c, [hdwidth, hdheight, debug]);
		#elseif wechat
		untyped window.start = function() {
			current = Type.createInstance(c, [hdwidth, hdheight, debug]);
		}
		#else
		current = Type.createInstance(c, [hdwidth, hdheight, debug]);
		#end
	}

	private var _hdsize = {
		width: 0,
		height: 0
	}

	private var _debug:Bool = false;
	private var _debugDisplay:FPSDebug;

	/**
	 * 构造一个启动类
	 * @param width 适配宽度
	 * @param height 适配高度
	 * @param debug 是否开启调试信息
	 */
	public function new(width:Int = 1920, height:Int = 1080, debug:Bool = false) {
		super();
		_debug = debug;
		_hdsize.width = width;
		_hdsize.height = height;
	}

	override function init() {
		super.init();
		trace("Hashlink version:", Compiler.getDefine("hl_ver"));
		if (_debug) {
			_debugDisplay = new FPSDebug();
		}
		this.onResize();
	}

	override function onResize() {
		super.onResize();
		trace("stage size:", this.s2d.width, this.s2d.height);
		__currentScale = ScaleUtils.mathScale(this.s2d.width, this.s2d.height, _hdsize.width, _hdsize.height);
		this.s2d.setScale(__currentScale);
		this.__stateSize.width = Math.round(s2d.width / __currentScale);
		this.__stateSize.height = Math.round(s2d.height / __currentScale);
		trace("changed scale:", __currentScale, "size:", this.stageWidth, this.stageHeight);
	}

	/**
	 * 当前缩放比例
	 */
	public var currentScale(get, never):Float;

	private var __currentScale:Float = 0;

	private var __stateSize = {
		width: 0.,
		height: 0.
	}

	function get_currentScale() {
		return __currentScale;
	}

	/**
	 * 获取舞台宽度
	 */
	public var stageWidth(get, never):Float;

	function get_stageWidth():Float {
		return __stateSize.width;
	}

	/**
	 * 获取舞台高度
	 */
	public var stageHeight(get, never):Float;

	function get_stageHeight():Float {
		return __stateSize.height;
	}

	override function update(dt:Float) {
		super.update(dt);
		if (_debugDisplay != null) {
			s2d.add(_debugDisplay);
			_debugDisplay.update();
		}
	}
}
