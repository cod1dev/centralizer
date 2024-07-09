main()
{
    gametype = getcvar("g_gametype");
    
    level.callbackStartGameType = ::startGameType;
    level.callbackPlayerConnect = ::playerConnect;
    level.callbackPlayerDisconnect = ::playerDisconnect;
    level.callbackPlayerDamage = ::playerDamage;
    level.callbackPlayerKilled = ::playerKilled;

    maps\mp\gametypes\_callbacksetup::SetupCallbacks();

    if(gametype == "sd")
    {
        level._effect["bombexplosion"] = loadfx("fx/explosions/mp_bomb.efx");
    }

    allowed[0] = gametype;
    if(gametype == "sd")
    {
        allowed[1] = "bombzone";
        allowed[2] = "blocker";
    }
    else if(gametype == "re")
    {
        allowed[1] = "retrieval";
    }
    maps\mp\gametypes\_gameobjects::main(allowed);

    if(gametype == "sd")
    {
        if(getcvar("scr_sd_timelimit") == "")		// Time limit per map
            setcvar("scr_sd_timelimit", "0");
        else if(getcvarfloat("scr_sd_timelimit") > 1440)
            setcvar("scr_sd_timelimit", "1440");
        level.timelimit = getcvarfloat("scr_sd_timelimit");            
    }
    else if(gametype == "re")
    {
        if(getcvar("scr_re_timelimit") == "")		// Time limit per map
            setcvar("scr_re_timelimit", "0");
        else if(getcvarfloat("scr_re_timelimit") > 1440)
            setcvar("scr_re_timelimit", "1440");
        level.timelimit = getcvarfloat("scr_re_timelimit");
    }
    else if(gametype == "dm")
    {
        if(getcvar("scr_dm_timelimit") == "")		// Time limit per map
            setcvar("scr_dm_timelimit", "30");
        else if(getcvarfloat("scr_dm_timelimit") > 1440)
            setcvar("scr_dm_timelimit", "1440");
        level.timelimit = getcvarfloat("scr_dm_timelimit");
    }
    else if(gametype == "tdm")
    {
        if(getcvar("scr_tdm_timelimit") == "")		// Time limit per map
            setcvar("scr_tdm_timelimit", "30");
        else if(getcvarfloat("scr_tdm_timelimit") > 1440)
            setcvar("scr_tdm_timelimit", "1440");
        level.timelimit = getcvarfloat("scr_tdm_timelimit");
    }
    else if(gametype == "bel")
    {
        if(getcvar("scr_bel_timelimit") == "")
            setcvar("scr_bel_timelimit", "30");
        else if(getcvarfloat("scr_bel_timelimit") > 1440)
            setcvar("scr_bel_timelimit", "1440");
        level.timelimit = getcvarfloat("scr_bel_timelimit");
    }

    if(gametype == "sd" || gametype == "re")
    {
        if(!isdefined(game["timeleft"]))
            game["timeleft"] = level.timelimit;
    }
    
    if(gametype == "sd")
    {
        if(getcvar("scr_sd_scorelimit") == "")		// Score limit per map
            setcvar("scr_sd_scorelimit", "10");
        level.scorelimit = getcvarint("scr_sd_scorelimit");
            
        if(getcvar("scr_sd_roundlimit") == "")		// Round limit per map
            setcvar("scr_sd_roundlimit", "0");
        level.roundlimit = getcvarint("scr_sd_roundlimit");

        if(getcvar("scr_sd_roundlength") == "")		// Time length of each round
            setcvar("scr_sd_roundlength", "4");
        else if(getcvarfloat("scr_sd_roundlength") > 10)
            setcvar("scr_sd_roundlength", "10");
        level.roundlength = getcvarfloat("scr_sd_roundlength");

        if(getcvar("scr_sd_graceperiod") == "")		// Time at round start where spawning and weapon choosing is still allowed
            setcvar("scr_sd_graceperiod", "15");
        else if(getcvarfloat("scr_sd_graceperiod") > 60)
            setcvar("scr_sd_graceperiod", "60");
        level.graceperiod = getcvarfloat("scr_sd_graceperiod");
    }
    else if(gametype == "re")
    {
        if(getcvar("scr_re_scorelimit") == "")		// Score limit per map
            setcvar("scr_re_scorelimit", "10");
        level.scorelimit = getcvarint("scr_re_scorelimit");

        if(getcvar("scr_re_roundlimit") == "")		// Round limit per map
            setcvar("scr_re_roundlimit", "0");
        level.roundlimit = getcvarint("scr_re_roundlimit");

        if(getcvar("scr_re_roundlength") == "")		// Time length of each round
            setcvar("scr_re_roundlength", "4");
        else if(getcvarfloat("scr_re_roundlength") > 10)
            setcvar("scr_re_roundlength", "10");
        level.roundlength = getcvarfloat("scr_re_roundlength");

        if(getcvar("scr_re_graceperiod") == "")		// Time at round start where spawning and weapon choosing is still allowed
            setcvar("scr_re_graceperiod", "15");
        else if(getcvarfloat("scr_re_graceperiod") > 60)
            setcvar("scr_re_graceperiod", "60");
        level.graceperiod = getcvarfloat("scr_re_graceperiod");
    }
    else if(gametype == "dm")
    {
        if(getcvar("scr_dm_scorelimit") == "")		// Score limit per map
            setcvar("scr_dm_scorelimit", "50");
        level.scorelimit = getcvarint("scr_dm_scorelimit");
    }
    else if(gametype == "tdm")
    {
        if(getcvar("scr_tdm_scorelimit") == "")		// Score limit per map
            setcvar("scr_tdm_scorelimit", "100");
        level.scorelimit = getcvarint("scr_tdm_scorelimit");
    }
    else if(gametype == "bel")
    {
        if(getcvar("scr_bel_scorelimit") == "")
            setcvar("scr_bel_scorelimit", "50");
        level.playerscorelimit = getcvarint("scr_bel_scorelimit");
    }

    if(gametype == "bel")
    {
        if(getcvar("scr_bel_alivepointtime") == "")
            setcvar("scr_bel_alivepointtime", "10");
        level.AlivePointTime = getcvarint("scr_bel_alivepointtime");

        if(getcvar("scr_bel_positiontime") == "")
            setcvar("scr_bel_positiontime", "6");
        level.PositionUpdateTime = getcvarint("scr_bel_positiontime");

        if(getcvar("scr_bel_respawndelay") == "")
            setcvar("scr_bel_respawndelay", "0");

        if(getcvar("scr_bel_showoncompass") == "")
            setcvar("scr_bel_showoncompass", "1");
    }

    if(gametype == "sd" || gametype == "re" || gametype == "tdm" || gametype == "bel")
    {
        if(getcvar("scr_friendlyfire") == "")		// Friendly fire
            setcvar("scr_friendlyfire", "0");

        if(gametype == "sd" || gametype == "re")
        {
            if(getcvar("scr_roundcam") == "")		// Round Cam On or Off (Default 0 - off)
                setcvar("scr_roundcam", "0");
        }

        if(getcvar("scr_drawfriend") == "")		// Draws a team icon over teammates
            setcvar("scr_drawfriend", "0");
        level.drawfriend = getcvarint("scr_drawfriend");
    }

    if(gametype == "dm" || gametype == "tdm")
    {
        if(getcvar("scr_forcerespawn") == "")		// Force respawning
            setcvar("scr_forcerespawn", "0");
    }

    if(getcvar("g_allowvote") == "")
        setcvar("g_allowvote", "1");
    level.allowvote = getcvarint("g_allowvote");
    setcvar("scr_allow_vote", level.allowvote);

    if(gametype == "re")
    {
        if(!isdefined(game["re_attackers"]))
            game["re_attackers"] = "allies";
        if(!isdefined(game["re_defenders"]))
            game["re_defenders"] = "axis";

        if(getcvar("scr_re_showcarrier") == "")
            setcvar("scr_re_showcarrier", "0");

        if(!isdefined(game["re_attackers_obj_text"]))
            game["re_attackers_obj_text"] = (&"RE_ATTACKERS_OBJ_TEXT_GENERIC");
        if(!isdefined(game["re_defenders_obj_text"]))
            game["re_defenders_obj_text"] = (&"RE_DEFENDERS_OBJ_TEXT_GENERIC");            
    }

    if(!isdefined(game["state"]))
        game["state"] = "playing";
    if(gametype == "sd" || gametype == "re")
    {
        if(!isdefined(game["roundsplayed"]))
            game["roundsplayed"] = 0;
        if(!isdefined(game["matchstarted"]))
            game["matchstarted"] = false;
            
        if(!isdefined(game["alliedscore"]))
            game["alliedscore"] = 0;
        setTeamScore("allies", game["alliedscore"]);

        if(!isdefined(game["axisscore"]))
            game["axisscore"] = 0;
        setTeamScore("axis", game["axisscore"]);
    }

    if(gametype == "re")
    {
        game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
        game["headicon_axis"] = "gfx/hud/headicon@axis.tga";
        game["headicon_carrier"] = "gfx/hud/headicon@re_objcarrier.tga";            
    }

    if(gametype == "sd")
    {
        level.bombplanted = false;
        level.bombexploded = false;
    }
    if(gametype == "sd" || gametype == "re")
    {
        level.roundstarted = false;
        level.roundended = false;
    }
    if(gametype == "dm")
    {
        level.QuickMessageToAll = true;
    }
    level.mapended = false;
    if(gametype == "dm" || gametype == "tdm")
    {
        level.healthqueue = [];
        level.healthqueuecurrent = 0;
    }
    if(gametype == "bel")
    {
        level.alliesallowed = 1;
    }

    if(gametype == "sd" || gametype == "re")
    {
        level.exist["allies"] = 0;
        level.exist["axis"] = 0;
        level.exist["teams"] = false;
        level.didexist["allies"] = false;
        level.didexist["axis"] = false;
    }
    if(gametype == "re")
    {
        level.numobjectives = 0;
        level.objectives_done = 0;
        level.hudcount = 0;
        level.barsize = 288;
    }
    
    if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
    {
        if(gametype == "dm")
        {
            spawnpointname = "mp_deathmatch_spawn";
        }
        else if(gametype == "tdm" || gametype == "bel")
        {
            spawnpointname = "mp_teamdeathmatch_spawn";
        }
        spawnpoints = getentarray(spawnpointname, "classname");

        if(spawnpoints.size > 0)
        {
            for(i = 0; i < spawnpoints.size; i++)
                spawnpoints[i] placeSpawnpoint();
        }
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }
    else
    {
        if(gametype == "sd")
        {
            spawnpointname = "mp_searchanddestroy_spawn_allied";
        }
        else if(gametype == "re")
        {
            spawnpointname = "mp_retrieval_spawn_allied";
        }
        spawnpoints = getentarray(spawnpointname, "classname");

        if(spawnpoints.size > 0)
        {
            for(i = 0; i < spawnpoints.size; i++)
                spawnpoints[i] placeSpawnpoint();
        }
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        
        if(gametype == "sd")
        {
            spawnpointname = "mp_searchanddestroy_spawn_axis";            
        }
        else if(gametype == "re")
        {
            spawnpointname = "mp_retrieval_spawn_axis";            
        }
        spawnpoints = getentarray(spawnpointname, "classname");

        if(spawnpoints.size > 0)
        {
            for(i = 0; i < spawnpoints.size; i++)
                spawnpoints[i] PlaceSpawnpoint();
        }
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }

    if(gametype == "re")
    {
        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
            players[i].objs_held = 0;

        //get the minefields
        level.minefield = getentarray("minefield", "targetname");

        thread maps\mp\gametypes\re::retrieval();
    }

    setarchive(true);
}

startGameType()
{
    gametype = getcvar("g_gametype");

    // if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
    if((gametype == "dm" || gametype == "tdm" || gametype == "bel") || ((gametype == "sd" || gametype == "re") && !isdefined(game["gamestarted"])))
    {
        // defaults if not defined in level script
        if(!isdefined(game["allies"]))
            game["allies"] = "american";
        if(!isdefined(game["axis"]))
            game["axis"] = "german";

        if(!isdefined(game["layoutimage"]))
            game["layoutimage"] = "default";
        layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
        precacheShader(layoutname);
        setcvar("scr_layoutimage", layoutname);
        makeCvarServerInfo("scr_layoutimage", "");

        // server cvar overrides
        if(getcvar("scr_allies") != "")
            game["allies"] = getcvar("scr_allies");	
        if(getcvar("scr_axis") != "")
            game["axis"] = getcvar("scr_axis");
        
        if(gametype == "bel")
        {
            game["menu_team"] = "team_germanonly";
    
            game["menu_weapon_all"] = "weapon_" + game["allies"] + game["axis"];
            game["menu_weapon_allies_only"] = "weapon_" + game["allies"];
            game["menu_weapon_axis_only"] = "weapon_" + game["axis"];
        }
        else
        {
            game["menu_team"] = "team_" + game["allies"] + game["axis"];
            game["menu_weapon_allies"] = "weapon_" + game["allies"];
            game["menu_weapon_axis"] = "weapon_" + game["axis"];
        }
        game["menu_viewmap"] = "viewmap";
        game["menu_callvote"] = "callvote";
        game["menu_quickcommands"] = "quickcommands";
        game["menu_quickstatements"] = "quickstatements";
        game["menu_quickresponses"] = "quickresponses";
        if(gametype == "sd" || gametype == "tdm" || gametype == "bel")
        {
            game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
            game["headicon_axis"] = "gfx/hud/headicon@axis.tga";
        }
        
        if(gametype == "sd" || gametype == "re")
        {
            precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
        }
        else if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
        {
            precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
        }
        precacheString(&"MPSCRIPT_KILLCAM");
        if(gametype == "sd")
        {
            precacheString(&"SD_MATCHSTARTING");
            precacheString(&"SD_MATCHRESUMING");
            precacheString(&"SD_EXPLOSIVESPLANTED");
            precacheString(&"SD_EXPLOSIVESDEFUSED");
            precacheString(&"SD_ROUNDDRAW");
            precacheString(&"SD_TIMEHASEXPIRED");
            precacheString(&"SD_ALLIEDMISSIONACCOMPLISHED");
            precacheString(&"SD_AXISMISSIONACCOMPLISHED");
            precacheString(&"SD_ALLIESHAVEBEENELIMINATED");
            precacheString(&"SD_AXISHAVEBEENELIMINATED");
        }
        else if(gametype == "re")
        {
            precacheString(&"MPSCRIPT_ROUNDCAM");
            precacheString(&"MPSCRIPT_ALLIES_WIN");
            precacheString(&"MPSCRIPT_AXIS_WIN");
            precacheString(&"MPSCRIPT_STARTING_NEW_ROUND");
            precacheString(&"RE_U_R_CARRYING");
            precacheString(&"RE_U_R_CARRYING_GENERIC");
            precacheString(&"RE_PICKUP_AXIS_ONLY_GENERIC");
            precacheString(&"RE_PICKUP_AXIS_ONLY");
            precacheString(&"RE_PICKUP_ALLIES_ONLY_GENERIC");
            precacheString(&"RE_PICKUP_ALLIES_ONLY");
            precacheString(&"RE_OBJ_PICKED_UP_GENERIC");
            precacheString(&"RE_OBJ_PICKED_UP_GENERIC_NOSTARS");
            precacheString(&"RE_OBJ_PICKED_UP");
            precacheString(&"RE_OBJ_PICKED_UP_NOSTARS");
            precacheString(&"RE_PRESS_TO_PICKUP");
            precacheString(&"RE_PRESS_TO_PICKUP_GENERIC");
            precacheString(&"RE_OBJ_TIMEOUT_RETURNING");
            precacheString(&"RE_OBJ_DROPPED");
            precacheString(&"RE_OBJ_DROPPED_DEFAULT");
            precacheString(&"RE_OBJ_INMINES_MULTIPLE");
            precacheString(&"RE_OBJ_INMINES_GENERIC");
            precacheString(&"RE_OBJ_INMINES");
            precacheString(&"RE_ATTACKERS_OBJ_TEXT_GENERIC");
            precacheString(&"RE_DEFENDERS_OBJ_TEXT_GENERIC");
            precacheString(&"RE_ROUND_DRAW");
            precacheString(&"RE_MATCHSTARTING");
            precacheString(&"RE_MATCHRESUMING");
            precacheString(&"RE_TIMEEXPIRED");
            precacheString(&"RE_ELIMINATED_ALLIES");
            precacheString(&"RE_ELIMINATED_AXIS");
            precacheString(&"RE_OBJ_CAPTURED_GENERIC");
            precacheString(&"RE_OBJ_CAPTURED_ALL");
            precacheString(&"RE_OBJ_CAPTURED");
            precacheString(&"RE_RETRIEVAL");
            precacheString(&"RE_ALLIES");
            precacheString(&"RE_AXIS");
            precacheString(&"RE_OBJ_ARTILLERY_MAP");
            precacheString(&"RE_OBJ_PATROL_LOGS");
            precacheString(&"RE_OBJ_CODE_BOOK");
            precacheString(&"RE_OBJ_FIELD_RADIO");
            precacheString(&"RE_OBJ_SPY_RECORDS");
            precacheString(&"RE_OBJ_ROCKET_SCHEDULE");
            precacheString(&"RE_OBJ_CAMP_RECORDS");
        }
        else if(gametype == "bel")
        {
            precacheString(&"BEL_TIME_ALIVE");
            precacheString(&"BEL_TIME_TILL_SPAWN");
            precacheString(&"BEL_PRESS_TO_RESPAWN");
            precacheString(&"BEL_POINTS_EARNED");
            precacheString(&"BEL_WONTBE_ALLIED");
            precacheString(&"BEL_BLACKSCREEN_KILLEDALLIED");
            precacheString(&"BEL_BLACKSCREEN_WILLSPAWN");
        }

        precacheMenu(game["menu_team"]);
        if(gametype == "bel")
        {
            precacheMenu(game["menu_weapon_all"]);
            precacheMenu(game["menu_weapon_allies_only"]);
            precacheMenu(game["menu_weapon_axis_only"]);
        }
        else
        {
            precacheMenu(game["menu_weapon_allies"]);
            precacheMenu(game["menu_weapon_axis"]);
        }
        precacheMenu(game["menu_viewmap"]);
        precacheMenu(game["menu_callvote"]);
        precacheMenu(game["menu_quickcommands"]);
        precacheMenu(game["menu_quickstatements"]);
        precacheMenu(game["menu_quickresponses"]);

        if(gametype == "sd" || gametype == "re" || gametype == "tdm" || gametype == "bel")
        {
            precacheHeadIcon(game["headicon_allies"]);
            precacheHeadIcon(game["headicon_axis"]);
        }
        if(gametype == "re")
        {
            precacheHeadIcon(game["headicon_carrier"]);
        }
        if(gametype == "bel")
        {
            precacheHeadIcon("gfx/hud/headicon@killcam_arrow");
        }

        precacheStatusIcon("gfx/hud/hud@status_dead.tga");
        precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
        if(gametype == "re")
        {
            precacheStatusIcon(game["headicon_carrier"]);
        }

        precacheShader("black");
        if(gametype == "sd" || gametype == "re")
        {
            precacheShader("white");
        }
        precacheShader("hudScoreboard_mp");
        if(gametype == "dm")
        {
            precacheShader("gfx/hud/hud@mpflag_none.tga");
        }
        precacheShader("gfx/hud/hud@mpflag_spectator.tga");
        if(gametype == "sd")
        {
            precacheShader("ui_mp/assets/hud@plantbomb.tga");
            precacheShader("ui_mp/assets/hud@defusebomb.tga");
            precacheShader("gfx/hud/hud@objectiveA.tga");
            precacheShader("gfx/hud/hud@objectiveA_up.tga");
            precacheShader("gfx/hud/hud@objectiveA_down.tga");
            precacheShader("gfx/hud/hud@objectiveB.tga");
            precacheShader("gfx/hud/hud@objectiveB_up.tga");
            precacheShader("gfx/hud/hud@objectiveB_down.tga");
            precacheShader("gfx/hud/hud@bombplanted.tga");
            precacheShader("gfx/hud/hud@bombplanted_up.tga");
            precacheShader("gfx/hud/hud@bombplanted_down.tga");
            precacheShader("gfx/hud/hud@bombplanted_down.tga");
        }
        else if(gametype == "re")
        {
            precacheShader("gfx/hud/hud@objectivegoal.tga");
            precacheShader("gfx/hud/hud@objectivegoal_up.tga");
            precacheShader("gfx/hud/hud@objectivegoal_down.tga");
            precacheShader("gfx/hud/objective.tga");
            precacheShader("gfx/hud/objective_up.tga");
            precacheShader("gfx/hud/objective_down.tga");
        }
        else if(gametype == "bel")
        {
            precacheShader("gfx/hud/hud@objective_bel.tga");
            precacheShader("gfx/hud/hud@objective_bel_up.tga");
            precacheShader("gfx/hud/hud@objective_bel_down.tga");
        }

        if(gametype == "sd")
        {
            precacheModel("xmodel/mp_bomb1_defuse");
            precacheModel("xmodel/mp_bomb1");
        }

        if(gametype == "dm" || gametype == "tdm")
        {
            precacheItem("item_health");
        }

        maps\mp\gametypes\_teams::precache();
        if(gametype == "sd" || gametype == "re" || gametype == "tdm" || gametype == "bel")
        {
            maps\mp\gametypes\_teams::scoreboard();
        }
        maps\mp\gametypes\_teams::initGlobalCvars();
        
        if(gametype == "sd")
        {
            //thread addBotClients();
        }
        else if(gametype == "re")
        {
            //thread addBotClients();
        }
    }

    maps\mp\gametypes\_teams::modeltype();
    maps\mp\gametypes\_teams::restrictPlacedWeapons();

    if(gametype == "sd" || gametype == "re")
    {
        game["gamestarted"] = true;
    }

    if(gametype == "sd" || gametype == "re")
    {
        setClientNameMode("manual_change");
    }
    else if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
    {
        setClientNameMode("auto_change");
    }

    if(gametype == "sd")
    {
        thread maps\mp\gametypes\sd::bombzones();
        thread maps\mp\gametypes\sd::startGame();
        thread maps\mp\gametypes\sd::updateScriptCvars();
        //thread addBotClients();
    }
    else if(gametype == "re")
    {
        thread maps\mp\gametypes\re::startGame();
        thread maps\mp\gametypes\re::updateScriptCvars();
        //thread addBotClients();
    }
    else if(gametype == "dm")
    {
        thread maps\mp\gametypes\dm::startGame();
        //thread addBotClients(); // For development testing
        thread maps\mp\gametypes\dm::updateScriptCvars();
    }
    else if(gametype == "tdm")
    {
        thread maps\mp\gametypes\tdm::startGame();
        //thread addBotClients(); // For development testing
        thread maps\mp\gametypes\tdm::updateScriptCvars();
    }
    else if(gametype == "bel")
    {
        thread maps\mp\gametypes\bel::startGame();
        thread maps\mp\gametypes\bel::updateScriptCvars();            
    }
}

playerConnect()
{
    gametype = getcvar("g_gametype");

    self.statusicon = "gfx/hud/hud@status_connecting.tga";
    self waittill("begin");
    self.statusicon = "";
    if(gametype == "re")
    {
        self.hudelem = [];
    }
    else if(gametype == "bel")
    {
        self.god = false;
        self.respawnwait = false;
    }

    if((gametype == "dm" || gametype == "tdm") || !isdefined(self.pers["team"]))
        iprintln(&"MPSCRIPT_CONNECTED", self);

    lpselfnum = self getEntityNumber();
    logPrint("J;" + lpselfnum + ";" + self.name + "\n");

    if(gametype == "re")
    {
        self.objs_held = 0;
    }
    if(game["state"] == "intermission")
    {
        spawnIntermission();
        return;
    }

    level endon("intermission");

    if(gametype == "bel")
    {
        if (isdefined (self.blackscreen))
            self.blackscreen destroy();
        if (isdefined (self.blackscreentext))
            self.blackscreentext destroy();
        if (isdefined (self.blackscreentext2))
            self.blackscreentext2 destroy();
        if (isdefined (self.blackscreentimer))
            self.blackscreentimer destroy();
    }

    if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
    {
        self setClientCvar("scr_showweapontab", "1");
        if(gametype == "dm")
        {
            self.sessionteam = "none";
        }

        if(self.pers["team"] == "allies")
        {
            if(gametype == "tdm" || gametype == "bel")
            {
                self.sessionteam = "allies";
            }
            if(gametype != "bel")
            {
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
            }
        }
        else
        {
            if(gametype == "tdm" || gametype == "bel")
            {
                self.sessionteam = "axis";
            }
            if(gametype != "bel")
            {
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
            }
        }
        if(gametype == "bel")
        {
            self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);
        }
        
        if(isdefined(self.pers["weapon"]))
        {
            spawnPlayer();
        }
        else
        {
            if(gametype == "sd" || gametype == "re")
            {
                self.sessionteam = "spectator";
            }

            spawnSpectator();

            if(self.pers["team"] == "allies")
            {
                if(gametype == "bel")
                {
                    self openMenu(game["menu_weapon_allies_only"]);
                }
                else
                {
                    self openMenu(game["menu_weapon_allies"]);
                }
            }
            else
            {
                if(gametype == "bel")
                {
                    self openMenu(game["menu_weapon_axis_only"]);
                }
                else
                {
                    self openMenu(game["menu_weapon_axis"]);
                }
            }
        }
    }
    else
    {
        self setClientCvar("g_scriptMainMenu", game["menu_team"]);
        self setClientCvar("scr_showweapontab", "0");

        if(!isdefined(self.pers["team"]))
            self openMenu(game["menu_team"]);

        self.pers["team"] = "spectator";
        self.sessionteam = "spectator";

        spawnSpectator();
    }

    for(;;)
    {
        self waittill("menuresponse", menu, response);

        if(response == "open" || response == "close")
            continue;
        
        if(menu == game["menu_team"])
        {
            switch(response)
            {
                case "allies":
                case "axis":
                    if(gametype == "bel")
                    {
                        if ( (self.pers["team"] != "axis") && (self.pers["team"] != "allies") )
                        {
                            self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis_only"]);
                            self.pers["team"] = "axis";
                            if (isdefined (self.blackscreen))
                                self.blackscreen destroy();
                            if (isdefined (self.blackscreentext))
                                self.blackscreentext destroy();
                            if (isdefined (self.blackscreentext2))
                                self.blackscreentext2 destroy();
                            if (isdefined (self.blackscreentimer))
                                self.blackscreentimer destroy();
                            maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies(self);
                            if (self.pers["team"] == "axis")
                            {
                                self thread printJoinedTeam("axis");
                                self maps\mp\gametypes\bel::move_to_axis();
                            }
                            else if (self.pers["team"] == "allies")
                                self thread printJoinedTeam("allies");
                        }
                        break;
                    }
                case "autoassign":
                    if(response == "autoassign")
                    {
                        if(gametype == "sd" || gametype == "re" || gametype == "tdm")
                        {
                            numonteam["allies"] = 0;
                            numonteam["axis"] = 0;

                            players = getentarray("player", "classname");
                            for(i = 0; i < players.size; i++)
                            {
                                player = players[i];

                                if(!isdefined(player.pers["team"]) || player.pers["team"] == "spectator" || player == self)
                                    continue;
                    
                                numonteam[player.pers["team"]]++;
                            }

                            // if teams are equal return the team with the lowest score
                            if(numonteam["allies"] == numonteam["axis"])
                            {
                                if(getTeamScore("allies") == getTeamScore("axis"))
                                {
                                    teams[0] = "allies";
                                    teams[1] = "axis";
                                    response = teams[randomInt(2)];
                                }
                                else if(numonteam["allies"] < numonteam["axis"])
                                    response = "allies";
                                else
                                    response = "axis";
                            }
                            else if(numonteam["allies"] < numonteam["axis"])
                                response = "allies";
                            else
                                response = "axis";
                        }
                        else if(gametype == "dm")
                        {
                            teams[0] = "allies";
                            teams[1] = "axis";
                            response = teams[randomInt(2)];
                        }
                    }

                    if(response == self.pers["team"] && self.sessionstate == "playing")
                        break;
                    
                    if(response != self.pers["team"] && self.sessionstate == "playing")
                        self suicide();
                    
                    if(gametype == "dm" || gametype == "tdm")
                    {
                        self notify("end_respawn");
                    }
                                
                    self.pers["team"] = response;
                    self.pers["weapon"] = undefined;
                    if(gametype == "sd" || gametype == "re")
                    {
                        self.pers["weapon1"] = undefined;
                        self.pers["weapon2"] = undefined;
                        self.pers["spawnweapon"] = undefined;
                    }
                    self.pers["savedmodel"] = undefined;

                    self setClientCvar("scr_showweapontab", "1");

                    if(self.pers["team"] == "allies")
                    {
                        self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
                        self openMenu(game["menu_weapon_allies"]);
                    }
                    else
                    {
                        self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
                        self openMenu(game["menu_weapon_axis"]);
                    }
                    break;

                case "spectator":
                    if(self.pers["team"] != "spectator")
                    {
                        if(gametype == "sd" || gametype == "re")
                        {
                            if(isalive(self))
                                self suicide();
                        }
                        
                        self.pers["team"] = "spectator";
                        self.pers["weapon"] = undefined;
                        if(gametype == "sd" || gametype == "re")
                        {
                            self.pers["weapon1"] = undefined;
                            self.pers["weapon2"] = undefined;
                            self.pers["spawnweapon"] = undefined;
                        }
                        else if(gametype == "bel")
                        {
                            self.pers["LastAxisWeapon"] = undefined;
                            self.pers["LastAlliedWeapon"] = undefined;
                        }
                        self.pers["savedmodel"] = undefined;
                        
                        self.sessionteam = "spectator";
                        self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                        self setClientCvar("scr_showweapontab", "0");
                        if(gametype == "bel")
                        {
                            if (isdefined (self.blackscreen))
                                self.blackscreen destroy();
                            if (isdefined (self.blackscreentext))
                                self.blackscreentext destroy();
                            if (isdefined (self.blackscreentext2))
                                self.blackscreentext2 destroy();
                            if (isdefined (self.blackscreentimer))
                                self.blackscreentimer destroy();
                        }
                        spawnSpectator();
                        if(gametype == "bel")
                        {
                            maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
                        }
                    }
                    break;
                
                case "weapon":
                    if(gametype == "bel")
                    {
                        if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                            self openMenu(game["menu_weapon_all"]);
                    }
                    else
                    {
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
                    }
                    break;
                
                case "viewmap":
                    self openMenu(game["menu_viewmap"]);
                    break;
                
                case "callvote":
                    self openMenu(game["menu_callvote"]);
                    break;
            }
        }
        else if(gametype == "bel" && (menu == game["menu_weapon_all"] || menu == game["menu_weapon_allies_only"] || menu == game["menu_weapon_axis_only"]))
        {
            if(response == "team")
            {
                self openMenu(game["menu_team"]);
                continue;
            }
            else if(response == "viewmap")
            {
                self openMenu(game["menu_viewmap"]);
                continue;
            }
            else if(response == "callvote")
            {
                self openMenu(game["menu_callvote"]);
                continue;
            }
            
            if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
                continue;
            
            weapon = self maps\mp\gametypes\_teams::restrict_anyteam(response);

            if(weapon == "restricted")
            {
                self openMenu(menu);
                continue;
            }
            
            axisweapon = false;
            if (response == "kar98k_mp")
                axisweapon = true;
            else if (response == "mp40_mp")
                axisweapon = true;
            else if (response == "mp44_mp")
                axisweapon = true;
            else if (response == "kar98k_sniper_mp")
                axisweapon = true;

            if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                continue;

            if(!isdefined(self.pers["weapon"]))
            {
                if (axisweapon == true)
                    self.pers["LastAxisWeapon"] = weapon;
                else
                    self.pers["LastAlliedWeapon"] = weapon;

                if (self.respawnwait != true)
                {
                    if (self.pers["team"] == "allies")
                    {
                        if (axisweapon == true)
                        {
                            self openMenu(menu);
                            continue;
                        }
                        else
                        {
                            self.pers["weapon"] = weapon;
                            spawnPlayer();
                        }

                    }
                    else if (self.pers["team"] == "axis")
                    {
                        if (axisweapon != true)
                        {
                            self openMenu(menu);
                            continue;
                        }
                        else
                        {
                            self.pers["weapon"] = weapon;
                            spawnPlayer();
                        }
                    }
                }
            }
            else
            {
                if ( (self.sessionstate != "playing") && (self.respawnwait != true) )
                {
                    if (isdefined (self.pers["team"]))
                    {
                        if ( (self.pers["team"] == "allies") && (axisweapon != true) )
                            self.pers["LastAlliedWeapon"] = weapon;
                        else if ( (self.pers["team"] == "axis") && (axisweapon == true) )
                            self.pers["LastAxisWeapon"] = weapon;
                        else
                            continue;

                        self.pers["weapon"] = weapon;
                        spawnPlayer();
                    }
                }
                else
                {
                    weaponname = maps\mp\gametypes\_teams::getWeaponName(weapon);			
                    if (axisweapon == true)
                    {
                        self.pers["LastAxisWeapon"] = weapon;
                        if (maps\mp\gametypes\_teams::useAn(weapon))
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN", weaponname);
                        else
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A", weaponname);
                    }
                    else
                    {
                        self.pers["LastAlliedWeapon"] = weapon;
                        if (maps\mp\gametypes\_teams::useAn(weapon))
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN", weaponname);
                        else
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A", weaponname);
                    }

                    if ( (self.pers["team"] == "allies") && (axisweapon != true) )
                        self.pers["nextWeapon"] = weapon;
                    else if ( (self.pers["team"] == "axis") && (axisweapon == true) )
                        self.pers["nextWeapon"] = weapon;
                    else
                        continue;
                }

                if (isdefined (self.pers["team"]))
                {	
                    if (axisweapon != true)
                    {
                        self.pers["LastAlliedWeapon"] = weapon;
                        continue;
                    }
                    else if (axisweapon == true)
                    {
                        self.pers["LastAxisWeapon"] = weapon;
                        continue;
                    }
                }
                continue;
            }
        }
        else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
        {
            if(response == "team")
            {
                self openMenu(game["menu_team"]);
                continue;
            }
            else if(response == "viewmap")
            {
                self openMenu(game["menu_viewmap"]);
                continue;
            }
            else if(response == "callvote")
            {
                self openMenu(game["menu_callvote"]);
                continue;
            }

            if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
                continue;
                
            weapon = self maps\mp\gametypes\_teams::restrict(response);

            if(weapon == "restricted")
            {
                self openMenu(menu);
                continue;
            }

            if(gametype == "sd" || gametype == "re")
            {
                if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isdefined(self.pers["weapon1"]))
                    continue;
            }
            else if(gametype == "dm" || gametype == "tdm")
            {
                if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                    continue;
            }

            if((gametype == "sd" || gametype == "re") && !game["matchstarted"])
            {
                self.pers["weapon"] = weapon;
                self.spawned = undefined;
                spawnPlayer();
                self thread printJoinedTeam(self.pers["team"]);
                if(gametype == "sd")
                {
                    level maps\mp\gametypes\sd::checkMatchStart();
                }
                else if(gametype == "re")
                {
                    level maps\mp\gametypes\re::checkMatchStart();
                }
            }
            else if((gametype == "sd" || gametype == "re") && !level.roundstarted)
            {
                if(isdefined(self.pers["weapon"]))
                {
                    self.pers["weapon"] = weapon;
                    self setWeaponSlotWeapon("primary", weapon);
                    self setWeaponSlotAmmo("primary", 999);
                    self setWeaponSlotClipAmmo("primary", 999);
                    self switchToWeapon(weapon);
                }
                else
                {			 	
                    self.pers["weapon"] = weapon;
                    if(!level.exist[self.pers["team"]])
                    {
                        self.spawned = undefined;
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                        if(gametype == "sd")
                        {
                            level maps\mp\gametypes\sd::checkMatchStart();
                        }
                        else if(gametype == "re")
                        {
                            level maps\mp\gametypes\re::checkMatchStart();
                        }
                    }
                    else
                    {
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                    }
                }
            }
            else
            {
                if(gametype == "sd" || gametype == "re")
                {
                    if(isdefined(self.pers["weapon"]))
                        self.oldweapon = self.pers["weapon"];
                    
                    self.pers["weapon"] = weapon;
                    self.sessionteam = self.pers["team"];

                    if(self.sessionstate != "playing")
                        self.statusicon = "gfx/hud/hud@status_dead.tga";
                    
                    if(self.pers["team"] == "allies")
                        otherteam = "axis";
                    else if(self.pers["team"] == "axis")
                        otherteam = "allies";
                    
                    // if joining a team that has no opponents, just spawn
                    if(!level.didexist[otherteam] && !level.roundended)
                    {
                        self.spawned = undefined;
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                    }
                    else if(!level.didexist[self.pers["team"]] && !level.roundended)
                    {
                        self.spawned = undefined;
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                        if(gametype == "sd")
                        {
                            level maps\mp\gametypes\sd::checkMatchStart();
                        }
                        else if(gametype == "re")
                        {
                            level maps\mp\gametypes\re::checkMatchStart();
                        }
                    }
                    else
                    {
                        weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

                        if(self.pers["team"] == "allies")
                        {
                            if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
                            else
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
                        }
                        else if(self.pers["team"] == "axis")
                        {
                            if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname);
                            else
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname);
                        }
                    }
                }
                else if(gametype == "dm" || gametype == "tdm")
                {
                    if(!isdefined(self.pers["weapon"]))
                    {
                        self.pers["weapon"] = weapon;
                        spawnPlayer();
                        if(gametype == "tdm")
                        {
                            self thread printJoinedTeam(self.pers["team"]);
                        }
                    }
                    else
                    {
                        self.pers["weapon"] = weapon;
                        
                        weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);
                        
                        if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
                            self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
                        else
                            self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
                    }
                }
            }
        }
        else if(menu == game["menu_viewmap"])
        {
            switch(response)
            {
            case "team":
                self openMenu(game["menu_team"]);
                break;
            
            case "weapon":
                if(gametype == "bel")
                {
                    if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                        self openMenu(game["menu_weapon_all"]);
                }
                else
                {
                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else if(self.pers["team"] == "axis")
                        self openMenu(game["menu_weapon_axis"]);
                }
                break;
            
            case "callvote":
                self openMenu(game["menu_callvote"]);
                break;
            }
        }
        else if(menu == game["menu_callvote"])
        {
            switch(response)
            {
            case "team":
                self openMenu(game["menu_team"]);
                break;
            
            case "weapon":
                if(gametype == "bel")
                {
                    if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                        self openMenu(game["menu_weapon_all"]);
                }
                else
                {
                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else if(self.pers["team"] == "axis")
                        self openMenu(game["menu_weapon_axis"]);
                }
                break;
            
            case "viewmap":
                    self openMenu(game["menu_viewmap"]);
                    break;
            }
        }
        else if(menu == game["menu_quickcommands"])
            maps\mp\gametypes\_teams::quickcommands(response);
        else if(menu == game["menu_quickstatements"])
            maps\mp\gametypes\_teams::quickstatements(response);
        else if(menu == game["menu_quickresponses"])
            maps\mp\gametypes\_teams::quickresponses(response);
    }
}

playerDisconnect()
{
    gametype = getcvar("g_gametype");

    iprintln(&"MPSCRIPT_DISCONNECTED", self);

    lpselfnum = self getEntityNumber();
    logPrint("Q;" + lpselfnum + ";" + self.name + "\n");

    if(gametype == "re")
    {
        if (isdefined (self.objs_held))
        {
            if (self.objs_held > 0)
            {
                for (i=0;i<(level.numobjectives + 1);i++)
                {
                    if (isdefined (self.hasobj[i]))
                    {
                        //if (self isonground())
                            self.hasobj[i] maps\mp\gametypes\re::drop_objective_on_disconnect_or_death(self);
                        //else
                        //	self.hasobj[i] drop_objective_on_disconnect_or_death(self, "trace");
                    }
                }
            }
        }

        self notify ("death");
    }
    else if(gametype == "bel")
    {
        self.pers["team"] = "spectator";
        self maps\mp\gametypes\bel::check_delete_objective();
        maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
    }

    if(gametype == "sd" || gametype == "re")
    {
        if(game["matchstarted"])
        {
            if(gametype == "sd")
            {
                level thread maps\mp\gametypes\sd::updateTeamStatus();
            }
            else if(gametype == "re")
            {
                level thread maps\mp\gametypes\re::updateTeamStatus();
            }
        }
    }
}

playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    gametype = getcvar("g_gametype");

    if(gametype == "bel")
    {
        if ( (isdefined (eAttacker)) && (isPlayer(eAttacker)) && (isdefined (eAttacker.god)) && (eAttacker.god == true) )
            return;

        if ( (self.sessionteam == "spectator") || (self.god == true) )
            return;
    }
    else
    {
        if(self.sessionteam == "spectator")
            return;
    }
    
    // Don't do knockback if the damage direction was not specified
    if(!isDefined(vDir))
        iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
    
    if(gametype == "dm")
    {
        // Make sure at least one point of damage is done
        if(iDamage < 1)
            iDamage = 1;
    }

    if(gametype == "sd" || gametype == "re" || gametype == "tdm" || gametype == "bel")
    {
        // check for completely getting out of the damage
        if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
        {
            if(isPlayer(eAttacker) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]))
            {
                if(getCvarInt("scr_friendlyfire") <= 0)
                    return;

                if(getCvarInt("scr_friendlyfire") == 2)
                    reflect = true;
            }
        }

        // Apply the damage to the player
        if(!isdefined(reflect))
        {
            // Make sure at least one point of damage is done
            if(iDamage < 1)
                iDamage = 1;

            self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
        }
        else
        {
            eAttacker.reflectdamage = true;

            iDamage = iDamage * .5;

            // Make sure at least one point of damage is done
            if(iDamage < 1)
                iDamage = 1;

            eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
            eAttacker.reflectdamage = undefined;
        }
    }

    // Do debug print if it's enabled
    if(getCvarInt("g_debugDamage"))
    {
        println("client:" + self getEntityNumber() + " health:" + self.health +
            " damage:" + iDamage + " hitLoc:" + sHitLoc);
    }

    if(gametype == "dm")
    {
        // Apply the damage to the player
        self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);            
    }

    if(self.sessionstate != "dead")
    {
        lpselfnum = self getEntityNumber();
        lpselfname = self.name;
        lpselfteam = self.pers["team"];
        lpattackerteam = "";

        if(isPlayer(eAttacker))
        {
            lpattacknum = eAttacker getEntityNumber();
            lpattackname = eAttacker.name;
            lpattackerteam = eAttacker.pers["team"];
        }
        else
        {
            lpattacknum = -1;
            lpattackname = "";
            lpattackerteam = "world";
        }

        if(isdefined(reflect)) 
        {  
            lpattacknum = lpselfnum;
            lpattackname = lpselfname;
            lpattackerteam = lpattackerteam;
        }

        logPrint("D;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
    }
}

playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
    gametype = getcvar("g_gametype");

    self endon("spawned");
    if(gametype == "bel")
    {
        self notify ("Stop give points");
        
        self maps\mp\gametypes\bel::check_delete_objective();
        
        if ( (self.sessionteam == "spectator") || (self.god == true) )
            return;
    }
    else
    {
        if(self.sessionteam == "spectator")
            return;
    }

    // If the player was killed by a head shot, let players know it was a head shot kill
    if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
        sMeansOfDeath = "MOD_HEAD_SHOT";

    // send out an obituary message to all clients about the kill
    obituary(self, attacker, sWeapon, sMeansOfDeath);
    if(gametype == "re")
    {
        self notify ("death");

        if (isdefined (self.objs_held))
        {
            if (self.objs_held > 0)
            {
                for (i=0;i<(level.numobjectives + 1);i++)
                {
                    if (isdefined (self.hasobj[i]))
                    {
                        //if (self isonground())
                        //{
                        //	println ("PLAYER KILLED ON THE GROUND");
                            self.hasobj[i] thread maps\mp\gametypes\re::drop_objective_on_disconnect_or_death(self);
                        //}
                        //else
                        //{
                        //	println ("PLAYER KILLED NOT ON THE GROUND");
                        //	self.hasobj[i] thread drop_objective_on_disconnect_or_death(self.origin, "trace");
                        //}
                    }
                }
            }
        }
    }

    self.sessionstate = "dead";
    self.statusicon = "gfx/hud/hud@status_dead.tga";
    if(gametype != "dm")
    {
        self.headicon = "";
    }
    if(gametype == "sd" || gametype == "re")
    {
        self.pers["deaths"]++;
        self.deaths = self.pers["deaths"];
    }
    else
    {
        self.deaths++;        
    }

    if(gametype == "bel")
    {
        body = self cloneplayer();
        self dropItem(self getcurrentweapon());
        self maps\mp\gametypes\bel::updateDeathArray();
    }

    lpselfnum = self getEntityNumber();
    lpselfname = self.name;
    if(gametype == "dm")
    {
        lpselfteam = "";
    }
    else
    {
        lpselfteam = self.pers["team"];
    }
    lpattackerteam = "";

    attackerNum = -1;
    if(gametype == "sd" || gametype == "re")
    {
        level.playercam = attacker getEntityNumber();
    }

    if(isPlayer(attacker))
    {
        if(gametype == "bel")
        {
            lpattacknum = attacker getEntityNumber();
            lpattackname = attacker.name;
            lpattackerteam = attacker.pers["team"];
            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");                
        }

        if(attacker == self) // killed himself
        {
            if(gametype == "bel")
            {
                if(isdefined(attacker.reflectdamage))
                    clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
                
                self.score--;
                if (self.pers["team"] == "allies")
                {
                    if (maps\mp\gametypes\bel::Number_On_Team("axis") < 1)
                        self thread maps\mp\gametypes\bel::respawn("auto");
                    else
                    {
                        self maps\mp\gametypes\bel::move_to_axis();
                        maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies(undefined, self);
                        self thread maps\mp\gametypes\bel::respawn();
                    }
                }
                else
                    self thread maps\mp\gametypes\bel::respawn();
                return;
            }
            else
            {
                doKillcam = false;

                if(gametype == "dm" || gametype == "tdm")
                {
                    attacker.score--;
                }
                else
                {
                    attacker.pers["score"]--;
                    attacker.score = attacker.pers["score"];
                }

                if(gametype == "sd" || gametype == "re" || gametype == "tdm")
                {
                    if(isdefined(attacker.reflectdamage))
                        clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT");
                }
            }
        }
        else
        {
            if(gametype == "bel")
            {
                if(self.pers["team"] == attacker.pers["team"]) // player was killed by a friendly
                {
                    attacker.score--;
                    if (attacker.pers["team"] == "allies")
                    {
                        attacker maps\mp\gametypes\bel::move_to_axis();
                        maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
                    }
                    self thread maps\mp\gametypes\bel::respawn();
                    return;
                }
                else
                {
                    attackerNum = attacker getEntityNumber();
                    if (self.pers["team"] == "allies") //Allied player was killed by an Axis
                    {
                        attacker.god = true;
                        iprintln (&"BEL_KILLED_ALLIED_SOLDIER",attacker);
                        
                        self thread killcam (attackerNum, 2, "allies to axis");
                        maps\mp\gametypes\bel::Set_Number_Allowed_Allies(maps\mp\gametypes\bel::Number_On_Team("axis"));
                        if (maps\mp\gametypes\bel::Number_On_Team("allies") < level.alliesallowed)
                            attacker maps\mp\gametypes\bel::move_to_allies(undefined, 2, "nodelay on respawn", 1);
                        else
                        {
                            attacker.god = false;
                            attacker thread maps\mp\gametypes\bel::client_print(&"BEL_WONTBE_ALLIED");
                        }
                        return;
                    }
                    else //Axis player was killed by Allies
                    {
                        attacker.score++;
                        attacker maps\mp\gametypes\bel::checkScoreLimit();
                    
                        // Stop thread if map ended on this death
                        if(level.mapended)
                            return;	
                    
                        self thread killcam (attackerNum, 2, "axis to axis");
                        return;
                    }
                }
            }
            else
            {
                attackerNum = attacker getEntityNumber();
                doKillcam = true;

                if(gametype == "dm")
                {
                    attacker.score++;
                    attacker maps\mp\gametypes\dm::checkScoreLimit();
                }
                else
                {
                    if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
                    {
                        if(gametype == "tdm")
                        {
                            attacker.score--;
                        }
                        else
                        {
                            attacker.pers["score"]--;
                            attacker.score = attacker.pers["score"];
                        }
                    }
                    else
                    {
                        if(gametype == "tdm")
                        {
                            attacker.score++;

                            teamscore = getTeamScore(attacker.pers["team"]);
                            teamscore++;
                            setTeamScore(attacker.pers["team"], teamscore);
                        
                            maps\mp\gametypes\tdm::checkScoreLimit();
                        }
                        else
                        {
                            attacker.pers["score"]++;
                            attacker.score = attacker.pers["score"];
                        }
                    }
                }
            }
        }

        lpattacknum = attacker getEntityNumber();
        lpattackname = attacker.name;
        if(gametype == "sd" || gametype == "re" || gametype == "tdm")
        {
            lpattackerteam = attacker.pers["team"];
        }
    }
    else
    {
        if(gametype == "bel") // Player wasn't killed by another player or themself (landmines, etc.)
        {
            lpattacknum = -1;
            lpattackname = "";
            lpattackerteam = "world";
            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
            
            self.score--;
            if (self.pers["team"] == "allies")
            {
                if (maps\mp\gametypes\bel::Number_On_Team("axis") < 1)
                    self thread maps\mp\gametypes\bel::respawn("auto");
                else
                {
                    self maps\mp\gametypes\bel::move_to_axis();
                    maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies(undefined, self);
                    self thread maps\mp\gametypes\bel::respawn();
                }
            }
            else
                self thread maps\mp\gametypes\bel::respawn();
            
            return;
        }
        else // If you weren't killed by a player, you were in the wrong place at the wrong time
        {
            doKillcam = false;

            if(gametype == "dm" || gametype == "tdm")
            {
                self.score--;
            }
            else
            {
                self.pers["score"]--;
                self.score = self.pers["score"];
            }

            lpattacknum = -1;
            lpattackname = "";
            if(gametype == "sd" || gametype == "re" || gametype == "tdm")
            {
                lpattackerteam = "world";
            }
        }
    }

    logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

    if(gametype == "dm" || gametype == "tdm")
    {
        // Stop thread if map ended on this death
        if(level.mapended)
            return;
        
        if(gametype == "dm")
        {
            //self updateDeathArray();
        }
    }

    // Make the player drop his weapon
    self dropItem(self getcurrentweapon());

    if(gametype == "sd" || gametype == "re")
    {
        self.pers["weapon1"] = undefined;
        self.pers["weapon2"] = undefined;
        self.pers["spawnweapon"] = undefined;
    }

    if(gametype == "re")
    {
        //Remove HUD text if there is any
        for (i=1;i<16;i++)
        {
            if ( (isdefined (self.hudelem)) && (isdefined (self.hudelem[i])) )
                self.hudelem[i] destroy();
        }
        if (isdefined (self.progressbackground))
            self.progressbackground destroy();
        if (isdefined (self.progressbar))
            self.progressbar destroy();
    }

    if(gametype == "dm")
    {
        // Make the player drop health
        self maps\mp\gametypes\dm::dropHealth();            
    }
    else if(gametype == "tdm")
    {
        // Make the player drop health
        self maps\mp\gametypes\tdm::dropHealth();
    }

    body = self cloneplayer();

    if(gametype == "sd")
    {
        maps\mp\gametypes\sd::updateTeamStatus();
    }
    else if(gametype == "re")
    {
        maps\mp\gametypes\re::updateTeamStatus();
    }

    if(gametype == "sd" || gametype == "re")
    {
        // TODO: Add additional checks that allow killcam when the last player killed wouldn't end the round (bomb is planted)
        if(!level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
            doKillcam = false;
    }

    delay = 2;	// Delay the player becoming a spectator till after he's done dying
    wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

    if(gametype == "dm" || gametype == "tdm")
    {
        if(getcvarint("scr_forcerespawn") > 0)
            doKillcam = false;
    }

    if((((gametype == "dm" || gametype == "tdm") && doKillcam)) || ((gametype == "sd" || gametype == "re") && doKillcam && !level.roundended))
    {
        self thread killcam(attackerNum, delay);
    }
    else
    {
        if(gametype == "dm")
        {
            self thread maps\mp\gametypes\dm::respawn();
        }
        else if(gametype == "tdm")
        {
            self thread maps\mp\gametypes\tdm::respawn();
        }
        else
        {
            currentorigin = self.origin;
            currentangles = self.angles;

            if(gametype == "sd" || gametype == "re")
            {
                self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
            }
        }
    }
}

spawnPlayer()
{
    gametype = getcvar("g_gametype");

    self notify("spawned");
    if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
    {
        self notify("end_respawn");
    }
    if(gametype == "bel")
    {
        self notify("stop weapon timeout");
        self notify ("do_timer_cleanup");
    }

    resettimeout();

    if(gametype == "dm")
    {
        //if(isdefined(self.shocked))
        //{
        //	self stopShellshock();
        //	self.shocked = undefined;
        //}
    }

    if(gametype == "bel")
    {
        self.respawnwait = false;
    }
    if(gametype == "dm")
    {
        self.sessionteam = "none";
    }
    else
    {
        self.sessionteam = self.pers["team"];
    }
    if(gametype == "bel")
    {
        self.lastteam = self.pers["team"];
    }
    if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
    {
        self.sessionstate = "playing";
    }
    if(gametype != "bel")
    {
        self.spectatorclient = -1;
        self.archivetime = 0;
    }
    if(gametype == "sd" || gametype == "re" || gametype == "tdm" || gametype == "bel")
    {
        self.reflectdamage = undefined;

        if(gametype == "sd" || gametype == "re" || gametype == "bel")
        {
            if(gametype == "bel")
            {
                if (isdefined(self.spawnMsg))
                    self.spawnMsg destroy();
            }
            else
            {
                if(isdefined(self.spawned))
                    return;
                
                self.sessionstate = "playing";
            }

            if(gametype == "bel")
            {
                spawnpointname = "mp_teamdeathmatch_spawn";
                spawnpoints = getentarray(spawnpointname, "classname");

                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_MiddleThird(spawnpoints);
            }
            else
            {
                if(self.pers["team"] == "allies")
                {
                    if(gametype == "sd")
                    {
                        spawnpointname = "mp_searchanddestroy_spawn_allied";
                    }
                    else if(gametype == "re")
                    {
                        spawnpointname = "mp_retrieval_spawn_allied";
                    }
                }
                else
                {
                    if(gametype == "sd")
                    {
                        spawnpointname = "mp_searchanddestroy_spawn_axis";
                    }
                    else if(gametype == "re")
                    {
                        spawnpointname = "mp_retrieval_spawn_axis";
                    }
                }

                spawnpoints = getentarray(spawnpointname, "classname");
                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
            }
        }
        else if(gametype == "tdm")
        {
            spawnpointname = "mp_teamdeathmatch_spawn";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);
        }
    }
    else if(gametype == "dm")
    {
        spawnpointname = "mp_deathmatch_spawn";
        spawnpoints = getentarray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
    }
    
    if(isdefined(spawnpoint))
        self spawn(spawnpoint.origin, spawnpoint.angles);
    else
        maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

    if(gametype == "re")
    {
        //Set their intro text
        /*REMOVED
        if(self.pers["team"] == "allies")
        {
            if (isdefined (game["re_attackers_intro_text"]))
                clientAnnouncement (self,game["re_attackers_intro_text"]);
        }
        else if(self.pers["team"] == "axis")
        {
            if (isdefined (game["re_defenders_intro_text"]))
                clientAnnouncement (self,game["re_defenders_intro_text"]);
        }
        */
    }

    if(gametype == "sd" || gametype == "re")
    {
        self.spawned = true;
    }
    self.statusicon = "";
    self.maxhealth = 100;
    self.health = self.maxhealth;
    if(gametype == "re")
    {
        self.objs_held = 0;
    }
    if(gametype == "bel")
    {
        self.pers["savedmodel"] = undefined;

        maps\mp\gametypes\_teams::model();

        maps\mp\gametypes\_teams::loadout();
        
        self setClientCvar("scr_showweapontab", "1");
        self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);

        if (self.pers["team"] == "allies")
        {
            if (isdefined (self.pers["LastAlliedWeapon"]))
                self.pers["weapon"] = self.pers["LastAlliedWeapon"];
            else
            {
                if (isdefined (self.pers["nextWeapon"]))
                {
                    self.pers["weapon"] = self.pers["nextWeapon"];
                    self.pers["nextWeapon"] = undefined;
                }
            }
        }
        else if (self.pers["team"] == "axis")
        {
            if (isdefined (self.pers["LastAxisWeapon"]))
                self.pers["weapon"] = self.pers["LastAxisWeapon"];
            else
            {
                if (isdefined (self.pers["nextWeapon"]))
                {
                    self.pers["weapon"] = self.pers["nextWeapon"];
                    self.pers["nextWeapon"] = undefined;
                }
            }
        }

        self giveWeapon(self.pers["weapon"]);
        self giveMaxAmmo(self.pers["weapon"]);
        self setSpawnWeapon(self.pers["weapon"]);

        self.archivetime = 0;
        
        if(self.pers["team"] == "allies")
        {
            self thread maps\mp\gametypes\bel::make_obj_marker();
            self setClientCvar("cg_objectiveText", &"BEL_OBJ_ALLIED");
        }
        else if(self.pers["team"] == "axis")
            self setClientCvar("cg_objectiveText", &"BEL_OBJ_AXIS");
    }
    else
    {
        if(gametype == "sd")
        {
            maps\mp\gametypes\re::updateTeamStatus();
        }
        else if(gametype == "re")
        {
            maps\mp\gametypes\re::updateTeamStatus();
        }

        if(gametype == "sd" || gametype == "re")
        {
            if(!isdefined(self.pers["score"]))
                self.pers["score"] = 0;
            self.score = self.pers["score"];
            
            if(!isdefined(self.pers["deaths"]))
                self.pers["deaths"] = 0;
            self.deaths = self.pers["deaths"];
        }

        if(!isdefined(self.pers["savedmodel"]))
            maps\mp\gametypes\_teams::model();
        else
            maps\mp\_utility::loadModel(self.pers["savedmodel"]);
        
        maps\mp\gametypes\_teams::loadout();
    }

    if(gametype == "dm")
    {
        self giveWeapon(self.pers["weapon"]);
        self giveMaxAmmo(self.pers["weapon"]);
        self setSpawnWeapon(self.pers["weapon"]);
        
        self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
    }
    else
    {
        if(gametype == "sd" || gametype == "re")
        {
            if(isdefined(self.pers["weapon1"]) && isdefined(self.pers["weapon2"]))
            {
                self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
                self setWeaponSlotAmmo("primary", 999);
                self setWeaponSlotClipAmmo("primary", 999);

                self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
                self setWeaponSlotAmmo("primaryb", 999);
                self setWeaponSlotClipAmmo("primaryb", 999);

                self setSpawnWeapon(self.pers["spawnweapon"]);
            }
            else
            {
                self setWeaponSlotWeapon("primary", self.pers["weapon"]);
                self setWeaponSlotAmmo("primary", 999);
                self setWeaponSlotClipAmmo("primary", 999);

                self setSpawnWeapon(self.pers["weapon"]);
            }
        }
        else if(gametype == "tdm")
        {
            self giveWeapon(self.pers["weapon"]);
            self giveMaxAmmo(self.pers["weapon"]);
            self setSpawnWeapon(self.pers["weapon"]);
        }

        if(gametype == "sd")
        {
            if(self.pers["team"] == game["attackers"])
                self setClientCvar("cg_objectiveText", &"SD_OBJ_ATTACKERS");
            else if(self.pers["team"] == game["defenders"])
                self setClientCvar("cg_objectiveText", &"SD_OBJ_DEFENDERS");
        }
        else if(gametype == "re")
        {
            if(self.pers["team"] == game["re_attackers"])
                self setClientCvar("cg_objectiveText", game["re_attackers_obj_text"]);
            else if(self.pers["team"] == game["re_defenders"])
                self setClientCvar("cg_objectiveText", game["re_defenders_obj_text"]);
        }
        else if(gametype == "tdm")
        {
            if(self.pers["team"] == "allies")
                self setClientCvar("cg_objectiveText", &"TDM_KILL_AXIS_PLAYERS");
            else if(self.pers["team"] == "axis")
                self setClientCvar("cg_objectiveText", &"TDM_KILL_ALLIED_PLAYERS");
        }

        if(level.drawfriend)
        {
            if(self.pers["team"] == "allies")
            {
                self.headicon = game["headicon_allies"];
                self.headiconteam = "allies";
            }
            else
            {
                self.headicon = game["headicon_axis"];
                self.headiconteam = "axis";
            }
        }

        if(gametype == "bel")
        {
            self.god = false;
            wait 0.05;
            if (isdefined (self))
            {
                if (isdefined (self.blackscreen))
                    self.blackscreen destroy();
                if (isdefined (self.blackscreentext))
                    self.blackscreentext destroy();
                if (isdefined (self.blackscreentext2))
                    self.blackscreentext2 destroy();
                if (isdefined (self.blackscreentimer))
                    self.blackscreentimer destroy();
            }
        }
    }
}

spawnSpectator(origin, angles)
{
    gametype = getcvar("g_gametype");

    self notify("spawned");
    if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
    {
        self notify("end_respawn");
    }

    if(gametype == "bel")
    {
        self maps\mp\gametypes\bel::check_delete_objective();
    }

    resettimeout();

    if(gametype == "dm")
    {
        //if(isdefined(self.shocked))
        //{
        //	self stopShellshock();
        //	self.shocked = undefined;
        //}
    }

    self.sessionstate = "spectator";
    self.spectatorclient = -1;
    self.archivetime = 0;
    if(gametype == "sd" || gametype == "re" || gametype == "tdm" || gametype == "bel")
    {
        self.reflectdamage = undefined;
    }
    if(gametype == "bel")
    {
        self.pers["savedmodel"] = undefined;
        self.headicon = "";            
    }

    if(gametype != "bel")
    {
        if(self.pers["team"] == "spectator")
            self.statusicon = "";
    }

    if(isdefined(origin) && isdefined(angles))
        self spawn(origin, angles);
    else
    {
        if(gametype == "sd")
        {
            spawnpointname = "mp_searchanddestroy_intermission";
        }
        else if(gametype == "re")
        {
            spawnpointname = "mp_retrieval_intermission";
        }
        else if(gametype == "dm")
        {
            spawnpointname = "mp_deathmatch_intermission";
        }
        else if(gametype == "tdm" || gametype == "bel")
        {
            spawnpointname = "mp_teamdeathmatch_intermission";
        }
        spawnpoints = getentarray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

        if(isdefined(spawnpoint))
            self spawn(spawnpoint.origin, spawnpoint.angles);
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }

    if(gametype == "sd")
    {
        maps\mp\gametypes\sd::updateTeamStatus();

        if(game["attackers"] == "allies")
            self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_ALLIESATTACKING");
        else if(game["attackers"] == "axis")
            self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_AXISATTACKING");
    }
    else if(gametype == "re")
    {
        maps\mp\gametypes\re::updateTeamStatus();

        //if(game["re_attackers"] == "allies")
        //	self setClientCvar("cg_objectiveText", &"RE_ALLIES", game["re_attackers_obj_text"]);
        //else if(game["re_attackers"] == "axis")
        //	self setClientCvar("cg_objectiveText", &"RE_AXIS", game["re_attackers_obj_text"]);
        self setClientCvar("cg_objectiveText", game["re_spectator_obj_text"]);
    }
    else if(gametype == "dm")
    {
        self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
    }
    else if(gametype == "tdm")
    {
        self setClientCvar("cg_objectiveText", &"TDM_ALLIES_KILL_AXIS_PLAYERS");
    }
    else if(gametype == "bel")
    {
        self setClientCvar("cg_objectiveText", &"BEL_SPECTATOR_OBJS");
    }
}

spawnIntermission()
{
    gametype = getcvar("g_gametype");
    
    self notify("spawned");
    if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
    {
        self notify("end_respawn");
    }

    resettimeout();

    if(gametype == "dm")
    {
        //if(isdefined(self.shocked))
        //{
        //	self stopShellshock();
        //	self.shocked = undefined;
        //}
    }

    self.sessionstate = "intermission";
    self.spectatorclient = -1;
    self.archivetime = 0;
    if(gametype == "sd" || gametype == "re" || gametype == "tdm" || gametype == "bel")
    {
        self.reflectdamage = undefined;
    }

    if(gametype == "sd")
    {
        spawnpointname = "mp_searchanddestroy_intermission";
    }
    else if(gametype == "re")
    {
        spawnpointname = "mp_retrieval_intermission";
    }
    else if(gametype == "dm")
    {
        spawnpointname = "mp_deathmatch_intermission";
    }
    else if(gametype == "tdm" || gametype == "bel")
    {
        spawnpointname = "mp_teamdeathmatch_intermission";
    }
    spawnpoints = getentarray(spawnpointname, "classname");
    if(gametype == "bel")
    {
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_MiddleThird(spawnpoints);
    }
    else
    {
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
    }

    if(isdefined(spawnpoint))
        self spawn(spawnpoint.origin, spawnpoint.angles);
    else
        maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    
    if(gametype == "bel")
    {
        if (isdefined (self.blackscreen))
            self.blackscreen destroy();
        if (isdefined (self.blackscreentext))
            self.blackscreentext destroy();
        if (isdefined (self.blackscreentext2))
            self.blackscreentext2 destroy();
        if (isdefined (self.blackscreentimer))
            self.blackscreentimer destroy();            
    }
}

killcam(attackerNum, delay, option)
{
    gametype = getcvar("g_gametype");

    self endon("spawned");

    if(gametype == "dm" || gametype == "tdm")
    {
        //previousorigin = self.origin;
        //previousangles = self.angles;
    }

    // killcam
    if(attackerNum < 0)
        return;
    
    if(gametype == "bel")
    {
        if (option == "axis to axis")
            wait 2;
        else if (option == "allies to axis")
        {
            self.pers["team"] = ("axis");
            self.sessionteam = ("axis");
            wait 2;
        }
    }

    self.sessionstate = "spectator";
    self.spectatorclient = attackerNum;
    self.archivetime = delay + 7;

    // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
    wait 0.05;

    if(self.archivetime <= delay)
    {
        self.spectatorclient = -1;
        self.archivetime = 0;
        if(gametype == "dm" || gametype == "tdm")
        {
            self.sessionstate = "dead";

            if(gametype == "dm")
            {
                self thread maps\mp\gametypes\dm::respawn();
            }
            else if(gametype == "tdm")
            {
                self thread maps\mp\gametypes\tdm::respawn();
            }
        }
        else if(gametype == "bel")
        {
            if (option == "axis to axis")
            {
                if (!isalive (self))
                    self thread maps\mp\gametypes\bel::respawn("auto",0);
            }
            else if (option == "allies to axis")
                self maps\mp\gametypes\bel::move_to_axis(0,"nodelay on respawn");
        }

        return;
    }

    if(gametype == "sd" || gametype == "re")
    {
        self.killcam = true;
    }

    if(!isdefined(self.kc_topbar))
    {
        self.kc_topbar = newClientHudElem(self);
        self.kc_topbar.archived = false;
        self.kc_topbar.x = 0;
        self.kc_topbar.y = 0;
        self.kc_topbar.alpha = 0.5;
        self.kc_topbar setShader("black", 640, 112);
    }

    if(!isdefined(self.kc_bottombar))
    {
        self.kc_bottombar = newClientHudElem(self);
        self.kc_bottombar.archived = false;
        self.kc_bottombar.x = 0;
        self.kc_bottombar.y = 368;
        self.kc_bottombar.alpha = 0.5;
        self.kc_bottombar setShader("black", 640, 112);
    }

    if(!isdefined(self.kc_title))
    {
        self.kc_title = newClientHudElem(self);
        self.kc_title.archived = false;
        self.kc_title.x = 320;
        self.kc_title.y = 40;
        self.kc_title.alignX = "center";
        self.kc_title.alignY = "middle";
        self.kc_title.sort = 1; // force to draw after the bars
        self.kc_title.fontScale = 3.5;
    }
    self.kc_title setText(&"MPSCRIPT_KILLCAM");

    if(!isdefined(self.kc_skiptext))
    {
        self.kc_skiptext = newClientHudElem(self);
        self.kc_skiptext.archived = false;
        self.kc_skiptext.x = 320;
        self.kc_skiptext.y = 70;
        self.kc_skiptext.alignX = "center";
        self.kc_skiptext.alignY = "middle";
        self.kc_skiptext.sort = 1; // force to draw after the bars
    }
    if(gametype == "dm" || gametype == "tdm" || gametype == "bel")
    {
        self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
    }
    else
    {
        self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
    }

    if(!isdefined(self.kc_timer))
    {
        self.kc_timer = newClientHudElem(self);
        self.kc_timer.archived = false;
        self.kc_timer.x = 320;
        self.kc_timer.y = 428;
        self.kc_timer.alignX = "center";
        self.kc_timer.alignY = "middle";
        self.kc_timer.fontScale = 3.5;
        self.kc_timer.sort = 1;
    }
    self.kc_timer setTenthsTimer(self.archivetime - delay);

    self thread spawnedKillcamCleanup();
    self thread waitSkipKillcamButton();
    self thread waitKillcamTime();
    self waittill("end_killcam");

    self removeKillcamElements();

    self.spectatorclient = -1;
    self.archivetime = 0;
    if(gametype == "sd" || gametype == "re")
    {
        self.killcam = undefined;
    }
    if(gametype == "dm" || gametype == "tdm")
    {
        self.sessionstate = "dead";
    }

    if(gametype == "dm")
    {
        //self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
        self thread maps\mp\gametypes\dm::respawn();
    }
    else if(gametype == "tdm")
    {
        //self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
        self thread maps\mp\gametypes\tdm::respawn();
    }
    else if(gametype == "bel")
    {
        if (option == "axis to axis")
        {
            if (!isalive (self))
                self thread maps\mp\gametypes\bel::respawn("auto",0);
        }
        else if (option == "allies to axis")
            self maps\mp\gametypes\bel::move_to_axis(0,"nodelay on respawn");
    }
}

waitKillcamTime()
{
    self endon("end_killcam");
    
    wait (self.archivetime - 0.05);
    self notify("end_killcam");
}

waitSkipKillcamButton()
{
    self endon("end_killcam");
    
    while(self useButtonPressed())
        wait .05;

    while(!(self useButtonPressed()))
        wait .05;
    
    self notify("end_killcam");	
}

removeKillcamElements()
{
    if(isdefined(self.kc_topbar))
        self.kc_topbar destroy();
    if(isdefined(self.kc_bottombar))
        self.kc_bottombar destroy();
    if(isdefined(self.kc_title))
        self.kc_title destroy();
    if(isdefined(self.kc_skiptext))
        self.kc_skiptext destroy();
    if(isdefined(self.kc_timer))
        self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
    self endon("end_killcam");

    self waittill("spawned");
    self removeKillcamElements();
}

roundcam(delay, winningteam)
{
    gametype = getcvar("g_gametype");

    self endon("spawned");

    spawnSpectator();

    if(gametype == "sd")
    {
        if(isdefined(level.bombcam))
            self thread spawnSpectator(level.bombcam.origin, level.bombcam.angles);
        else
            self.spectatorclient = level.playercam;            
    }
    else if(gametype == "re")
    {
        if(isdefined(level.goalcam))
            self thread spawnSpectator(level.goalcam.origin, level.goalcam.angles);
        else
            self.spectatorclient = level.playercam;
    }

    self.archivetime = delay + 7;

    // wait till the next server frame to give the player the kill-cam huddraw elements
    wait 0.05;

    if (!isdefined(self.kc_topbar))
    {
        self.kc_topbar = newClientHudElem(self);
        self.kc_topbar.archived = false;
        self.kc_topbar.x = 0;
        self.kc_topbar.y = 0;
        self.kc_topbar.alpha = 0.5;
        self.kc_topbar setShader("black", 640, 112);
    }

    if (!isdefined(self.kc_bottombar))
    {
        self.kc_bottombar = newClientHudElem(self);
        self.kc_bottombar.archived = false;
        self.kc_bottombar.x = 0;
        self.kc_bottombar.y = 368;
        self.kc_bottombar.alpha = 0.5;
        self.kc_bottombar setShader("black", 640, 112);
    }

    if(!isdefined(self.kc_title))
    {
        self.kc_title = newClientHudElem(self);
        self.kc_title.archived = false;
        self.kc_title.x = 320;
        self.kc_title.y = 40;
        self.kc_title.alignX = "center";
        self.kc_title.alignY = "middle";
        self.kc_title.sort = 1; // force to draw after the bars
        self.kc_title.fontScale = 3.5;
    }

    if(winningteam == "allies")
        self.kc_title setText(&"MPSCRIPT_ALLIES_WIN");
    else if(winningteam == "axis")
        self.kc_title setText(&"MPSCRIPT_AXIS_WIN");
    else
        self.kc_title setText(&"MPSCRIPT_ROUNDCAM");
    
    if(!isdefined(self.kc_skiptext))
    {
        self.kc_skiptext = newClientHudElem(self);
        self.kc_skiptext.archived = false;
        self.kc_skiptext.x = 320;
        self.kc_skiptext.y = 70;
        self.kc_skiptext.alignX = "center";
        self.kc_skiptext.alignY = "middle";
        self.kc_skiptext.sort = 1; // force to draw after the bars
    }
    self.kc_skiptext setText(&"MPSCRIPT_STARTING_NEW_ROUND");

    if(!isdefined(self.kc_timer))
    {
        self.kc_timer = newClientHudElem(self);
        self.kc_timer.archived = false;
        self.kc_timer.x = 320;
        self.kc_timer.y = 428;
        self.kc_timer.alignX = "center";
        self.kc_timer.alignY = "middle";
        self.kc_timer.fontScale = 3.5;
        self.kc_timer.sort = 1;
    }
    self.kc_timer setTimer(self.archivetime - 1.05);

    self thread spawnedKillcamCleanup();
    self thread waitSkipKillcamButton();
    wait (self.archivetime - 0.05);
    self removeKillcamElements();

    self.spectatorclient = -1;
    self.archivetime = 0;
    
    level notify("roundcam_ended");
}

endMap()
{
    gametype = getcvar("g_gametype");

    switch(gametype)
    {
        case "sd":
        {
            game["state"] = "intermission";
            level notify("intermission");
            
            if(game["alliedscore"] == game["axisscore"])
                text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
            else if(game["alliedscore"] > game["axisscore"])
                text = &"MPSCRIPT_ALLIES_WIN";
            else
                text = &"MPSCRIPT_AXIS_WIN";

            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];

                player closeMenu();
                player setClientCvar("g_scriptMainMenu", "main");
                player setClientCvar("cg_objectiveText", text);
                player spawnIntermission();
            }

            wait 10;
            exitLevel(false);
        }
        break;

        case "dm":
        {
            game["state"] = "intermission";
            level notify("intermission");

            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];

                if(isdefined(player.pers["team"]) && player.pers["team"] == "spectator")
                    continue;

                if(!isdefined(highscore))
                {
                    highscore = player.score;
                    playername = player;
                    name = player.name;
                    continue;
                }

                if(player.score == highscore)
                    tied = true;
                else if(player.score > highscore)
                {
                    tied = false;
                    highscore = player.score;
                    playername = player;
                    name = player.name;
                }
            }

            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];

                player closeMenu();
                player setClientCvar("g_scriptMainMenu", "main");

                if(isdefined(tied) && tied == true)
                    player setClientCvar("cg_objectiveText", &"MPSCRIPT_THE_GAME_IS_A_TIE");
                else if(isdefined(playername))
                    player setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", playername);
                
                player spawnIntermission();
            }
            if (isdefined (name))
                logPrint("W;;" + name + "\n");
            wait 10;
            exitLevel(false);
        }

        case "tdm":
        {
            game["state"] = "intermission";
            level notify("intermission");
            
            alliedscore = getTeamScore("allies");
            axisscore = getTeamScore("axis");
            
            if(alliedscore == axisscore)
            {
                winningteam = "tie";
                losingteam = "tie";
                text = "MPSCRIPT_THE_GAME_IS_A_TIE";
            }
            else if(alliedscore > axisscore)
            {
                winningteam = "allies";
                losingteam = "axis";
                text = &"MPSCRIPT_ALLIES_WIN";
            }
            else
            {
                winningteam = "axis";
                losingteam = "allies";
                text = &"MPSCRIPT_AXIS_WIN";
            }
            
            if ( (winningteam == "allies") || (winningteam == "axis") )
            {
                winners = "";
                losers = "";
            }
            
            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];
                if ( (winningteam == "allies") || (winningteam == "axis") )
                {
                    if ( (isdefined (player.pers["team"])) && (player.pers["team"] == winningteam) )
                            winners = (winners + ";" + player.name);
                    else if ( (isdefined (player.pers["team"])) && (player.pers["team"] == losingteam) )
                            losers = (losers + ";" + player.name);
                }
                player closeMenu();
                player setClientCvar("g_scriptMainMenu", "main");
                player setClientCvar("cg_objectiveText", text);
                player spawnIntermission();
            }
            
            if ( (winningteam == "allies") || (winningteam == "axis") )
            {
                logPrint("W;" + winningteam + winners + "\n");
                logPrint("L;" + losingteam + losers + "\n");
            }
            
            wait 10;
            exitLevel(false);
        }
        break;

        case "bel":
        {
            level notify ("End of Round");
            game["state"] = "intermission";
            level notify("intermission");

            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];

                if(isdefined(player.pers["team"]) && player.pers["team"] == "spectator")
                    continue;

                if(!isdefined(highscore))
                {
                    highscore = player.score;
                    playername = player;
                    name = player.name;
                    continue;
                }

                if(player.score == highscore)
                    tied = true;
                else if(player.score > highscore)
                {
                    tied = false;
                    highscore = player.score;
                    playername = player;
                    name = player.name;
                }
            }

            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];

                player closeMenu();
                player setClientCvar("g_scriptMainMenu", "main");

                if(isdefined(tied) && tied == true)
                    player setClientCvar("cg_objectiveText", &"MPSCRIPT_THE_GAME_IS_A_TIE");
                else if(isdefined(playername))
                    player setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", playername);
                
                player spawnIntermission();
            }
            if (isdefined (name))
                logPrint("W;;" + name + "\n");
            wait 10;
            exitLevel(false);
        }
        break;

        case "re":
        {
            game["state"] = "intermission";
            level notify("intermission");

            if(game["alliedscore"] == game["axisscore"])
                text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
            else if(game["alliedscore"] > game["axisscore"])
                text = &"MPSCRIPT_ALLIES_WIN";
            else
                text = &"MPSCRIPT_AXIS_WIN";

            players = getentarray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];

                player closeMenu();
                player setClientCvar("g_scriptMainMenu", "main");
                player setClientCvar("cg_objectiveText", text);
                player spawnIntermission();
            }

            wait 10;
            exitLevel(false);
        }
        break;

        default:
        {
            printLn("##### centralizer: endMap: default");
        }
        break;
    }
}

printJoinedTeam(team)
{
    if(team == "allies")
        iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
    else if(team == "axis")
        iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}