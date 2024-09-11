/*
    Behind Enemy Lines
    Number of Allies: The more people playing in the round the more Allies there will be. Currently the Allied:Axis radio is about 1:3-4
    Allied Objective: Kill as many German players as possible before being overrun. You gain more points the longer you stay alive
    Axis objective: Hunt down Allied players
    Map ends:	When a player reaches the score limit, or time limit is reached
    Respawning: 	Axis respawn as Axis when they die, and Allied players respawn as Axis when they die
            An Axis who kills an Allied player will take that Allied players spot on the Allied team
            Uses TDM spawnpoints so all TDM maps automatically support this gametype

    Level requirements
    ------------------
        Spawnpoints:
            classname		mp_teamdeathmatch_spawn
            All players spawn from these. The spawnpoint chosen one is dependent on the current locations of teammates and enemies
            at the time of spawn. Players generally spawn away from enemies.

        Spectator Spawnpoints:
            classname		mp_teamdeathmatch_intermission
            Spectators spawn from these and intermission is viewed from these positions.
            Atleast one is required, any more and they are randomly chosen between.

    Level script requirements
    -------------------------
        Team Definitions:
            game["allies"] = "american";
            game["axis"] = "german";
            This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.
    
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

spawnSpectator()
{	
    centralizer::spawnSpectator();
}

spawnIntermission()
{
    centralizer::spawnIntermission();
}

respawn(noclick, delay)
{
    self endon("end_respawn");
    
    if (!isdefined (delay))
        delay = 2;
    wait delay;

    if (isdefined (self))
    {
        if (!isdefined (noclick))
        {
            if(getCvarInt("scr_bel_respawndelay") > 0)
            {
                self thread waitForceRespawnTime();
                self waittill("respawn");
            }
            else
            {
                self thread spawnPlayer();
                return;
            }
        }
        else
            self thread spawnPlayer();
    }
}

Respawn_HUD_Timer_Cleanup()
{
    self waittill("do_timer_cleanup");

    if (self.spawnTimer)
        self.spawnTimer destroy();
}

Respawn_HUD_Timer_Cleanup_Wait(message)
{
    self endon("do_timer_cleanup");

    self waittill(message);
    self notify("do_timer_cleanup");
}

Respawn_HUD_Timer()
{
    self endon ("respawn");
    self endon ("end_respawn");
    
    respawntime = getCvarInt("scr_bel_respawndelay");
    wait .1;
    
    if (!isdefined(self.toppart))
    {
        self.spawnMsg = newClientHudElem(self);
        self.spawnMsg.alignX = "center";
        self.spawnMsg.alignY = "middle";
        self.spawnMsg.x = 305;
        self.spawnMsg.y = 140;
        self.spawnMsg.fontScale = 1.5;
    }
    self.spawnMsg setText(&"BEL_TIME_TILL_SPAWN");
    
    if (!isdefined(self.spawnTimer))
    {
        self.spawnTimer = newClientHudElem(self);
        self.spawnTimer.alignX = "center";
        self.spawnTimer.alignY = "middle";
        self.spawnTimer.x = 305;
        self.spawnTimer.y = 155;
        self.spawnTimer.fontScale = 1.5;
    }
    self.spawnTimer setTimer(respawntime);

    self thread Respawn_HUD_Timer_Cleanup_Wait("respawn");
    self thread Respawn_HUD_Timer_Cleanup_Wait("end_respawn");
    self thread Respawn_HUD_Timer_Cleanup();

    wait (respawntime);

    self notify("do_timer_cleanup");
    self.spawnMsg setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
}

Respawn_HUD_NoTimer()
{
    self endon ("respawn");
    self endon ("end_respawn");
    
    wait .1;
    if (!isdefined(self.spawnMsg))
    {
        self.spawnMsg = newClientHudElem(self);
        self.spawnMsg.alignX = "center";
        self.spawnMsg.alignY = "middle";
        self.spawnMsg.x = 305;
        self.spawnMsg.y = 140;
        self.spawnMsg.fontScale = 1.5;
    }
    self.spawnMsg setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
}

waitForceRespawnTime()
{
    self endon("end_respawn");
    self endon("respawn");

    self.respawnwait = true;
    self thread Respawn_HUD_Timer();
    wait getCvarInt("scr_bel_respawndelay");
    self thread waitForceRespawnButton();
}

waitForceRespawnButton()
{
    self endon("end_respawn");
    self endon("respawn");

    while(self useButtonPressed() != true)
        wait .05;

    self notify("respawn");
}

endMap()
{
    centralizer::endMap();
}

checkTimeLimit()
{
    centralizer::checkTimeLimit();
}

checkScoreLimit()
{
    if(level.playerscorelimit <= 0)
        return;

    if(self.score < level.playerscorelimit)
        return;

    if(level.mapended)
        return;
    level.mapended = true;

    endMap();
}

updateScriptCvars()
{
    count = 1;
    for(;;)
    {
        timelimit = getCvarFloat("scr_bel_timelimit");
        if(level.timelimit != timelimit)
        {
            if(timelimit > 1440)
            {
                timelimit = 1440;
                setcvar("scr_bel_timelimit", "1440");
            }

            level.timelimit = timelimit;
            level.starttime = getTime();

            if(level.timelimit > 0)
            {
                if (!isdefined(level.clock))
                {
                    level.clock = newHudElem();
                    level.clock.alignX = "center";
                    level.clock.alignY = "middle";
                    level.clock.x = 320;
                    level.clock.y = 460;
                    level.clock.font = "bigfixed";
                }
                level.clock setTimer(level.timelimit * 60);
            }
            else
            {
                if (isdefined(level.clock))
                    level.clock destroy();
            }

            checkTimeLimit();
        }

        scorelimit = getCvarInt("scr_bel_scorelimit");
        if(level.playerscorelimit != scorelimit)
        {
            level.playerscorelimit = scorelimit;

            players = getEntArray("player", "classname");
            for(i = 0; i < players.size; i++)
                players[i] checkScoreLimit();
        }

        drawfriend = getCvarFloat("scr_drawfriend");
        if(level.drawfriend != drawfriend)
        {
            level.drawfriend = drawfriend;

            if(level.drawfriend)
            {
                players = getEntArray("player", "classname");
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
                players = getEntArray("player", "classname");
                for(i = 0; i < players.size; i++)
                {
                    player = players[i];

                    if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
                        player.headicon = "";
                }
            }
        }

        allowvote = getCvarInt("g_allowvote");
        if(level.allowvote != allowvote)
        {
            level.allowvote = allowvote;
            setcvar("scr_allow_vote", allowvote);
        }

        level notify ("update obj");

        wait 1;
    }
}

CheckAllies_andMoveAxis_to_Allies(playertomove, playernottomove)
{
    numOnTeam["allies"] = 0;
    numOnTeam["axis"] = 0;
    
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == "allies")
        {
            alliedplayers = [];
            alliedplayers[alliedplayers.size] = players[i];
            numOnTeam["allies"]++;
        }
        else if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == "axis")
        {
            axisplayers = [];
            axisplayers[axisplayers.size] = players[i];
            numOnTeam["axis"]++;
        }
    }

    Set_Number_Allowed_Allies(numOnTeam["axis"]);
    
    if (numOnTeam["allies"] == level.alliesallowed)
    {
        return;
    }
    
    if (numOnTeam["allies"] < level.alliesallowed)
    {
        if ( (isdefined (playertomove)) && (playertomove.pers["team"] != "allies") )
        {
            playertomove move_to_allies(undefined, 2, undefined, 2);
        }
        else if (isdefined (playernottomove))
            move_random_axis_to_allied(playernottomove);
        else
            move_random_axis_to_allied();

        if (level.alliesallowed > 1)
            iprintln(&"BEL_ADDING_ALLIED");

        return;
    }
    
    if (numOnTeam["allies"] > (level.alliesallowed + 1))
    {
        move_random_allied_to_axis();
        iprintln(&"BEL_REMOVING_ALLIED");
        return;
    }
    if ( (numOnTeam["allies"] > level.alliesallowed) && (level.alliesallowed == 1) )
    {
        move_random_allied_to_axis();
        iprintln(&"BEL_REMOVING_ALLIED");
        return;
    }
}

Set_Number_Allowed_Allies(axis)
{
    if (axis > 30)
        level.alliesallowed = 11;
    else if (axis > 27)
        level.alliesallowed = 10;
    else if (axis > 24)
        level.alliesallowed = 9;
    else if (axis > 21)
        level.alliesallowed = 8;
    else if (axis > 18)
        level.alliesallowed = 7;
    else if (axis > 15)
        level.alliesallowed = 6;
    else if (axis > 12)
        level.alliesallowed = 5;
    else if (axis > 9)
        level.alliesallowed = 4;
    else if (axis > 6)
        level.alliesallowed = 3;
    else if (axis > 3)
        level.alliesallowed = 2;
    else
        level.alliesallowed = 1;
}

move_random_axis_to_allied(playernottoinclude)
{
    candidates = [];
    axisplayers = [];
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == "axis")
        {
            axisplayers[axisplayers.size] = players[i];
            if ( (isdefined (playernottoinclude)) && (playernottoinclude == players[i]) )
                continue;
            candidates[candidates.size] = players[i];
        }
    }
    if (axisplayers.size == 1)
    {
        num = randomint(axisplayers.size);
        iprintln(&"BEL_IS_NOW_ALLIED",axisplayers[num]);
        axisplayers[num] move_to_allies(undefined, 2, undefined, 2);
    }
    else if (axisplayers.size > 1)
    {
        if (candidates.size > 0)
        {
            num = randomint(candidates.size);
            iprintln(&"BEL_IS_NOW_ALLIED",candidates[num]);
            candidates[num] move_to_allies(undefined, 2, undefined, 2);
            return;
        }
        else
        {
            num = randomint(axisplayers.size);
            iprintln(&"BEL_IS_NOW_ALLIED",axisplayers[num]);
            axisplayers[num] move_to_allies(undefined, 2, undefined, 2);
            return;
        }
    }
}

move_random_allied_to_axis()
{
    numOnTeam["allies"] = 0;
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == "allies")
        {
            alliedplayers = [];
            alliedplayers[alliedplayers.size] = players[i];
            numOnTeam["allies"]++;
        }
    }
    if (numOnTeam["allies"] > 0)
    {
        num = randomint(alliedplayers.size);
        iprintln(&"BEL_MOVED_TO_AXIS",alliedplayers[num]);
        alliedplayers[num] move_to_axis();
    }
}

move_to_axis(delay, respawnoption)
{
    if (isplayer (self))
    {
        self check_delete_objective();
        self.pers["nextWeapon"] = undefined;
        self.pers["lastweapon1"] = undefined;
        self.pers["lastweapon2"] = undefined;
        self.pers["savedmodel"] = undefined;
        self.pers["team"] = ("axis");
        self.sessionteam = ("axis");

        if (isdefined (delay))
            wait delay;

        if (isplayer (self))
        {
            if (!isdefined (self.pers["LastAxisWeapon"]))
            {
                self spawnSpectator();
                
                self setClientCvar("scr_showweapontab", "1");
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis_only"]);
                self openMenu(game["menu_weapon_axis_only"]);
            }
            else
            {
                self setClientCvar("scr_showweapontab", "1");
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);
                
                if ( (isdefined (delay)) && (isdefined (respawnoption)) && (respawnoption == "nodelay on respawn") )
                    self thread respawn("auto",0);
                else
                    self thread respawn("auto");
            }
        }
    }
}

move_to_allies(nospawn, delay, respawnoption, blackscreen)
{
    if (isplayer (self))
    {
        self.god = true;
        self.pers["team"] = ("allies");
        self.sessionteam = ("allies");
        self.lastteam = ("allies");
        self.pers["nextWeapon"] = undefined;
        self.pers["lastweapon1"] = undefined;
        self.pers["lastweapon2"] = undefined;
        self.pers["savedmodel"] = undefined;

        if (isdefined (delay))
        {
            if (blackscreen == 1)
            {
                if (!isdefined (self.blackscreen))
                    self blackscreen();
            }
            else if (blackscreen == 2)
            {
                if (!isdefined (self.blackscreen))
                    self blackscreen(2);
            }
            wait 2;
        }
        
        if (isplayer (self))
        {
            if (!isdefined (self.pers["LastAlliedWeapon"]))
            {
                self spawnSpectator();
                
                self setClientCvar("scr_showweapontab", "1");
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies_only"]);
                self openMenu(game["menu_weapon_allies_only"]);
                
                self thread auto_giveweapon_allied();
                return;
            }
            else
            {
                self setClientCvar("scr_showweapontab", "1");
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);
                
                if ( (isdefined (delay)) && (isdefined (respawnoption)) && (respawnoption == "nodelay on respawn") )
                    self thread respawn("auto",0);
                else
                    self thread respawn("auto");
            }
        }
        else
        {
            self.god = false;
        }
    }
}

allied_hud_element()
{
    wait .1;
    
    if (!isdefined(self.hud_bgnd))
    {
        self.hud_bgnd = newClientHudElem(self);
        self.hud_bgnd.alpha = 0.2;
        self.hud_bgnd.x = 505;
        self.hud_bgnd.y = 382;
        self.hud_bgnd.sort = -1;
        self.hud_bgnd setShader("black", 130, 35);
    }
    
    if (!isdefined(self.hud_clock))
    {
        self.hud_clock = newClientHudElem(self);
        self.hud_clock.x = 520;
        self.hud_clock.y = 385;
        self.hud_clock.label = &"BEL_TIME_ALIVE";
    }
    self.hud_clock setTimerUp(0);
    
    if (!isdefined(self.hud_points))
    {
        self.hud_points = newClientHudElem(self);
        self.hud_points.x = 520;
        self.hud_points.y = 401;
        self.hud_points.label = &"BEL_POINTS_EARNED";
        self.hud_points setValue(1);
    }

    self thread give_allied_points();
}

check_delete_objective()
{
    if (isdefined(self.hud_points))
        self.hud_points destroy();
    if (isdefined(self.hud_clock))
        self.hud_clock destroy();
    if (isdefined(self.hud_bgnd))
        self.hud_bgnd destroy();
    
    self notify ("Stop Blip");
    objnum = ((self getEntityNumber()) + 1);
    objective_delete(objnum);
}

make_obj_marker()
{
    level endon ("End of Round");
    self endon ("Stop Blip");
    self endon ("death");	
    count1 = 1;
    count2 = 1;
    
    if(getCvar("scr_bel_showoncompass") == "1")
    {
        objnum = ((self getEntityNumber()) + 1);
        objective_add(objnum, "current", self.origin, "gfx/hud/hud@objective_bel.tga");
        objective_icon(objnum,"gfx/hud/hud@objective_bel.tga");
        objective_team(objnum,"axis");
        objective_position(objnum, self.origin);
        lastobjpos = self.origin;
        newobjpos = self.origin;
    }
    self.score++;
    self checkScoreLimit();
    
    self thread allied_hud_element();
    
    while ((isplayer (self)) && (isalive(self)))
    {
        level waittill ("update obj");
    
        if (self.health < 100)
            self.health = (self.health + 3);
    
        if (count1 != level.PositionUpdateTime)
            count1++;
        else
        {
            count1 = 1;
            if(getCvar("scr_bel_showoncompass") == "1")
            {
                lastobjpos = newobjpos;
                newobjpos = ( ((lastobjpos[0] + self.origin[0]) * 0.5), ((lastobjpos[1] + self.origin[1]) * 0.5), ((lastobjpos[2] + self.origin[2]) * 0.5) );
                objective_position(objnum, newobjpos);
            }
        }
    }
}

give_allied_points()
{
    level endon ("End of Round");
    self endon ("Stop give points");
    self endon ("Stop Blip");
    self endon ("death");
    
    lpselfnum = self getEntityNumber();
    
    PointsEarned = 1;
    while ((isplayer (self)) && (isalive(self)))
    {
        wait level.AlivePointTime;
        self.score++;
        PointsEarned++;
        self.god = false; //failsafe to fix a very rare bug
        logPrint("A;" + lpselfnum + ";allies;" + self.name + ";bel_alive_tick\n");
        self.hud_points setValue(PointsEarned);
        self checkScoreLimit();
    }
}

auto_giveweapon_allied()
{
    self endon ("end_respawn");
    self endon ("stop weapon timeout");

    wait 6;
    if ( (isplayer (self)) && (self.sessionstate == "spectator") )
    {
        self notify("end_respawn");
        
        switch(game["allies"])
        {
            case "american":
                self.pers["weapon"] = "m1garand_mp";
                break;
            case "british":
                self.pers["weapon"] = "enfield_mp";
                break;
            case "russian":
                self.pers["weapon"] = "mosin_nagant_mp";
                break;
        }
        self.pers["LastAlliedWeapon"] = self.pers["weapon"];
        self closeMenu();
            self thread respawn("auto");
    }
}

blackscreen(didntkill)
{
    if (!isdefined (didntkill))
    {
        self.blackscreentext = newClientHudElem(self);
        self.blackscreentext.sort = -1;
        self.blackscreentext.archived = false;
        self.blackscreentext.alignX = "center";
        self.blackscreentext.alignY = "middle";
        self.blackscreentext.x = 320;
        self.blackscreentext.y = 220;
        self.blackscreentext settext (&"BEL_BLACKSCREEN_KILLEDALLIED");
    }
    
    self.blackscreentext2 = newClientHudElem(self);
    self.blackscreentext2.sort = -1;
    self.blackscreentext2.archived = false;
    self.blackscreentext2.alignX = "center";
    self.blackscreentext2.alignY = "middle";
    self.blackscreentext2.x = 320;
    self.blackscreentext2.y = 240;
    self.blackscreentext2 settext (&"BEL_BLACKSCREEN_WILLSPAWN");
    
    self.blackscreentimer = newClientHudElem(self);
    self.blackscreentimer.sort = -1;
    self.blackscreentimer.archived = false;
    self.blackscreentimer.alignX = "center";
    self.blackscreentimer.alignY = "middle";
    self.blackscreentimer.x = 320;
    self.blackscreentimer.y = 260;
    self.blackscreentimer settimer (2);
    
    self.blackscreen = newClientHudElem(self);
    self.blackscreen.sort = -2;
    self.blackscreen.archived = false;
    self.blackscreen.alignX = "left";
    self.blackscreen.alignY = "top";
    self.blackscreen.x = 0;
    self.blackscreen.y = 0;
    self.blackscreen.alpha = 1;
    self.blackscreen setShader("black", 640, 480);
    if (!isdefined (didntkill))
    {
        self.blackscreen.alpha = 0;
        self.blackscreen fadeOverTime(1.5);
    }
    self.blackscreen.alpha = 1;
}

Number_On_Team(team)
{
    players = getEntArray("player", "classname");

    if (team == "axis")
    {
        numOnTeam["axis"] = 0;
        for(i = 0; i < players.size; i++)
        {
            if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == "axis")
                numOnTeam["axis"]++;
        }
        return numOnTeam["axis"];
    }
    else if (team == "allies")
    {
        numOnTeam["allies"] = 0;
        for(i = 0; i < players.size; i++)
        {
            if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == "allies")
                numOnTeam["allies"]++;
        }
        return numOnTeam["allies"];
    }
}

updateDeathArray()
{
    if(!isdefined(level.deatharray))
    {
        level.deatharray[0] = self.origin;
        level.deatharraycurrent = 1;
        return;
    }

    if(level.deatharraycurrent < 4)
        level.deatharray[level.deatharraycurrent] = self.origin;
    else
    {
        level.deatharray[0] = self.origin;
        level.deatharraycurrent = 1;
        return;
    }

    level.deatharraycurrent++;
}

client_print(text)
{
    self notify ("stop client print");
    self endon ("stop client print");
    
    if (!isdefined(self.print))
    {
        self.print = newClientHudElem(self);
        self.print.alignX = "center";
        self.print.alignY = "middle";
        self.print.x = 320;
        self.print.y = 176;
    }
    self.print.alpha = 1;
    self.print setText(text);

    wait 3;
    self.print.alpha = .9;
    wait .9;
    self.print destroy();
}

killcam(attackerNum, delay, option)
{
    centralizer::killcam(attackerNum, delay, option);
}