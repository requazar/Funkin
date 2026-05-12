package funkin.ui.debug.character.handlers;

import funkin.ui.debug.character.toolboxes.CharacterEditorStagePreviewToolbox;
import funkin.ui.debug.character.toolboxes.CharacterEditorBaseToolbox;
import haxe.ui.containers.dialogs.Dialog.DialogButton;

@:access(funkin.ui.debug.character.CharacterEditorState)
class CharacterEditorToolboxHandler
{
  public static function setToolboxState(state:CharacterEditorState, id:String, shown:Bool):Void
  {
    if (shown)
    {
      showToolbox(state, id);
    }
    else
    {
      hideToolbox(state, id);
    }
  }

  public static function showToolbox(state:CharacterEditorState, id:String):Void
  {
    var toolbox:Null<CharacterEditorBaseToolbox> = state.activeToolboxes.get(id);
    if (toolbox == null) toolbox = buildToolbox(state, id);

    if (toolbox == null)
    {
      trace('${' WARNING '.bg_yellow().bold()} Could not retrieve toolbox: $id');
      return;
    }

    toolbox.showDialog(false);
    toolbox.refresh();

    // TODO: play openWindow sound
  }

  public static function hideToolbox(state:CharacterEditorState, id:String):Void
  {
    var toolbox:Null<CharacterEditorBaseToolbox> = state.activeToolboxes.get(id);

    if (toolbox == null)
    {
      trace('${' WARNING '.bg_yellow().bold()} Could not retrieve toolbox: $id');
      return;
    }

    toolbox.hideDialog(DialogButton.CANCEL);
    // TODO: play exitWindow sound
  }

  public static function buildToolbox(state:CharacterEditorState, id:String):Null<CharacterEditorBaseToolbox>
  {
    var toolbox:Null<CharacterEditorBaseToolbox> = switch (id)
    {
      case 'ToolboxStage':
        new CharacterEditorStagePreviewToolbox(state);
      default:
        null;
    };

    if (toolbox != null) state.activeToolboxes.set(id, toolbox);
    return toolbox;
  }
}
