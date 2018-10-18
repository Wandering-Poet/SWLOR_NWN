﻿using NWN;
using SWLOR.Game.Server.Data.Entities;
using SWLOR.Game.Server.Enumeration;
using SWLOR.Game.Server.GameObject;
using SWLOR.Game.Server.Item.Contracts;
using SWLOR.Game.Server.Service.Contracts;
using SWLOR.Game.Server.ValueObject;
using static NWN.NWScript;

namespace SWLOR.Game.Server.Item.Medicine
{
    public class Bandages: IActionItem
    {
        private readonly INWScript _;
        private readonly ISkillService _skill;
        private readonly ICustomEffectService _customEffect;
        private readonly IRandomService _random;
        private readonly IPerkService _perk;
        private readonly IPlayerStatService _playerStat;

        public Bandages(INWScript script,
            ISkillService skill,
            ICustomEffectService customEffect,
            IRandomService random,
            IPerkService perk,
            IPlayerStatService playerStat)
        {
            _ = script;
            _skill = skill;
            _customEffect = customEffect;
            _random = random;
            _perk = perk;
            _playerStat = playerStat;
        }

        public CustomData StartUseItem(NWCreature user, NWItem item, NWObject target, Location targetLocation)
        {
            user.SendMessage("You begin treating " + target.Name + "'s wounds...");
            return null;
        }

        public void ApplyEffects(NWCreature user, NWItem item, NWObject target, Location targetLocation, CustomData customData)
        {
            NWPlayer player = (user.Object);
            var effectiveStats = _playerStat.GetPlayerItemEffectiveStats(player);

            _customEffect.RemovePCCustomEffect((NWPlayer)target, CustomEffectType.Bleeding);
            player.SendMessage("You finish bandaging " + target.Name + "'s wounds.");
            
            PCSkill skill = _skill.GetPCSkill(player, SkillType.Medicine);
            int rank = skill.Rank;

            int healAmount = 2 + effectiveStats.Medicine / 2;
            healAmount += item.MedicineBonus;
            if (rank >= item.RecommendedLevel && item.MedicineBonus > 0)
            {
                _.ApplyEffectToObject(DURATION_TYPE_INSTANT, _.EffectHeal(healAmount), target);
            }

            int xp = (int)_skill.CalculateRegisteredSkillLevelAdjustedXP(100, item.RecommendedLevel, skill.Rank);
            _skill.GiveSkillXP(player, SkillType.Medicine, xp);
        }

        public float Seconds(NWCreature user, NWItem item, NWObject target, Location targetLocation, CustomData customData)
        {
            if (_random.Random(100) + 1 <= _perk.GetPCPerkLevel((NWPlayer)user, PerkType.SpeedyFirstAid) * 10)
            {
                return 0.1f;
            }

            PCSkill skill = _skill.GetPCSkill((NWPlayer)user, SkillType.Medicine);
            float seconds = 6.0f - (skill.Rank * 0.2f);
            if (seconds < 1.0f) seconds = 1.0f;
            return seconds;
        }

        public bool FaceTarget()
        {
            return true;
        }

        public int AnimationID()
        {
            return ANIMATION_LOOPING_GET_MID;
        }

        public float MaxDistance(NWCreature user, NWItem item, NWObject target, Location targetLocation)
        {
            return 3.5f + _perk.GetPCPerkLevel(user.Object, PerkType.RangedHealing);
        }

        public bool ReducesItemCharge(NWCreature user, NWItem item, NWObject target, Location targetLocation, CustomData customData)
        {
            return true;
        }

        public string IsValidTarget(NWCreature user, NWItem item, NWObject target, Location targetLocation)
        {
            if (!user.IsPlayer)
            {
                return "Only players may be targeted with this item.";
            }

            if (!_customEffect.DoesPCHaveCustomEffect((NWPlayer)target, CustomEffectType.Bleeding))
            {
                return "Your target is not bleeding.";
            }

            int rank = _skill.GetPCSkill(user.Object, SkillType.Medicine).Rank;
            if (rank < item.RecommendedLevel)
            {
                return "Your skill level is too low to use this item.";
            }

            return null;
        }

        public bool AllowLocationTarget()
        {
            return false;
        }
    }
}
