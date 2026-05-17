package funkin.ui.debug.character.handlers;

import funkin.play.character.BaseCharacter.CharacterType;
import funkin.modding.events.ScriptEvent;
import funkin.modding.events.ScriptEventDispatcher;
import funkin.data.character.CharacterData.CharacterDataParser;
import funkin.data.stage.StageRegistry;

@:access(funkin.play.stage.Stage)
class CharacterEditorStageHandler
{
  public static function setupStage(instance:CharacterEditorState, stageId:Null<String>):Void
  {
    if (instance.currentStage != null)
    {
      if (instance.currentStage.id == stageId || (stageId == null && instance.currentStage == checkerboardStage)) return;

      removeCharacterFromStage(instance);

      var event:ScriptEvent = new ScriptEvent(DESTROY, false);
      ScriptEventDispatcher.callEvent(instance.currentStage, event);

      instance.remove(instance.currentStage);
      instance.currentStage.kill();
      instance.currentStage = null;
    }

    if (stageId != null)
    {
      instance.currentStage = StageRegistry.instance.fetchEntry(stageId);
    }
    else
    {
      if (checkerboardStage == null) checkerboardStage = new CheckerboardStage();
      instance.currentStage = checkerboardStage;
    }

    if (instance.currentStage == null) return;

    var directory:String = instance.currentStage?._data?.directory ?? 'shared';
    Paths.setCurrentLevel(directory);

    instance.currentStage.revive();

    ScriptEventDispatcher.callEvent(instance.currentStage, new ScriptEvent(CREATE, false));
    instance.add(instance.currentStage);

    addCharacterToStage(instance);
  }

  public static function setupCharacter(instance:CharacterEditorState, characterId:Null<String>):Void
  {
    var charType:Null<CharacterType> = instance.character?.characterType ?? CharacterEditorState.DEFAULT_CHARACTER_POSITION;

    if (instance.character != null)
    {
      ScriptEventDispatcher.callEvent(instance.character, new ScriptEvent(DESTROY, false));

      instance.character.kill();
      instance.character.destroy();
      instance.character = null;
    }

    if (characterId != null)
    {
      instance.character = CharacterDataParser.fetchCharacter(characterId, true);
      instance.character.characterType = charType;
      addCharacterToStage(instance);
    }

    instance.resetCamera();
  }

  public static function moveCharStagePosition(instance:CharacterEditorState, charType:Null<CharacterType>, ?force:Bool = false):Void
  {
    if (instance.character?.characterType == charType && !force) return;

    removeCharacterFromStage(instance);
    instance.character.characterType = charType ?? CharacterEditorState.DEFAULT_CHARACTER_POSITION;
    addCharacterToStage(instance);
  }

  public static function removeCharacterFromStage(instance:CharacterEditorState):Void
  {
    if (instance.character != null)
    {
      // Make sure that shaders don't move over.
      instance.character.shader = null;

      instance.currentStage.remove(instance.character);
    }

    instance.currentStage.remove(instance.onionSkin);
    instance.currentStage.characters.clear();
  }

  public static function addCharacterToStage(instance:CharacterEditorState):Void
  {
    if (instance.character == null) return;

    instance.currentStage.addCharacter(instance.character, instance.character.characterType);

    instance.onionSkin.zIndex = instance.character.zIndex - 1;
    instance.currentStage.add(instance.onionSkin);

    instance.currentStage.refresh();
    instance.resetCamera();
  }

  static var checkerboardStage:Null<CheckerboardStage>;
}
