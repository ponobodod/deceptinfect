package deceptinfect;

import deceptinfect.game.components.AliveComponent;
import deceptinfect.Classes.Weapons;
import deceptinfect.ecswip.PlayerComponent;
using deceptinfect.util.ArrayTools;
@:keep
class WeaponSystem extends System {

    var currentStage:WeaponStage = INITAL;

    var timevalues:Map<WeaponStage,Float> = [
        TWO => 2.0,
        THREE => 5.0,
        FINAL => 8.0
    ];

    var weapons_give:Map<WeaponStage,Array<Weapons>> = [

        INITAL => [weapon_mor_usp],
        TWO => [weapon_mor_ump],
        THREE => [],
        FINAL => []
    ];

    #if server
    override function init_server() {

    }

    override function run_server() {
        switch (GameManager.state) { // replace with weapon menu
        case PLAYING(x):
            if (x.totalGameTime > timevalues.get(currentStage)) { //mins, secs, conversion :)
                for (ent in entities) {
                    switch [ent.get(PlayerComponent),ent.get(AliveComponent)] {
                    case [Comp(c_ply),Comp(_)]:
                        c_ply.player.Give(weapons_give.get(currentStage).getRandom()); //give weapon? upgrade weapon? hmmm
                    default:
                    }
                }
                incrementStage();
            }
        default:
        }
    }

    public function giveInitalWeapons() {
        for (ent in entities) {
            switch [ent.get(PlayerComponent),ent.get(AliveComponent)] {
                case [Comp(c_ply),Comp(_)]:
                    c_ply.player.Give(weapons_give.get(INITAL).getRandom());
                default:
            }
        }
    }

    function incrementStage() {
        currentStage = switch currentStage {
            case FINAL:
                FINAL;
            case x:
                WeaponStage.createByIndex(x.getIndex() + 1);
        }
    }
    #end
}

enum WeaponStage {
    INITAL;
    TWO;
    THREE;
    FINAL;
}
