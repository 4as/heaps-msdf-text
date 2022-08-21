package h2d;

import h3d.shader.OutlinedSignedDistanceField;

/**
	Extension of standard `Text` with support for outlines.
	Creating outlines using SDFs can be a little tricky since we're dealing percentile values that rarely mean anything.
	If you intend to create outlines with precise pixel dimentions you need to consider the font's size, the distance value used to generate it, and what `thickness` you're using.
	Your best bet is probably just to guesstimate until it looks right.
**/
class OutlinedText extends Text {
	private final _shader:OutlinedSignedDistanceField = new OutlinedSignedDistanceField();
	private var _thickness:Float = 0;
	private var _smoothness:Float = 0;
	private var _outline:Bool = false;
	private var _outlineColor:Int = 0;
	private var _outlineThickness:Float = 0;
	private var _outlineSmoothness:Float = 0;
	private var _added:Bool;
	
	/**
		Creates a new Outlined Text instance.
		@param font The font used to render the Text. Only SDF fonts support outlines.
		@param parent An optional parent `h2d.Object` instance to which Text adds itself if set.
	**/
	public function new(font:Font, ?parent:Object) {
		super(font, parent);
	}
	
	override function set_font(value:Font):Font {
		if( _added ) {
			_added = false;
			this.textColor = this.textColor;
			removeShader(_shader);
		}
		super.font = value;
		if( sdfShader != null ) {
			color.set(1,1,1,color.w);
			
			_thickness = sdfShader.alphaCutoff;
			_smoothness = sdfShader.smoothing;
			_shader.channel = sdfShader.channel;
			__syncOutline();
			
			_added = true;
			removeShader(sdfShader);
			addShader(_shader);
		}
		return value;
	}
	
	override function set_textColor(value:Int):Int {
		super.textColor = value;
		if( _added ) {
			color.set(1,1,1,color.w); 
		}
		__syncOutline();
		return value;
	}
	
	/**
		Percentile value (0.0 - 1.0) of the distance cutoff point (same as 'alphaCutoff' in `BitmapFont.toSdfFont`) 
	**/
	public var thickness(get, set):Float;
	function get_thickness():Float { return _thickness; }
	function set_thickness(value:Float):Float {
		if( value < 0 ) value = 0;
		else if( value > 1 ) value = 1;
		_thickness = value;
		__syncOutline();
		return value;
	}
	
	/**
		Additional value added to `thickness` to dilute the cut off point creating antialiasing/blur.
	**/
	public var smoothness(get, set):Float;
	function get_smoothness():Float { return _smoothness; }
	function set_smoothness(value:Float):Float {
		_smoothness = value;
		__syncOutline();
		return value;
	}
	
	/**
		Whether to show outlines or not.
	**/
	public var outline(get, set):Bool;
	function get_outline():Bool { return _outline; }
	function set_outline(value:Bool):Bool {
		_outline = value;
		__syncOutline();
		return value;
	}
	
	/**
		Color of the outline.
	**/
	public var outlineColor(get, set):Int;
	function get_outlineColor():Int { return _outlineColor; }
	function set_outlineColor(value:Int):Int {
		_outlineColor = value;
		__syncOutline();
		return value;
	}
	
	/**
		Percentile value (0.0 - 1.0) of the distance cutoff point where the outlines ends.
		Outlines are rendered in the range between this value and the `thickness` value.
	**/
	public var outlineThickness(get, set):Float;
	function get_outlineThickness():Float { return _outlineThickness; }
	function set_outlineThickness(value:Float):Float {
		if( value < 0 ) value = 0;
		else if( value > 1 ) value = 1;
		_outlineThickness = value;
		__syncOutline();
		return value;
	}
	
	/**
		Additional value added to `outlineThickness` to dilute the cut off point creating antialiasing for outlines.
	**/
	public var outlineSmoothness(get, set):Float;
	function get_outlineSmoothness():Float { return _outlineSmoothness; }
	function set_outlineSmoothness(value:Float):Float {
		_outlineSmoothness = value;
		__syncOutline();
		return value;
	}
	
	private function __syncOutline() {
		_shader.color.setColor(this.textColor);
		if( _outline ) {
			if( _outlineThickness < _thickness ) {
				_shader.thickness = _thickness;
				_shader.outline_thickness = _outlineThickness;
			}
			else {
				_shader.thickness = _outlineThickness;
				_shader.outline_thickness = _thickness;
			}
			_shader.outline_color.setColor( _outlineColor );
			_shader.smoothness = _smoothness;
			_shader.outline_smoothness = _outlineSmoothness;
		}
		else {
			_shader.thickness = _thickness;
			_shader.smoothness = _smoothness;
			_shader.outline_color.set( _shader.color.r, _shader.color.g, _shader.color.b );
			_shader.outline_smoothness = _shader.smoothness;
			_shader.outline_thickness = _shader.thickness;
		}
	}
}