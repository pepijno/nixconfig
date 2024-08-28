/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>
#include <stdio.h>
#include <string.h>

void exitdwm ()
{
# define S_LOCK "Lock"
# define S_RESTART_DWM "Restart Dwm"
# define S_KILL_DWM "Kill Dwm"
# define S_SUSPEND "Suspend"
# define S_HIBERNATE "Hibernate"
# define S_REBOOT "Reboot"
# define S_SHUTDOWN "Shutdown"
# define S_LOCK_ICON ""
# define S_RESTART_DWM_ICON ""
# define S_KILL_DWM_ICON ""
# define S_SUSPEND_ICON ""
# define S_HIBERNATE_ICON "⏾"
# define S_REBOOT_ICON ""
# define S_SHUTDOWN_ICON ""

# define S_FORMAT(ACTION) S_##ACTION##_ICON " " S_##ACTION
# define S_FORMAT_CLEAR "sed 's/^..//'"

	FILE * exit_menu = popen (
		"echo \""
			S_FORMAT (LOCK) "\n"
			S_FORMAT (RESTART_DWM) "\n"
			S_FORMAT (KILL_DWM) "\n"
			S_FORMAT (SUSPEND) "\n"
			S_FORMAT (HIBERNATE) "\n"
			S_FORMAT (REBOOT) "\n"
			S_FORMAT (SHUTDOWN)
			"\" | ${dmenu}/bin/dmenu -i -l 7 -p exit: | " S_FORMAT_CLEAR
		,
		"r"
	);

	char exit_action [16];

	if (
		exit_menu == NULL ||
		fscanf (exit_menu, "%15[a-zA-Z -]", exit_action) == EOF
	) {
		fputs ("Error. Failure in exit_dwm.", stderr);
		goto close_streams;
	}

	if (strcmp (exit_action, S_LOCK) == 0) system ("${betterlockscreen}/bin/betterlockscreen --lock blur");
	else if (strcmp (exit_action, S_RESTART_DWM) == 0) quit (& (const Arg) {1});
	else if (strcmp (exit_action, S_KILL_DWM) == 0) system ("${sw}/bin/pkill dwm");
	else if (strcmp (exit_action, S_SUSPEND) == 0) system ("${sw}/bin/systemctl suspend");
	else if (strcmp (exit_action, S_HIBERNATE) == 0) system ("${sw}/bin/systemctl hibernate");
	else if (strcmp (exit_action, S_REBOOT) == 0) system ("${sw}/bin/systemctl reboot");
	else if (strcmp (exit_action, S_SHUTDOWN) == 0) system ("${sw}/bin/systemctl poweroff -i");

close_streams:
	pclose (exit_menu);

# undef S_LOCK
# undef S_RESTART_DWM
# undef S_KILL_DWM
# undef S_SUSPEND
# undef S_HIBERNATE
# undef S_REBOOT
# undef S_SHUTDOWN
# undef S_LOCK_ICON
# undef S_RESTART_DWM_ICON
# undef S_KILL_DWM_ICON
# undef S_SUSPEND_ICON
# undef S_HIBERNATE_ICON
# undef S_REBOOT_ICON
# undef S_SHUTDOWN_ICON
# undef S_FORMAT
# undef S_FORMAT_CLEAR
}

/* appearance */
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static const int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int vertpad            = 10;       /* vertical padding of bar */
static const int sidepad            = 10;       /* horizontal padding of bar */
static const int horizpadbar        = 5;        /* horizontal padding for statusbar */
static const int vertpadbar         = 11;       /* vertical padding for statusbar */
static const int colorfultag        = 1;        /* 0 means use SchemeSel for selected non vacant tag */
static const char *fonts[]          = { "mononoki:style=Regular:size=12", "JetBrainsMono Nerd Font Mono:style=Medium:size=16" };
static const char black[]           = "#4c4f69";
static const char gray2[]           = "#8c8fa1"; // unfocused window border
static const char gray3[]           = "#9ca0b0";
static const char gray4[]           = "#acb0be";
static const char blue[]            = "#1e66f5";  // focused window border
static const char green[]           = "#40a02b";
static const char red[]             = "#d20f39";
static const char orange[]          = "#fe640b";
static const char yellow[]          = "#df8e1d";
static const char pink[]            = "#ea76cb";
static const char col_borderbar[]   = "#1E1D2D"; // inner border
static const char white[]           = "#eff1f5";

#define ICONSIZE 19   /* icon size */
#define ICONSPACING 8 /* space between icon and title */

static const char *colors[][3]      = {
    /*                     fg       bg      border */
    [SchemeNorm]       = { gray3,   white,  gray2 },
    [SchemeSel]        = { gray4,   blue,   blue  },
    [SchemeTag]        = { gray3,   white,  white },
    [SchemeTag1]       = { blue,    white,  white },
    [SchemeTag2]       = { red,     white,  white },
    [SchemeTag3]       = { orange,  white,  white },
    [SchemeTag4]       = { green,   white,  white },
    [SchemeTag5]       = { pink,    white,  white },
};

/* tagging */
static const char *tags[] = { "", "", "", "", "" };

static const int tagschemes[] = {
    SchemeTag1, SchemeTag2, SchemeTag3, SchemeTag4, SchemeTag5
};

static const unsigned int ulinepad      = 5; /* horizontal padding between the underline and tag */
static const unsigned int ulinestroke   = 2; /* thickness / height of the underline */
static const unsigned int ulinevoffset  = 0; /* how far above the bottom of the bar the line should appear */
static const int ulineall               = 0; /* 1 to show underline on all tags, 0 for just the active ones */

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class             instance    title       tags mask     isfloating   monitor */
	{ "firefox",         NULL,       NULL,       1 << 2,       0,           -1 },
	{ "Vivaldi-stable",  NULL,       NULL,       1 << 1,       0,           -1 },
	{ "steam",           NULL,       NULL,       1 << 4,       0,           -1 },
	{ "Tor Browser",     NULL,       NULL,       1 << 3,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "${dmenu}/bin/dmenu_run", "-c", "-l", "20", NULL };
static const char *termcmd[]  = { "${kitty}/bin/kitty", NULL };
static const char *sysmenucmd[]  = { "${sysmenu}/bin/sysmenu", NULL };
static const char *firefoxcmd[]  = { "${firefox}/bin/firefox", NULL };
static const char *vivaldicmd[]  = { "${vivaldi}/bin/vivaldi", NULL };
static const char *torcmd[]  = { "${tor-browser}/bin/tor-browser", NULL };
static const char *steamcmd[]  = { "${steam}/bin/steam", NULL };

static const char *pactldecrease[] = { "${sw}/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };
static const char *pactlincrease[] = { "${sw}/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };
static const char *pactlmute[] = { "${sw}/bin/pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };
static const char *medplaypausecmd[] = { "${playerctl}/bin/playerctl", "play-pause", NULL };
static const char *mednextcmd[] = { "${playerctl}/bin/playerctl", "next", NULL };
static const char *medprevcmd[] = { "${playerctl}/bin/playerctl", "previous", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_e,      exitdwm,        {0} },

	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_b,      spawn,          {.v = vivaldicmd } },
	{ MODKEY|ShiftMask,             XK_f,      spawn,          {.v = firefoxcmd } },
	{ MODKEY|ShiftMask,             XK_o,      spawn,          {.v = torcmd } },
	{ MODKEY|ShiftMask,             XK_s,      spawn,          {.v = steamcmd } },

	{ 0,                            XF86XK_AudioLowerVolume, spawn, {.v = pactldecrease } },
	{ 0,                            XF86XK_AudioRaiseVolume, spawn, {.v = pactlincrease } },
	{ 0,                            XF86XK_AudioMute,        spawn, {.v = pactlmute } },
	{ 0,                            XF86XK_AudioPlay,        spawn, {.v = medplaypausecmd } },
	{ 0,                            XF86XK_AudioNext,        spawn, {.v = mednextcmd } },
	{ 0,                            XF86XK_AudioPrev,        spawn, {.v = medprevcmd } },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

