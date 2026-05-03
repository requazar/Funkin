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
      if (instance.character != null)
      {
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

    instance.currentStage.revive();

    ScriptEventDispatcher.callEvent(instance.currentStage, new ScriptEvent(CREATE, false));
    instance.add(instance.currentStage);

    if (instance.character != null)
    {
      instance.currentStage.addCharacter(instance.character, instance.character.characterType);
      instance.currentStage.refresh();
    }
  }

  public static function setupCharacter(instance:CharacterEditorState, characterId:Null<String>):Void
  {
    var charType:Null<CharacterType> = instance.character?.characterType ?? CharacterType.DAD;

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
  }

  static var checkerboardStage:Null<CheckerboardStage>;
}
