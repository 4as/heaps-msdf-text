package h3d.shader;

class OutlinedSignedDistanceField extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.Base2d;

		@const var channel : Int = 0;
		@param var color : Vec3 = vec3(1,1,1);
		@param var thickness : Float = 0.5;
		@param var smoothness : Float = 0;
		@param var outline_color : Vec3 = vec3(0,0,0);
		@param var outline_thickness : Float = 0;
		@param var outline_smoothness: Float = 0;

		function median(r : Float, g : Float, b : Float) : Float {
			return max(min(r, g), min(max(r, g), b));
		}

		function fragment() {
			var textureSample : Vec4 = textureColor;
			var distance : Float;
			var outline:Float;
			var albedo:Vec3;
			
			if (channel == 0) {
				distance = textureSample.r;
				outline = distance;
			}
			else if (channel == 1) {
				distance = textureSample.g;
				outline = distance;
			}
			else if (channel == 2) {
				distance = textureSample.b;
				outline = distance;
			}
			else if (channel == 3) {
				distance = textureSample.a;
				outline = distance;
			}
			else {
				distance = median(textureSample.r, textureSample.g, textureSample.b);
				outline = textureSample.a;
			}
			
			distance = smoothstep(thickness - smoothness, thickness + smoothness, distance);
			outline = smoothstep(outline_thickness - outline_smoothness, outline_thickness + outline_smoothness, outline);
			
			albedo = mix(outline_color, color.rgb, distance);
			textureColor = vec4(albedo.r, albedo.g, albedo.b, outline);
		}
	}

}