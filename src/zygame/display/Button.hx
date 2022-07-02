package zygame.display;

import hxd.Event;
import h2d.RenderContext;
import zygame.display.data.ButtonSkin;
import h2d.Object;

/**
	简易按钮，一般无需通过interactive重写onClick，可直接使用`onClick`访问点击事件。当只有up纹理时，按钮则启动缩放计算，存在up/down两种纹理时，则会切换呈现。
**/
class Button extends Flow {
	/**
		按钮皮肤
	**/
	public var skin:ButtonSkin;

	public var img:ImageBitmap;

	public var label:Label;

	public var text(get, set):String;

	public var labelOffest = {
		x: 0.,
		y: 0.
	}

	function get_text():String {
		return label.text;
	}

	function set_text(text:String):String {
		label.text = text;
		return text;
	}

	public function new(skin:ButtonSkin, ?parent:Object) {
		super(parent);
		this.dirt = true;
		this.skin = skin;
		trace(this.skin.up);
		img = new ImageBitmap(this.skin.up, this);
		this.enableInteractive = true;
		this.interactive.onPush = function(e) {
			img.scale(1);
			dirt = true;
			if (skin.down != null) {
				img.tile = skin.down;
			} else {
				// 缩放计算
				img.scaleX = 0.94;
				img.scaleY = 0.94;
				var rect = img.getBounds();
				img.x = rect.width * 0.03;
				img.y = rect.height * 0.03;
			}
		}
		this.interactive.onRelease = function(e) {
			img.tile = skin.up;
			img.scaleX = 1;
			img.scaleY = 1;
			img.x = img.y = 0;
			dirt = true;
		}
		this.interactive.onClick = function(e) {
			this.onClick(e);
		}
		label = new Label(null, img);
		label.textAlign = Center;
	}

	private function updateLabelContext():Void {
		label.x = img.tile.width / 2 + labelOffest.x;
		label.y = img.tile.height / 2 - label.textHeight / 2 - 6;
	}

	override function draw(ctx:RenderContext) {
		if (dirt || label.dirt || img.dirt) {
			this.updateLabelContext();
			dirt = false;
		}
		super.draw(ctx);
	}

	dynamic public function onClick(e:Event):Void {}
}
