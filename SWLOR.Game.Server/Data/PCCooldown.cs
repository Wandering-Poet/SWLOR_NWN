//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SWLOR.Game.Server.Data
{
    using System;
    using System.Collections.Generic;
    
    public partial class PCCooldown
    {
        public int PCCooldownID { get; set; }
        public string PlayerID { get; set; }
        public int CooldownCategoryID { get; set; }
        public System.DateTime DateUnlocked { get; set; }
    
        public virtual CooldownCategory CooldownCategory { get; set; }
        public virtual PlayerCharacter PlayerCharacter { get; set; }
    }
}