﻿using SWLOR.Game.Server.GameObject;

namespace SWLOR.Game.Server.NWNX.Contracts
{
    public interface INWNXDamage
    {
        DamageData GetDamageEventData();
        void SetDamageEventData(DamageData data);
        void SetDamageEventScript(string script, NWObject oOwner = null);
    }
}