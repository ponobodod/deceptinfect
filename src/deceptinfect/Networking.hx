package deceptinfect;

import deceptinfect.GameManager.Net_GAME_STATE_VAL;
import deceptinfect.ecswip.ComponentManager.DI_ID;
import gmod.Networking;
@:build(gmod.macros.Networking.build())
class Networking {

    var InfectionMessage:NetMessageServer<N_InfectionMessageDef>;
    var GameState:NetMessageServer<N_GameState>;
    
}

typedef N_InfectionMessageDef = {
    infection : Float,
}



typedef N_GameState = {
    state : Net_GAME_STATE_VAL,
}

