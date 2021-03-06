

SELECT * 
FROM dbo.Player 

BEGIN TRANSACTION

UPDATE dbo.Player
SET PrimaryResidencePCBaseID = NULL,
	PrimaryResidencePCBaseStructureID = NULL 

DELETE FROM dbo.ChatLog

DELETE FROM dbo.PCBaseStructureItem

DELETE FROM dbo.PCBaseStructurePermission

DELETE FROM dbo.PCBasePermission

DELETE FROM dbo.PCBaseStructure

DELETE FROM dbo.PCBase

DELETE FROM dbo.AreaWalkmesh

DELETE FROM dbo.Area

DELETE FROM dbo.PCCraftedBlueprint

DELETE FROM dbo.PCCooldown

DELETE FROM dbo.PCCustomEffect

DELETE FROM dbo.PCKeyItem

DELETE FROM dbo.PCPerk

DELETE FROM dbo.PCSkill

DELETE FROM dbo.PCObjectVisibility

DELETE FROM dbo.PCOutfit

DELETE FROM dbo.PCOverflowItem

DELETE FROM dbo.PCSearchSiteItem

DELETE FROM dbo.PCSearchSite

DELETE FROM dbo.PCRegionalFame

DELETE FROM dbo.PCQuestItemProgress

DELETE FROM dbo.PCQuestKillTargetProgress

DELETE FROM dbo.PCQuestStatus

DELETE FROM dbo.BugReport

DELETE FROM dbo.ClientLogEvent

DELETE FROM dbo.PCMapPin

DELETE FROM dbo.PCImpoundedItem

DELETE FROM dbo.PCPerkRefund

DELETE FROM dbo.BankItem

DELETE FROM dbo.Bank

DELETE FROM dbo.PCMapProgression

DELETE FROM dbo.Player

DELETE FROM dbo.GrowingPlant

-- rollback
-- commit

