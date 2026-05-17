package funkin.ui.debug.character.dialogs;

import haxe.ui.containers.dialogs.Dialog;

@:access(funkin.ui.debug.character.CharacterEditorState)
class CharacterEditorBaseDialog extends Dialog
{
  var instance:CharacterEditorState;

  public function new(instance:CharacterEditorState)
  {
    super();

    this.instance = instance;
    instance.isHaxeUIDialogOpen = true;

    this.onDialogClosed = event -> onClose(event);
    this.destroyOnClose = true;
  }

  /**
   * Called when the dialog is closed.
   * Override this to add custom behavior.
   * @param event The event.
   */
  public function onClose(event:DialogEvent):Void
  {
    instance.isHaxeUIDialogOpen = false;
  }
}
