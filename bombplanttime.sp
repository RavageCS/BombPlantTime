#include <sourcemod>
#include <cstrike>
#include <sdktools>

#pragma semicolon 1

int g_num_ticks_start_pre;
int g_num_ticks_finish_pre;

int g_num_ticks_start_post;
int g_num_ticks_finish_post;

float g_ticked_time_start_pre;
float g_ticked_time_finish_pre;

float g_ticked_time_start_post;
float g_ticked_time_finish_post;

float g_engine_time_start_pre;
float g_engine_time_finish_pre;

float g_engine_time_start_post;
float g_engine_time_finish_post;

bool g_attack1;
bool g_use;

// Plugin definitions
#define PLUGIN_VERSION "1.1.0"
public Plugin:myinfo =
{
	name = "Bomb Plant Time Tester",
	author = "Gdk",
	version = PLUGIN_VERSION,
	description = "Test how long bomb plants take",
	url = "https://github.com/RavageCS/BombPlantTime"
};

public OnPluginStart()
{
	HookEvent("round_start", Set_vars);
	HookEvent("bomb_exploded", Set_vars);

	// Pre hook events
	HookEvent("bomb_beginplant", Event_Pre_BombPlantStart, EventHookMode_Pre);
	HookEvent("bomb_abortplant", Event_Pre_BombPlantStop, EventHookMode_Pre);
	HookEvent("bomb_planted", Event_Pre_BombPlantFinish, EventHookMode_Pre);

	// Post hook events
	HookEvent("bomb_beginplant", Event_Post_BombPlantStart, EventHookMode_Post);
	HookEvent("bomb_planted", Event_Post_BombPlantFinish, EventHookMode_Post);
}

public void reset_globals()
{
	g_num_ticks_start_pre = 0;
	g_num_ticks_finish_pre = 0;

	g_num_ticks_start_post = 0;
	g_num_ticks_finish_post = 0;

	g_ticked_time_start_pre = 0.0;
	g_ticked_time_finish_pre = 0.0;

	g_ticked_time_start_post = 0.0;
	g_ticked_time_finish_post = 0.0;

	g_engine_time_start_pre = 0.0;
	g_engine_time_finish_pre = 0.0;

	g_engine_time_start_post = 0.0;
	g_engine_time_finish_post = 0.0;

	g_attack1 = false;
	g_use = false;
}

public void GetKeys(int client)
{
	new Buttons = GetClientButtons(client);
    
        if (Buttons & IN_ATTACK)
        {
		g_attack1 = true;
	}
	else if (Buttons & IN_USE)
	{
		g_use = true;
	}
}

public void OnMapStart()
{
	reset_globals();
}

public Set_vars(Handle:event, const String:name[], bool:dontBroadcast)
{
	reset_globals();
}

//Pre hook calls
public Event_Pre_BombPlantStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	g_num_ticks_start_pre = GetGameTickCount();
	g_ticked_time_start_pre = GetTickedTime();
	g_engine_time_start_pre = GetEngineTime();
	GetKeys(client);
}

public Event_Pre_BombPlantStop(Handle:event, const String:name[], bool:dontBroadcast)
{
	reset_globals();
}

public Event_Pre_BombPlantFinish(Handle:event, const String:name[], bool:dontBroadcast)
{
	g_num_ticks_finish_pre = GetGameTickCount();
	g_ticked_time_finish_pre = GetTickedTime();
	g_engine_time_finish_pre = GetEngineTime();
	PrintToChatAll("Bomb Planted!!");
	
	if(g_attack1)
		PrintToChatAll("Method: +attack");
	else if(g_use)
		PrintToChatAll("Method: +use");
	else
		PrintToChatAll("Error decting key press");

	PrintToChatAll("Number of ticks to plant bomb pre hook: %i", g_num_ticks_finish_pre - g_num_ticks_start_pre);
	PrintToChatAll("Ticked time to plant post hook: %f", g_ticked_time_finish_pre - g_ticked_time_start_pre);
	PrintToChatAll("Engine time to plant pre hook: %f", g_engine_time_finish_pre - g_engine_time_start_pre);
}

//Post hook calls
public Event_Post_BombPlantStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	g_num_ticks_start_post = GetGameTickCount();
	g_ticked_time_start_post = GetTickedTime();
	g_engine_time_start_post = GetEngineTime();
}

public Event_Post_BombPlantFinish(Handle:event, const String:name[], bool:dontBroadcast)
{
	g_num_ticks_finish_post = GetGameTickCount();
	g_ticked_time_finish_post = GetTickedTime();
	g_engine_time_finish_post = GetEngineTime();
	PrintToChatAll("Number of ticks to plant bomb post hook: %i", g_num_ticks_finish_post - g_num_ticks_start_post);
	PrintToChatAll("Ticked time to plant post hook: %f", g_ticked_time_finish_post - g_ticked_time_start_post);
	PrintToChatAll("Engine time to plant post hook: %f", g_engine_time_finish_post - g_engine_time_start_post);
}