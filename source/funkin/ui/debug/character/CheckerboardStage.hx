package funkin.ui.debug.character;

import funkin.data.stage.StageData;
import flixel.util.FlxColor;
import funkin.play.stage.Stage;
import flixel.addons.display.FlxGridOverlay;
import openfl.display.BitmapData;
import flixel.addons.display.FlxBackdrop;

/**
 * Checkerboard used for the Character Editor.
 */
class CheckerboardStage extends Stage
{
  /**
   * Size of each cell in the backdrop.
   */
  public static final CELL_SIZE:Int = 10;

  /**
   * First color used in the backdrop.
   */
  public static final CELL_COLOR_1:FlxColor = 0xFFE7E6E6;

  /**
   * Second color used in the backdrop.
   */
  public static final CELL_COLOR_2:FlxColor = 0xFFD9D5D5;

  var bg:FlxBackdrop;

  public function new()
  {
    super('checkerboard');
  }

  override function buildStage():Void
  {
    var bitmap:BitmapData = FlxGridOverlay.createGrid(CELL_SIZE, CELL_SIZE, FlxG.width, FlxG.height, true, CELL_COLOR_1, CELL_COLOR_2);

    bg = new FlxBackdrop(bitmap);
    bg.zIndex = 0;
    add(bg);
  }

  override function _fetchData(_):Null<StageData>
  {
    // Use `mainStage` data to prevent a crash.
    return super._fetchData('mainStage');
  }

  override public function update(elapsed:Float):Void
  {
    bg.scale.set(1 / FlxG.camera.zoom, 1 / FlxG.camera.zoom);
    bg.updateHitbox();

    super.update(elapsed);
  }
}
