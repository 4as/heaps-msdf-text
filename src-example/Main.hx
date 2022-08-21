import hxd.Key;
import h2d.OutlinedText;
import hxd.Event;
import hxd.res.DefaultFont;
import hxd.Res;
import h2d.Font;
import h2d.Scene.ScaleModeAlign;
import hxd.Timer;
import hxd.Window;
import h2d.Text;

class Main extends hxd.App {
	public static var INSTANCE:Main;
	
	private var _fonts:Array<Font>;
	private var _header:Text;
	private var _status:Text;
	private var _text:OutlinedText;
	
	override function init() {
		super.init();
		
		final w = 800;
		final h = 600;
		
		final win:Window = Window.getInstance();
		win.resize(w, h);
		engine.backgroundColor = 0xDDDDDD;
		s2d.scaleMode = ScaleMode.Fixed(w, h, 1, ScaleModeAlign.Center, ScaleModeAlign.Center);
		Timer.smoothFactor = 0;
		
		_header = new Text(DefaultFont.get());
		_header.text = "Click anywhere to randomize the text\nWSAD to control outline properties\nArrow keys to control text properties\nSpace to toggle outlines";
		_header.textColor = 0;
		_header.textAlign = Center;
		_header.x = w/2;
		_header.y = _header.textHeight + 4;
		s2d.addChild(_header);
		
		
		_fonts = [DefaultFont.get(),
					Res.montserrat.toSdfFont(48, SDFChannel.MultiChannel), Res.montserrat.toSdfFont(48, SDFChannel.MultiChannel),
					Res.aldo.toSdfFont(64, SDFChannel.Red), Res.aldo.toSdfFont(64, SDFChannel.Green), Res.aldo.toSdfFont(64, SDFChannel.Blue), Res.aldo.toSdfFont(64, SDFChannel.Alpha)];
		
		_text = new OutlinedText( DefaultFont.get() );
		_text.font = Res.montserrat.toSdfFont(48, SDFChannel.MultiChannel);
		_text.textAlign = Center;
		_text.text = "xA";
		_text.textColor = 0x000000;
		_text.outlineColor = 0xff0000;
		_text.thickness = 0.5;
		_text.smoothness = 0;
		_text.outline = true;
		_text.outlineThickness = 0.4;
		_text.outlineSmoothness = 0.2;
		_text.x = w/2;
		_text.y = h/2 - _text.textHeight/2;
		_text.scaleX = 2;
		_text.scaleY = 2;
		s2d.addChild(_text);
		
		_status = new Text(DefaultFont.get());
		_status.textColor = 0;
		_status.textAlign = Center;
		_status.x = w/2;
		_status.y = h - _header.textHeight - 4;
		s2d.addChild(_status);
		
		win.addEventTarget(onEvent);
	}
	
	private function onEvent(e:Event) {
		switch(e.kind) {
			case EPush:
				_text.text = randomText(4,10);
				_text.font = _fonts[ Std.int(Math.random() * _fonts.length) ];
				_text.textColor = Std.int(Math.random() * 0xffffff);
				_text.outlineColor = Std.int(Math.random() * 0xffffff);
				_text.thickness = 0.25 + (Math.random()*0.5);
				_text.outlineThickness = 0.25 + (Math.random()*0.5);
				_text.smoothness = (1 - _text.thickness) * Math.random()/2;
				_text.outlineSmoothness = (1 - _text.outlineThickness) * Math.random()/2;
			case EKeyDown:
				switch(e.keyCode) {
					case Key.UP:
						_text.thickness += 0.1;
						if( _text.thickness >= 1 ) _text.thickness = 1;
					case Key.DOWN:
						_text.thickness -= 0.1;
						if( _text.thickness <= 0 ) _text.thickness = 0;
					case Key.RIGHT:
						_text.smoothness += 0.1;
						if( _text.smoothness >= 1 ) _text.smoothness = 1;
					case Key.LEFT:
						_text.smoothness -= 0.1;
						if( _text.smoothness <= 0 ) _text.smoothness = 0;
					case Key.W:
						_text.outlineThickness += 0.1;
						if( _text.outlineThickness >= 1 ) _text.outlineThickness = 1;
					case Key.S:
						_text.outlineThickness -= 0.1;
						if( _text.outlineThickness <= 0 ) _text.outlineThickness = 0;
					case Key.D:
						_text.outlineSmoothness += 0.1;
						if( _text.outlineSmoothness >= 1 ) _text.outlineSmoothness = 1;
					case Key.A:
						_text.outlineSmoothness -= 0.1;
						if( _text.outlineSmoothness <= 0 ) _text.outlineSmoothness = 0;
					case Key.SPACE:
						_text.outline = !_text.outline;
				}
			default:
		}
		
		if( e.kind == EPush || e.kind == EKeyDown ) {
			_status.text = "font: "+_text.font.name+", thickness: "+_text.thickness+", smoothness: "+_text.smoothness+"\noutline thickness: "+_text.outlineThickness+", outline smoothness: "+_text.outlineSmoothness;
		}
	}
	
	private static final CHAR_AA:Int = "A".charCodeAt(0);
	private static final CHAR_ZZ:Int = "Z".charCodeAt(0);
	private static final CHAR_A:Int = "a".charCodeAt(0);
	private static final CHAR_Z:Int = "z".charCodeAt(0);
	
	private function randomText(min_size:Int, max_size:Int):String {
		if( min_size < 1 ) min_size = 1;
		if( max_size < min_size ) return "";
		final buf:StringBuf = new StringBuf();
		var size:Int = max_size - min_size;
		var upper_size:Int = CHAR_ZZ - CHAR_AA;
		var lower_size:Int = CHAR_Z - CHAR_Z;
		for(i in 0...size) {
			var r:Float = Math.random();
			if( r < 0.5) {
				buf.addChar( CHAR_A + Std.int(r*2*lower_size));
			}
			else {
				buf.addChar( CHAR_AA + Std.int((r-0.5)*2*upper_size));
			}
		}
		return buf.toString();
	}
	
	
	public static function main() {
		Res.initEmbed();
		INSTANCE = new Main();
	}
}



