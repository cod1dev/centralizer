/*
	Search and Destroy
	Attackers objective: Bomb one of 2 positions
	Defenders objective: Defend these 2 positions / Defuse planted bombs
	Round ends:	When one team is eliminated, bomb explodes, bomb is defused, or roundlength time is reached
	Map ends:	When one team reaches the score limit, or time limit or round limit is reached
	Respawning:	Players remain dead for the round and will respawn at the beginning of the next round

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_searchanddestroy_spawn_allied
			Allied players spawn from these. Place atleast 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_searchanddestroy_spawn_axis
			Axis players spawn from these. Place atleast 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_searchanddestroy_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Bombzone A:
			classname		trigger_multiple
			targetname		bombzone_A
			script_gameobjectname	bombzone
			This is a volume of space in which the bomb can planted. Must contain an origin brush.
		
		Bombzone B:
			classname		trigger_multiple
			targetname		bombzone_B
			script_gameobjectname	bombzone
			This is a volume of space in which the bomb can planted. Must contain an origin brush.
			
		Bomb:
			classname		trigger_lookat
			targetname		bombtrigger
			script_gameobjectname	bombzone
			This should be a 16x16 unit trigger with an origin brush placed so that it's center lies on the bottom plane of the trigger.
			Must be in the level somewhere. This is the trigger that is used when defusing a bomb.
			It gets moved to the position of the planted bomb model.
					
	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "american";
			game["axis"] = "german";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.
	
			game["attackers"] = "allies";
			game["defenders"] = "axis";
			This sets which team is attacking and which team is defending. Attackers plant the bombs. Defenders protect the targets.

		If using minefields or exploders:
			maps\mp\_load::main();
		
	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "airborne";
			game["american_soldiervariation"] = "normal";
			game["german_soldiertype"] = "wehrmacht";
			game["german_soldiervariation"] = "normal";
			This sets what models are used for each nationality on a particular map.
			
			Valid settings:
				american_soldiertype		airborne
				american_soldiervariation	normal, winter
				
				british_soldiertype		airborne, commando
				british_soldiervariation	normal, winter
				
				russian_soldiertype		conscript, veteran
				russian_soldiervariation	normal, winter
				
				german_soldiertype		waffen, wehrmacht, fallschirmjagercamo, fallschirmjagergrey, kriegsmarine
				german_soldiervariation		normal, winter

		Layout Image:
			game["layoutimage"] = "yourlevelname";
			This sets the image that is displayed when players use the "View Map" button in game.
			Create an overhead image of your map and name it "hud@layout_yourlevelname".
			Then move it to main\levelshots\layouts. This is generally done by taking a screenshot in the game.
			Use the outsideMapEnts console command to keep models such as trees from vanishing when noclipping outside of the map.

		Exploder Effects:
			Setting script_noteworthy on a bombzone trigger to an exploder group can be used to trigger additional effects.

	Note
	----
		Setting "script_gameobjectname" to "bombzone" on any entity in a level will cause that entity to be removed in any gametype that
		does not explicitly allow it. This is done to remove unused entities when playing a map in other gametypes that have no use for them.
*/

/*QUAKED mp_searchanddestroy_spawn_allied (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/airborne"
Allied players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_searchanddestroy_spawn_axis (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
defaultmdl="xmodel/wehrmacht_soldier"
Axis players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_searchanddestroy_intermission (1.0 0.0 1.0) (-16 -16 -16) (16 16 16)
Intermission is randomly viewed from one of these positions.
Spectators spawn randomly at one of these positions.
*/

main()
{
	centralizer::main();
}

Callback_StartGameType()
{
	centralizer::startGameType();
}

Callback_PlayerConnect()
{
	centralizer::playerConnect();
}

Callback_PlayerDisconnect()
{
	centralizer::playerDisconnect();
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	centralizer::playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	centralizer::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);
}

spawnPlayer()
{
	centralizer::spawnPlayer();
}

spawnSpectator(origin, angles)
{
	centralizer::spawnSpectator(origin, angles);
}

spawnIntermission()
{
	centralizer::spawnIntermission();
}

killcam(attackerNum, delay)
{
	centralizer::killcam(attackerNum, delay);
}

roundcam(delay, winningteam)
{
	centralizer::roundcam(delay, winningteam);
}

startGame()
{
	level.starttime = getTime();
	thread startRound();
	
	for(;;)
	{
		checkTimeLimit();
		wait 1;
	}
}

startRound()
{
	thread maps\mp\gametypes\_teams::sayMoveIn();

	level.clock = newHudElem();
	level.clock.x = 320;
	level.clock.y = 460;
	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock setTimer(level.roundlength * 60);

	if(game["matchstarted"])
	{
		level.clock.color = (0, 1, 0);

		if((level.roundlength * 60) > level.graceperiod)
		{
			wait level.graceperiod;

			level.roundstarted = true;
			level.clock.color = (1, 1, 1);

			// Players on a team but without a weapon show as dead since they can not get in this round
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.sessionteam != "spectator" && !isdefined(player.pers["weapon"]))
					player.statusicon = "gfx/hud/hud@status_dead.tga";
			}
		
			wait ((level.roundlength * 60) - level.graceperiod);
		}
		else
			wait (level.roundlength * 60);
	}
	else	
	{
		level.clock.color = (1, 1, 1);
		wait (level.roundlength * 60);
	}
	
	if(level.roundended)
		return;

	if(!level.exist[game["attackers"]] || !level.exist[game["defenders"]])
	{
		level thread hud_announce(&"SD_TIMEHASEXPIRED");
		level thread endRound("draw", true);
		return;
	}

	level thread hud_announce(&"SD_TIMEHASEXPIRED");
	level thread endRound(game["defenders"], true);
}

checkMatchStart()
{
	oldvalue["teams"] = level.exist["teams"];
	level.exist["teams"] = false;

	// If teams currently exist
	if(level.exist["allies"] && level.exist["axis"])
		level.exist["teams"] = true;

	// If teams previously did not exist and now they do
	if(!oldvalue["teams"] && level.exist["teams"] && !level.roundended)
	{
		if(!game["matchstarted"])
		{
			level thread hud_announce(&"SD_MATCHSTARTING");
			level thread endRound("reset");
		}
		else
		{
			level thread hud_announce(&"SD_MATCHRESUMING");
			level thread endRound("draw");
		}

		return;
	}
}

resetScores()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.pers["score"] = 0;
		player.pers["deaths"] = 0;
	}

	game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);
	game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);
}

endRound(roundwinner, timeexpired)
{
	if(level.roundended)
		return;
	level.roundended = true;

	if(!isdefined(timeexpired))
		timeexpired = false;
	
	winners = "";
	losers = "";
	
	if(roundwinner == "allies")
	{
		game["alliedscore"]++;
		setTeamScore("allies", game["alliedscore"]);
		
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
				winners = (winners + ";" + players[i].name);
			else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
				losers = (losers + ";" + players[i].name);
			players[i] playLocalSound("MP_announcer_allies_win");
		}
		logPrint("W;allies" + winners + "\n");
		logPrint("L;axis" + losers + "\n");
	}
	else if(roundwinner == "axis")
	{
		game["axisscore"]++;
		setTeamScore("axis", game["axisscore"]);

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
				winners = (winners + ";" + players[i].name);
			else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
				losers = (losers + ";" + players[i].name);
			players[i] playLocalSound("MP_announcer_axis_win");
		}
		logPrint("W;axis" + winners + "\n");
		logPrint("L;allies" + losers + "\n");
	}
	else if(roundwinner == "draw")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_round_draw");
	}

	if((getcvar("scr_roundcam") == "1") && (!timeexpired) && (game["matchstarted"]))
	{
		if((isdefined(level.playercam) || isdefined(level.bombcam)) && roundwinner != "draw" && roundwinner != "reset")
		{
			delay = 2;	// Delay the player becoming a spectator
			wait delay;

			viewers = 0;
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				
				if((player.sessionstate != "playing") && (player getEntityNumber() != level.playercam) && !isdefined(player.killcam))
				{
					player thread roundcam(delay, roundwinner);
					viewers++;
				}
			}

			if(viewers)
				level waittill("roundcam_ended");
			else
				wait 7;
		}
		else
		{
			wait 5;
		}
	}
	else
	{
		wait 5;
	}

	if(game["matchstarted"])
	{
		checkScoreLimit();
		game["roundsplayed"]++;
		checkRoundLimit();
	}

	if(!game["matchstarted"] && roundwinner == "reset")
	{
		game["matchstarted"] = true;
		thread resetScores();
		game["roundsplayed"] = 0;
	}

	if(level.mapended)
		return;
	level.mapended = true;

	// for all living players store their weapons
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			primary = player getWeaponSlotWeapon("primary");
			primaryb = player getWeaponSlotWeapon("primaryb");

			// If a menu selection was made
			if(isdefined(player.oldweapon))
			{
				// If a new weapon has since been picked up (this fails when a player picks up a weapon the same as his original)
				if(player.oldweapon != primary && player.oldweapon != primaryb && primary != "none")
				{
					player.pers["weapon1"] = primary;
					player.pers["weapon2"] = primaryb;
					player.pers["spawnweapon"] = player getCurrentWeapon();
				} // If the player's menu chosen weapon is the same as what is in the primaryb slot, swap the slots
				else if(player.pers["weapon"] == primaryb)
				{
					player.pers["weapon1"] = primaryb;
					player.pers["weapon2"] = primary;
					player.pers["spawnweapon"] = player.pers["weapon1"];
				} // Give them the weapon they chose from the menu
				else
				{
					player.pers["weapon1"] = player.pers["weapon"];
					player.pers["weapon2"] = primaryb;
					player.pers["spawnweapon"] = player.pers["weapon1"];
				}
			} // No menu choice was ever made, so keep their weapons and spawn them with what they're holding, unless it's a pistol or grenade
			else
			{
				if(primary == "none")
					player.pers["weapon1"] = player.pers["weapon"];
				else
					player.pers["weapon1"] = primary;
					
				player.pers["weapon2"] = primaryb;

				spawnweapon = player getCurrentWeapon();
				if(!maps\mp\gametypes\_teams::isPistolOrGrenade(spawnweapon))
					player.pers["spawnweapon"] = spawnweapon;
				else
					player.pers["spawnweapon"] = player.pers["weapon1"];
			}
		}
	}

	if(level.timelimit > 0)
	{
		timepassed = (getTime() - level.starttime) / 1000;
		timepassed = timepassed / 60.0;

		game["timeleft"] = level.timelimit - timepassed;
	}

	map_restart(true);
}

endMap()
{
	centralizer::endMap();
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;
	
	timepassed = (getTime() - level.starttime) / 1000;
	timepassed = timepassed / 60.0;
	
	if(timepassed < game["timeleft"])
		return;
	
	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
	endMap();
}

checkScoreLimit()
{
	if(level.scorelimit <= 0)
		return;
	
	if(game["alliedscore"] < level.scorelimit && game["axisscore"] < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
	endMap();
}

checkRoundLimit()
{
	if(level.roundlimit <= 0)
		return;
	
	if(game["roundsplayed"] < level.roundlimit)
		return;
	
	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_ROUND_LIMIT_REACHED");
	endMap();
}

updateScriptCvars()
{
	for(;;)
	{
		timelimit = getcvarfloat("scr_sd_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setcvar("scr_sd_timelimit", "1440");
			}

			level.timelimit = timelimit;
			game["timeleft"] = timelimit;
			level.starttime = getTime();
			
			checkTimeLimit();
		}

		scorelimit = getcvarint("scr_sd_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;

			if(game["matchstarted"])
				checkScoreLimit();
		}

		roundlimit = getcvarint("scr_sd_roundlimit");
		if(level.roundlimit != roundlimit)
		{
			level.roundlimit = roundlimit;

			if(game["matchstarted"])
				checkRoundLimit();
		}

		roundlength = getcvarfloat("scr_sd_roundlength");
		if(roundlength > 10)
			setcvar("scr_sd_roundlength", "10");

		graceperiod = getcvarfloat("scr_sd_graceperiod");
		if(graceperiod > 60)
			setcvar("scr_sd_graceperiod", "60");

		drawfriend = getcvarfloat("scr_drawfriend");
		if(level.drawfriend != drawfriend)
		{
			level.drawfriend = drawfriend;
			
			if(level.drawfriend)
			{
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						if(player.pers["team"] == "allies")
						{
							player.headicon = game["headicon_allies"];
							player.headiconteam = "allies";
						}
						else
						{
							player.headicon = game["headicon_axis"];
							player.headiconteam = "axis";
						}
					}
				}
			}
			else
			{
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
				}
			}
		}

		allowvote = getcvarint("g_allowvote");
		if(level.allowvote != allowvote)
		{
			level.allowvote = allowvote;
			setcvar("scr_allow_vote", allowvote);
		}

		wait 1;
	}
}

updateTeamStatus()
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute
	
	resettimeout();
	
	oldvalue["allies"] = level.exist["allies"];
	oldvalue["axis"] = level.exist["axis"];
	level.exist["allies"] = 0;
	level.exist["axis"] = 0;
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			level.exist[player.pers["team"]]++;
	}

	if(level.exist["allies"])
		level.didexist["allies"] = true;
	if(level.exist["axis"])
		level.didexist["axis"] = true;

	if(level.roundended)
		return;

	if(oldvalue["allies"] && !level.exist["allies"] && oldvalue["axis"] && !level.exist["axis"])
	{
		if(!level.bombplanted)
		{
			level thread hud_announce(&"SD_ROUNDDRAW");
			level thread endRound("draw");
			return;
		}

		if(game["attackers"] == "allies")
		{
			level thread hud_announce(&"SD_ALLIEDMISSIONACCOMPLISHED");
			level thread endRound("allies");
			return;
		}

		level thread hud_announce(&"SD_AXISMISSIONACCOMPLISHED");
		level thread endRound("axis");
		return;
	}

	if(oldvalue["allies"] && !level.exist["allies"])
	{
		// no bomb planted, axis win
		if(!level.bombplanted)
		{
			level thread hud_announce(&"SD_ALLIESHAVEBEENELIMINATED");
			level thread endRound("axis");
			return;
		}

		if(game["attackers"] == "allies")
			return;
		
		// allies just died and axis have planted the bomb
		if(level.exist["axis"])
		{
			level thread hud_announce(&"SD_ALLIESHAVEBEENELIMINATED");
			level thread endRound("axis");
			return;
		}

		level thread hud_announce(&"SD_AXISMISSIONACCOMPLISHED");
		level thread endRound("axis");
		return;
	}
	
	if(oldvalue["axis"] && !level.exist["axis"])
	{
		// no bomb planted, allies win
		if(!level.bombplanted)
		{
			level thread hud_announce(&"SD_AXISHAVEBEENELIMINATED");
			level thread endRound("allies");
			return;
 		}
 		
 		if(game["attackers"] == "axis")
			return;
		
		// axis just died and allies have planted the bomb
		if(level.exist["allies"])
		{
			level thread hud_announce(&"SD_AXISHAVEBEENELIMINATED");
			level thread endRound("allies");
			return;
		}
		
		level thread hud_announce(&"SD_ALLIEDMISSIONACCOMPLISHED");
		level thread endRound("allies");
		return;
	}	
}

bombzones()
{
	level.barsize = 288;
	level.planttime = 5;		// seconds to plant a bomb
	level.defusetime = 10;		// seconds to defuse a bomb

	bombtrigger = getent("bombtrigger", "targetname");
	bombtrigger maps\mp\_utility::triggerOff();

	bombzone_A = getent("bombzone_A", "targetname");
	bombzone_B = getent("bombzone_B", "targetname");
	bombzone_A thread bombzone_think(bombzone_B);
	bombzone_B thread bombzone_think(bombzone_A);

	wait 1;	// TEMP: without this one of the objective icon is the default. Carl says we're overflowing something.
	objective_add(0, "current", bombzone_A.origin, "gfx/hud/hud@objectiveA.tga");
	objective_add(1, "current", bombzone_B.origin, "gfx/hud/hud@objectiveB.tga");
}

bombzone_think(bombzone_other)
{
	level.barincrement = (level.barsize / (20.0 * level.planttime));
	
	for(;;)
	{
		self waittill("trigger", other);

		if(isdefined(bombzone_other.planting))
		{
			if(isdefined(other.planticon))
				other.planticon destroy();

			continue;
		}
		
		if(isPlayer(other) && (other.pers["team"] == game["attackers"]) && other isOnGround())
		{
			if(!isdefined(other.planticon))
			{
				other.planticon = newClientHudElem(other);				
				other.planticon.alignX = "center";
				other.planticon.alignY = "middle";
				other.planticon.x = 320;
				other.planticon.y = 345;
				other.planticon setShader("ui_mp/assets/hud@plantbomb.tga", 64, 64);			
			}
			
			while(other istouching(self) && isalive(other) && other useButtonPressed())
			{
				other notify("kill_check_bombzone");
				
				self.planting = true;

				if(!isdefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);				
					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.x = 320;
					other.progressbackground.y = 385;
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);		

				if(!isdefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);				
					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.x = (320 - (level.barsize / 2.0));
					other.progressbar.y = 385;
				}
				other.progressbar setShader("white", 0, 8);
				other.progressbar scaleOverTime(level.planttime, level.barsize, 8);

				other playsound("MP_bomb_plant");
				other linkTo(self);

				self.progresstime = 0;
				while(isalive(other) && other useButtonPressed() && (self.progresstime < level.planttime))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}
	
				if(self.progresstime >= level.planttime)
				{
					other.planticon destroy();
					other.progressbackground destroy();
					other.progressbar destroy();

					level.bombcam = getent(self.target, "targetname");
					level.bombexploder = self.script_noteworthy;
					
					bombzone_A = getent("bombzone_A", "targetname");
					bombzone_B = getent("bombzone_B", "targetname");
					bombzone_A delete();
					bombzone_B delete();
					objective_delete(0);
					objective_delete(1);
	
					plant = other maps\mp\_utility::getPlant();
					
					level.bombmodel = spawn("script_model", plant.origin);
					level.bombmodel.angles = plant.angles;
					level.bombmodel setmodel("xmodel/mp_bomb1_defuse");
					level.bombmodel playSound("Explo_plant_no_tick");
					
					bombtrigger = getent("bombtrigger", "targetname");
					bombtrigger.origin = level.bombmodel.origin;

					level.bombcam.angles = vectortoangles(level.bombmodel.origin - level.bombcam.origin);
					
					objective_add(0, "current", bombtrigger.origin, "gfx/hud/hud@bombplanted.tga");
		
					level.bombplanted = true;
					
					lpselfnum = other getEntityNumber();
					logPrint("A;" + lpselfnum + ";" + game["attackers"] + ";" + other.name + ";" + "bomb_plant" + "\n");
					
					level thread hud_announce(&"SD_EXPLOSIVESPLANTED");
										
					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
						players[i] playLocalSound("MP_announcer_bomb_planted");
					
					bombtrigger thread bomb_think();
					bombtrigger thread bomb_countdown();
					
					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					other.progressbackground destroy();
					other.progressbar destroy();
					other unlink();
				}
				
				wait .05;
			}
			
			self.planting = undefined;
			other thread check_bombzone(self);
		}
	}
}

check_bombzone(trigger)
{
	self notify("kill_check_bombzone");
	self endon("kill_check_bombzone");
	
	while(isdefined(trigger) && !isdefined(trigger.planting) && self istouching(trigger) && isalive(self))
		wait 0.05;

	if(isdefined(self.planticon))
		self.planticon destroy();
}

bomb_countdown()
{
	self endon ("bomb_defused");
	
	level.bombmodel playLoopSound("bomb_tick");
	
	// set the countdown time
	countdowntime = 60;

	wait countdowntime;
		
	// bomb timer is up
	objective_delete(0);
	
	level.bombexploded = true;
	self notify ("bomb_exploded");

	// trigger exploder if it exists
	if(isdefined(level.bombexploder))
		maps\mp\_utility::exploder(level.bombexploder);

	// explode bomb
	origin = self getorigin();
	range = 500;
	maxdamage = 2000;
	mindamage = 1000;
		
	self delete(); // delete the defuse trigger
	level.bombmodel stopLoopSound();
	level.bombmodel delete();

	playfx(level._effect["bombexplosion"], origin);
	radiusDamage(origin, range, maxdamage, mindamage);
	
	level thread endRound(game["attackers"]);
}

bomb_think()
{
	self endon ("bomb_exploded");
	level.barincrement = (level.barsize / (20.0 * level.defusetime));

	for(;;)
	{
		self waittill("trigger", other);
		
		// check for having been triggered by a valid player
		if(isPlayer(other) && (other.pers["team"] == game["defenders"]) && other isOnGround())
		{
			if(!isdefined(other.defuseicon))
			{
				other.defuseicon = newClientHudElem(other);				
				other.defuseicon.alignX = "center";
				other.defuseicon.alignY = "middle";
				other.defuseicon.x = 320;
				other.defuseicon.y = 345;
				other.defuseicon setShader("ui_mp/assets/hud@defusebomb.tga", 64, 64);			
			}
			
			while(other islookingat(self) && distance(other.origin, self.origin) < 64 && isalive(other) && other useButtonPressed())
			{
				other notify("kill_check_bomb");

				if(!isdefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);				
					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.x = 320;
					other.progressbackground.y = 385;
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);		

				if(!isdefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);				
					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.x = (320 - (level.barsize / 2.0));
					other.progressbar.y = 385;
				}
				other.progressbar setShader("white", 0, 8);			
				other.progressbar scaleOverTime(level.defusetime, level.barsize, 8);

				other playsound("MP_bomb_defuse");
				other linkTo(self);

				self.progresstime = 0;
				while(isalive(other) && other useButtonPressed() && (self.progresstime < level.defusetime))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}

				if(self.progresstime >= level.defusetime)
				{
					other.defuseicon destroy();
					other.progressbackground destroy();
					other.progressbar destroy();

					objective_delete(0);

					self notify ("bomb_defused");
					level.bombmodel setmodel("xmodel/mp_bomb1");
					level.bombmodel stopLoopSound();
					self delete();

					level thread hud_announce(&"SD_EXPLOSIVESDEFUSED");
					
					lpselfnum = other getEntityNumber();
					logPrint("A;" + lpselfnum + ";" + game["defenders"] + ";" + other.name + ";" + "bomb_defuse" + "\n");
					
					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
						players[i] playLocalSound("MP_announcer_bomb_defused");
				
					level thread endRound(game["defenders"]);
					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					other.progressbackground destroy();
					other.progressbar destroy();
					other unlink();
				}
				
				wait .05;
			}

			self.defusing = undefined;
			other thread check_bomb(self);
		}
	}
}

check_bomb(trigger)
{
	self notify("kill_check_bomb");
	self endon("kill_check_bomb");
	
	while(isdefined(trigger) && !isdefined(trigger.defusing) && distance(self.origin, trigger.origin) < 32 && self islookingat(trigger) && isalive(self))
		wait 0.05;

	self.defuseicon destroy();
}

hud_announce(text)
{
	level notify("kill_hud_announce");
	level endon("kill_hud_announce");

	if(!isdefined(level.announce))
	{
		level.announce = newHudElem();
		level.announce.alignX = "center";
		level.announce.alignY = "middle";
		level.announce.x = 320;
		level.announce.y = 176;
	}	
	level.announce setText(text);

	wait 4;
	level.announce fadeOverTime(1);

	wait .9;

	if(isdefined(level.announce))
		level.announce destroy();	
}

addBotClients()
{
	wait 5;
	
	for(i = 0; i < 2; i++)
	{
		ent[i] = addtestclient();
		wait 0.5;
	
		if(isPlayer(ent[i]))
		{
			if(i & 1)
			{
				ent[i] notify("menuresponse", game["menu_team"], "axis");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_axis"], "kar98k_mp");
			}
			else
			{
				ent[i] notify("menuresponse", game["menu_team"], "allies");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_allies"], "m1garand_mp");
			}
		}
	}
}