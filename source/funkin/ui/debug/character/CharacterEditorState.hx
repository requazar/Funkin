package funkin.ui.debug.character;

import funkin.play.stage.Stage;
import funkin.graphics.FunkinCamera;
import funkin.util.WindowUtil;
import funkin.play.character.BaseCharacter;
import funkin.data.character.CharacterData;
import haxe.ui.containers.windows.WindowManager;
import haxe.ui.backend.flixel.UIState;
import haxe.ui.focus.FocusManager;
import funkin.audio.FunkinSound;
import funkin.util.MouseUtil;
import haxe.ui.core.Screen;
import funkin.input.Cursor;

/**
 * Animation Editor if it wasn't larping as a usable editor
 *
 * By TilNotDrip & ADA-Funni
 */
@:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/character-editor/main-view.xml'))
class CharacterEditorState extends UIState
{
  /**
   * The current instance of the Character Editor.
   */
  public static var instance:Null<CharacterEditorState> = null;

  /**
   * The character that is currently being edited.
   */
  public var character:BaseCharacter;

  /**
   * The current stage that the character is contained in.
   *
   * This will be a checkerboard pattern by default.
   */
  public var currentStage:Stage;

  /**
   * Whether the user is focused on an input in the Haxe UI, and inputs are being fed into it.
   * If the user clicks off the input, focus will leave.
   */
  var isHaxeUIFocused(get, never):Bool;

  function get_isHaxeUIFocused():Bool
  {
    return FocusManager.instance.focus != null;
  }

  var camGame:FunkinCamera;
  var camHUD:FunkinCamera;

  override public function create():Void
  {
    WindowManager.instance.reset();
    instance = this;
    FlxG.sound.music?.stop();
    WindowUtil.setWindowTitle("Friday Night Funkin' Character Editor");

    camGame = new FunkinCamera('gameCamera');
    camHUD = new FunkinCamera('hudCamera');

    camGame.bgColor.alpha = 0;
    camHUD.bgColor.alpha = 0;

    FlxG.cameras.reset(camGame);
    FlxG.cameras.add(camHUD, false);

    super.create();

    this.root.scrollFactor.set();
    this.root.cameras = [camHUD];
    this.root.width = FlxG.width;
    this.root.height = FlxG.height;

    WindowManager.instance.container = root;
    Screen.instance.addComponent(root);

    this.setupStage(null);
    this.setupCharacter('bf');

    Cursor.show();
    FunkinSound.playMusic('chartEditorLoop', {
      startingVolume: 0.0
    });
    FlxG.sound.music.fadeIn(10, 0, 1);
  }

  override public function update(elapsed:Float):Void
  {
    MouseUtil.mouseCamDrag();
    if (!isHaxeUIFocused) MouseUtil.mouseWheelZoom();

    super.update(elapsed);
  }
}
