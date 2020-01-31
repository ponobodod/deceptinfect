package deceptinfect;

import deceptinfect.ecswip.ComponentManager;

import gmod.Hooks;
import lua.Lua;
import tink.core.Annex;
import gmod.hooks.Gm.GmPlayerCanHearPlayersVoiceHaxeReturn;
import gmod.HaxeMultiReturn;
import gmod.libs.MathLib;
import gmod.types.Vector;
import gmod.libs.EntsLib;
import gmod.gclass.Player;
import deceptinfect.DI_Player;
import gmod.types.Entity;
using gmod.PairTools;
using gmod.TableTools;
using deceptinfect.PlayerExt;

@:build(gmod.macros.GamemodeMacro.build())
class DeceptInfect extends gmod.hooks.Gm {

    #if server

    
    override function PlayerDeath(victim:Player, inflictor:Entity, attacker:Entity) {
        trace("Player ded!");
    }
    
    override function EntityKeyValue(ent:Entity, key:String, value:String):String {
        trace(Lua.tostring(ent),key,value);
        return null;
    }

    override function PlayerInitialSpawn(player:Player, transition:Bool) {
        player.annex = new Annex(player);
        // var ent = new DI_Entity(player);
        // ComponentManager.addEnt(ent);

        new DI_Player(player); //calls get to initalise
        // new DI_Player(player);
        //FIXME
        // switch (currentState) {
        //     case PLAY(_):
        //         player.KillSilent();
        //         GAMEMODE.PlayerSpawnAsSpectator(player);
        //     default:
        // }

    }

    override function PlayerDeathThink(ply:Player):Bool {
        var plyr:DI_Player = ply;
        
        return true;
    }

    override function Think() {
        
    }
    override function IsSpawnpointSuitable(ply:Player, spawnpoint:Entity, makeSuitable:Bool):Bool {
        var pos = spawnpoint.GetPos();
        var blockers = EntsLib.FindInBox(pos + new Vector(-16,-16,0), pos + new Vector(16,16,72));
        for (ent in blockers) {
            if (ent.IsPlayer()) {
                ply.setWalkthroughable(true);
            }
        }
        return true;
    }
    
    override function PlayerSelectSpawn(ply:Player, transition:Bool):Entity {
        var spawns = EntsLib.FindByClass("info_player_start");
        var random_spawn = MathLib.random(spawns.length());
        if (GAMEMODE.IsSpawnpointSuitable(ply,spawns[random_spawn],false)) {
            return spawns[random_spawn];
        }
        return null;
    }

    override function PlayerCanHearPlayersVoice(listener:Player, talker:Player):HaxeMultiReturn<GmPlayerCanHearPlayersVoiceHaxeReturn> {
        
        return {a : false, b: false};
        // if (listener.GetPos().Distance(talker.GetPos()) > 1000) {
        //    return {a : false,b : false};
        // }
        // var _talker:DI_Player = talker;
        // if (_talker.grab.isGrabbed) {
        //     return {a : false, b : true}
        // }
        // return {a : true, b : true}
        
        // 
        // if (_talker.) {
        //     return {

        //     }
        // }
    }
    #end
    
}


// enum GAME_STATE {
//     WAIT;
//     PLAY(st:PLAY_STATE);
// }

// enum PLAY_STATE {
//     NORMAL;
//     EVAC;
// }
