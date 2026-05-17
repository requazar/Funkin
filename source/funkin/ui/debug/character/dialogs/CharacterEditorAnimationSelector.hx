package funkin.ui.debug.character.dialogs;

import haxe.ui.events.FocusEvent;
import haxe.ui.focus.FocusManager;
import haxe.ui.core.Screen;
import haxe.ui.containers.ListView;

class CharacterEditorAnimationSelector extends ListView
{
  var instance:CharacterEditorState;

  public function new(instance:CharacterEditorState)
  {
    super();
    this.instance = instance;

    width = 150;
    height = 200;

    x = 5;
    y = instance.playbar.screenTop - height - 5;

    refresh();
    show();

    registerEvent(FocusEvent.FOCUS_OUT, onFocusOut);
    onChange = _ -> instance.character.playAnimation(selectedItem, true);

    FlxG.console.registerObject('animationSelector', this);
    Screen.instance.addComponent(this);
  }

  public function refresh():Void
  {
    dataSource.clear();

    // TODO: why cant i use `characterData.animations`?
    @:privateAccess
    for (anim in instance.character.animationOffsets.keys())
    {
      dataSource.add(anim);
    }

    selectedIndex = dataSource.indexOf(instance.character.getCurrentAnimation());
  }

  override public function show():Void
  {
    @:privateAccess
    instance.isHaxeUIDialogOpen = true;
    FocusManager.instance.focus = this;

    super.show();
  }

  override public function hide():Void
  {
    @:privateAccess
    instance.isHaxeUIDialogOpen = false;

    super.hide();
  }

  function onFocusOut(e:FocusEvent):Void
  {
    trace('focused out');
    hide();
  }
}
