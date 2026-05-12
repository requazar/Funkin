package funkin.ui.debug.character;

import funkin.ui.debug.character.dialogs.CharacterEditorWelcomeDialog;
import flixel.math.FlxPoint;
import funkin.play.stage.Stage;
import funkin.graphics.FunkinCamera;
import funkin.util.WindowUtil;
import funkin.play.character.BaseCharacter;
import funkin.data.character.CharacterData;
import funkin.ui.debug.character.toolboxes.CharacterEditorBaseToolbox;
import haxe.ui.containers.windows.WindowManager;
import haxe.ui.backend.flixel.UIState;
import haxe.ui.focus.FocusManager;
import funkin.audio.FunkinSound;
import funkin.util.MouseUtil;
import haxe.ui.core.Screen;
import funkin.input.Cursor;
import flixel.FlxObject;

/**
 * Animation Editor if it wasn't larping as a usable editor
 *
 * By TilNotDrip & ADA_Funni
 */
@:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/character-editor/main-view.xml'))
class CharacterEditorState extends UIState
{
  /**
   * Default Position the character is placed in.
   */
  public static final DEFAULT_CHARACTER_POSITION:CharacterType = DAD;

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
   * The main focus point of the camera.
   */
  public var camFollow:FlxObject;

  /**
   * The main camera containing stage elements.
   * This includes the current character being edited.
   */
  public var camGame:FunkinCamera;

  /**
   * The camera containing all UI elements.
   */
  public var camHUD:FunkinCamera;

  var activeToolboxes:Map<String, CharacterEditorBaseToolbox> = new Map<String, CharacterEditorBaseToolbox>();

  /**
   * Whether the user is focused on an input in the Haxe UI, and inputs are being fed into it.
   * If the user clicks off the input, focus will leave.
   */
  var isHaxeUIFocused(get, never):Bool;

  function get_isHaxeUIFocused():Bool
  {
    return FocusManager.instance.focus != null;
  }

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

    camFollow = new FlxObject(0, 0, 1, 1);
    camFollow.screenCenter();
    add(camFollow);
    camGame.follow(camFollow, LOCKON);

    super.create();

    this.root.scrollFactor.set();
    this.root.cameras = [camHUD];
    this.root.width = FlxG.width;
    this.root.height = FlxG.height;

    WindowManager.instance.container = root;
    Screen.instance.addComponent(root);

    this.setupStage(null);
    this.setupCharacter('bf');
    this.setupUIListeners();

    Cursor.show();
    FunkinSound.playMusic('chartEditorLoop', {
      startingVolume: 0.0
    });
    FlxG.sound.music.fadeIn(10, 0, 1);

    CharacterEditorWelcomeDialog.build(this);
  }

  function setupUIListeners():Void
  {
    menubarItemToggleToolboxStage.onChange = event -> this.setToolboxState('ToolboxStage', event.value);
  }

  override public function update(elapsed:Float):Void
  {
    if (!isHaxeUIFocused)
    {
      var point:FlxPoint = camFollow.getPosition(FlxPoint.weak());
      MouseUtil.mouseCamDrag(point);
      camFollow.setPosition(point.x, point.y);
      point.put();

      MouseUtil.mouseWheelZoom();
    }

    super.update(elapsed);
  }

  /**
   * Reset the camera to focus on its default target.
   */
  public function resetCamera():Void
  {
    if (character != null)
    {
      camFollow.setPosition(character.cameraFocusPoint.x, character.cameraFocusPoint.y);
    }

    camGame.zoom = currentStage?.camZoom ?? 1.0;
  }
}
