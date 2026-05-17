package funkin.ui.debug.character;

import funkin.ui.debug.character.dialogs.CharacterEditorWelcomeDialog;
import funkin.ui.debug.character.dialogs.CharacterEditorAnimationSelector;
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
   * The data of the character that is currently being edited.
   */
  public var characterData:Null<CharacterData>;

  function get_characterData():Null<CharacterData>
  {
    @:privateAccess
    return character?._data;
  }

  /**
   * The onion skin shown behind the current character.
   */
  public var onionSkin:OnionSkin;

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

  var activeToolboxes:Map<CharacterEditorToolbox, CharacterEditorBaseToolbox> = new Map<CharacterEditorToolbox, CharacterEditorBaseToolbox>();
  var animationSelector:CharacterEditorAnimationSelector;

  /**
   * Whether the user is focused on an input in the Haxe UI, and inputs are being fed into it.
   * If the user clicks off the input, focus will leave.
   */
  var isHaxeUIFocused(get, never):Bool;

  function get_isHaxeUIFocused():Bool
  {
    return FocusManager.instance.focus != null;
  }

  /**
   * If a HaxeUI dialog is currently open.
   */
  var isHaxeUIDialogOpen:Bool = false;

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

    onionSkin = new OnionSkin(this);

    super.create();

    this.root.scrollFactor.set();
    this.root.cameras = [camHUD];
    this.root.width = FlxG.width;
    this.root.height = FlxG.height;

    WindowManager.instance.container = root;
    Screen.instance.addComponent(root);

    this.setupStage(null);
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
    menubarItemNewChar.onClick = _ -> CharacterEditorWelcomeDialog.build(this);

    menubarItemToggleToolboxData.onChange = event -> this.setToolboxState(Metadata, event.value);
    menubarItemToggleToolboxAnims.onChange = event -> this.setToolboxState(Animations, event.value);
    menubarItemToggleToolboxDeath.onChange = event -> this.setToolboxState(DeathProperties, event.value);
    menubarItemToggleToolboxStage.onChange = event -> this.setToolboxState(StagePreview, event.value);

    playbarAnimName.onClick = _ ->
    {
      if (animationSelector == null)
      {
        animationSelector = new CharacterEditorAnimationSelector(this);
      }
      else
      {
        animationSelector.show();
      }
    };
  }

  override public function update(elapsed:Float):Void
  {
    if (!isHaxeUIFocused && !isHaxeUIDialogOpen)
    {
      var point:FlxPoint = camFollow.getPosition(FlxPoint.weak());
      MouseUtil.mouseCamDrag(point);
      camFollow.setPosition(point.x, point.y);
      point.put();

      MouseUtil.mouseWheelZoom();

      // TODO: move this into an updateInput function
      if (FlxG.keys.justPressed.F)
      {
        onionSkin.visible = !onionSkin.visible;
        if (onionSkin.visible) onionSkin.createOnionSkin();
      }
    }
    @:privateAccess
    if (character != null)
    {
      playbarAnimName.text = character.getCurrentAnimation();
      playbarAnimOffsets.text = '[${character.animOffsets.join(', ')}]';

      playbarGlobalOffsets.text = '[${character.globalOffsets.join(', ')}]';
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
