::ModArenaOnlyTournament <- {
	ID = "mod_arena_only_tournament",
	Name = "Arena Only Tournament",
	Version = "1.0.1",
	Enabled = true,
	Unlimited = false,
};

::ModArenaOnlyTournament.HooksMod <- ::Hooks.register(
	::ModArenaOnlyTournament.ID,
	::ModArenaOnlyTournament.Version,
	::ModArenaOnlyTournament.Name
);

::ModArenaOnlyTournament.HooksMod.require("mod_msu >= 1.2.7", "mod_modern_hooks >= 0.5.4");

::ModArenaOnlyTournament.HooksMod.queue(">mod_msu", ">mod_legends", function () {
	::ModArenaOnlyTournament.Mod <- ::MSU.Class.Mod(
		::ModArenaOnlyTournament.ID,
		::ModArenaOnlyTournament.Version,
		::ModArenaOnlyTournament.Name
	);

	::ModArenaOnlyTournament.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/mnshdw/ArenaOnlyTournament");

	::ModArenaOnlyTournament.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::HasLegends <- ::Hooks.hasMod("mod_legends");

	local page = ::ModArenaOnlyTournament.Mod.ModSettings.addPage("Arena Only Tournament");
	local settingEnabled = page.addBooleanSetting(
		"Enabled",
		true,
		"Enabled",
		"When enabled, the arena will only have tournaments instead of regular battles."
	);
	settingEnabled.addCallback(function (_value) {
		::ModArenaOnlyTournament.Enabled = _value;
	});

	local settingUnlimited = page.addBooleanSetting(
		"Unlimited",
		false,
		"Unlimited",
		"When enabled, you can do unlimited tournaments per day. When disabled, only one tournament per day is allowed."
	);
	settingUnlimited.addCallback(function (_value) {
		::ModArenaOnlyTournament.Unlimited = _value;
	});

	::include("mod_arena_only_tournament/load.nut");

}, ::Hooks.QueueBucket.Normal);
