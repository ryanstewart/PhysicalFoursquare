/**
 * Ryan Stewart - http://blog.digitalbackcountry.com
 * ryan@adobe.com
 *  
 * This project was created to show off a Flash application on mobile devices.
 * It was customized to run for the screen size of the Nexus One but should work
 * on any other device that supports Flash.
 * 
 * ----------------------------------------------------------------------------
 *  "THE BEER-WARE LICENSE" (Revision 42):
 * <ryan@adobe.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return 
 * 															=Ryan Stewart
 * ----------------------------------------------------------------------------
 */

package components
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class NavigationButton extends SimpleButton
	{
		protected var _label:String;
		protected var _width:Number;
		protected var _height:Number;
		protected var _textField:TextField;
		
		public function NavigationButton(label:String=null,width:Number=160,height:Number=100,upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			_label = label;
			_width = width;
			_height = height;
			super(upState, overState, downState, hitTestState);
			init();
		}

		protected function init():void
		{
			var state:Sprite = null;
			var hit:Shape = null;
			
			var colors:Array = [0xffffff,0xb8d54f,0x0b743b];
			var alphas:Array = [1,0.5,0.5];
			var ratios:Array = [0,0x7f,0xff];
			var matrix:Matrix = new Matrix();
				matrix.createGradientBox(_width,_height,90 * ( Math.PI / 180 ));
			
			var format:TextFormat = new TextFormat();
				format.color = 0xffffff;
				format.bold = true;
				format.size = 24;
				format.align = TextAlign.CENTER;
				format.font = "Folks";
				
			var glow:GlowFilter = new GlowFilter();
				glow.color = 0x009245;
				glow.blurX = 10;
				glow.blurY = 10;
			
			// Up	
			state = new Sprite();
			state.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
			state.graphics.drawRect(0,0,_width,_height);
			state.graphics.endFill();
	
			_textField = new TextField();
			_textField.text = _label;
			_textField.embedFonts = true;
			_textField.setTextFormat(format);
			_textField.width = _width;
			_textField.height = _height;
			_textField.selectable = false;
			_textField.filters = [glow];
			_textField.y = 38;
			
			state.addChild(_textField);
			
			upState = state;
			
			
			// Hit Area
			hit = new Shape();
			hit.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
			hit.graphics.drawRect(0,0,_width,_height);
			hit.graphics.endFill();
			
			hitTestState = hit;			
			
			// Over
			colors = [0xffffff,0xb8d54f,0x0b743b];
			alphas = [1,0.5,0.5];
			
			state = new Sprite();
			state.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
			state.graphics.drawRect(0,0,_width,_height);
			state.graphics.endFill();
			
			_textField = new TextField();
			_textField.text = _label;
			_textField.embedFonts = true;
			_textField.setTextFormat(format);
			_textField.width = _width;
			_textField.height = _height;
			_textField.selectable = false;
			_textField.filters = [glow];
			_textField.y = 38;
			
			state.addChild(_textField);
			
			overState = state;				

			// Down
			colors = [0xffffff,0xb8d54f,0x0b743b];
			alphas = [0.75,0.75,0.75];
			
			glow.color = 0xcccccc;
			
			state = new Sprite();
			state.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
			state.graphics.drawRect(0,0,_width,_height);
			state.graphics.endFill();
			
			_textField = new TextField();
			_textField.text = _label;
			_textField.embedFonts = true;
			_textField.setTextFormat(format);
			_textField.width = _width;
			_textField.height = _height;
			_textField.selectable = false;
			_textField.filters = [glow];
			_textField.y = 38;
			
			state.addChild(_textField);
			
			downState = state;			
		}
	}
}	