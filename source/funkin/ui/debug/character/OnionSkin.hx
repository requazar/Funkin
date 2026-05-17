package funkin.ui.debug.character;

import funkin.play.character.BaseCharacter;
import flixel.math.FlxMatrix;
import funkin.graphics.FunkinCamera;
import animate.internal.RenderTexture;
import funkin.graphics.FunkinSprite;

@:access(animate.FlxAnimate) @:access(flixel.FlxSprite)
class OnionSkin extends FunkinSprite
{
  final instance:CharacterEditorState;
  var copyMatrix:FlxMatrix;

  public function new(instance:CharacterEditorState)
  {
    super();

    this.instance = instance;
    copyMatrix = new FlxMatrix();

    this.visible = false;
  }

  /**
   * Updates the onion skin to use the current frame of the character.
   * This will persist.
   */
  public function createOnionSkin():Void
  {
    if (character == null) return;

    followCharacterMatrix();

    this.setColorTransform();
    this.character.colorTransform.concat(this.character.colorTransform);
    this.blend = character.blend;
    this.antialiasing = character.antialiasing;
    this.shader = character.shader;
    this.alpha = 0.5; // should you be able to change this?

    var bounds:Array<Int> = character.isAnimate ? [

      Math.ceil(character.timeline._bounds.width),
      Math.ceil(character.timeline._bounds.height)
    ] : [
      Math.ceil(character.frame.frame.width),
      Math.ceil(character.frame.frame.height)
      ];

    if (_renderTexture == null)
    {
      _renderTexture = new RenderTexture(bounds[0], bounds[1]);

      // Replace the render texture's camera with a FunkinCamera
      // This allows the blend shader to work inside the render texture!
      @:privateAccess
      _renderTexture._camera = new FunkinCamera('', 0, 0, bounds[0], bounds[1]);
    }

    _renderTexture.init(bounds[0], bounds[1]);
    _renderTexture.drawToCamera((camera, matrix) ->
    {
      if (character.isAnimate)
      {
        matrix.translate(-character.timeline._bounds.x, -character.timeline._bounds.y);
        character.timeline.draw(camera, matrix, null, null, antialiasing, null);
      }
      else
      {
        camera.drawPixels(character._frame, character.framePixels, matrix, null, null, antialiasing, null);
      }
    });

    _renderTexture.render();
  }

  function followCharacterMatrix():Void
  {
    var bounds = character.timeline?._bounds;
    copyMatrix.identity();

    if (isAnimate)
    {
      if (character.checkFlipX())
      {
        copyMatrix.scale(-1, 1);
        copyMatrix.translate(bounds.width, 0);
      }

      if (character.checkFlipY())
      {
        copyMatrix.scale(1, -1);
        copyMatrix.translate(0, bounds.height);
      }
    }
    else
    {
      character._frame.prepareMatrix(copyMatrix, ANGLE_0, character.checkFlipX(), character.checkFlipY());
    }

    var doStageMatrix:Bool = character.isAnimate && character.applyStageMatrix;
    if (doStageMatrix) copyMatrix.translate(-bounds.x, bounds.y);

    copyMatrix.translate(-character.origin.x, -character.origin.y);
    copyMatrix.scale(character.scale.x, character.scale.y);

    if (character.angle != 0)
    {
      character.updateTrig();
      copyMatrix.rotateWithTrig(character._cosAngle, character._sinAngle);
    }

    if (character.skew.x != 0 || character.skew.y != 0)
    {
      character.updateSkew();
      copyMatrix.concat(animate.FlxAnimate._skewMatrix);
    }

    if (doStageMatrix) copyMatrix.concat(character.library.matrix);

    copyMatrix.tx += character.origin.x - character.offset.x;
    copyMatrix.ty += character.origin.y - character.offset.y;

    copyMatrix.tx -= (character.animOffsets[0] - character.globalOffsets[0]) * character.scale.x;
    copyMatrix.ty -= (character.animOffsets[1] - character.globalOffsets[1]) * character.scale.y;

    // getScreenPosition still needs to be updated.
    this.setPosition(character.x, character.y);
    this.scrollFactor.set(character.scrollFactor.x, character.scrollFactor.y);
  }

  override public function draw():Void
  {
    if (!visible || _renderTexture == null) return;

    for (camera in getCamerasLegacy())
    {
      if (!camera.visible || !camera.exists) continue;

      var matrix = this._matrix;
      matrix.copyFrom(copyMatrix);

      getScreenPosition(_point, camera);
      matrix.translate(_point.x, _point.y);

      camera.drawPixels(_renderTexture.graphic.imageFrame.frame, null, matrix, colorTransform, blend, antialiasing, shader);
    }
  }

  var character(get, never):Null<BaseCharacter>;

  function get_character():Null<BaseCharacter>
  {
    return instance?.character;
  }
}
