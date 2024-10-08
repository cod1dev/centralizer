/*
    Retrieval
    Attackers objective: Retrieve the specified object and return it to the specified goal
    Defenders objective: Defend the specified object
    Round ends:	When one team is eliminated, all objectives are retrieved and taken to the goal, or roundlength time is reached
    Map ends:	When one team reaches the score limit, or time limit or round limit is reached
    Respawning:	Players remain dead for the round and will respawn at the beginning of the next round

    Level requirements
    ------------------
        Allied Spawnpoints:
            classname		mp_retrieval_spawn_allied
            Allied players spawn from these. Place atleast 16 of these relatively close together.

        Axis Spawnpoints:
            classname		mp_retrieval_spawn_axis
            Axis players spawn from these. Place atleast 16 of these relatively close together.

        Spectator Spawnpoints:
            classname		mp_retrieval_intermission
            Spectators spawn from these and intermission is viewed from these positions.
            Atleast one is required, any more and they are randomly chosen between.

        Objective Item(s):
            classname		script_model
            targetname		retrieval_objective
            target			<Each must target their own pick up trigger, their own goal trigger, and atleast one item spawn location.>
            script_gameobjectname	retrieval
            script_objective_name	"Artillery Map" (example)
            There can be more than one of these for multiple objectives.

        Item Pick Up Trigger(s):
            classname		trigger_use
            script_gameobjectname	retrieval
            This trigger is used to pick up an objective item. This should be a 16x16 unit trigger with an origin brush placed
            so that it's center lies on the bottom plane of the trigger. Must be in the level somewhere. It is automatically
            moved to the position of the objective item targeting it.

        Item Spawn Location(s):
            classname		mp_retrieval_objective
            script_gameobjectname	retrieval
            An objective item targeting this will spawn at this location. If an objective item targets more than one it will randomly choose between them.
        
        Goal(s):
            classname		trigger_multiple
            script_gameobjectname	retrieval
            This is the area the attacking team must return an objective item to. Must contain an origin brush.

    Level script requirements
    -------------------------
        Team Definitions:
            game["allies"] = "american";
            game["axis"] = "german";
            This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.
    
            game["re_attackers"] = "allies";
            game["re_defenders"] = "axis";
            This sets which team is attacking and which team is defending. Attackers retrieve the objective items. Defenders protect them.

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

        Objective Text:
            game["re_attackers_obj_text"] = "Capture the code book";
            game["re_defenders_obj_text"] = "Defend the code book";
            game["re_spectator_obj_text"] = "Allies: Capture the code book\nAxis: Defend the code book";
            These set custom objective text. Otherwise default text is used.

    Note
    ----
        Setting "script_gameobjectname" to "retrieval" on any entity in a level will cause that entity to be removed in any gametype that
        does not explicitly allow it. This is done to remove unused entities when playing a map in other gametypes that have no use for them.
*/

/*QUAKED mp_retrieval_spawn_allied (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_retrieval_spawn_axis (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn randomly at one of these positions at the beginning of a round.
*/

/*QUAKED mp_retrieval_intermission (0.0 0.5 1.0) (-16 -16 -16) (16 16 16)
Intermission is randomly viewed from one of these positions.
Spectators spawn randomly at one of these positions.
*/

/*QUAKED mp_retrieval_objective (0.0 0.5 1.0) (-8 -8 -8) (8 8 8)
The objective item will spawn randomly at one of these if the objective item targets it.
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

roundcam(delay,winningteam)
{
    centralizer::roundcam(delay, winningteam);
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
            announcement(&"RE_MATCHSTARTING");
            level thread endRound("reset");
        }
        else
        {
            announcement(&"RE_MATCHRESUMING");
            level thread endRound("draw");
        }

        return;
    }
}

endRound(roundwinner, timeexpired)
{
    centralizer::endRound(roundwinner, timeexpired);
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
    centralizer::checkScoreLimit();
}

checkRoundLimit()
{
    centralizer::checkRoundLimit();
}

updateScriptCvars()
{
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
            game["timeleft"] = timelimit;
            level.starttime = getTime();

            checkTimeLimit();
        }

        scorelimit = getCvarInt("scr_re_scorelimit");
        if(level.scorelimit != scorelimit)
        {
            level.scorelimit = scorelimit;

            if(game["matchstarted"])
                checkScoreLimit();
        }

        roundlimit = getCvarInt("scr_re_roundlimit");
        if(level.roundlimit != roundlimit)
        {
            level.roundlimit = roundlimit;

            if(game["matchstarted"])
                checkRoundLimit();
        }

        roundlength = getCvarFloat("scr_re_roundlength");
        if(roundlength > 10)
            setcvar("scr_re_roundlength", "10");

        graceperiod = getCvarFloat("scr_re_graceperiod");
        if(graceperiod > 60)
            setcvar("scr_re_graceperiod", "60");

        drawfriend = getCvarFloat("scr_drawfriend");
        if(level.drawfriend != drawfriend)
        {
            level.drawfriend = drawfriend;

            if(level.drawfriend)
            {
                // for all living players, show the appropriate headicon
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

    players = getEntArray("player", "classname");
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
        announcement(&"RE_ROUND_DRAW");
        level thread endRound("draw");
        return;
    }

    if(oldvalue["allies"] && !level.exist["allies"])
    {
        announcement(&"RE_ELIMINATED_ALLIES");
        level thread endRound("axis");
        return;
    }

    if(oldvalue["axis"] && !level.exist["axis"])
    {
        announcement(&"RE_ELIMINATED_AXIS");
        level thread endRound("allies");
        return;
    }
}

retrieval()
{
    level.retrieval_objective = getEntArray("retrieval_objective","targetname");
    for(i = 0; i < level.retrieval_objective.size; i++)
    {
        level.retrieval_objective[i] thread retrieval_spawn_objective();
        level.retrieval_objective[i] thread objective_think("objective");
    }
}

objective_think(type)
{
    level.numobjectives = (level.numobjectives + 1);
    num = level.numobjectives;

    objective_add(num, "current", self.origin, "gfx/hud/objective.tga");
    self.objnum = (num);

    if (type == "objective")
    {
        level.hudcount++;
        self.hudnum = level.hudcount;
        objective_position(num, self.origin);
        if (getCvar("scr_re_showcarrier") == "0")
        {
            while (1)
            {
                self waittill ("picked up");
                objective_team(num,game["re_attackers"]);

                self waittill ("dropped");
                objective_team(num,"none");
            }
        }
    }
    else
    if (type == "goal")
    {
        objective_icon (num,"gfx/hud/hud@objectivegoal.tga");
        //if (getCvar("scr_re_showcarrier") == "0")
        //	objective_team(num,game["re_attackers"]);
    }
}

retrieval_spawn_objective()
{
    targeted = getEntArray (self.target,"targetname");
    for (i=0;i<targeted.size;i++)
    {
        if (targeted[i].classname == "mp_retrieval_objective")
            spawnloc = maps\MP\_utility::add_to_array(spawnloc, targeted[i]);
        else
        if (targeted[i].classname == "trigger_use")
            self.trigger = (targeted[i]);
        else
        if (targeted[i].classname == "trigger_multiple")
        {
            self.goal = (targeted[i]);
            self.goal thread objective_think("goal");
        }
    }

    if ( (!isdefined (spawnloc)) || (spawnloc.size < 1) )
    {
        maps\mp\_utility::error("retrieval_objective does not target any mp_retrieval_objectives");
        return;
    }
    if (!isdefined (self.trigger))
    {
        maps\mp\_utility::error("retrieval_objective does not target a trigger_use");
        return;
    }
    if (!isdefined (self.goal))
    {
        maps\mp\_utility::error("retrieval_objective trigger_use does not target a trigger_multiple");
        return;
    }

    //move objective to random spot
    rand = randomint(spawnloc.size);
    if (spawnloc.size > 2)
    {
        if (isdefined(game["last_objective_pos"]))
        while (rand == game["last_objective_pos"])
            rand = randomint(spawnloc.size);
        game["last_objective_pos"] = rand;
    }
    self.origin = (spawnloc[rand].origin);
    self.startorigin = self.origin;
    self.startangles = self.angles;
    self.trigger.origin = (spawnloc[rand].origin);
    self.trigger.startorigin = self.trigger.origin;
    
    self thread retrieval_think();
    
    //Set hintstring on the objectives trigger
    wait 0;//required for level script to run and load the level.obj array
    if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
        self.trigger setHintString (&"RE_PRESS_TO_PICKUP",level.obj[self.script_objective_name]);
    else
        self.trigger setHintString (&"RE_PRESS_TO_PICKUP_GENERIC");
}

retrieval_think() //each objective model runs this to find it's trigger and goal
{
    if (isdefined (self.objnum))
        objective_position(self.objnum,self.origin);

    while (1)
    {
        self.trigger waittill ("trigger",other);
        
        if(!game["matchstarted"])
            return;

        if ( (isPlayer(other)) && (other.pers["team"] == game["re_attackers"]) )
        {
            if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
            {
                if (getCvar("scr_re_showcarrier") == "0")
                    announcement(&"RE_OBJ_PICKED_UP_NOSTARS",level.obj[self.script_objective_name]);
                else
                announcement(&"RE_OBJ_PICKED_UP",level.obj[self.script_objective_name]);
            }
            else
            {
                if (getCvar("scr_re_showcarrier") == "0")
                    announcement(&"RE_OBJ_PICKED_UP_GENERIC_NOSTARS");
                else
                announcement(&"RE_OBJ_PICKED_UP_GENERIC");
            }

            self thread hold_objective(other);
            other.hasobj[self.objnum] = self;
            //println ("SETTING HASOBJ[" + self.objnum + "] as the " + self.script_objective_name);
            other.objs_held++;
            /*
            println ("PUTTING OBJECTIVE " + self.objnum + " ON THE PLAYER ENTITY");
            objective_onEntity(self.objnum, other);
            */
            other thread display_holding_obj(self);
            return;

        }
        else if ( (isPlayer(other)) && (other.pers["team"] == game["re_defenders"]) )
        {
            if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
            {
                if ( game["re_attackers"] == "allies" )
                    other thread client_print(self, &"RE_PICKUP_ALLIES_ONLY",level.obj[self.script_objective_name]);
                else if ( game["re_attackers"] == "axis" )
                    other thread client_print(self, &"RE_PICKUP_AXIS_ONLY",level.obj[self.script_objective_name]);
            }
            else
            {
                if ( game["re_attackers"] == "allies" )
                    other thread client_print(self, &"RE_PICKUP_ALLIES_ONLY_GENERIC");
                else if ( game["re_attackers"] == "axis" )
                    other thread client_print(self, &"RE_PICKUP_AXIS_ONLY_GENERIC");
            }
        }
        else
            wait (.5);
    }
}

hold_objective(player) //the objective model runs this to be held by 'player'
{
    self endon ("completed");
    self endon ("dropped");
    team = player.sessionteam;
    self hide();
    
    lpselfnum = player getEntityNumber();
    logPrint("A;" + lpselfnum + ";" + game["re_attackers"] + ";" + player.name + ";" + "re_pickup" + "\n");
    
    if (player.pers["team"] == game["re_attackers"])

    self.trigger triggerOff();
    player playLocalSound ("re_pickup_paper");
    self notify ("picked up");

    //println ("PUTTING OBJECTIVE " + self.objnum + " ON THE PLAYER ENTITY");
    player.statusicon = game["headicon_carrier"];
    objective_onEntity(self.objnum, player);

    self thread objective_carrier_atgoal_wait(player);
    self thread holduse(player);
    self thread pressuse_notify(player);

    player.headicon = game["headicon_carrier"];
    if (getCvar("scr_re_showcarrier") == "0")
        player.headiconteam = (game["re_attackers"]);
    else
        player.headiconteam = "none";
}

objective_carrier_atgoal_wait(player)
{
    self endon ("dropped");
    while (1)
    {
        self.goal waittill ("trigger",other);
        if ( (other == player) && (isPlayer(player)) && (player.pers["team"] == game["re_attackers"]) )
        {
            //player.pers["score"] += 3;
            //player.score = player.pers["score"];
            level.objectives_done++;

            objective_delete(self.objnum);
            self notify ("completed");

            //org = (player.origin);
            self thread drop_objective(player,1);

            objective_delete(self.objnum);

            self delete();

            if (level.objectives_done < level.retrieval_objective.size)
            {
                return;
            }
            else
            {
                if(isdefined (self.goal.target))
                    level.goalcam = getent(self.goal.target, "targetname");
                else
                    level.goalcam = spawn ("script_origin",(self.goal.origin + (0,0,100)) );

                if (isdefined (level.goalcam.target))
                {
                    goalcam_focus = getent (level.goalcam.target,"targetname");
                    level.goalcam.angles = vectortoangles(goalcam_focus.origin - level.goalcam.origin);
                }
                else
                    level.goalcam.angles = vectortoangles(self.goal.origin - level.goalcam.origin);

                announcement (&"RE_OBJ_CAPTURED_ALL");
                level thread endRound(game["re_attackers"]);
                return;
            }
        }
        else
        {
            wait .05;
        }
    }
}

drop_objective(player,option)
{
    if (isPlayer(player))
    {
        num = (16 - (self.hudnum));
        if (isdefined (self.objs_held))
        {
            if (self.objs_held > 0)
            {
                for (i=0;i<(level.numobjectives + 1);i++)
                {
                    if (isdefined (self.hasobj[i]))
                    {
                        //if (self isonground())
                            self.hasobj[i] thread drop_objective_on_disconnect_or_death(self);
                        //else
                        //	self.hasobj[i] thread drop_objective_on_disconnect_or_death(self.origin, "trace");
                    }
                }
            }
        }
        
        if ( (isdefined (player.hudelem)) && (isdefined (player.hudelem[num])) )
            player.hudelem[num] destroy();
    }

    //if (isdefined (loc))
    loc = (player.origin + (0,0,25));

    if ( (isdefined (option)) && (option == 1) )
    {
        player.objs_held--;
        if ( (isdefined (self.objnum)) && (isdefined (player.hasobj[self.objnum])) )
            player.hasobj[self.objnum] = undefined;
        else
            println ("#### " + self.objnum + "UNDEFINED");

        objective_delete(self.objnum);
        
        lpselfnum = player getEntityNumber();
        logPrint("A;" + lpselfnum + ";" + game["re_attackers"] + ";" + player.name + ";" + "re_capture" + "\n");
        
        if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
            announcement(&"RE_OBJ_CAPTURED",level.obj[self.script_objective_name]);
        else
            announcement(&"RE_OBJ_CAPTURED_GENERIC");

        if (isdefined (self.trigger))
            self.trigger delete();

        if ( (isPlayer(player)) && (player.objs_held < 1) )
        {
            if (level.drawfriend == 1)
            {
                if (isPlayer(player))
                if(player.pers["team"] == "allies")
                {
                    player.headicon = game["headicon_allies"];
                    player.headiconteam = "allies";
                }
                else if(player.pers["team"] == "axis")
                {
                    player.headicon = game["headicon_axis"];
                    player.headiconteam = "axis";
                }
                else
                {
                    player.statusicon = "";
                    player.headicon = "";
                }
            }
            else
            {
                if (isPlayer(player))
                {
                    player.statusicon = "";
                    player.headicon = "";
                }
            }
        }
    }
    else
    {
        /*
        if (player isOnGround())
        {
            trace = bulletTrace(loc, (loc-(0,0,5000)), false, undefined);
            end_loc = trace["position"]; //where the ground under the player is
        }
        else
        {
            println ("PLAYER IS ON GROUND - SKIPPING TRACE");
            end_loc = player.origin;
        }
        */
        //CHAD
        plant = player maps\mp\_utility::getPlant();
        end_loc = plant.origin;
        
        if (distance(loc,end_loc) > 0 )
        {
            self.origin = (loc);
            self.angles = plant.angles;
            self show();
            speed = (distance(loc,end_loc) / 250);
            if (speed > 0.4)
            {
                self moveto(end_loc,speed,.1,.1);
                self waittill ("movedone");
                self.trigger.origin = (end_loc);
            }
            else
            {
                self.origin = end_loc;
                self.angles = plant.angles;
                self show();
                self.trigger.origin = (end_loc);
            }
        }
        else
        {
            self.origin = end_loc;
            self.angles = plant.angles;
            self show();
            self.trigger.origin = (end_loc);
        }

        //check if it's in a minefield
        In_Mines = 0;
        for (i=0;i<level.minefield.size;i++)
        {
            if (self istouching(level.minefield[i]))
            {
                In_Mines = 1;
                break;
            }
        }

        if (In_Mines == 1)
        {
            if (player.objs_held > 1)
            {	//IF A PLAYER HOLDS 2 OR MORE OBJECTIVES AND DROPS ONLY ONE INTO THE MINEFIELD
                //THEN THIS WILL STILL SAY "MULTIPLE OBJECTIVES..." BUT A PLAYER SHOULD NEVER
                //BE ABOVE A MINEFIELD IN ONE OF THE SHIPPED MAPS SO I'LL LEAVE IT FOR NOW
                if ( (!isdefined (level.lastdropper)) || (level.lastdropper != player) )
                {
                    level.lastdropper = player;
                    announcement (&"RE_OBJ_INMINES_MULTIPLE");
                }
            }
            else
            {
                if ( (!isdefined (level.lastdropper)) || (level.lastdropper != player) )
                {
                    level.lastdropper = player;
                    if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
                        announcement (&"RE_OBJ_INMINES",level.obj[self.script_objective_name]);
                    else
                        announcement (&"RE_OBJ_INMINES_GENERIC");
                }
            }
            self.trigger.origin = (self.trigger.startorigin);
            self.origin = (self.startorigin);
            self.angles = (self.startangles);
        }
        else
        {
            if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )

                announcement (&"RE_OBJ_DROPPED",level.obj[self.script_objective_name]);
            else
                announcement (&"RE_OBJ_DROPPED");
        }

        if (isPlayer(player))
        {
            if ( (isdefined (self.objnum)) && (isdefined (player.hasobj[self.objnum])) )
                player.hasobj[self.objnum] = undefined;
            else
                println ("#### " + self.objnum + "UNDEFINED");
            player.objs_held--;
        }

        if ( (isPlayer(player)) && (player.objs_held < 1) )
        {
            if (level.drawfriend == 1)
            {
                if (isPlayer(player))
                if(player.pers["team"] == "allies")
                {
                    player.headicon = game["headicon_allies"];
                    player.headiconteam = "allies";
                }
                else if(player.pers["team"] == "axis")
                {
                    player.headicon = game["headicon_axis"];
                    player.headiconteam = "axis";
                }
                else
                {
                    player.statusicon = "";
                    player.headicon = "";
                }
            }
            else
            {
                if (isPlayer(player))
                {
                    player.statusicon = "";
                    player.headicon = "";
                }
            }
        }

        if (self istouching (self.goal))
        {
            if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
                announcement(&"RE_OBJ_CAPTURED",level.obj[self.script_objective_name]);
            else
                announcement(&"RE_OBJ_CAPTURED_GENERIC");

            if (isdefined (self.trigger))
                self.trigger delete();

            if ( (isPlayer(player)) && (player.objs_held < 1) )
            {
                if (level.drawfriend == 1)
                {
                    if (isPlayer(player))
                    if(player.pers["team"] == "allies")
                    {
                        player.headicon = game["headicon_allies"];
                        player.headiconteam = "allies";
                    }
                    else if(player.pers["team"] == "axis")
                    {
                        player.headicon = game["headicon_axis"];
                        player.headiconteam = "axis";
                    }
                    else
                    {
                        player.statusicon = "";
                        player.headicon = "";
                    }
                }
                else
                {
                    if (isPlayer(player))
                    {
                        player.statusicon = "";
                        player.headicon = "";
                    }
                }
            }

            //player.pers["score"] += 3;
            //player.score = player.pers["score"];
            level.objectives_done++;

            self notify ("completed");
            level thread clear_player_dropbar(player);
            
            objective_delete(self.objnum);
            self delete();

            if (level.objectives_done < level.retrieval_objective.size)
            {
                return;
            }
            else
            {
                announcement (&"RE_OBJ_CAPTURED_ALL");
                level thread endRound(game["re_attackers"]);
                return;
            }
        }

        self thread objective_timeout();
        self notify ("dropped");
        self thread retrieval_think();
    }
}

clear_player_dropbar(player)
{
    if (isdefined (player))
    {
        player.progressbackground destroy();
        player.progressbar destroy();
        player unlink();
        player.isusing = false;
    }
}

objective_timeout()
{
    self endon ("picked up");
    obj_timeout = 60;
    wait obj_timeout;
    announcement (&"RE_OBJ_TIMEOUT_RETURNING",obj_timeout);
    self.trigger.origin = (self.trigger.startorigin);
    self.origin = (self.startorigin);
    self.angles = (self.startangles);
    objective_position(self.objnum,self.origin);
}

holduse(player)
{
    player endon ("death");
    self endon ("completed");
    self endon ("dropped");
    player.isusing = false;
    delaytime = .3;
    droptime = 2;
    barsize = 288;
    level.barincrement = (barsize / (20.0 * droptime));
    
    wait (1);

    while (isPlayer(player))
    {
        player waittill ("Pressed Use");
        if (player.isusing == true)
            continue;
        else
            player.isusing = true;

        player.currenttime = 0;
        while(player useButtonPressed() && (isalive (player)))
        {
            usetime = 0;
            while(isalive(player) && player useButtonPressed() && (usetime < delaytime))
            {
                wait .05;
                usetime = (usetime + .05);
            }

            if (!(player isOnGround()))
                continue;

            if (!( (isalive(player)) && (player useButtonPressed()) ) )
            {
                player unlink();
                continue;
            }
            else
            {
                if(!isdefined(player.progressbackground))
                {
                    player.progressbackground = newClientHudElem(player);
                    player.progressbackground.alignX = "center";
                    player.progressbackground.alignY = "middle";
                    player.progressbackground.x = 320;
                    player.progressbackground.y = 385;
                    player.progressbackground.alpha = 0.5;
                }
                player.progressbackground setShader("black", (level.barsize + 4), 12);		
                progresstime = 0;
                progresslength = 0;
                
                spawned = spawn ("script_origin",player.origin);
                if (isdefined (spawned))
                    player linkto(spawned);

                while(isalive(player) && player useButtonPressed() && (progresstime < droptime))
                {
                    progresstime += 0.05;
                    progresslength += level.barincrement;

                    if(!isdefined(player.progressbar))
                    {
                        player.progressbar = newClientHudElem(player);				
                        player.progressbar.alignX = "left";
                        player.progressbar.alignY = "middle";
                        player.progressbar.x = (320 - (level.barsize / 2.0));
                        player.progressbar.y = 385;
                    }
                    player.progressbar setShader("white", progresslength, 8);			

                    wait 0.05;
                }

                if(progresstime >= droptime)
                {
                    if (isdefined (player.progressbackground))
                        player.progressbackground destroy();
                    if (isdefined (player.progressbar))
                        player.progressbar destroy();
                    
                    self thread drop_objective(player);
                    self notify ("dropped");
                    player unlink();
                    player.isusing = false;
                    return;
                }
                else if(isalive(player))
                {
                    player.progressbackground destroy();
                    player.progressbar destroy();
                }
            }
        }
        player unlink();
        player.isusing = false;
        wait(.05);
    }
}

pressuse_notify(player)
{
    player endon ("death");
    self endon ("dropped");
    while (isPlayer(player))
    {
        if (player useButtonPressed())
            player notify ("Pressed Use");

        wait (.05);
    }
}

display_holding_obj(obj_ent)
{
    num = (16 - (obj_ent.hudnum));

    if (num > 16)
        return;
    
    offset = (150 + (obj_ent.hudnum * 15));
    
    self.hudelem[num] = newClientHudElem(self);
    self.hudelem[num].alignX = "right";
    self.hudelem[num].alignY = "middle";
    self.hudelem[num].x = 635;
    self.hudelem[num].y = (550-offset);

    if ( (isdefined (obj_ent.script_objective_name)) && (isdefined (level.obj[obj_ent.script_objective_name])) )
    {
        self.hudelem[num].label = (&"RE_U_R_CARRYING");
        self.hudelem[num] setText(level.obj[obj_ent.script_objective_name]);
    }
    else
        self.hudelem[num] setText (&"RE_U_R_CARRYING_GENERIC");
}

triggerOff()
{
    self.origin = (self.origin - (0,0,10000));
}

client_print(obj, text, s)
{
    num = (16 - (obj.hudnum));

    if (num > 16)
        return;

    self notify ("stop client print");
    self endon ("stop client print");

    //if ( (isdefined (self.hudelem)) && (isdefined (self.hudelem[num])) )
    //	self.hudelem[num] destroy();
    
    for (i=1;i<16;i++)
    {
        if ( (isdefined (self.hudelem)) && (isdefined (self.hudelem[i])) )
            self.hudelem[i] destroy();
    }
    
    self.hudelem[num] = newClientHudElem(self);
    self.hudelem[num].alignX = "center";
    self.hudelem[num].alignY = "middle";
    self.hudelem[num].x = 320;
    self.hudelem[num].y = 200;

    if (isdefined (s))
    {
        self.hudelem[num].label = text;
        self.hudelem[num] setText(s);
    }
    else
        self.hudelem[num] setText(text);

    wait 3;
    
    if ( (isdefined (self.hudelem)) && (isdefined (self.hudelem[num])) )
        self.hudelem[num] destroy();
}

drop_objective_on_disconnect_or_death(player)
{
    //CHAD
    /*
    if (isdefined (trace))
    {
        loc = (loc + (0,0,25));
        trace = bulletTrace(loc, (loc-(0,0,5000)), false, undefined);
        end_loc = trace["position"]; //where the ground under the player is
    }
    else
    {
        println ("PLAYER IS ON GROUND - SKIPPING TRACE");
        end_loc = loc;
    }
    */
    
    plant = player maps\mp\_utility::getPlant();
    end_loc = plant.origin;
    
    if (distance(player.origin,end_loc) > 0 )
    {
        self.origin = (player.origin);
        self.angles = plant.angles;
        self show();
        speed = (distance(player.origin,end_loc) / 250);
        if (speed > 0.4)
        {
            self moveto(end_loc,speed,.1,.1);
            self waittill ("movedone");
            self.trigger.origin = (end_loc);
        }
        else
        {
            self.origin = end_loc;
            self.angles = plant.angles;
            self show();
            self.trigger.origin = (end_loc);
        }
    }
    else
    {
        self.origin = end_loc;
        self.angles = plant.angles;
        self show();
        self.trigger.origin = (end_loc);
    }

    //check if it's in a minefield
    In_Mines = 0;
    for (i=0;i<level.minefield.size;i++)
    {
        if (self istouching(level.minefield[i]))
        {
            In_Mines = 1;
            break;
        }
    }

    if (In_Mines == 1)
    {
        if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
            announcement (&"RE_OBJ_INMINES",level.obj[self.script_objective_name]);
        else
            announcement (&"RE_OBJ_INMINES_GENERIC");

        self.trigger.origin = (self.trigger.startorigin);
        self.origin = (self.startorigin);
        self.angles = (self.startangles);
    }
    else if (self istouching (self.goal))
    {
        if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
            announcement(&"RE_OBJ_CAPTURED",level.obj[self.script_objective_name]);
        else
            announcement(&"RE_OBJ_CAPTURED_GENERIC");

        if (isdefined (self.trigger))
            self.trigger delete();

        if ( (isPlayer(player)) && (player.objs_held < 1) )
        {
            if (level.drawfriend == 1)
            {
                if (isPlayer(player))
                if(player.pers["team"] == "allies")
                {
                    player.headicon = game["headicon_allies"];
                    player.headiconteam = "allies";
                }
                else if(player.pers["team"] == "axis")
                {
                    player.headicon = game["headicon_axis"];
                    player.headiconteam = "axis";
                }
                else
                {
                    player.statusicon = "";
                    player.headicon = "";
                }
            }
            else
            {
                if (isPlayer(player))
                {
                    player.statusicon = "";
                    player.headicon = "";
                }
            }
        }

        //player.pers["score"] += 3;
        //player.score = player.pers["score"];
        level.objectives_done++;

        self notify ("completed");
        level thread clear_player_dropbar(player);
        
        objective_delete(self.objnum);
        self delete();

        if (level.objectives_done < level.retrieval_objective.size)
        {
            return;
        }
        else
        {
            announcement (&"RE_OBJ_CAPTURED_ALL");
            level thread endRound(game["re_attackers"]);
            return;
        }
    }
    else
    {
        if ( (isdefined (self.script_objective_name)) && (isdefined (level.obj[self.script_objective_name])) )
            announcement (&"RE_OBJ_DROPPED",level.obj[self.script_objective_name]);
        else
            announcement (&"RE_OBJ_DROPPED");
    }

    self thread objective_timeout();
    self notify ("dropped");
    self thread retrieval_think();
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