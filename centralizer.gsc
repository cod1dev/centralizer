Callback_StartGameType(gametype)
{
    switch(gametype)
    {
        case "sd":
        {
            // if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
            if(!isdefined(game["gamestarted"]))
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

                game["menu_team"] = "team_" + game["allies"] + game["axis"];
                game["menu_weapon_allies"] = "weapon_" + game["allies"];
                game["menu_weapon_axis"] = "weapon_" + game["axis"];
                game["menu_viewmap"] = "viewmap";
                game["menu_callvote"] = "callvote";
                game["menu_quickcommands"] = "quickcommands";
                game["menu_quickstatements"] = "quickstatements";
                game["menu_quickresponses"] = "quickresponses";
                game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
                game["headicon_axis"] = "gfx/hud/headicon@axis.tga";

                precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
                precacheString(&"MPSCRIPT_KILLCAM");
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

                precacheMenu(game["menu_team"]);
                precacheMenu(game["menu_weapon_allies"]);
                precacheMenu(game["menu_weapon_axis"]);
                precacheMenu(game["menu_viewmap"]);
                precacheMenu(game["menu_callvote"]);
                precacheMenu(game["menu_quickcommands"]);
                precacheMenu(game["menu_quickstatements"]);
                precacheMenu(game["menu_quickresponses"]);

                precacheShader("black");
                precacheShader("white");
                precacheShader("hudScoreboard_mp");
                precacheShader("gfx/hud/hud@mpflag_spectator.tga");
                precacheStatusIcon("gfx/hud/hud@status_dead.tga");
                precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
                precacheHeadIcon(game["headicon_allies"]);
                precacheHeadIcon(game["headicon_axis"]);

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
                precacheModel("xmodel/mp_bomb1_defuse");
                precacheModel("xmodel/mp_bomb1");
                
                maps\mp\gametypes\_teams::precache();
                maps\mp\gametypes\_teams::scoreboard();
                maps\mp\gametypes\_teams::initGlobalCvars();

                //thread addBotClients();
            }
            
            maps\mp\gametypes\_teams::modeltype();
            maps\mp\gametypes\_teams::restrictPlacedWeapons();

            game["gamestarted"] = true;
            
            setClientNameMode("manual_change");

            thread maps\mp\gametypes\sd::bombzones();
            thread maps\mp\gametypes\sd::startGame();
            thread maps\mp\gametypes\sd::updateScriptCvars();
            //thread maps\mp\gametypes\sd::addBotClients();
        }
        break;

        case "dm":
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

            game["menu_team"] = "team_" + game["allies"] + game["axis"];
            game["menu_weapon_allies"] = "weapon_" + game["allies"];
            game["menu_weapon_axis"] = "weapon_" + game["axis"];
            game["menu_viewmap"] = "viewmap";
            game["menu_callvote"] = "callvote";
            game["menu_quickcommands"] = "quickcommands";
            game["menu_quickstatements"] = "quickstatements";
            game["menu_quickresponses"] = "quickresponses";

            precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
            precacheString(&"MPSCRIPT_KILLCAM");

            precacheMenu(game["menu_team"]);
            precacheMenu(game["menu_weapon_allies"]);
            precacheMenu(game["menu_weapon_axis"]);
            precacheMenu(game["menu_viewmap"]);
            precacheMenu(game["menu_callvote"]);
            precacheMenu(game["menu_quickcommands"]);
            precacheMenu(game["menu_quickstatements"]);
            precacheMenu(game["menu_quickresponses"]);

            precacheShader("black");
            precacheShader("hudScoreboard_mp");
            precacheShader("gfx/hud/hud@mpflag_none.tga");
            precacheShader("gfx/hud/hud@mpflag_spectator.tga");
            precacheStatusIcon("gfx/hud/hud@status_dead.tga");
            precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
            precacheItem("item_health");

            maps\mp\gametypes\_teams::modeltype();
            maps\mp\gametypes\_teams::precache();
            maps\mp\gametypes\_teams::initGlobalCvars();
            maps\mp\gametypes\_teams::restrictPlacedWeapons();

            setClientNameMode("auto_change");

            thread maps\mp\gametypes\dm::startGame();
        //	thread maps\mp\gametypes\dm::addBotClients(); // For development testing
            thread maps\mp\gametypes\dm::updateScriptCvars();
        }
        break;

        case "tdm":
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
            
            game["menu_team"] = "team_" + game["allies"] + game["axis"];
            game["menu_weapon_allies"] = "weapon_" + game["allies"];
            game["menu_weapon_axis"] = "weapon_" + game["axis"];
            game["menu_viewmap"] = "viewmap";
            game["menu_callvote"] = "callvote";
            game["menu_quickcommands"] = "quickcommands";
            game["menu_quickstatements"] = "quickstatements";
            game["menu_quickresponses"] = "quickresponses";
            game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
            game["headicon_axis"] = "gfx/hud/headicon@axis.tga";

            precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
            precacheString(&"MPSCRIPT_KILLCAM");

            precacheMenu(game["menu_team"]);
            precacheMenu(game["menu_weapon_allies"]);
            precacheMenu(game["menu_weapon_axis"]);
            precacheMenu(game["menu_viewmap"]);
            precacheMenu(game["menu_callvote"]);
            precacheMenu(game["menu_quickcommands"]);
            precacheMenu(game["menu_quickstatements"]);
            precacheMenu(game["menu_quickresponses"]);

            precacheShader("black");
            precacheShader("hudScoreboard_mp");
            precacheShader("gfx/hud/hud@mpflag_spectator.tga");
            precacheStatusIcon("gfx/hud/hud@status_dead.tga");
            precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
            precacheHeadIcon(game["headicon_allies"]);
            precacheHeadIcon(game["headicon_axis"]);
            precacheItem("item_health");

            maps\mp\gametypes\_teams::modeltype();
            maps\mp\gametypes\_teams::precache();
            maps\mp\gametypes\_teams::scoreboard();
            maps\mp\gametypes\_teams::initGlobalCvars();
            maps\mp\gametypes\_teams::restrictPlacedWeapons();

            setClientNameMode("auto_change");
            
            thread maps\mp\gametypes\tdm::startGame();
            //thread maps\mp\gametypes\tdm::addBotClients(); // For development testing
            thread maps\mp\gametypes\tdm::updateScriptCvars();
        }
        break;

        case "bel":
        {
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

            if(getcvar("scr_allies") != "")
                game["allies"] = getcvar("scr_allies");
            if(getcvar("scr_axis") != "")
                game["axis"] = getcvar("scr_axis");

            game["menu_team"] = "team_germanonly";
            
            game["menu_weapon_all"] = "weapon_" + game["allies"] + game["axis"];
            game["menu_weapon_allies_only"] = "weapon_" + game["allies"];
            game["menu_weapon_axis_only"] = "weapon_" + game["axis"];
            game["menu_viewmap"] = "viewmap";
            game["menu_callvote"] = "callvote";
            game["menu_quickcommands"] = "quickcommands";
            game["menu_quickstatements"] = "quickstatements";
            game["menu_quickresponses"] = "quickresponses";
            game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
            game["headicon_axis"] = "gfx/hud/headicon@axis.tga";

            precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
            precacheString(&"MPSCRIPT_KILLCAM");
            precacheString(&"BEL_TIME_ALIVE");
            precacheString(&"BEL_TIME_TILL_SPAWN");
            precacheString(&"BEL_PRESS_TO_RESPAWN");
            precacheString(&"BEL_POINTS_EARNED");
            precacheString(&"BEL_WONTBE_ALLIED");
            precacheString(&"BEL_BLACKSCREEN_KILLEDALLIED");
            precacheString(&"BEL_BLACKSCREEN_WILLSPAWN");
            
            precacheMenu(game["menu_team"]);
            precacheMenu(game["menu_weapon_all"]);
            precacheMenu(game["menu_weapon_allies_only"]);
            precacheMenu(game["menu_weapon_axis_only"]);
            precacheMenu(game["menu_viewmap"]);
            precacheMenu(game["menu_callvote"]);
            precacheMenu(game["menu_quickcommands"]);
            precacheMenu(game["menu_quickstatements"]);
            precacheMenu(game["menu_quickresponses"]);

            precacheShader("black");
            precacheShader("gfx/hud/hud@objective_bel.tga");
            precacheShader("gfx/hud/hud@objective_bel_up.tga");
            precacheShader("gfx/hud/hud@objective_bel_down.tga");
            precacheShader("hudScoreboard_mp");
            precacheShader("gfx/hud/hud@mpflag_spectator.tga");
            precacheHeadIcon("gfx/hud/headicon@killcam_arrow");
            precacheHeadIcon(game["headicon_allies"]);
            precacheHeadIcon(game["headicon_axis"]);
            precacheStatusIcon("gfx/hud/hud@status_dead.tga");
            precacheStatusIcon("gfx/hud/hud@status_connecting.tga");

            maps\mp\gametypes\_teams::modeltype();
            maps\mp\gametypes\_teams::precache();
            maps\mp\gametypes\_teams::scoreboard();
            maps\mp\gametypes\_teams::initGlobalCvars();
            maps\mp\gametypes\_teams::restrictPlacedWeapons();

            setClientNameMode("auto_change");

            thread maps\mp\gametypes\bel::startGame();
            thread maps\mp\gametypes\bel::updateScriptCvars();
        }
        break;

        case "re":
        {
            // if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
            if(!isdefined(game["gamestarted"]))
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

                game["menu_team"] = "team_" + game["allies"] + game["axis"];
                game["menu_weapon_allies"] = "weapon_" + game["allies"];
                game["menu_weapon_axis"] = "weapon_" + game["axis"];
                game["menu_viewmap"] = "viewmap";
                game["menu_callvote"] = "callvote";
                game["menu_quickcommands"] = "quickcommands";
                game["menu_quickstatements"] = "quickstatements";
                game["menu_quickresponses"] = "quickresponses";
                
                precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
                precacheString(&"MPSCRIPT_KILLCAM");
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
                
                precacheHeadIcon(game["headicon_allies"]);
                precacheHeadIcon(game["headicon_axis"]);
                precacheHeadIcon(game["headicon_carrier"]);
                
                precacheShader("gfx/hud/hud@objectivegoal.tga");
                precacheShader("gfx/hud/hud@objectivegoal_up.tga");
                precacheShader("gfx/hud/hud@objectivegoal_down.tga");
                precacheShader("gfx/hud/objective.tga");
                precacheShader("gfx/hud/objective_up.tga");
                precacheShader("gfx/hud/objective_down.tga");
                precacheShader("black");
                precacheShader("white");
                precacheShader("hudScoreboard_mp");
                precacheShader("gfx/hud/hud@mpflag_spectator.tga");
                
                precacheMenu(game["menu_team"]);
                precacheMenu(game["menu_weapon_allies"]);
                precacheMenu(game["menu_weapon_axis"]);
                precacheMenu(game["menu_viewmap"]);
                precacheMenu(game["menu_callvote"]);
                precacheMenu(game["menu_quickcommands"]);
                precacheMenu(game["menu_quickstatements"]);
                precacheMenu(game["menu_quickresponses"]);
                
                precacheStatusIcon("gfx/hud/hud@status_dead.tga");
                precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
                precacheStatusIcon(game["headicon_carrier"]);
                
                maps\mp\gametypes\_teams::precache();
                maps\mp\gametypes\_teams::scoreboard();
                maps\mp\gametypes\_teams::initGlobalCvars();

                //thread maps\mp\gametypes\re::addBotClients();
            }

            maps\mp\gametypes\_teams::modeltype();
            maps\mp\gametypes\_teams::restrictPlacedWeapons();

            game["gamestarted"] = true;
            
            setClientNameMode("manual_change");

            thread maps\mp\gametypes\re::startGame();
            thread maps\mp\gametypes\re::updateScriptCvars();
            //thread maps\mp\gametypes\re::addBotClients();
        }
        break;

        default:
        {
            printLn("##### centralizer: Callback_StartGameType: default");
        }
        break;
    }
}

Callback_PlayerConnect(gametype)
{
    switch(gametype)
    {
        case "sd":
        {
            self.statusicon = "gfx/hud/hud@status_connecting.tga";
            self waittill("begin");
            self.statusicon = "";

            if(!isdefined(self.pers["team"]))
                iprintln(&"MPSCRIPT_CONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("J;" + lpselfnum + ";" + self.name + "\n");

            if(game["state"] == "intermission")
            {
                maps\mp\gametypes\sd::spawnIntermission();
                return;
            }
            
            level endon("intermission");
            
            if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
            {
                self setClientCvar("scr_showweapontab", "1");

                if(self.pers["team"] == "allies")
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
                else
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

                if(isdefined(self.pers["weapon"]))
                    maps\mp\gametypes\sd::spawnPlayer();
                else
                {
                    self.sessionteam = "spectator";

                    maps\mp\gametypes\sd::spawnSpectator();

                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else
                        self openMenu(game["menu_weapon_axis"]);
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

                maps\mp\gametypes\sd::spawnSpectator();
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
                    case "autoassign":
                        if(response == "autoassign")
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
                                else if(getTeamScore("allies") < getTeamScore("axis"))
                                    response = "allies";
                                else
                                    response = "axis";
                            }
                            else if(numonteam["allies"] < numonteam["axis"])
                                response = "allies";
                            else
                                response = "axis";
                        }
                        
                        if(response == self.pers["team"] && self.sessionstate == "playing")
                            break;
                        
                        if(response != self.pers["team"] && self.sessionstate == "playing")
                            self suicide();
                                    
                        self.pers["team"] = response;
                        self.pers["weapon"] = undefined;
                        self.pers["weapon1"] = undefined;
                        self.pers["weapon2"] = undefined;
                        self.pers["spawnweapon"] = undefined;
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
                            if(isalive(self))
                                self suicide();

                            self.pers["team"] = "spectator";
                            self.pers["weapon"] = undefined;
                            self.pers["weapon1"] = undefined;
                            self.pers["weapon2"] = undefined;
                            self.pers["spawnweapon"] = undefined;
                            self.pers["savedmodel"] = undefined;
                            
                            self.sessionteam = "spectator";
                            self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                            self setClientCvar("scr_showweapontab", "0");
                            maps\mp\gametypes\sd::spawnSpectator();
                        }
                        break;

                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
                        break;

                    case "viewmap":
                        self openMenu(game["menu_viewmap"]);
                        break;
                    
                    case "callvote":
                        self openMenu(game["menu_callvote"]);
                        break;
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
                    
                    if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isdefined(self.pers["weapon1"]))
                        continue;
                        
                    if(!game["matchstarted"])
                    {
                        self.pers["weapon"] = weapon;
                        self.spawned = undefined;
                        maps\mp\gametypes\sd::spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                        level maps\mp\gametypes\sd::checkMatchStart();
                    }
                    else if(!level.roundstarted)
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
                                maps\mp\gametypes\sd::spawnPlayer();
                                self thread printJoinedTeam(self.pers["team"]);
                                level maps\mp\gametypes\sd::checkMatchStart();
                            }
                            else
                            {
                                maps\mp\gametypes\sd::spawnPlayer();
                                self thread printJoinedTeam(self.pers["team"]);
                            }
                        }
                    }
                    else
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
                            maps\mp\gametypes\sd::spawnPlayer();
                            self thread printJoinedTeam(self.pers["team"]);
                        }				
                        else if(!level.didexist[self.pers["team"]] && !level.roundended)
                        {
                            self.spawned = undefined;
                            maps\mp\gametypes\sd::spawnPlayer();
                            self thread printJoinedTeam(self.pers["team"]);
                            level maps\mp\gametypes\sd::checkMatchStart();
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
                }
                else if(menu == game["menu_viewmap"])
                {
                    switch(response)
                    {
                    case "team":
                        self openMenu(game["menu_team"]);
                        break;
                        
                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
        break;

        case "dm":
        {
            self.statusicon = "gfx/hud/hud@status_connecting.tga";
            self waittill("begin");
            self.statusicon = "";

            iprintln(&"MPSCRIPT_CONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("J;" + lpselfnum + ";" + self.name + "\n");
            
            if(game["state"] == "intermission")
            {
                maps\mp\gametypes\dm::spawnIntermission();
                return;
            }

            level endon("intermission");

            if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
            {
                self setClientCvar("scr_showweapontab", "1");
                self.sessionteam = "none";

                if(self.pers["team"] == "allies")
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
                else
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

                if(isdefined(self.pers["weapon"]))
                    maps\mp\gametypes\dm::spawnPlayer();
                else
                {
                    maps\mp\gametypes\dm::spawnSpectator();

                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else
                        self openMenu(game["menu_weapon_axis"]);
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

                maps\mp\gametypes\dm::spawnSpectator();
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
                    case "autoassign":
                        if(response == "autoassign")
                        {
                            teams[0] = "allies";
                            teams[1] = "axis";
                            response = teams[randomInt(2)];
                        }

                        if(response == self.pers["team"] && self.sessionstate == "playing")
                            break;

                        if(response != self.pers["team"] && self.sessionstate == "playing")
                            self suicide();

                        self notify("end_respawn");

                        self.pers["team"] = response;
                        self.pers["weapon"] = undefined;
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
                            self.pers["team"] = "spectator";
                            self.pers["weapon"] = undefined;
                            self.pers["savedmodel"] = undefined;

                            self.sessionteam = "spectator";
                            self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                            self setClientCvar("scr_showweapontab", "0");
                            maps\mp\gametypes\dm::spawnSpectator();
                        }
                        break;

                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
                        break;

                    case "viewmap":
                        self openMenu(game["menu_viewmap"]);
                        break;

                    case "callvote":
                        self openMenu(game["menu_callvote"]);
                        break;
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

                    if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                        continue;

                    if(!isdefined(self.pers["weapon"]))
                    {
                        self.pers["weapon"] = weapon;
                        maps\mp\gametypes\dm::spawnPlayer();
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
                else if(menu == game["menu_viewmap"])
                {
                    switch(response)
                    {
                    case "team":
                        self openMenu(game["menu_team"]);
                        break;

                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
        break;

        case "tdm":
        {
            self.statusicon = "gfx/hud/hud@status_connecting.tga";
            self waittill("begin");
            self.statusicon = "";

            iprintln(&"MPSCRIPT_CONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("J;" + lpselfnum + ";" + self.name + "\n");

            if(game["state"] == "intermission")
            {
                maps\mp\gametypes\tdm::spawnIntermission();
                return;
            }
            
            level endon("intermission");

            if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
            {
                self setClientCvar("scr_showweapontab", "1");

                if(self.pers["team"] == "allies")
                {
                    self.sessionteam = "allies";
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
                }
                else
                {
                    self.sessionteam = "axis";
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
                }
                    
                if(isdefined(self.pers["weapon"]))
                    maps\mp\gametypes\tdm::spawnPlayer();
                else
                {
                    maps\mp\gametypes\tdm::spawnSpectator();

                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else
                        self openMenu(game["menu_weapon_axis"]);
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

                maps\mp\gametypes\tdm::spawnSpectator();
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
                    case "autoassign":
                        if(response == "autoassign")
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
                                else if(getTeamScore("allies") < getTeamScore("axis"))
                                    response = "allies";
                                else
                                    response = "axis";
                            }
                            else if(numonteam["allies"] < numonteam["axis"])
                                response = "allies";
                            else
                                response = "axis";
                        }
                        
                        if(response == self.pers["team"] && self.sessionstate == "playing")
                            break;

                        if(response != self.pers["team"] && self.sessionstate == "playing")
                            self suicide();

                        self notify("end_respawn");

                        self.pers["team"] = response;
                        self.pers["weapon"] = undefined;
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
                            self.pers["team"] = "spectator";
                            self.pers["weapon"] = undefined;
                            self.pers["savedmodel"] = undefined;
                            
                            self.sessionteam = "spectator";
                            self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                            self setClientCvar("scr_showweapontab", "0");
                            maps\mp\gametypes\tdm::spawnSpectator();
                        }
                        break;

                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
                        break;
                        
                    case "viewmap":
                        self openMenu(game["menu_viewmap"]);
                        break;

                    case "callvote":
                        self openMenu(game["menu_callvote"]);
                        break;
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
                    
                    if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                        continue;
                    
                    if(!isdefined(self.pers["weapon"]))
                    {
                        self.pers["weapon"] = weapon;
                        maps\mp\gametypes\tdm::spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
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
                else if(menu == game["menu_viewmap"])
                {
                    switch(response)
                    {
                    case "team":
                        self openMenu(game["menu_team"]);
                        break;
                        
                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
        break;

        case "bel":
        {
            self.statusicon = "gfx/hud/hud@status_connecting.tga";
            self waittill("begin");
            self.statusicon = "";
            self.god = false;
            self.respawnwait = false;
            
            if(!isdefined(self.pers["team"]))
                iprintln(&"MPSCRIPT_CONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("J;" + lpselfnum + ";" + self.name + "\n");

            if(game["state"] == "intermission")
            {
                maps\mp\gametypes\bel::spawnIntermission();
                return;
            }

            level endon("intermission");
            
            if (isdefined (self.blackscreen))
                self.blackscreen destroy();
            if (isdefined (self.blackscreentext))
                self.blackscreentext destroy();
            if (isdefined (self.blackscreentext2))
                self.blackscreentext2 destroy();
            if (isdefined (self.blackscreentimer))
                self.blackscreentimer destroy();

            if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
            {
                self setClientCvar("scr_showweapontab", "1");

                if(self.pers["team"] == "allies")
                    self.sessionteam = "allies";
                else
                    self.sessionteam = "axis";
                
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);
                
                if(isdefined(self.pers["weapon"]))
                {
                    maps\mp\gametypes\bel::spawnPlayer();
                }
                else
                {
                    maps\mp\gametypes\bel::spawnSpectator();

                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies_only"]);
                    else
                        self openMenu(game["menu_weapon_axis_only"]);
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
                
                maps\mp\gametypes\bel::spawnSpectator();
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
                        case "axis":
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

                        case "spectator":
                            if(self.pers["team"] != "spectator")
                            {
                                self.pers["team"] = "spectator";
                                self.pers["weapon"] = undefined;
                                self.pers["LastAxisWeapon"] = undefined;
                                self.pers["LastAlliedWeapon"] = undefined;
                                self.pers["savedmodel"] = undefined;
                                self.sessionteam = "spectator";
                                self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                                self setClientCvar("scr_showweapontab", "0");
                                if (isdefined (self.blackscreen))
                                    self.blackscreen destroy();
                                if (isdefined (self.blackscreentext))
                                    self.blackscreentext destroy();
                                if (isdefined (self.blackscreentext2))
                                    self.blackscreentext2 destroy();
                                if (isdefined (self.blackscreentimer))
                                    self.blackscreentimer destroy();
                                self maps\mp\gametypes\bel::spawnSpectator();
                                maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
                            }
                            break;

                        case "weapon":
                            if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                                self openMenu(game["menu_weapon_all"]);
                            break;

                        case "viewmap":
                            self openMenu(game["menu_viewmap"]);
                            break;

                        case "callvote":
                            self openMenu(game["menu_callvote"]);
                            break;
                    }
                }		
                else if(menu == game["menu_weapon_all"] || menu == game["menu_weapon_allies_only"] || menu == game["menu_weapon_axis_only"])
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
                                    maps\mp\gametypes\bel::spawnPlayer();
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
                                    maps\mp\gametypes\bel::spawnPlayer();
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
                                maps\mp\gametypes\bel::spawnPlayer();
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
                else if(menu == game["menu_viewmap"])
                {
                    switch(response)
                    {
                        case "team":
                            self openMenu(game["menu_team"]);
                            break;

                        case "weapon":
                            if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                                self openMenu(game["menu_weapon_all"]);
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
                            if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                                self openMenu(game["menu_weapon_all"]);
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
        break;

        case "re":
        {
            self.statusicon = "gfx/hud/hud@status_connecting.tga";
            self waittill("begin");
            self.statusicon = "";
            self.hudelem = [];
            
            if(!isdefined(self.pers["team"]))
                iprintln(&"MPSCRIPT_CONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("J;" + lpselfnum + ";" + self.name + "\n");

            self.objs_held = 0;
            if(game["state"] == "intermission")
            {
                maps\mp\gametypes\re::spawnIntermission();
                return;
            }

            level endon("intermission");

            if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
            {
                self setClientCvar("scr_showweapontab", "1");

                if(self.pers["team"] == "allies")
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
                else
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

                if(isdefined(self.pers["weapon"]))
                    maps\mp\gametypes\re::spawnPlayer();
                else
                {
                    self.sessionteam = "spectator";

                    maps\mp\gametypes\re::spawnSpectator();

                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else
                        self openMenu(game["menu_weapon_axis"]);
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

                maps\mp\gametypes\re::spawnSpectator();
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
                    case "autoassign":
                        if(response == "autoassign")
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
                                else if(getTeamScore("allies") < getTeamScore("axis"))
                                    response = "allies";
                                else
                                    response = "axis";
                            }
                            else if(numonteam["allies"] < numonteam["axis"])
                                response = "allies";
                            else
                                response = "axis";
                        }

                        if(response == self.pers["team"] && self.sessionstate == "playing")
                            break;

                        if(response != self.pers["team"] && self.sessionstate == "playing")
                            self suicide();

                        self.pers["team"] = response;
                        self.pers["weapon"] = undefined;
                        self.pers["weapon1"] = undefined;
                        self.pers["weapon2"] = undefined;
                        self.pers["spawnweapon"] = undefined;
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
                            if(isalive(self))
                                self suicide();

                            self.pers["team"] = "spectator";
                            self.pers["weapon"] = undefined;
                            self.pers["weapon1"] = undefined;
                            self.pers["weapon2"] = undefined;
                            self.pers["spawnweapon"] = undefined;
                            self.pers["savedmodel"] = undefined;

                            self.sessionteam = "spectator";
                            self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                            self setClientCvar("scr_showweapontab", "0");
                            maps\mp\gametypes\re::spawnSpectator();
                        }
                        break;

                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
                        break;

                    case "viewmap":
                        self openMenu(game["menu_viewmap"]);
                        break;

                    case "callvote":
                        self openMenu(game["menu_callvote"]);
                        break;
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

                    if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isdefined(self.pers["weapon1"]))
                        continue;

                    if(!game["matchstarted"])
                    {
                        self.pers["weapon"] = weapon;
                        self.spawned = undefined;
                        maps\mp\gametypes\re::spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                        level maps\mp\gametypes\re::checkMatchStart();
                    }
                    else if(!level.roundstarted)
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
                                maps\mp\gametypes\re::spawnPlayer();
                                self thread printJoinedTeam(self.pers["team"]);
                                level maps\mp\gametypes\re::checkMatchStart();
                            }
                            else
                            {
                                maps\mp\gametypes\re::spawnPlayer();
                                self thread printJoinedTeam(self.pers["team"]);
                            }
                        }
                    }
                    else
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
                            maps\mp\gametypes\re::spawnPlayer();
                            self thread printJoinedTeam(self.pers["team"]);
                        }				
                        else if(!level.didexist[self.pers["team"]] && !level.roundended)
                        {
                            self.spawned = undefined;
                            maps\mp\gametypes\re::spawnPlayer();
                            self thread printJoinedTeam(self.pers["team"]);
                            level maps\mp\gametypes\re::checkMatchStart();
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
                }
                else if(menu == game["menu_viewmap"])
                {
                    switch(response)
                    {
                    case "team":
                        self openMenu(game["menu_team"]);
                        break;

                    case "weapon":
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
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
        break;

        default:
        {
            printLn("##### centralizer: Callback_PlayerConnect: default");
        }
        break;
    }
}

Callback_PlayerDisconnect(gametype)
{
    switch(gametype)
    {
        case "sd":
        {
            iprintln(&"MPSCRIPT_DISCONNECTED", self);
    
            lpselfnum = self getEntityNumber();
            logPrint("Q;" + lpselfnum + ";" + self.name + "\n");

            if(game["matchstarted"])
                level thread maps\mp\gametypes\sd::updateTeamStatus();
        }
        break;

        case "dm":
        {
            iprintln(&"MPSCRIPT_DISCONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("Q;" + lpselfnum + ";" + self.name + "\n");
        }
        break;

        case "tdm":
        {
            iprintln(&"MPSCRIPT_DISCONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("Q;" + lpselfnum + ";" + self.name + "\n");
        }
        break;

        case "bel":
        {
            iprintln(&"MPSCRIPT_DISCONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("Q;" + lpselfnum + ";" + self.name + "\n");

            self.pers["team"] = "spectator";
            self maps\mp\gametypes\bel::check_delete_objective();
            maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
        }
        break;

        case "re":
        {
            iprintln(&"MPSCRIPT_DISCONNECTED", self);

            lpselfnum = self getEntityNumber();
            logPrint("Q;" + lpselfnum + ";" + self.name + "\n");

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
                            //	self.hasobj[i] maps\mp\gametypes\re::drop_objective_on_disconnect_or_death(self, "trace");
                        }
                    }
                }
            }

            self notify ("death");
            
            if(game["matchstarted"])
            level thread maps\mp\gametypes\re::updateTeamStatus();
        }
        break;

        default:
        {
            printLn("##### centralizer: Callback_PlayerDisconnect: default");
        }
        break;
    }
}

Callback_PlayerDamage(gametype, eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    switch(gametype)
    {
        case "sd":
        {
            if(self.sessionteam == "spectator")
                return;

            // Don't do knockback if the damage direction was not specified
            if(!isDefined(vDir))
                iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

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

            // Do debug print if it's enabled
            if(getCvarInt("g_debugDamage"))
            {
                println("client:" + self getEntityNumber() + " health:" + self.health +
                    " damage:" + iDamage + " hitLoc:" + sHitLoc);
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
        break;

        case "dm":
        {
            if(self.sessionteam == "spectator")
                return;

            // Don't do knockback if the damage direction was not specified
            if(!isDefined(vDir))
                iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

            // Make sure at least one point of damage is done
            if(iDamage < 1)
                iDamage = 1;

            // Do debug print if it's enabled
            if(getCvarInt("g_debugDamage"))
            {
                println("client:" + self getEntityNumber() + " health:" + self.health +
                    " damage:" + iDamage + " hitLoc:" + sHitLoc);
            }

            // Apply the damage to the player
            self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);

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

                logPrint("D;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
            }
        }
        break;

        case "tdm":
        {
            if(self.sessionteam == "spectator")
                return;

            // Don't do knockback if the damage direction was not specified
            if(!isDefined(vDir))
                iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

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

            // Do debug print if it's enabled
            if(getCvarInt("g_debugDamage"))
            {
                println("client:" + self getEntityNumber() + " health:" + self.health +
                    " damage:" + iDamage + " hitLoc:" + sHitLoc);
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
        break;

        case "bel":
        {
            if ( (isdefined (eAttacker)) && (isPlayer(eAttacker)) && (isdefined (eAttacker.god)) && (eAttacker.god == true) )
                return;

            if ( (self.sessionteam == "spectator") || (self.god == true) )
                return;
            
            // Don't do knockback if the damage direction was not specified
            if(!isDefined(vDir))
                iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

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

            // Do debug print if it's enabled
            if(getCvarInt("g_debugDamage"))
            {
                println("client:" + self getEntityNumber() + " health:" + self.health +
                    " damage:" + iDamage + " hitLoc:" + sHitLoc);
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
        break;

        case "re":
        {
            if(self.sessionteam == "spectator")
                return;

            // Don't do knockback if the damage direction was not specified
            if(!isDefined(vDir))
                iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

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

            // Do debug print if it's enabled
            if(getCvarInt("g_debugDamage"))
            {
                println("client:" + self getEntityNumber() + " health:" + self.health +
                    " damage:" + iDamage + " hitLoc:" + sHitLoc);
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
        break;

        default:
        {
            printLn("##### centralizer: Callback_PlayerDamage: default");
        }
        break;
    }
}

Callback_PlayerKilled(gametype, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
    switch(gametype)
    {
        case "sd":
        {
            self endon("spawned");

            if(self.sessionteam == "spectator")
                return;

            // If the player was killed by a head shot, let players know it was a head shot kill
            if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
                sMeansOfDeath = "MOD_HEAD_SHOT";

            // send out an obituary message to all clients about the kill
            obituary(self, attacker, sWeapon, sMeansOfDeath);

            self.sessionstate = "dead";
            self.statusicon = "gfx/hud/hud@status_dead.tga";
            self.headicon = "";
            self.pers["deaths"]++;
            self.deaths = self.pers["deaths"];

            lpselfnum = self getEntityNumber();
            lpselfname = self.name;
            lpselfteam = self.pers["team"];
            lpattackerteam = "";

            attackerNum = -1;
            level.playercam = attacker getEntityNumber();

            if(isPlayer(attacker))
            {
                if(attacker == self) // killed himself
                {
                    doKillcam = false;

                    attacker.pers["score"]--;
                    attacker.score = attacker.pers["score"];
                    
                    if(isdefined(attacker.reflectdamage))
                        clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
                }
                else
                {
                    attackerNum = attacker getEntityNumber();
                    doKillcam = true;

                    if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
                    {
                        attacker.pers["score"]--;
                        attacker.score = attacker.pers["score"];
                    }
                    else
                    {
                        attacker.pers["score"]++;
                        attacker.score = attacker.pers["score"];
                    }
                }
                
                lpattacknum = attacker getEntityNumber();
                lpattackname = attacker.name;
                lpattackerteam = attacker.pers["team"];
            }
            else // If you weren't killed by a player, you were in the wrong place at the wrong time
            {
                doKillcam = false;

                self.pers["score"]--;
                self.score = self.pers["score"];

                lpattacknum = -1;
                lpattackname = "";
                lpattackerteam = "world";
            }

            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

            // Make the player drop his weapon
            self dropItem(self getcurrentweapon());

            self.pers["weapon1"] = undefined;
            self.pers["weapon2"] = undefined;
            self.pers["spawnweapon"] = undefined;

            body = self cloneplayer();

            maps\mp\gametypes\sd::updateTeamStatus();

            // TODO: Add additional checks that allow killcam when the last player killed wouldn't end the round (bomb is planted)
            if(!level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
                doKillcam = false;

            delay = 2;	// Delay the player becoming a spectator till after he's done dying
            wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

            if(doKillcam && !level.roundended)
                self thread maps\mp\gametypes\sd::killcam(attackerNum, delay);
            else
            {
                currentorigin = self.origin;
                currentangles = self.angles;

                self thread maps\mp\gametypes\sd::spawnSpectator(currentorigin + (0, 0, 60), currentangles);
            }
        }
        break;

        case "dm":
        {
            self endon("spawned");

            if(self.sessionteam == "spectator")
                return;

            // If the player was killed by a head shot, let players know it was a head shot kill
            if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
                sMeansOfDeath = "MOD_HEAD_SHOT";

            // send out an obituary message to all clients about the kill
            obituary(self, attacker, sWeapon, sMeansOfDeath);

            self.sessionstate = "dead";
            self.statusicon = "gfx/hud/hud@status_dead.tga";
            self.deaths++;

            lpselfnum = self getEntityNumber();
            lpselfname = self.name;
            lpselfteam = "";
            lpattackerteam = "";

            attackerNum = -1;
            if(isPlayer(attacker))
            {
                if(attacker == self) // killed himself
                {
                    doKillcam = false;

                    attacker.score--;
                }
                else
                {
                    attackerNum = attacker getEntityNumber();
                    doKillcam = true;

                    attacker.score++;
                    attacker maps\mp\gametypes\dm::checkScoreLimit();
                }

                lpattacknum = attacker getEntityNumber();
                lpattackname = attacker.name;
            }
            else // If you weren't killed by a player, you were in the wrong place at the wrong time
            {
                doKillcam = false;

                self.score--;

                lpattacknum = -1;
                lpattackname = "";
            }

            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

            // Stop thread if map ended on this death
            if(level.mapended)
                return;
                
        //	self updateDeathArray();

            // Make the player drop his weapon
            self dropItem(self getcurrentweapon());

            // Make the player drop health
            self maps\mp\gametypes\dm::dropHealth();

            body = self cloneplayer();

            delay = 2;	// Delay the player becoming a spectator till after he's done dying
            wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute
            
            if(getcvarint("scr_forcerespawn") > 0)
                doKillcam = false;
            
            if(doKillcam)
                self thread maps\mp\gametypes\dm::killcam(attackerNum, delay);
            else
                self thread maps\mp\gametypes\dm::respawn();
        }
        break;

        case "tdm":
        {
            self endon("spawned");
    
            if(self.sessionteam == "spectator")
                return;

            // If the player was killed by a head shot, let players know it was a head shot kill
            if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
                sMeansOfDeath = "MOD_HEAD_SHOT";
                
            // send out an obituary message to all clients about the kill
            obituary(self, attacker, sWeapon, sMeansOfDeath);
            
            self.sessionstate = "dead";
            self.statusicon = "gfx/hud/hud@status_dead.tga";
            self.headicon = "";
            self.deaths++;

            lpselfnum = self getEntityNumber();
            lpselfname = self.name;
            lpselfteam = self.pers["team"];
            lpattackerteam = "";

            attackerNum = -1;
            if(isPlayer(attacker))
            {
                if(attacker == self) // killed himself
                {
                    doKillcam = false;

                    attacker.score--;
                    
                    if(isdefined(attacker.reflectdamage))
                        clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
                }
                else
                {
                    attackerNum = attacker getEntityNumber();
                    doKillcam = true;

                    if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
                        attacker.score--;
                    else
                    {
                        attacker.score++;

                        teamscore = getTeamScore(attacker.pers["team"]);
                        teamscore++;
                        setTeamScore(attacker.pers["team"], teamscore);
                    
                        maps\mp\gametypes\tdm::checkScoreLimit();
                    }
                }

                lpattacknum = attacker getEntityNumber();
                lpattackname = attacker.name;
                lpattackerteam = attacker.pers["team"];
            }
            else // If you weren't killed by a player, you were in the wrong place at the wrong time
            {
                doKillcam = false;
                
                self.score--;

                lpattacknum = -1;
                lpattackname = "";
                lpattackerteam = "world";
            }

            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

            // Stop thread if map ended on this death
            if(level.mapended)
                return;

            // Make the player drop his weapon
            self dropItem(self getcurrentweapon());
            
            // Make the player drop health
            self maps\mp\gametypes\tdm::dropHealth();

            body = self cloneplayer();

            delay = 2;	// Delay the player becoming a spectator till after he's done dying
            wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

            if(getcvarint("scr_forcerespawn") > 0)
                doKillcam = false;

            if(doKillcam)
                self thread maps\mp\gametypes\tdm::killcam(attackerNum, delay);
            else
                self thread maps\mp\gametypes\tdm::respawn();
        }
        break;

        case "bel":
        {
            self endon("spawned");
            self notify ("Stop give points");
            
            self maps\mp\gametypes\bel::check_delete_objective();
            
            if ( (self.sessionteam == "spectator") || (self.god == true) )
                return;
            
            obituary(self, attacker, sWeapon, sMeansOfDeath);
            
            // If the player was killed by a head shot, let players know it was a head shot kill
            if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
                sMeansOfDeath = "MOD_HEAD_SHOT";
            
            self.sessionstate = "dead";
            self.statusicon = "gfx/hud/hud@status_dead.tga";
            self.deaths++;
            self.headicon = "";

            body = self cloneplayer();
            self dropItem(self getcurrentweapon());
            self maps\mp\gametypes\bel::updateDeathArray();

            lpselfnum = self getEntityNumber();
            lpselfname = self.name;
            lpselfteam = self.pers["team"];
            lpattackerteam = "";
            
            attackerNum = -1;
            if(isPlayer(attacker))
            {
                lpattacknum = attacker getEntityNumber();
                lpattackname = attacker.name;
                lpattackerteam = attacker.pers["team"];
                logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
                
                if(attacker == self) // player killed himself
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
                else if(self.pers["team"] == attacker.pers["team"]) // player was killed by a friendly
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
                        
                        self thread maps\mp\gametypes\bel::killcam (attackerNum, 2, "allies to axis");
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
                    
                        self thread maps\mp\gametypes\bel::killcam (attackerNum, 2, "axis to axis");
                        return;
                    }
                }
            }
            else // Player wasn't killed by another player or themself (landmines, etc.)
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
            }
        }
        break;

        case "re":
        {
            self endon("spawned");

            if(self.sessionteam == "spectator")
                return;

            // If the player was killed by a head shot, let players know it was a head shot kill
            if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
                sMeansOfDeath = "MOD_HEAD_SHOT";

            // send out an obituary message to all clients about the kill
            obituary(self, attacker, sWeapon, sMeansOfDeath);
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
                            //	self.hasobj[i] thread maps\mp\gametypes\re::drop_objective_on_disconnect_or_death(self.origin, "trace");
                            //}
                        }
                    }
                }
            }

            self.sessionstate = "dead";
            self.statusicon = "gfx/hud/hud@status_dead.tga";
            self.headicon = "";
            self.pers["deaths"]++;
            self.deaths = self.pers["deaths"];

            lpselfnum = self getEntityNumber();
            lpselfname = self.name;
            lpselfteam = self.pers["team"];
            lpattackerteam = "";

            attackerNum = -1;
            level.playercam = attacker getEntityNumber();

            if(isPlayer(attacker))
            {
                if(attacker == self) // killed himself
                {
                    doKillcam = false;

                    attacker.pers["score"]--;
                    attacker.score = attacker.pers["score"];

                    if(isdefined(attacker.reflectdamage))
                        clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
                }
                else
                {
                    attackerNum = attacker getEntityNumber();
                    doKillcam = true;

                    if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
                    {
                        attacker.pers["score"]--;
                        attacker.score = attacker.pers["score"];
                    }
                    else
                    {
                        attacker.pers["score"]++;
                        attacker.score = attacker.pers["score"];
                    }
                }

                lpattacknum = attacker getEntityNumber();
                lpattackname = attacker.name;
                lpattackerteam = attacker.pers["team"];
            }
            else // If you weren't killed by a player, you were in the wrong place at the wrong time
            {
                doKillcam = false;

                self.pers["score"]--;
                self.score = self.pers["score"];
                
                lpattacknum = -1;
                lpattackname = "";
                lpattackerteam = "world";
            }

            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

            // Make the player drop his weapon
            self dropItem(self getcurrentweapon());

            self.pers["weapon1"] = undefined;
            self.pers["weapon2"] = undefined;
            self.pers["spawnweapon"] = undefined;

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
            
            body = self cloneplayer();

            maps\mp\gametypes\re::updateTeamStatus();

            // TODO: Add additional checks that allow killcam when the last player killed wouldn't end the round (bomb is planted)
            if(!level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
                doKillcam = false;

            delay = 2;	// Delay the player becoming a spectator till after he's done dying
            wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

            if(doKillcam && !level.roundended)
                self thread maps\mp\gametypes\re::killcam(attackerNum, delay);
            else
            {
                currentorigin = self.origin;
                currentangles = self.angles;

                self thread maps\mp\gametypes\re::spawnSpectator(currentorigin + (0, 0, 60), currentangles);
            }
        }
        break;

        default:
        {
            printLn("##### centralizer: Callback_PlayerKilled: default");
        }
        break;
    }
}

spawnPlayer(gametype)
{
    switch(gametype)
    {
        case "sd":
        {
            self notify("spawned");

            resettimeout();

            self.sessionteam = self.pers["team"];
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            if(isdefined(self.spawned))
                return;

            self.sessionstate = "playing";
                
            if(self.pers["team"] == "allies")
                spawnpointname = "mp_searchanddestroy_spawn_allied";
            else
                spawnpointname = "mp_searchanddestroy_spawn_axis";

            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
            
            self.spawned = true;
            self.statusicon = "";
            self.maxhealth = 100;
            self.health = self.maxhealth;
            
            maps\mp\gametypes\sd::updateTeamStatus();
            
            if(!isdefined(self.pers["score"]))
                self.pers["score"] = 0;
            self.score = self.pers["score"];
            
            if(!isdefined(self.pers["deaths"]))
                self.pers["deaths"] = 0;
            self.deaths = self.pers["deaths"];
            
            if(!isdefined(self.pers["savedmodel"]))
                maps\mp\gametypes\_teams::model();
            else
                maps\mp\_utility::loadModel(self.pers["savedmodel"]);
            
            maps\mp\gametypes\_teams::loadout();

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
            
            if(self.pers["team"] == game["attackers"])
                self setClientCvar("cg_objectiveText", &"SD_OBJ_ATTACKERS");
            else if(self.pers["team"] == game["defenders"])
                self setClientCvar("cg_objectiveText", &"SD_OBJ_DEFENDERS");
                
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
        }
        break;

        case "dm":
        {
            self notify("spawned");
            self notify("end_respawn");

            resettimeout();

        //	if(isdefined(self.shocked))
        //	{
        //		self stopShellshock();
        //		self.shocked = undefined;
        //	}

            self.sessionteam = "none";
            self.sessionstate = "playing";
            self.spectatorclient = -1;
            self.archivetime = 0;
                
            spawnpointname = "mp_deathmatch_spawn";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

            self.statusicon = "";
            self.maxhealth = 100;
            self.health = self.maxhealth;

            if(!isdefined(self.pers["savedmodel"]))
                maps\mp\gametypes\_teams::model();
            else
                maps\mp\_utility::loadModel(self.pers["savedmodel"]);

            maps\mp\gametypes\_teams::loadout();

            self giveWeapon(self.pers["weapon"]);
            self giveMaxAmmo(self.pers["weapon"]);
            self setSpawnWeapon(self.pers["weapon"]);
            
            self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
        }
        break;

        case "tdm":
        {
            self notify("spawned");
            self notify("end_respawn");
            
            resettimeout();

            self.sessionteam = self.pers["team"];
            self.sessionstate = "playing";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;
                
            spawnpointname = "mp_teamdeathmatch_spawn";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

            self.statusicon = "";
            self.maxhealth = 100;
            self.health = self.maxhealth;
            
            if(!isdefined(self.pers["savedmodel"]))
                maps\mp\gametypes\_teams::model();
            else
                maps\mp\_utility::loadModel(self.pers["savedmodel"]);

            maps\mp\gametypes\_teams::loadout();
            
            self giveWeapon(self.pers["weapon"]);
            self giveMaxAmmo(self.pers["weapon"]);
            self setSpawnWeapon(self.pers["weapon"]);
            
            if(self.pers["team"] == "allies")
                self setClientCvar("cg_objectiveText", &"TDM_KILL_AXIS_PLAYERS");
            else if(self.pers["team"] == "axis")
                self setClientCvar("cg_objectiveText", &"TDM_KILL_ALLIED_PLAYERS");

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
        }
        break;

        case "bel":
        {
            self notify("spawned");
            self notify("end_respawn");
            self notify("stop weapon timeout");
            self notify ("do_timer_cleanup");
            
            resettimeout();

            self.respawnwait = false;
            self.sessionteam = self.pers["team"];
            self.lastteam = self.pers["team"];
            self.sessionstate = "playing";
            self.reflectdamage = undefined;
            
            if (isdefined(self.spawnMsg))
                self.spawnMsg destroy();

            spawnpointname = "mp_teamdeathmatch_spawn";
            spawnpoints = getentarray(spawnpointname, "classname");

            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_MiddleThird(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

            self.statusicon = "";
            self.maxhealth = 100;
            self.health = self.maxhealth;
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

            if (level.drawfriend == 1)
            {
                if(self.pers["team"] == "allies")
                {
                    self.headicon = game["headicon_allies"];
                    self.headiconteam = "allies";
                }
                else if(self.pers["team"] == "axis")
                {
                    self.headicon = game["headicon_axis"];
                    self.headiconteam = "axis";
                }
                else
                {
                    self.headicon = "";
                }
            }
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
        break;

        case "re":
        {
            self notify("spawned");

            resettimeout();

            self.sessionteam = self.pers["team"];
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;
                        
            if(isdefined(self.spawned))
                    return;

            self.sessionstate = "playing";

            if(self.pers["team"] == "allies")
                spawnpointname = "mp_retrieval_spawn_allied";
            else
                spawnpointname = "mp_retrieval_spawn_axis";

            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

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

            self.spawned = true;
            self.statusicon = "";
            self.maxhealth = 100;
            self.health = self.maxhealth;
            self.objs_held = 0;

            maps\mp\gametypes\re::updateTeamStatus();

            if(!isdefined(self.pers["score"]))
                self.pers["score"] = 0;
            self.score = self.pers["score"];

            if(!isdefined(self.pers["deaths"]))
                self.pers["deaths"] = 0;
            self.deaths = self.pers["deaths"];

            if(!isdefined(self.pers["savedmodel"]))
            maps\mp\gametypes\_teams::model();
            else
                maps\mp\_utility::loadModel(self.pers["savedmodel"]);

            maps\mp\gametypes\_teams::loadout();

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

            if(self.pers["team"] == game["re_attackers"])
                self setClientCvar("cg_objectiveText", game["re_attackers_obj_text"]);
            else if(self.pers["team"] == game["re_defenders"])
                self setClientCvar("cg_objectiveText", game["re_defenders_obj_text"]);

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
        }
        break;

        default:
        {
            printLn("##### centralizer: spawnPlayer: default");
        }
        break;
    }
}

spawnSpectator(gametype, origin, angles)
{
    switch(gametype)
    {
        case "sd":
        {
            self notify("spawned");

            resettimeout();

            self.sessionstate = "spectator";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            if(self.pers["team"] == "spectator")
                self.statusicon = "";

            if(isdefined(origin) && isdefined(angles))
                self spawn(origin, angles);
            else
            {
                spawnpointname = "mp_searchanddestroy_intermission";
                spawnpoints = getentarray(spawnpointname, "classname");
                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

                if(isdefined(spawnpoint))
                    self spawn(spawnpoint.origin, spawnpoint.angles);
                else
                    maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
            }

            maps\mp\gametypes\sd::updateTeamStatus();

            if(game["attackers"] == "allies")
                self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_ALLIESATTACKING");
            else if(game["attackers"] == "axis")
                self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_AXISATTACKING");            
        }
        break;

        case "dm":
        {
            self notify("spawned");
            self notify("end_respawn");
            
            resettimeout();

        //	if(isdefined(self.shocked))
        //	{
        //		self stopShellshock();
        //		self.shocked = undefined;
        //	}

            self.sessionstate = "spectator";
            self.spectatorclient = -1;
            self.archivetime = 0;

            if(self.pers["team"] == "spectator")
                self.statusicon = "";

            if(isdefined(origin) && isdefined(angles))
                self spawn(origin, angles);
            else
            {
                spawnpointname = "mp_deathmatch_intermission";
                spawnpoints = getentarray(spawnpointname, "classname");
                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

                if(isdefined(spawnpoint))
                    self spawn(spawnpoint.origin, spawnpoint.angles);
                else
                    maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
            }

            self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
        }
        break;

        case "tdm":
        {
            self notify("spawned");
            self notify("end_respawn");

            resettimeout();

            self.sessionstate = "spectator";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            if(self.pers["team"] == "spectator")
                self.statusicon = "";
            
            if(isdefined(origin) && isdefined(angles))
                self spawn(origin, angles);
            else
            {
                    spawnpointname = "mp_teamdeathmatch_intermission";
                spawnpoints = getentarray(spawnpointname, "classname");
                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
            
                if(isdefined(spawnpoint))
                    self spawn(spawnpoint.origin, spawnpoint.angles);
                else
                    maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
            }

            self setClientCvar("cg_objectiveText", &"TDM_ALLIES_KILL_AXIS_PLAYERS");
        }
        break;

        case "bel":
        {
            self notify("spawned");
            self notify("end_respawn");
            
            self maps\mp\gametypes\bel::check_delete_objective();
            
            resettimeout();
            
            self.sessionstate = "spectator";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;
            self.pers["savedmodel"] = undefined;
            self.headicon = "";

            spawnpointname = "mp_teamdeathmatch_intermission";
            spawnpoints = getentarray(spawnpointname, "classname");

            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

            self setClientCvar("cg_objectiveText", &"BEL_SPECTATOR_OBJS");
        }
        break;

        case "re":
        {
            self notify("spawned");

            resettimeout();

            self.sessionstate = "spectator";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            if(self.pers["team"] == "spectator")
                self.statusicon = "";

            if(isdefined(origin) && isdefined(angles))
                self spawn(origin, angles);
            else
            {
                spawnpointname = "mp_retrieval_intermission";
                spawnpoints = getentarray(spawnpointname, "classname");
                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

                if(isdefined(spawnpoint))
                    self spawn(spawnpoint.origin, spawnpoint.angles);
                else
                    maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
            }

            maps\mp\gametypes\re::updateTeamStatus();

            //if(game["re_attackers"] == "allies")
            //	self setClientCvar("cg_objectiveText", &"RE_ALLIES", game["re_attackers_obj_text"]);
            //else if(game["re_attackers"] == "axis")
            //	self setClientCvar("cg_objectiveText", &"RE_AXIS", game["re_attackers_obj_text"]);
            self setClientCvar("cg_objectiveText", game["re_spectator_obj_text"]);
        }
        break;

        default:
        {
            printLn("##### centralizer: spawnSpectator: default");
        }
        break;
    }
}

spawnIntermission(gametype)
{
    switch(gametype)
    {
        case "sd":
        {
            self notify("spawned");
    
            resettimeout();

            self.sessionstate = "intermission";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            spawnpointname = "mp_searchanddestroy_intermission";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        }
        break;

        case "dm":
        {
            self notify("spawned");
            self notify("end_respawn");
            
            resettimeout();

        //	if(isdefined(self.shocked))
        //	{
        //		self stopShellshock();
        //		self.shocked = undefined;
        //	}

            self.sessionstate = "intermission";
            self.spectatorclient = -1;
            self.archivetime = 0;

            spawnpointname = "mp_deathmatch_intermission";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        }
        break;

        case "tdm":
        {
            self notify("spawned");
            self notify("end_respawn");

            resettimeout();

            self.sessionstate = "intermission";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            spawnpointname = "mp_teamdeathmatch_intermission";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
            
            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        }
        break;

        case "bel":
        {
            self notify("spawned");
            self notify("end_respawn");

            resettimeout();

            self.sessionstate = "intermission";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            spawnpointname = "mp_teamdeathmatch_intermission";
            spawnpoints = getentarray(spawnpointname, "classname");

            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_MiddleThird(spawnpoints);

            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
            
            if (isdefined (self.blackscreen))
                self.blackscreen destroy();
            if (isdefined (self.blackscreentext))
                self.blackscreentext destroy();
            if (isdefined (self.blackscreentext2))
                self.blackscreentext2 destroy();
            if (isdefined (self.blackscreentimer))
                self.blackscreentimer destroy();
        }
        break;

        case "re":
        {
            self notify("spawned");

            resettimeout();

            self.sessionstate = "intermission";
            self.spectatorclient = -1;
            self.archivetime = 0;
            self.reflectdamage = undefined;

            spawnpointname = "mp_retrieval_intermission";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
            
            if(isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        }
        break;

        default:
        {
            printLn("##### centralizer: spawnIntermission: default");
        }
        break;
    }
}

killcam(gametype, attackerNum, delay, option)
{
    switch(gametype)
    {
        case "sd":
        {
            self endon("spawned");
    
            // killcam
            if(attackerNum < 0)
                return;

            self.sessionstate = "spectator";
            self.spectatorclient = attackerNum;
            self.archivetime = delay + 7;

            // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
            wait 0.05;

            if(self.archivetime <= delay)
            {
                self.spectatorclient = -1;
                self.archivetime = 0;
            
                return;
            }

            self.killcam = true;

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
            self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");

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
            self.killcam = undefined;
        }
        break;

        case "dm":
        {
            self endon("spawned");

        //	previousorigin = self.origin;
        //	previousangles = self.angles;

            // killcam
            if(attackerNum < 0)
                return;

            self.sessionstate = "spectator";
            self.spectatorclient = attackerNum;
            self.archivetime = delay + 7;

            // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
            wait 0.05;

            if(self.archivetime <= delay)
            {
                self.spectatorclient = -1;
                self.archivetime = 0;
                self.sessionstate = "dead";
            
                self thread maps\mp\gametypes\dm::respawn();
                return;
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
            self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

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
            self.sessionstate = "dead";
            
            //self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
            self thread maps\mp\gametypes\dm::respawn();
        }
        break;

        case "tdm":
        {
            self endon("spawned");

        //	previousorigin = self.origin;
        //	previousangles = self.angles;
            
            // killcam
            if(attackerNum < 0)
                return;

            self.sessionstate = "spectator";
            self.spectatorclient = attackerNum;
            self.archivetime = delay + 7;

            // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
            wait 0.05;

            if(self.archivetime <= delay)
            {
                self.spectatorclient = -1;
                self.archivetime = 0;
                self.sessionstate = "dead";
            
                self thread maps\mp\gametypes\tdm::respawn();
                return;
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
            self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

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
            self.sessionstate = "dead";

            //self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
            self thread maps\mp\gametypes\tdm::respawn();
        }
        break;

        case "bel":
        {
            self endon("spawned");

            if(attackerNum < 0)
                return;

            if (option == "axis to axis")
                wait 2;
            else if (option == "allies to axis")
            {
                self.pers["team"] = ("axis");
                self.sessionteam = ("axis");
                wait 2;
            }

            self.sessionstate = "spectator";
            self.spectatorclient = attackerNum;
            self.archivetime = delay + 7;
            
            wait 0.05;

            if(self.archivetime <= delay)
            {
                self.spectatorclient = -1;
                self.archivetime = 0;

                if (option == "axis to axis")
                {
                    if (!isalive (self))
                        self thread maps\mp\gametypes\bel::respawn("auto",0);
                }
                else if (option == "allies to axis")
                    self maps\mp\gametypes\bel::move_to_axis(0,"nodelay on respawn");
            
                return;
            }

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
            
            if (!isdefined(self.kc_title))
            {
                self.kc_title = newClientHudElem(self);
                self.kc_title.archived = false;
                self.kc_title.x = 320;
                self.kc_title.y = 40;
                self.kc_title.alignX = "center";
                self.kc_title.alignY = "middle";
                self.kc_title.sort = 1;
                self.kc_title.fontScale = 3.5;
            }
            self.kc_title setText(&"MPSCRIPT_KILLCAM");
            
            if (!isdefined(self.kc_skiptext))
            {
                self.kc_skiptext = newClientHudElem(self);
                self.kc_skiptext.archived = false;
                self.kc_skiptext.x = 320;
                self.kc_skiptext.y = 70;
                self.kc_skiptext.alignX = "center";
                self.kc_skiptext.alignY = "middle";
                self.kc_skiptext.sort = 1;
            }
            self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

            if (!isdefined(self.kc_timer))
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

            if (option == "axis to axis")
            {
                if (!isalive (self))
                    self thread maps\mp\gametypes\bel::respawn("auto",0);
            }
            else if (option == "allies to axis")
                self maps\mp\gametypes\bel::move_to_axis(0,"nodelay on respawn");
        }
        break;

        case "re":
        {
            self endon("spawned");

            // killcam
            if(attackerNum < 0)
                return;

            self.sessionstate = "spectator";
            self.spectatorclient = attackerNum;
            self.archivetime = delay + 7;

            // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
            wait 0.05;

            if(self.archivetime <= delay)
            {
                self.spectatorclient = -1;
                self.archivetime = 0;
            
                return;
            }

            self.killcam = true;
            
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
            
            if (!isdefined(self.kc_title))
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
            
            if (!isdefined(self.kc_skiptext))
            {
                self.kc_skiptext = newClientHudElem(self);
                self.kc_skiptext.archived = false;
                self.kc_skiptext.x = 320;
                self.kc_skiptext.y = 70;
                self.kc_skiptext.alignX = "center";
                self.kc_skiptext.alignY = "middle";
                self.kc_skiptext.sort = 1; // force to draw after the bars
            }
            self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");

            if (!isdefined(self.kc_timer))
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
            self.killcam = undefined;
        }
        break;

        default:
        {
            printLn("##### centralizer: killcam: default");
        }
        break;
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

roundcam(gametype, delay, winningteam)
{
    switch(gametype)
    {
        case "sd":
        {
            self endon("spawned");
    
            maps\mp\gametypes\sd::spawnSpectator();

            if(isdefined(level.bombcam))
                self thread maps\mp\gametypes\sd::spawnSpectator(level.bombcam.origin, level.bombcam.angles);
            else
                self.spectatorclient = level.playercam;
                
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
        break;

        case "re":
        {
            self endon("spawned");

            maps\mp\gametypes\re::spawnSpectator();

            if(isdefined(level.goalcam))
                self thread maps\mp\gametypes\re::spawnSpectator(level.goalcam.origin, level.goalcam.angles);
            else
                self.spectatorclient = level.playercam;

            self.archivetime = delay + 7;

            // wait till the next server frame to give the player the kill-cam huddraw elements
            wait 0.05;
            
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

            if(winningteam == "allies")
                self.kc_title setText(&"MPSCRIPT_ALLIES_WIN");
            else if (winningteam == "axis")
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
        break;

        default:
        {
            printLn("##### centralizer: roundcam: default");
        }
        break;
    }
}

endMap(gametype)
{
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
                player maps\mp\gametypes\sd::spawnIntermission();
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
                
                player maps\mp\gametypes\dm::spawnIntermission();
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
                player maps\mp\gametypes\tdm::spawnIntermission();
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
                
                player maps\mp\gametypes\bel::spawnIntermission();
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
                player maps\mp\gametypes\re::spawnIntermission();
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