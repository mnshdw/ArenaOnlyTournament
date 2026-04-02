::ModArenaOnlyTournament.HooksMod.hook("scripts/entity/world/settlements/buildings/arena_building", function (q) {

    q.isClosed = @(__original) function () {
        if (::ModArenaOnlyTournament.Unlimited) {
            return false;
        }
        return __original();
    }

    q.getUIImage = @(__original) function () {
        if (::ModArenaOnlyTournament.Night && !::World.getTime().IsDaytime) {
            return this.m.UIImage;
        }
        return __original();
    }

    q.getTooltip = @(__original) function () {
        if (::ModArenaOnlyTournament.Night && !::World.getTime().IsDaytime) {
            return this.m.Tooltip;
        }
        return __original();
    }

    q.onClicked = @(__original) function (_townScreen) {
        if (!::ModArenaOnlyTournament.Enabled
            && !::ModArenaOnlyTournament.Night
            && !::ModArenaOnlyTournament.Unlimited)
        {
            return __original(_townScreen);
        }

        if (!::ModArenaOnlyTournament.Night && !::World.getTime().IsDaytime) {
            return;
        }

        local unlimited = ::ModArenaOnlyTournament.Unlimited;
        if (!unlimited && ::World.getTime().Days < this.m.CooldownUntil) {
            return;
        }

        local activeContract = ::World.Contracts.getActiveContract();
        local isArenaContract = activeContract != null
            && (activeContract.getType() == "contract.arena"
                || activeContract.getType() == "contract.arena_tournament");

        if (activeContract != null && !isArenaContract) {
            return;
        }

        local f = ::World.FactionManager.getFactionOfType(::Const.Faction.Arena);
        local contracts = f.getContracts();
        local c = null;

        if (isArenaContract) {
            c = activeContract;
        } else if (contracts.len() == 0) {
            if (::ModArenaOnlyTournament.Enabled) {
                if (!unlimited && ::HasLegends) {
                    this.refreshTooltip();
                    if (this.getCurrentAttempts() >= this.getMaxAttempts()) {
                        return;
                    }
                }

                if (::World.Assets.getStash().getNumberOfEmptySlots() >= 5) {
                    c = ::new("scripts/contracts/contracts/arena_tournament_contract");
                    c.setFaction(f.getID());
                    c.setHome(::World.State.getCurrentTown());
                    ::World.Contracts.addContract(c);

                    if (!unlimited && ::HasLegends) {
                        this.registerAttempt();
                        this.refreshCooldown();
                    }
                } else {
                    return;
                }
            } else {
                if (::World.State.getCurrentTown().hasSituation("situation.arena_tournament")
                    && ::World.Assets.getStash().getNumberOfEmptySlots() >= 5)
                {
                    c = ::new("scripts/contracts/contracts/arena_tournament_contract");
                    c.setFaction(f.getID());
                    c.setHome(::World.State.getCurrentTown());
                    ::World.Contracts.addContract(c);
                } else if (::World.Assets.getStash().getNumberOfEmptySlots() >= 3) {
                    c = ::new("scripts/contracts/contracts/arena_contract");
                    c.setFaction(f.getID());
                    c.setHome(::World.State.getCurrentTown());
                    ::World.Contracts.addContract(c);
                } else {
                    return;
                }
            }
        } else {
            c = contracts[0];
        }

        c.setScreenForArena();
        ::World.Contracts.showContract(c);
    }
});
