package funkin.ui.debug.character.handlers;

import haxe.ui.containers.dialogs.Dialog;

@:access(funkin.ui.debug.character.CharacterEditorState)
class ToolboxHandler
{
  public static function setToolboxState(state:CharacterEditorState, id:CharacterEditorToolbox, shown:Bool):Void
  {
    (shown ? showToolbox : hideToolbox)(state, id);
  }

  public static function showToolbox(state:CharacterEditorState, id:CharacterEditorToolbox):Void
  {
    var toolbox:Null<BaseToolbox> = state.activeToolboxes.get(id);
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

  public static function hideToolbox(state:CharacterEditorState, id:CharacterEditorToolbox):Void
  {
    var toolbox:Null<BaseToolbox> = state.activeToolboxes.get(id);

    if (toolbox == null)
    {
      trace('${' WARNING '.bg_yellow().bold()} Could not retrieve toolbox: $id');
      return;
    }

    toolbox.hideDialog(DialogButton.CANCEL);
    // TODO: play exitWindow sound
  }

  public static function buildToolbox(state:CharacterEditorState, id:CharacterEditorToolbox):Null<BaseToolbox>
  {
    var toolbox:Null<BaseToolbox> = switch (id)
    {
      case StagePreview:
        new StagePreviewToolbox(state);
      default:
        new TodoToolbox(state);
    };

    if (toolbox != null) state.activeToolboxes.set(id, toolbox);
    return toolbox;
  }
}

enum CharacterEditorToolbox
{
  Metadata;
  Animations;
  DeathProperties;
  StagePreview;
}
