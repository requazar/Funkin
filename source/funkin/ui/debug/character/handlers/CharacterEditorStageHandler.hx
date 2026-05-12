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

      if (instance.character != null)
      {
        // Make sure that shaders don't move over between stages.
        instance.character.shader = null;

        instance.currentStage.remove(instance.character);
        instance.currentStage.characters.clear();
      }

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

    final DIRECTORY:String = instance.currentStage?._data?.directory ?? 'shared';
    Paths.setCurrentLevel(DIRECTORY);

    instance.currentStage.revive();

    ScriptEventDispatcher.callEvent(instance.currentStage, new ScriptEvent(CREATE, false));
    instance.add(instance.currentStage);

    if (instance.character != null)
    {
      instance.currentStage.addCharacter(instance.character, instance.character.characterType);
      instance.currentStage.refresh();
    }

    instance.resetCamera();
  }

  public static function setupCharacter(instance:CharacterEditorState, characterId:Null<String>):Void
  {
    var charType:Null<CharacterType> = instance.character?.characterType ?? CharacterEditorState.DEFAULT_CHARACTER_POSITION;

    if (instance.character != null)
    {
      instance.currentStage.remove(instance.character);
      instance.currentStage.characters.clear();

      ScriptEventDispatcher.callEvent(instance.character, new ScriptEvent(DESTROY, false));

      instance.character.kill();
      instance.character.destroy();
      instance.character = null;
    }

    if (characterId != null)
    {
      instance.character = CharacterDataParser.fetchCharacter(characterId, true);
      instance.currentStage.addCharacter(instance.character, charType);
      instance.currentStage.refresh();
    }

    instance.resetCamera();
  }

  public static function moveCharStagePosition(instance:CharacterEditorState, charType:Null<CharacterType>, ?force:Bool = false):Void
  {
    if (instance.character?.characterType == charType && !force) return;

    // Make sure that shaders don't move over.
    instance.character.shader = null;

    instance.currentStage.remove(instance.character);
    instance.currentStage.characters.clear();

    instance.currentStage.addCharacter(instance.character, charType ?? CharacterEditorState.DEFAULT_CHARACTER_POSITION);
    instance.currentStage.refresh();

    instance.resetCamera();
  }

  static var checkerboardStage:Null<CheckerboardStage>;
}
