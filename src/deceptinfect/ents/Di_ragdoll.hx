package deceptinfect.ents;

import deceptinfect.game.CleanupEnt;
import deceptinfect.game.Ragdoll;
import deceptinfect.ecswip.GEntityComponent;
import gmod.sent.SentBuild;

class Di_ragdoll extends gmod.sent.SentBuild<gmod.sent.ENT_ANIM> {

    final properties:EntFields = {Base: "base_entity"};

    public var owner:Entity;
    public var id:DI_ID;


    override function Initialize() {
        self.SetModel(owner.GetModel());
        id = new GEntCompat(self).id;
        
        id.add_component(new Ragdoll());
        id.add_component(new CleanupEnt());
        
    }
}
