package gmod.enums;
/**
    Used by game.AddAmmoType's input structure - the AmmoData structure.
	**Note:** These enumerations do not exist in game and are listed here only for reference!
**/
@:native("_G")
extern enum abstract AMMO(Int) {
    /**
        Forces player to drop the object they are carrying if the object was hit by this ammo type.
    **/
    var AMMO_FORCE_DROP_IF_CARRIED;
    /**
        Uses [AmmoData](https://wiki.garrysmod.com/page/Structures/AmmoData).plydmg of the ammo type as the damage to deal to shot players instead of [Bullet](https://wiki.garrysmod.com/page/Structures/Bullet).Damage.
    **/
    var AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER;
    
}