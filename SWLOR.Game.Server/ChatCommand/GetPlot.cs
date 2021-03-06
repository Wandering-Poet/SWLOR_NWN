﻿using NWN;
using SWLOR.Game.Server.ChatCommand.Contracts;
using SWLOR.Game.Server.Enumeration;
using SWLOR.Game.Server.GameObject;
using static NWN.NWScript;

namespace SWLOR.Game.Server.ChatCommand
{
    [CommandDetails("Gets whether an object is marked plot.", CommandPermissionType.DM)]
    public class GetPlot : IChatCommand
    {
        private readonly INWScript _;

        public GetPlot(INWScript script)
        {
            _ = script;
        }

        public void DoAction(NWPlayer user, NWObject target, NWLocation targetLocation, params string[] args)
        {
            if (target.IsPlot)
            {
                user.SendMessage("Target is marked plot.");
            }
            else
            {
                user.SendMessage("Target is NOT marked plot.");
            }
        }

        public string ValidateArguments(NWPlayer user, params string[] args)
        {
            return string.Empty;
        }

        public bool RequiresTarget => true;
    }
}
