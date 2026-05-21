package funkin.ui.debug.character.toolboxes;

import haxe.ui.containers.dialogs.CollapsibleDialog;

/**
 * The base class for the Toolboxes (manipulatable, arrangeable control windows) in the Character Editor.
 */
@:access(funkin.ui.debug.charting.CharacterEditorState)
class BaseToolbox extends CollapsibleDialog
{
  var characterEditorState:CharacterEditorState;

  public function new(characterEditorState:CharacterEditorState)
  {
    super();
    this.destroyOnClose = false;

    this.characterEditorState = characterEditorState;
  }

  /**
   * Override to implement this.
   */
  public function refresh():Void
  {
  }
}
