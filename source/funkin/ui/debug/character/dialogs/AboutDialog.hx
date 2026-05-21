package funkin.ui.debug.character.dialogs;

@:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/character-editor/dialogs/about.xml'))
class AboutDialog extends BaseDialog
{
  public function new(characterEditor:CharacterEditorState)
  {
    super(characterEditor);
  }

  public static function build(instance:CharacterEditorState, ?modal:Bool = true):Void
  {
    var dialog:AboutDialog = new AboutDialog(instance);
    dialog.showDialog(modal);
  }
}
