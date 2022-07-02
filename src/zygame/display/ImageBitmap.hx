package zygame.display;

import h2d.RenderContext;
import h2d.Tile;
import zygame.core.Start;
import zygame.display.base.IDisplayObject;
import h2d.Bitmap;

/**
 * 图片显示对象
 */
class ImageBitmap extends Bitmap implements IDisplayObject {
	public var dirt:Bool = false;

	public function get_stageWidth():Float {
		return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	override function set_tile(t:Tile):Tile {
		this.dirt = true;
		return super.set_tile(t);
	}

	override function draw(ctx:RenderContext) {
		super.draw(ctx);
		this.dirt = false;
	}
}
