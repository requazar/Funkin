package funkin.ui.debug.character.toolboxes;

import funkin.play.character.BaseCharacter.CharacterType;
import funkin.play.stage.Stage;
import funkin.data.stage.StageRegistry;

/**
 * Stage Preview Toolbox for the Character Editor.
 */
@:access(funkin.ui.debug.character.CharacterEditorState) @:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/character-editor/toolboxes/stage-preview.xml'))
class StagePreviewToolbox extends BaseToolbox
{
  /**
   * Names to use in the character position dropdown.
   */
  public static final CHARACTER_POSITIONS:Map<CharacterType, String> = [DAD => 'Dad (Opponent)', BF => 'BF (Player)', GF => 'Girlfriend'];

  public function new(instance:CharacterEditorState)
  {
    super(instance);
    initCallbacks();
  }

  override public function refresh():Void
  {
    super.refresh();
    initStageDropDown();
    initCharPositions();
  }

  function initCallbacks():Void
  {
    toolboxStageSelected.onChange = _ -> characterEditorState.setupStage(toolboxStageSelected.value.id);
    toolboxStageCharPos.onChange = _ -> characterEditorState.moveCharStagePosition(toolboxStageCharPos.value.id);

    toolboxStagePosMarker.onChange = event ->
    {
      trace('oh yeah we are definitely ${event.value ? 'showing' : 'hiding'} the position marker trust!!');
    };
  }

  function initStageDropDown():Void
  {
    toolboxStageSelected.dataSource.clear();

    var checkerboardData = {id: null, text: 'Checkerboard (None)'};
    toolboxStageSelected.dataSource.add(checkerboardData);

    var stageIds:Array<String> = StageRegistry.instance.listEntryIds();
    stageIds.sort(funkin.util.SortUtil.alphabetically);

    for (stageId in stageIds)
    {
      var stage:Null<Stage> = StageRegistry.instance.fetchEntry(stageId);
      if (stage == null) continue;

      toolboxStageSelected.dataSource.add({id: stage.id, text: stage.stageName});
    }

    toolboxStageSelected.value = checkerboardData;
  }

  function initCharPositions():Void
  {
    toolboxStageCharPos.dataSource.clear();

    for (type => name in CHARACTER_POSITIONS)
    {
      var value = {id: type, text: name};
      toolboxStageCharPos.dataSource.add(value);

      if (characterEditorState.character?.characterType == type)
      {
        toolboxStageCharPos.value = value;
      }
    }
  }
}
