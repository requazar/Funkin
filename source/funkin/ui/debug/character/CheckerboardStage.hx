package funkin.ui.debug.character;

import funkin.data.stage.StageData;
import flixel.util.FlxColor;
import funkin.play.stage.Stage;
import flixel.math.FlxMath;
import flixel.addons.display.FlxGridOverlay;
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
    bg = new FlxBackdrop(FlxGridOverlay.createGrid(CELL_SIZE, CELL_SIZE, Std.int(CELL_SIZE * 2), Std.int(CELL_SIZE * 2), true, CELL_COLOR_1, CELL_COLOR_2));
    bg.zIndex = 0;
    // add(bg);
  }

  override function _fetchData(_):Null<StageData>
  {
    final stageData:StageData = new StageData();

    stageData.characters = {
      bf: {
        zIndex: 300,
        position: [989.5, 885],
        scroll: [1, 1],
        cameraOffsets: [-100, -100]
      },
      dad: {
        zIndex: 200,
        position: [335, 885],
        scroll: [1, 1],
        cameraOffsets: [150, -100]
      },
      gf: {
        zIndex: 100,
        cameraOffsets: [0, 0],
        scroll: [1, 1],
        position: [751.5, 787]
      }
    };

    return stageData;
  }

  override public function update(elapsed:Float):Void
  {
    bg.scale.set(1 / FlxG.camera.zoom, 1 / FlxG.camera.zoom);
    bg.updateHitbox();

    super.update(elapsed);
  }
}
