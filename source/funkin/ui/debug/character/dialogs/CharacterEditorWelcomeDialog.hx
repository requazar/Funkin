package funkin.ui.debug.character.dialogs;

import haxe.ui.containers.dialogs.Dialog.DialogButton;
import funkin.data.character.CharacterData;
import haxe.ui.components.Link;
import funkin.util.SortUtil;

@:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/character-editor/dialogs/welcome.xml'))
class CharacterEditorWelcomeDialog extends CharacterEditorBaseDialog
{
  public function new(characterEditor:CharacterEditorState)
  {
    super(characterEditor);

    buildTemplateList();
  }

  function buildTemplateList():Void
  {
    var characterList:Array<String> = CharacterDataParser.listCharacterIds();
    characterList.sort(SortUtil.alphabetically);

    for (charId in characterList)
    {
      var charData:CharacterData = CharacterDataParser.fetchCharacterData(charId);
      if (charData.name == CharacterDataParser.DEFAULT_NAME) continue;

      var link:Link = new Link();
      link.text = charData.name;
      link.tooltip = charId;

      link.onClick = (_) ->
      {
        instance.setupCharacter(charId);
        hideDialog(DialogButton.CANCEL);
      };

      splashTemplateContainer.addComponent(link);
    }
  }

  public static function build(instance:CharacterEditorState, ?modal:Bool = true):Void
  {
    var dialog:CharacterEditorWelcomeDialog = new CharacterEditorWelcomeDialog(instance);
    dialog.showDialog(modal);
  }
}
