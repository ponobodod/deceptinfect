package deceptinfect.game;

import gmod.helpers.PrintTimer;
import haxe.Exception;
import deceptinfect.radiation.RadiationAccepter;
import deceptinfect.radiation.ContaminationAccepter;
import deceptinfect.game.WinSystem.Win;
import deceptinfect.radiation.RadVictim;
import deceptinfect.infection.InfectionComponent;
import deceptinfect.infection.InfectionSystem;
import deceptinfect.radiation.RadSourceSystem;
import deceptinfect.ecswip.VirtualPosition;
import deceptinfect.GEntCompat;
import deceptinfect.ecswip.GEntityComponent;
import deceptinfect.macros.IterateEnt;
import deceptinfect.ents.Di_entities;
import deceptinfect.infection.components.*;
import deceptinfect.abilities.*;
import deceptinfect.infection.*;
import deceptinfect.ecswip.ReplicatedEntity;
import deceptinfect.ecswip.PlayerComponent;
import deceptinfect.grab.components.GrabSearcher;
import deceptinfect.grab.components.GrabSearchVictim;

using deceptinfect.util.PlayerExt;

import deceptinfect.GameManager2.GAME_STATE_2;

interface GameSystemI {
	function gameManagerAvaliable():Bool;
	function getGameManager():GameManager2;
	#if server
	function setState(newState:GAME_STATE_2):Void;
	function diffTime():Float;
	function beginInfected(ent:DI_ID):Void;
	function cleanup():Void;
	function isPlaying():Bool;
	function thinkWait():Void;
	function shouldAllowRespawn():Bool;
	#end
}

// TODO -- what do we name it? uhh it needs to exist
abstract class GameSystem extends System implements GameSystemI {}

class GameSystemDef extends GameSystem {
	var gameManager:GameManager2;

	var signalTrig:SignalTrigger<GAME_STATE_2> = new SignalTrigger();

	public function gameManagerAvaliable() {
		IterateEnt.iterGet([GameManager2], [gameManager], function() {
			return true;
		});
		return false;
	}

	public function getGameManager() {
		IterateEnt.iterGet([GameManager2], [gameManager], function() {
			return gameManager;
		});
		throw new Exception("Cannot find game manager");
	}

	#if server
	override function init_server() {
		var ent = componentManager.addEntity();
		gameManager = new GameManager2();
		gameManager.stateChanged = signalTrig.asSignal();
		ent.add_component(gameManager);
		ent.add_component(new ReplicatedEntity());
		trace("Entity created from server");
	}

	override function run_server() {
		PrintTimer.print_time(2, () -> trace(gameManager.state));
		switch (gameManager.state) {
			case WAIT:
				thinkWait();
			case SETTING_UP(time):
				if (Gmod.CurTime() > time) {
					setState(PLAYING);
				}
			case ENDING(time):
				if (Gmod.CurTime() > time) {
					setState(WAIT);
				}
			case PLAYING: // GameInProgressSystem
		}
		if (gameManager.diffTime == null) {
			gameManager.diffTime = 0.0;
		} else {
			gameManager.diffTime = Gmod.CurTime() - gameManager.lastTick;
		}
		gameManager.lastTick = Gmod.CurTime();
	}

	function newGameInProgress() {
		return new GameInProgress();
	}

	public function setState(newState:GAME_STATE_2) {
		final manager = getGameManager();
		manager.state = stateTransition(newState);
	}

	function stateTransition(x:GAME_STATE_2):GAME_STATE_2 {
		var time = 0.0;
		trace('STATE TRANSITION: ${gameManager.state} $x');
		var prevState = gameManager.state;
		gameManager.state = x;
		switch ([prevState, x]) { // TODO unify gameManger.state/getGameManager(). which should we use? does it matter
			case [ENDING(_), WAIT]:
				cleanup();
			case [SETTING_UP(_), PLAYING]:
				playing();
			case [WAIT, PLAYING]:
				playing();
			case [WAIT, SETTING_UP(t)]:
				time = t;
			case [PLAYING, ENDING(t)]:
				time = t;
			case [PLAYING, PLAYING]:
				cleanup();
				playing();
			// spawn
			default:
				trace(prevState, x);
				throw "Unsupported state transition";
		}
		signalTrig.trigger(x);
		return x;
	}

	function playing() {
		beginRoundForAll();
		setupInfection();
		hookWin();
	}

	function setupInfection() {
		final gameInProgressSystem = systemManager.get(GameInProgressSystem);
		var ent = componentManager.addEntity();
		var gip = new GameInProgress();
		ent.add_component(gip);
		gameInProgressSystem.setTime(gip);
		gameInProgressSystem.spawns();
	}

	function beginRoundForAll() {
		final infectionSystem = systemManager.get(InfectionSystem);
		var choose = MathLib.random(1, PlayerLib.GetCount());
		if (Main.forceInfected) {
			choose = 1;
		} else if (Main.forceUninfected) {
			choose = MathLib.random(2, PlayerLib.GetCount());
		}
		gameManager.spawnAllowed = true;
		TimerLib.Simple(5, () -> {
			gameManager.spawnAllowed = false;
		});
		for (ind => _ply in PlayerLib.GetAll()) {
			trace('Player index $ind');
			var player:GPlayerCompat = _ply;
			beginPlayer(player);
			if (ind == choose) {
				infectionSystem.makeInfected(player.id);
			}
			TimerLib.Simple(0.1, () -> player.Give(Misc.startingWeapons[0]));
			player.giveFullAmmo();
			player.Spawn();
		}
	}

	public function diffTime() {
		return getGameManager().diffTime;
	}

	public function beginInfected(ent:DI_ID) {
		final radSourceSystem = systemManager.get(RadSourceSystem);
		ent.add_component(new InfectedComponent());
		ent.add_component(new GrabProducer());
		ent.add_component(new GrabSearcher());
		ent.add_component(new HiddenHealthComponent());
		ent.add_component(new FormComponent());
		ent.add_component(new DamagePenaltyHidden());
		ent.add_component(new InfectionLookInfoAbility());
		ent.add_component(new InfectionPoints());
		var c_inf = ent.get_sure(InfectionComponent);
		var c_accept = ent.get_sure(GrabAccepter);
		c_accept.grabState = UNAVALIABLE(UNAVALIABLE);
		var rad = radSourceSystem.radSourceFromType(INF, ent);
		var rv = new RadVictim();
		rad.add_component(new VirtualPosition(ENT(ent.get_sure(GEntityComponent)
			.entity)));
	}

	function beginPlayer(ply:GPlayerCompat) {
		var p = ply.id;
		final infcomp = new InfectionComponent();
		final spec = new SpectateComponent();
		final rate = new RateAccepter();
		final vic = new RadVictim();
		final contam = new ContaminationAccepter();
		final health = new HiddenHealthComponent();
		final grabaccept = new GrabAccepter();
		final radaccept = new RadiationAccepter({});
		final virpos = new VirtualPosition(ENT(ply));
		final ply = new deceptinfect.game.components.GamePlayer();
		p.add_component(infcomp);
		p.add_component(spec);
		p.add_component(rate);
		p.add_component(health);
		p.add_component(grabaccept);
		p.add_component(radaccept);
		p.add_component(virpos);
		p.add_component(new AliveComponent());
		p.add_component(vic);
		p.add_component(new GrabSearchVictim());
		p.add_component(contam);
		final g = new deceptinfect.game.GeigerCounter();
		p.add_component(g);
	}

	function hookWin() {
		final runUntilDoneSystem = systemManager.get(RunUntilDoneSystem);
		runUntilDoneSystem.addRunner(() -> {
			IterateEnt.iterGet([WinManager], [{winSignal: sig}], function() {
				sig.nextTime()
					.handle(newWin);
				return true;
			});
			return false;
		});
	}

	function newWin(x:Win) {
		switch (x) {
			case WIN_HUMAN:
				trace("Humans win");
			case WIN_INF:
				trace("Infected win");
			case DRAW:
				trace("Draw. Boring...");
		}
		setState(ENDING(Gmod.CurTime() + 10));
	}

	public function cleanup() {
		final clientTranslateSystem = systemManager.get(ClientTranslateSystem);
		IterateEnt.iterGet([CleanupEnt, GEntityComponent], [_, {entity: ent}], function() {
			ent.Remove();
		});
		for (x in 0...componentManager.entities) {
			final ent:DI_ID = x;
			if (!ent.has_comp(KeepRestart)) {
				componentManager.removeEntity(ent);
			}
		}
		clientTranslateSystem.flush();
		// stateTrig.clear();
		systemManager.destroySystems();
		systemManager.initAllSystems();
		for (ent in EntsLib.GetAll()) {
			switch (ent.GetClass()) {
				case Di_entities.di_charger | Di_entities.di_battery | Di_entities.di_nest | Di_entities.di_evac_zone | Di_entities.di_flare:
					ent.Remove();
				default:
			}
		}
		// GameLib.CleanUpMap();
		for (p in PlayerLib.GetAll()) {
			new GPlayerCompat(new PlayerComponent(p));
			p.KillSilent();
			p.Spawn();
		}
	}

	public function isPlaying() {
		return switch (gameManager.state) {
			case PLAYING:
				true;
			default:
				false;
		}
	}

	public function thinkWait() {
		if (PlayerLib.GetCount() > GameValues.MIN_PLAYERS) {
			setState(SETTING_UP(Gmod.CurTime() + GameValues.SETUP_TIME));
		}
	}

	public function shouldAllowRespawn() {
		return switch (gameManager.state) {
			case WAIT | SETTING_UP(_):
				true;
			default:
				false;
		}
	}
	#end
}
