﻿using SWLOR.Game.Server.GameObject;

namespace SWLOR.Game.Server.Service.Contracts
{
    public interface IRaceService
    {
        void OnModuleEnter();
        void ApplyDefaultAppearance(NWPlayer player);
    }
}