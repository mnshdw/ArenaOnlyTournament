::mods_hookExactClass("entity/world/settlements/buildings/arena_building", function (o) {
    local onClicked = o.onClicked;
    o.onClicked = function (_townScreen) {
        if (!::ModArenaOnlyTournament.Enabled) {
            return onClicked(_townScreen);
        }

        if (!::World.getTime().IsDaytime) {
            return;
        }

        local activeContract = ::World.Contracts.getActiveContract();
        local isArenaContract = activeContract != null
            && (activeContract.getType() == "contract.arena"
                || activeContract.getType() == "contract.arena_tournament");

        if ((activeContract == null || isArenaContract)
            && ::World.getTime().Days >= this.m.CooldownUntil)
        {
            local f = ::World.FactionManager.getFactionOfType(::Const.Faction.Arena);
            local contracts = f.getContracts();
            local c = null;

            if (isArenaContract) {
                c = activeContract;
            } else if (contracts.len() == 0) {
                // Always create tournament contract if we have enough slots
                if (::World.Assets.getStash().getNumberOfEmptySlots() >= 5) {
                    c = ::new("scripts/contracts/contracts/arena_tournament_contract");
                    c.setFaction(f.getID());
                    c.setHome(::World.State.getCurrentTown());
                   ::World.Contracts.addContract(c);
                } else if (::World.Assets.getStash().getNumberOfEmptySlots() >= 3) {
                    // Fall back to regular arena if not enough slots for tournament
                    c = ::new("scripts/contracts/contracts/arena_contract");
                    c.setFaction(f.getID());
                    c.setHome(::World.State.getCurrentTown());
                   ::World.Contracts.addContract(c);
                } else {
                    return;
                }
            } else {
                c = contracts[0];
            }

            c.setScreenForArena();
           ::World.Contracts.showContract(c);
        }
    }
});
