CREATE TABLE [dbo].[PCPerks](
	[PCPerkID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[AcquiredDate] [datetime2](7) NOT NULL,
	[PerkID] [int] NOT NULL,
	[PerkLevel] [int] NOT NULL,
 CONSTRAINT [PK__PCPerks__0BA6BCB6B49FBD5D] PRIMARY KEY CLUSTERED 
(
	[PCPerkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PerkLevels]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[PerkLevels](
	[PerkLevelID] [int] IDENTITY(1,1) NOT NULL,
	[PerkID] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[Price] [int] NOT NULL,
	[Description] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK__PerkLeve__A934EB471F92073F] PRIMARY KEY CLUSTERED 
(
	[PerkLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [uq_PerkLevels_PerkIDLevel] UNIQUE NONCLUSTERED 
(
	[PerkID] ASC,
	[Level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCSkills]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[PCSkills](
	[PCSkillID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[SkillID] [int] NOT NULL,
	[XP] [int] NOT NULL,
	[Rank] [int] NOT NULL,
	[IsLocked] [bit] NOT NULL,
 CONSTRAINT [PK__PCSkills__F00838A44ECEB5BD] PRIMARY KEY CLUSTERED 
(
	[PCSkillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PerkLevelSkillRequirements]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[PerkLevelSkillRequirements](
	[PerkLevelSkillRequirementID] [int] IDENTITY(1,1) NOT NULL,
	[PerkLevelID] [int] NOT NULL,
	[SkillID] [int] NOT NULL,
	[RequiredRank] [int] NOT NULL,
 CONSTRAINT [PK_PerkLevelSkillRequirements_PerkLevelSkillRequirementID] PRIMARY KEY CLUSTERED 
(
	[PerkLevelSkillRequirementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPlayerEffectivePerkLevel]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE FUNCTION [dbo].[fn_GetPlayerEffectivePerkLevel]
(	
	@PlayerID NVARCHAR(60),
	@PerkID INT,
	@SkillLevel INT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT pl.PerkLevelID ,
		   pl.PerkID ,
		   pl.Level ,
		   pl.Price ,
		   pl.Description
	FROM dbo.PerkLevels pl
	WHERE pl.PerkLevelID = (
		SELECT TOP(1) pl2.PerkLevelID
		FROM dbo.PerkLevels pl2
		LEFT JOIN dbo.PerkLevelSkillRequirements pr ON pr.PerkLevelID = pl2.PerkLevelID
		JOIN dbo.PCPerks pcp ON pcp.PerkID = pl2.PerkID
			AND pcp.PlayerID = @PlayerID
			AND pcp.PerkLevel >= pl2.Level
		JOIN dbo.PCSkills pcs ON pcs.PlayerID = pcp.PlayerID
			AND pcs.SkillID = ISNULL(pr.SkillID, pcs.SkillID)
		WHERE pcp.PerkID = @PerkID
			AND ISNULL(@SkillLevel, pcs.Rank) >= ISNULL(pr.RequiredRank, 0)
		ORDER BY pl2.Level DESC

	)
)


GO
/****** Object:  Table [dbo].[ApartmentBuildings]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[ApartmentBuildings](
	[ApartmentBuildingID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ApartmentBuildingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Areas]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[Areas](
	[AreaID] [nvarchar](60) NOT NULL,
	[Resref] [nvarchar](16) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Tag] [nvarchar](32) NOT NULL,
	[ResourceSpawnTableID] [int] NOT NULL,
	[Width] [int] NOT NULL,
	[Height] [int] NOT NULL,
	[IsBuildable] [bit] NOT NULL,
	[NorthwestOwner] [nvarchar](60) NULL,
	[NortheastOwner] [nvarchar](60) NULL,
	[SouthwestOwner] [nvarchar](60) NULL,
	[SoutheastOwner] [nvarchar](60) NULL,
	[IsActive] [bit] NOT NULL,
	[PurchasePrice] [int] NOT NULL,
	[DailyUpkeep] [int] NOT NULL,
	[Walkmesh] [nvarchar](max) NULL,
	[DateLastBaked] [datetime2](7) NOT NULL,
	[AutoSpawnResources] [bit] NOT NULL,
	[ResourceQuality] [int] NOT NULL,
	[NorthwestLootTableID] [int] NULL,
	[NortheastLootTableID] [int] NULL,
	[SouthwestLootTableID] [int] NULL,
	[SoutheastLootTableID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Areas_Resref] UNIQUE NONCLUSTERED 
(
	[Resref] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AreaWalkmesh]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[AreaWalkmesh](
	[AreaWalkmeshID] [int] IDENTITY(1,1) NOT NULL,
	[AreaID] [nvarchar](60) NOT NULL,
	[LocationX] [float] NULL,
	[LocationY] [float] NULL,
	[LocationZ] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AreaWalkmeshID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Associations]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[Associations](
	[AssociationID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AssociationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Attributes]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[Attributes](
	[AttributeID] [int] NOT NULL,
	[NWNValue] [int] NOT NULL,
	[Name] [nvarchar](3) NOT NULL,
 CONSTRAINT [PK__Attribut__C189298A024C3D44] PRIMARY KEY CLUSTERED 
(
	[AttributeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuthorizedDMs]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[AuthorizedDMs](
	[AuthorizedDMID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CDKey] [nvarchar](20) NOT NULL,
	[DMRole] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__Authoriz__D233D9E915E4120B] PRIMARY KEY CLUSTERED 
(
	[AuthorizedDMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Backgrounds]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[Backgrounds](
	[BackgroundID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Description] [nvarchar](512) NOT NULL,
	[Bonuses] [nvarchar](512) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BackgroundID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BankItems]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[BankItems](
	[BankItemID] [int] IDENTITY(1,1) NOT NULL,
	[BankID] [int] NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[ItemID] [nvarchar](60) NOT NULL,
	[ItemName] [nvarchar](max) NOT NULL,
	[ItemTag] [nvarchar](64) NOT NULL,
	[ItemResref] [nvarchar](16) NOT NULL,
	[ItemObject] [nvarchar](max) NOT NULL,
	[DateStored] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BankItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Banks]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[Banks](
	[BankID] [int] NOT NULL,
	[AreaName] [nvarchar](255) NOT NULL,
	[AreaTag] [nvarchar](64) NOT NULL,
	[AreaResref] [nvarchar](16) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BaseItemTypes]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[BaseItemTypes](
	[BaseItemTypeID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK__BaseItem__1AC990A1E6B56350] PRIMARY KEY CLUSTERED 
(
	[BaseItemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BaseStructures]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[BaseStructures](
	[BaseStructureID] [int] NOT NULL,
	[BaseStructureTypeID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[PlaceableResref] [nvarchar](16) NOT NULL,
	[ItemResref] [nvarchar](16) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Power] [float] NOT NULL,
	[CPU] [float] NOT NULL,
	[Durability] [float] NOT NULL,
	[Storage] [int] NOT NULL,
	[HasAtmosphere] [bit] NOT NULL,
	[ReinforcedStorage] [int] NOT NULL,
	[RequiresBasePower] [bit] NOT NULL,
	[ResourceStorage] [int] NOT NULL,
	[RetrievalRating] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BaseStructureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BaseStructureType]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[BaseStructureType](
	[BaseStructureTypeID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CanPlaceInside] [bit] NOT NULL,
	[CanPlaceOutside] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BaseStructureTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BugReports]    Script Date: 10/22/2018 1:38:08 AM ******/

CREATE TABLE [dbo].[BugReports](
	[BugReportID] [int] IDENTITY(1,1) NOT NULL,
	[SenderPlayerID] [nvarchar](60) NULL,
	[CDKey] [nvarchar](20) NOT NULL,
	[Text] [nvarchar](1000) NOT NULL,
	[TargetName] [nvarchar](64) NOT NULL,
	[AreaResref] [nvarchar](16) NOT NULL,
	[SenderLocationX] [float] NOT NULL,
	[SenderLocationY] [float] NOT NULL,
	[SenderLocationZ] [float] NOT NULL,
	[SenderLocationOrientation] [float] NOT NULL,
	[DateSubmitted] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BugReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BuildingStyles]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[BuildingStyles](
	[BuildingStyleID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Resref] [nvarchar](16) NOT NULL,
	[BaseStructureID] [int] NULL,
	[IsDefault] [bit] NOT NULL,
	[DoorRule] [nvarchar](64) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[BuildingTypeID] [int] NOT NULL,
	[PurchasePrice] [int] NOT NULL,
	[DailyUpkeep] [int] NOT NULL,
	[FurnitureLimit] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BuildingStyleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BuildingTypes]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[BuildingTypes](
	[BuildingTypeID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BuildingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatChannelsDomain]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[ChatChannelsDomain](
	[ChatChannelID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK__ChatChan__7153E07326A4B168] PRIMARY KEY CLUSTERED 
(
	[ChatChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatLog]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[ChatLog](
	[ChatLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ChatChannelID] [int] NOT NULL,
	[SenderPlayerID] [nvarchar](60) NULL,
	[SenderAccountName] [nvarchar](1024) NOT NULL,
	[SenderCDKey] [nvarchar](20) NOT NULL,
	[ReceiverPlayerID] [nvarchar](60) NULL,
	[ReceiverAccountName] [nvarchar](1024) NULL,
	[ReceiverCDKey] [nvarchar](20) NULL,
	[Message] [nvarchar](max) NOT NULL,
	[DateSent] [datetime2](7) NOT NULL,
	[SenderDMName] [nvarchar](60) NULL,
	[ReceiverDMName] [nvarchar](60) NULL,
 CONSTRAINT [PK__ChatLog__454604C4BBAF0C10] PRIMARY KEY CLUSTERED 
(
	[ChatLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientLogEvents]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[ClientLogEvents](
	[ClientLogEventID] [int] IDENTITY(1,1) NOT NULL,
	[ClientLogEventTypeID] [int] NOT NULL,
	[PlayerID] [nvarchar](60) NULL,
	[CDKey] [nvarchar](20) NOT NULL,
	[AccountName] [nvarchar](1024) NOT NULL,
	[DateOfEvent] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ClientLogEvents_ClientLogEventID] PRIMARY KEY CLUSTERED 
(
	[ClientLogEventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientLogEventTypesDomain]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[ClientLogEventTypesDomain](
	[ClientLogEventTypeID] [int] NOT NULL,
	[Name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_ClientLogEventTypesDomain_ClientLogEventTypeID] PRIMARY KEY CLUSTERED 
(
	[ClientLogEventTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComponentTypes]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[ComponentTypes](
	[ComponentTypeID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ComponentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CooldownCategories]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[CooldownCategories](
	[CooldownCategoryID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[BaseCooldownTime] [float] NOT NULL,
 CONSTRAINT [PK__Cooldown__049008DC1A120AC0] PRIMARY KEY CLUSTERED 
(
	[CooldownCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CraftBlueprintCategories]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[CraftBlueprintCategories](
	[CraftBlueprintCategoryID] [bigint] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__CraftBlu__0EB197640EC6A590] PRIMARY KEY CLUSTERED 
(
	[CraftBlueprintCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CraftBlueprints]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[CraftBlueprints](
	[CraftBlueprintID] [bigint] NOT NULL,
	[CraftCategoryID] [bigint] NOT NULL,
	[BaseLevel] [int] NOT NULL,
	[ItemName] [nvarchar](64) NOT NULL,
	[ItemResref] [nvarchar](16) NOT NULL,
	[Quantity] [int] NOT NULL,
	[SkillID] [int] NOT NULL,
	[CraftDeviceID] [int] NOT NULL,
	[PerkID] [int] NULL,
	[RequiredPerkLevel] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[MainComponentTypeID] [int] NOT NULL,
	[MainMinimum] [int] NOT NULL,
	[SecondaryComponentTypeID] [int] NOT NULL,
	[SecondaryMinimum] [int] NOT NULL,
	[TertiaryComponentTypeID] [int] NOT NULL,
	[TertiaryMinimum] [int] NOT NULL,
	[EnhancementSlots] [int] NOT NULL,
	[MainMaximum] [int] NOT NULL,
	[SecondaryMaximum] [int] NOT NULL,
	[TertiaryMaximum] [int] NOT NULL,
	[BaseStructureID] [int] NULL,
 CONSTRAINT [PK__CraftBlu__DE6FED170EBF2383] PRIMARY KEY CLUSTERED 
(
	[CraftBlueprintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CraftDevices]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[CraftDevices](
	[CraftDeviceID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK__CraftDev__5CCBD473CCCE6D67] PRIMARY KEY CLUSTERED 
(
	[CraftDeviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomEffects]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[CustomEffects](
	[CustomEffectID] [bigint] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[IconID] [int] NOT NULL,
	[ScriptHandler] [nvarchar](64) NOT NULL,
	[StartMessage] [nvarchar](64) NOT NULL,
	[ContinueMessage] [nvarchar](64) NOT NULL,
	[WornOffMessage] [nvarchar](64) NOT NULL,
	[IsStance] [bit] NOT NULL,
 CONSTRAINT [PK__CustomEf__18502FBA6D986D4A] PRIMARY KEY CLUSTERED 
(
	[CustomEffectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatabaseVersions]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[DatabaseVersions](
	[DatabaseVersionID] [int] IDENTITY(1,1) NOT NULL,
	[ScriptName] [nvarchar](100) NOT NULL,
	[DateApplied] [datetime2](7) NOT NULL,
	[VersionDate] [datetime2](7) NOT NULL,
	[VersionNumber] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DatabaseVersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiscordChatQueue]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[DiscordChatQueue](
	[DiscordChatQueueID] [int] IDENTITY(1,1) NOT NULL,
	[SenderName] [nvarchar](255) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[DateSent] [datetime2](7) NOT NULL,
	[DatePosted] [datetime2](7) NULL,
	[DateForRetry] [datetime2](7) NULL,
	[ResponseContent] [nvarchar](max) NULL,
	[RetryAttempts] [int] NOT NULL,
	[SenderAccountName] [nvarchar](1024) NOT NULL,
	[SenderCDKey] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DiscordChatQueueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DMRoleDomain]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[DMRoleDomain](
	[DMRoleDomainID] [int] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__DMRoleDo__1EB081302A5E9C2F] PRIMARY KEY CLUSTERED 
(
	[DMRoleDomainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Downloads]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[Downloads](
	[DownloadID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[Url] [nvarchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Downloads_DownloadID] PRIMARY KEY CLUSTERED 
(
	[DownloadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnmityAdjustmentRule]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[EnmityAdjustmentRule](
	[EnmityAdjustmentRuleID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EnmityAdjustmentRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FameRegions]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[FameRegions](
	[FameRegionID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
 CONSTRAINT [QuestFameRegions_FameRegionID] PRIMARY KEY CLUSTERED 
(
	[FameRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameTopicCategories]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[GameTopicCategories](
	[GameTopicCategoryID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[GameTopicCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameTopics]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[GameTopics](
	[GameTopicID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[GameTopicCategoryID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Sequence] [int] NOT NULL,
	[Icon] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[GameTopicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GrowingPlants]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[GrowingPlants](
	[GrowingPlantID] [int] IDENTITY(1,1) NOT NULL,
	[PlantID] [int] NOT NULL,
	[RemainingTicks] [int] NOT NULL,
	[LocationAreaTag] [nvarchar](64) NOT NULL,
	[LocationX] [float] NOT NULL,
	[LocationY] [float] NOT NULL,
	[LocationZ] [float] NOT NULL,
	[LocationOrientation] [float] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[TotalTicks] [int] NOT NULL,
	[WaterStatus] [int] NOT NULL,
	[LongevityBonus] [int] NOT NULL,
 CONSTRAINT [PK__GrowingP__807B119175152584] PRIMARY KEY CLUSTERED 
(
	[GrowingPlantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemTypes]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[ItemTypes](
	[ItemTypeID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK__ItemType__F51540DB3DC6DAE5] PRIMARY KEY CLUSTERED 
(
	[ItemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KeyItemCategories]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[KeyItemCategories](
	[KeyItemCategoryID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__KeyItemC__CD3A52E2821EBDCD] PRIMARY KEY CLUSTERED 
(
	[KeyItemCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KeyItems]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[KeyItems](
	[KeyItemID] [int] NOT NULL,
	[KeyItemCategoryID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK__KeyItems__95F54E1C55214D3E] PRIMARY KEY CLUSTERED 
(
	[KeyItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LootTableItems]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[LootTableItems](
	[LootTableItemID] [int] IDENTITY(1,1) NOT NULL,
	[LootTableID] [int] NOT NULL,
	[Resref] [varchar](16) NOT NULL,
	[MaxQuantity] [int] NOT NULL,
	[Weight] [tinyint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[SpawnRule] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK__LootTabl__E0F42FED5CB8C330] PRIMARY KEY CLUSTERED 
(
	[LootTableItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LootTables]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[LootTables](
	[LootTableID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK__LootTabl__0DD0313424EBFFBF] PRIMARY KEY CLUSTERED 
(
	[LootTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mods]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[Mods](
	[ModID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Script] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ModID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NPCGroups]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[NPCGroups](
	[NPCGroupID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_NPCGroups_NPCGroupID] PRIMARY KEY CLUSTERED 
(
	[NPCGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCBasePermissions]    Script Date: 10/22/2018 1:38:09 AM ******/

CREATE TABLE [dbo].[PCBasePermissions](
	[PCBasePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PCBaseID] [int] NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[CanPlaceEditStructures] [bit] NOT NULL,
	[CanAccessStructureInventory] [bit] NOT NULL,
	[CanManageBaseFuel] [bit] NOT NULL,
	[CanExtendLease] [bit] NOT NULL,
	[CanAdjustPermissions] [bit] NOT NULL,
	[CanEnterBuildings] [bit] NOT NULL,
	[CanRetrieveStructures] [bit] NOT NULL,
	[CanCancelLease] [bit] NOT NULL,
	[CanRenameStructures] [bit] NOT NULL,
	[CanEditPrimaryResidence] [bit] NOT NULL,
	[CanRemovePrimaryResidence] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCBasePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCBases]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCBases](
	[PCBaseID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[AreaResref] [nvarchar](16) NOT NULL,
	[Sector] [char](2) NOT NULL,
	[DateInitialPurchase] [datetime2](7) NOT NULL,
	[DateRentDue] [datetime2](7) NOT NULL,
	[ShieldHP] [int] NOT NULL,
	[IsInReinforcedMode] [bit] NOT NULL,
	[Fuel] [int] NOT NULL,
	[ReinforcedFuel] [int] NOT NULL,
	[DateFuelEnds] [datetime2](7) NOT NULL,
	[PCBaseTypeID] [int] NOT NULL,
	[ApartmentBuildingID] [int] NULL,
	[CustomName] [nvarchar](64) NOT NULL,
	[BuildingStyleID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PCBaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCBaseStructureItems]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCBaseStructureItems](
	[PCBaseStructureItemID] [int] IDENTITY(1,1) NOT NULL,
	[PCBaseStructureID] [int] NOT NULL,
	[ItemGlobalID] [nvarchar](60) NOT NULL,
	[ItemName] [nvarchar](max) NOT NULL,
	[ItemTag] [nvarchar](64) NOT NULL,
	[ItemResref] [nvarchar](16) NOT NULL,
	[ItemObject] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCBaseStructureItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCBaseStructurePermissions]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCBaseStructurePermissions](
	[PCBaseStructurePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PCBaseStructureID] [int] NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[CanPlaceEditStructures] [bit] NOT NULL,
	[CanAccessStructureInventory] [bit] NOT NULL,
	[CanEnterBuilding] [bit] NOT NULL,
	[CanRetrieveStructures] [bit] NOT NULL,
	[CanAdjustPermissions] [bit] NOT NULL,
	[CanRenameStructures] [bit] NOT NULL,
	[CanEditPrimaryResidence] [bit] NOT NULL,
	[CanRemovePrimaryResidence] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCBaseStructurePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCBaseStructures]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCBaseStructures](
	[PCBaseStructureID] [int] IDENTITY(1,1) NOT NULL,
	[PCBaseID] [int] NOT NULL,
	[BaseStructureID] [int] NOT NULL,
	[LocationX] [float] NOT NULL,
	[LocationY] [float] NOT NULL,
	[LocationZ] [float] NOT NULL,
	[LocationOrientation] [float] NOT NULL,
	[Durability] [float] NOT NULL,
	[InteriorStyleID] [int] NULL,
	[ExteriorStyleID] [int] NULL,
	[ParentPCBaseStructureID] [int] NULL,
	[CustomName] [nvarchar](64) NOT NULL,
	[StructureBonus] [int] NOT NULL,
	[DateNextActivity] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[PCBaseStructureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCBaseTypes]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCBaseTypes](
	[PCBaseTypeID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCBaseTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCCooldowns]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCCooldowns](
	[PCCooldownID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[CooldownCategoryID] [int] NOT NULL,
	[DateUnlocked] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__PCCooldo__61BCE64547547BE9] PRIMARY KEY CLUSTERED 
(
	[PCCooldownID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCCraftedBlueprints]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCCraftedBlueprints](
	[PCCraftedBlueprintID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[CraftBlueprintID] [bigint] NOT NULL,
	[DateFirstCrafted] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCCraftedBlueprintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCCustomEffects]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCCustomEffects](
	[PCCustomEffectID] [bigint] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[CustomEffectID] [bigint] NOT NULL,
	[Ticks] [int] NOT NULL,
	[EffectiveLevel] [int] NOT NULL,
	[Data] [nvarchar](32) NOT NULL,
	[CasterNWNObjectID] [nvarchar](10) NOT NULL,
	[StancePerkID] [int] NULL,
 CONSTRAINT [PK__PCCustom__40F2132E1A5F30A2] PRIMARY KEY CLUSTERED 
(
	[PCCustomEffectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCImpoundedItems]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCImpoundedItems](
	[PCImpoundedItemID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[ItemName] [nvarchar](64) NOT NULL,
	[ItemTag] [nvarchar](32) NOT NULL,
	[ItemResref] [nvarchar](16) NOT NULL,
	[ItemObject] [nvarchar](max) NOT NULL,
	[DateImpounded] [datetime2](7) NOT NULL,
	[DateRetrieved] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[PCImpoundedItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCKeyItems]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCKeyItems](
	[PCKeyItemID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[KeyItemID] [int] NOT NULL,
	[AcquiredDate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK__PCKeyIte__36A246562715831F] PRIMARY KEY CLUSTERED 
(
	[PCKeyItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCMapPins]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCMapPins](
	[PCMapPinID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[AreaTag] [nvarchar](32) NOT NULL,
	[PositionX] [float] NOT NULL,
	[PositionY] [float] NOT NULL,
	[NoteText] [nvarchar](1024) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCMapPinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCMapProgression]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCMapProgression](
	[PCMapProgressionID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[AreaResref] [nvarchar](16) NOT NULL,
	[Progression] [nvarchar](1024) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCMapProgressionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCMigrationItems]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCMigrationItems](
	[PCMigrationItemID] [int] NOT NULL,
	[PCMigrationID] [int] NOT NULL,
	[CurrentResref] [nvarchar](16) NOT NULL,
	[NewResref] [nvarchar](16) NOT NULL,
	[StripItemProperties] [bit] NOT NULL,
	[BaseItemTypeID] [int] NOT NULL,
 CONSTRAINT [PK__PCMigrat__853DDE73AB544BB1] PRIMARY KEY CLUSTERED 
(
	[PCMigrationItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCMigrations]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCMigrations](
	[PCMigrationID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK__PCMigrat__3A08DA1F3966E5FE] PRIMARY KEY CLUSTERED 
(
	[PCMigrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCObjectVisibility]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCObjectVisibility](
	[PCObjectVisibilityID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[VisibilityObjectID] [nvarchar](60) NOT NULL,
	[IsVisible] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCObjectVisibilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCOutfits]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCOutfits](
	[PlayerID] [nvarchar](60) NOT NULL,
	[Outfit1] [varchar](max) NULL,
	[Outfit2] [varchar](max) NULL,
	[Outfit3] [varchar](max) NULL,
	[Outfit4] [varchar](max) NULL,
	[Outfit5] [varchar](max) NULL,
	[Outfit6] [varchar](max) NULL,
	[Outfit7] [varchar](max) NULL,
	[Outfit8] [varchar](max) NULL,
	[Outfit9] [varchar](max) NULL,
	[Outfit10] [varchar](max) NULL,
 CONSTRAINT [PK__PCOutfit__4A4E74A8B41DD37A] PRIMARY KEY CLUSTERED 
(
	[PlayerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCOverflowItems]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCOverflowItems](
	[PCOverflowItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[ItemName] [nvarchar](max) NOT NULL,
	[ItemTag] [nvarchar](64) NOT NULL,
	[ItemResref] [nvarchar](16) NOT NULL,
	[ItemObject] [varchar](max) NULL,
 CONSTRAINT [PK__PCOverfl__F923885539F635E2] PRIMARY KEY CLUSTERED 
(
	[PCOverflowItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCPerkRefunds]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCPerkRefunds](
	[PCPerkRefundID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[PerkID] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[DateAcquired] [datetime2](7) NOT NULL,
	[DateRefunded] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCPerkRefundID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCQuestItemProgress]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCQuestItemProgress](
	[PCQuestItemProgressID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[PCQuestStatusID] [int] NOT NULL,
	[Resref] [nvarchar](16) NOT NULL,
	[Remaining] [int] NOT NULL,
	[MustBeCraftedByPlayer] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCQuestItemProgressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCQuestKillTargetProgress]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCQuestKillTargetProgress](
	[PCQuestKillTargetProgressID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[PCQuestStatusID] [int] NOT NULL,
	[NPCGroupID] [int] NOT NULL,
	[RemainingToKill] [int] NOT NULL,
 CONSTRAINT [PK_PCQuestKillTargetProgress_PCQuestKillTargetProgressID] PRIMARY KEY CLUSTERED 
(
	[PCQuestKillTargetProgressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCQuestStatus]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCQuestStatus](
	[PCQuestStatusID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[QuestID] [int] NOT NULL,
	[CurrentQuestStateID] [int] NOT NULL,
	[CompletionDate] [datetime2](7) NULL,
	[SelectedItemRewardID] [int] NULL,
 CONSTRAINT [PK_PCQuestStatus_PCQuestStatusID] PRIMARY KEY CLUSTERED 
(
	[PCQuestStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCRegionalFame]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCRegionalFame](
	[PCRegionalFameID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[FameRegionID] [int] NOT NULL,
	[Amount] [int] NOT NULL,
 CONSTRAINT [PK_PCRegionalFame_PCRegionalFameID] PRIMARY KEY CLUSTERED 
(
	[PCRegionalFameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCSearchSiteItems]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCSearchSiteItems](
	[PCSearchSiteItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[SearchSiteID] [int] NOT NULL,
	[SearchItem] [varchar](max) NULL,
 CONSTRAINT [PK__PCSearch__001EF3E36436B4F3] PRIMARY KEY CLUSTERED 
(
	[PCSearchSiteItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCSearchSites]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PCSearchSites](
	[PCSearchSiteID] [int] IDENTITY(1,1) NOT NULL,
	[PlayerID] [nvarchar](60) NOT NULL,
	[SearchSiteID] [int] NOT NULL,
	[UnlockDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK__PCSearch__B988F45255B968F1] PRIMARY KEY CLUSTERED 
(
	[PCSearchSiteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PerkCategories]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PerkCategories](
	[PerkCategoryID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Sequence] [int] NOT NULL,
 CONSTRAINT [PK__PerkCate__9777DCFC136BDCB4] PRIMARY KEY CLUSTERED 
(
	[PerkCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PerkExecutionTypes]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PerkExecutionTypes](
	[PerkExecutionTypeID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK__PerkExec__8133420289767A5A] PRIMARY KEY CLUSTERED 
(
	[PerkExecutionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PerkLevelQuestRequirements]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[PerkLevelQuestRequirements](
	[PerkLevelQuestRequirementID] [int] IDENTITY(1,1) NOT NULL,
	[PerkLevelID] [int] NOT NULL,
	[RequiredQuestID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PerkLevelQuestRequirementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Perks]    Script Date: 10/22/2018 1:38:10 AM ******/

CREATE TABLE [dbo].[Perks](
	[PerkID] [int] NOT NULL,
	[Name] [varchar](64) NOT NULL,
	[FeatID] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[ScriptName] [varchar](64) NOT NULL,
	[BaseFPCost] [int] NOT NULL,
	[BaseCastingTime] [float] NOT NULL,
	[Description] [nvarchar](256) NOT NULL,
	[PerkCategoryID] [int] NOT NULL,
	[CooldownCategoryID] [int] NULL,
	[ExecutionTypeID] [int] NOT NULL,
	[ItemResref] [nvarchar](16) NULL,
	[IsTargetSelfOnly] [bit] NOT NULL,
	[Enmity] [int] NOT NULL,
	[EnmityAdjustmentRuleID] [int] NOT NULL,
	[CastAnimationID] [int] NULL,
 CONSTRAINT [PK__Perks__2432566E1A11FD39] PRIMARY KEY CLUSTERED 
(
	[PerkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Plants]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[Plants](
	[PlantID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[BaseTicks] [int] NOT NULL,
	[Resref] [nvarchar](16) NOT NULL,
	[WaterTicks] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[SeedResref] [nvarchar](16) NOT NULL,
 CONSTRAINT [PK__Plants__98FE46BC83E7C439] PRIMARY KEY CLUSTERED 
(
	[PlantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlayerCharacters]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[PlayerCharacters](
	[PlayerID] [nvarchar](60) NOT NULL,
	[CharacterName] [nvarchar](max) NULL,
	[HitPoints] [int] NOT NULL,
	[LocationAreaResref] [nvarchar](16) NULL,
	[LocationX] [float] NOT NULL,
	[LocationY] [float] NOT NULL,
	[LocationZ] [float] NOT NULL,
	[LocationOrientation] [float] NOT NULL,
	[CreateTimestamp] [datetime2](0) NOT NULL,
	[UnallocatedSP] [int] NOT NULL,
	[HPRegenerationAmount] [int] NOT NULL,
	[RegenerationTick] [int] NOT NULL,
	[RegenerationRate] [int] NOT NULL,
	[VersionNumber] [int] NOT NULL,
	[MaxFP] [int] NOT NULL,
	[CurrentFP] [int] NOT NULL,
	[CurrentFPTick] [int] NOT NULL,
	[RespawnAreaResref] [nvarchar](16) NULL,
	[RespawnLocationX] [float] NOT NULL,
	[RespawnLocationY] [float] NOT NULL,
	[RespawnLocationZ] [float] NOT NULL,
	[RespawnLocationOrientation] [float] NOT NULL,
	[DateSanctuaryEnds] [datetime2](7) NOT NULL,
	[IsSanctuaryOverrideEnabled] [bit] NOT NULL,
	[STRBase] [int] NOT NULL,
	[DEXBase] [int] NOT NULL,
	[CONBase] [int] NOT NULL,
	[INTBase] [int] NOT NULL,
	[WISBase] [int] NOT NULL,
	[CHABase] [int] NOT NULL,
	[TotalSPAcquired] [int] NOT NULL,
	[DisplayHelmet] [bit] NOT NULL,
	[PrimaryResidencePCBaseStructureID] [int] NULL,
	[DatePerkRefundAvailable] [datetime2](7) NULL,
	[AssociationID] [int] NOT NULL,
	[DisplayHolonet] [bit] NOT NULL,
	[DisplayDiscord] [bit] NOT NULL,
	[PrimaryResidencePCBaseID] [int] NULL,
 CONSTRAINT [PK__PlayerCh__4A4E74A8046BDEBE] PRIMARY KEY CLUSTERED 
(
	[PlayerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestKillTargetList]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[QuestKillTargetList](
	[QuestKillTargetListID] [int] IDENTITY(1,1) NOT NULL,
	[QuestID] [int] NOT NULL,
	[NPCGroupID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[QuestStateID] [int] NOT NULL,
 CONSTRAINT [PK_QuestKillTargetList_QuestKillTargetListID] PRIMARY KEY CLUSTERED 
(
	[QuestKillTargetListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestPrerequisites]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[QuestPrerequisites](
	[QuestPrerequisiteID] [int] IDENTITY(1,1) NOT NULL,
	[QuestID] [int] NOT NULL,
	[RequiredQuestID] [int] NOT NULL,
 CONSTRAINT [PK_QuestPreqrequisites_QuestPrerequisiteID] PRIMARY KEY CLUSTERED 
(
	[QuestPrerequisiteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestRequiredItemList]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[QuestRequiredItemList](
	[QuestRequiredItemListID] [int] IDENTITY(1,1) NOT NULL,
	[QuestID] [int] NOT NULL,
	[Resref] [nvarchar](16) NOT NULL,
	[Quantity] [int] NOT NULL,
	[QuestStateID] [int] NOT NULL,
	[MustBeCraftedByPlayer] [bit] NOT NULL,
 CONSTRAINT [PK_QuestRequiredItemList_QuestRequiredItemListID] PRIMARY KEY CLUSTERED 
(
	[QuestRequiredItemListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestRequiredKeyItemList]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[QuestRequiredKeyItemList](
	[QuestRequiredKeyItemID] [int] IDENTITY(1,1) NOT NULL,
	[QuestID] [int] NOT NULL,
	[KeyItemID] [int] NOT NULL,
	[QuestStateID] [int] NOT NULL,
 CONSTRAINT [PK_QuestRequiredKeyItemList_QuestRequiredKeyItemID] PRIMARY KEY CLUSTERED 
(
	[QuestRequiredKeyItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestRewardItems]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[QuestRewardItems](
	[QuestRewardItemID] [int] IDENTITY(1,1) NOT NULL,
	[QuestID] [int] NOT NULL,
	[Resref] [nvarchar](16) NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_QuestRewards_QuestRewardID] PRIMARY KEY CLUSTERED 
(
	[QuestRewardItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Quests]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[Quests](
	[QuestID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[JournalTag] [nvarchar](32) NOT NULL,
	[FameRegionID] [int] NOT NULL,
	[RequiredFameAmount] [int] NOT NULL,
	[AllowRewardSelection] [bit] NOT NULL,
	[RewardGold] [int] NOT NULL,
	[RewardKeyItemID] [int] NULL,
	[RewardFame] [int] NOT NULL,
	[IsRepeatable] [bit] NOT NULL,
	[MapNoteTag] [nvarchar](32) NOT NULL,
	[StartKeyItemID] [int] NULL,
	[RemoveStartKeyItemAfterCompletion] [bit] NOT NULL,
	[OnAcceptRule] [nvarchar](32) NOT NULL,
	[OnAdvanceRule] [nvarchar](32) NOT NULL,
	[OnCompleteRule] [nvarchar](32) NOT NULL,
	[OnKillTargetRule] [nvarchar](32) NOT NULL,
	[OnAcceptArgs] [nvarchar](256) NOT NULL,
	[OnAdvanceArgs] [nvarchar](256) NOT NULL,
	[OnCompleteArgs] [nvarchar](256) NOT NULL,
	[OnKillTargetArgs] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Quests_QuestID] PRIMARY KEY CLUSTERED 
(
	[QuestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestStates]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[QuestStates](
	[QuestStateID] [int] IDENTITY(1,1) NOT NULL,
	[QuestID] [int] NOT NULL,
	[Sequence] [int] NOT NULL,
	[QuestTypeID] [int] NOT NULL,
	[JournalStateID] [int] NOT NULL,
 CONSTRAINT [PK_QuestStates_QuestStateID] PRIMARY KEY CLUSTERED 
(
	[QuestStateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestTypeDomain]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[QuestTypeDomain](
	[QuestTypeID] [int] NOT NULL,
	[Name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_QuestTypeDomain_QuestTypeID] PRIMARY KEY CLUSTERED 
(
	[QuestTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServerConfiguration]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[ServerConfiguration](
	[ServerConfigurationID] [int] NOT NULL,
	[ServerName] [varchar](50) NOT NULL,
	[MessageOfTheDay] [varchar](1024) NOT NULL,
	[AreaBakeStep] [int] NOT NULL,
 CONSTRAINT [PK__ServerCo__90C495B665B9B563] PRIMARY KEY CLUSTERED 
(
	[ServerConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SkillCategories]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[SkillCategories](
	[SkillCategoryID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Sequence] [int] NOT NULL,
 CONSTRAINT [PK__SkillCat__D2A5F8BCCC134052] PRIMARY KEY CLUSTERED 
(
	[SkillCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Skills]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[Skills](
	[SkillID] [int] NOT NULL,
	[SkillCategoryID] [int] NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[MaxRank] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[Primary] [int] NOT NULL,
	[Secondary] [int] NOT NULL,
	[Tertiary] [int] NOT NULL,
	[ContributesToSkillCap] [bit] NOT NULL,
 CONSTRAINT [PK__Skills__DFA091E736021CE5] PRIMARY KEY CLUSTERED 
(
	[SkillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SkillXPRequirement]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[SkillXPRequirement](
	[SkillXPRequirementID] [int] IDENTITY(1,1) NOT NULL,
	[SkillID] [int] NOT NULL,
	[Rank] [int] NOT NULL,
	[XP] [int] NOT NULL,
 CONSTRAINT [PK__SkillXPR__A06512642D848122] PRIMARY KEY CLUSTERED 
(
	[SkillXPRequirementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpawnObjects]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[SpawnObjects](
	[SpawnObjectID] [int] IDENTITY(1,1) NOT NULL,
	[SpawnID] [int] NOT NULL,
	[Resref] [nvarchar](16) NOT NULL,
	[Weight] [int] NOT NULL,
	[SpawnRule] [nvarchar](32) NOT NULL,
	[NPCGroupID] [int] NULL,
	[BehaviourScript] [nvarchar](64) NOT NULL,
	[DeathVFXID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SpawnObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpawnObjectType]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[SpawnObjectType](
	[SpawnObjectTypeID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SpawnObjectTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Spawns]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[Spawns](
	[SpawnID] [int] NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[SpawnObjectTypeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SpawnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 10/22/2018 1:38:11 AM ******/

CREATE TABLE [dbo].[Users](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[DiscordUserID] [nvarchar](max) NOT NULL,
	[Username] [nvarchar](32) NOT NULL,
	[AvatarHash] [nvarchar](max) NOT NULL,
	[Discriminator] [nvarchar](4) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[RoleID] [int] NOT NULL,
	[DateRegistered] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__Users__1788CCAC642F36E9] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [ResourceSpawnTableID]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [IsBuildable]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [PurchasePrice]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [DailyUpkeep]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT (getutcdate()) FOR [DateLastBaked]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [AutoSpawnResources]
GO
ALTER TABLE [dbo].[Areas] ADD  DEFAULT ((0)) FOR [ResourceQuality]
GO
ALTER TABLE [dbo].[Attributes] ADD  CONSTRAINT [DF__Attribute__NWNVa__56E8E7AB]  DEFAULT ((0)) FOR [NWNValue]
GO
ALTER TABLE [dbo].[Attributes] ADD  CONSTRAINT [DF__Attributes__Name__57DD0BE4]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Backgrounds] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Backgrounds] ADD  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Backgrounds] ADD  DEFAULT ('') FOR [Bonuses]
GO
ALTER TABLE [dbo].[Backgrounds] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BankItems] ADD  DEFAULT (getutcdate()) FOR [DateStored]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ('') FOR [PlaceableResref]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ('') FOR [ItemResref]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0.0)) FOR [Power]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0.0)) FOR [CPU]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0.0)) FOR [Durability]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0)) FOR [Storage]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0)) FOR [HasAtmosphere]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0)) FOR [ReinforcedStorage]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0)) FOR [RequiresBasePower]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0)) FOR [ResourceStorage]
GO
ALTER TABLE [dbo].[BaseStructures] ADD  DEFAULT ((0)) FOR [RetrievalRating]
GO
ALTER TABLE [dbo].[BaseStructureType] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[BaseStructureType] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BaseStructureType] ADD  DEFAULT ((0)) FOR [CanPlaceInside]
GO
ALTER TABLE [dbo].[BaseStructureType] ADD  DEFAULT ((0)) FOR [CanPlaceOutside]
GO
ALTER TABLE [dbo].[BugReports] ADD  DEFAULT (getutcdate()) FOR [DateSubmitted]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ('') FOR [Resref]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ('') FOR [DoorRule]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ((0)) FOR [PurchasePrice]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ((0)) FOR [DailyUpkeep]
GO
ALTER TABLE [dbo].[BuildingStyles] ADD  DEFAULT ((0)) FOR [FurnitureLimit]
GO
ALTER TABLE [dbo].[ChatChannelsDomain] ADD  CONSTRAINT [DF__ChatChanne__Name__58D1301D]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[ChatLog] ADD  CONSTRAINT [DF__ChatLog__SenderA__59C55456]  DEFAULT ('') FOR [SenderAccountName]
GO
ALTER TABLE [dbo].[ChatLog] ADD  CONSTRAINT [DF__ChatLog__SenderC__5AB9788F]  DEFAULT ('') FOR [SenderCDKey]
GO
ALTER TABLE [dbo].[ChatLog] ADD  CONSTRAINT [DF__ChatLog__Message__5BAD9CC8]  DEFAULT ('') FOR [Message]
GO
ALTER TABLE [dbo].[ChatLog] ADD  CONSTRAINT [DF__ChatLog__DateSen__5CA1C101]  DEFAULT (getutcdate()) FOR [DateSent]
GO
ALTER TABLE [dbo].[ClientLogEvents] ADD  CONSTRAINT [DF__ClientLog__DateO__5D95E53A]  DEFAULT (getutcdate()) FOR [DateOfEvent]
GO
ALTER TABLE [dbo].[ComponentTypes] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[CooldownCategories] ADD  CONSTRAINT [DF__CooldownCa__Name__5F7E2DAC]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[CooldownCategories] ADD  CONSTRAINT [DF__CooldownC__BaseC__607251E5]  DEFAULT ((0.0)) FOR [BaseCooldownTime]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  CONSTRAINT [DF__CraftBlue__Requi__6166761E]  DEFAULT ((0)) FOR [RequiredPerkLevel]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  CONSTRAINT [DF__CraftBlue__IsAct__625A9A57]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [MainComponentTypeID]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [MainMinimum]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [SecondaryComponentTypeID]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [SecondaryMinimum]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [TertiaryComponentTypeID]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [TertiaryMinimum]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [EnhancementSlots]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [MainMaximum]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [SecondaryMaximum]
GO
ALTER TABLE [dbo].[CraftBlueprints] ADD  DEFAULT ((0)) FOR [TertiaryMaximum]
GO
ALTER TABLE [dbo].[CraftDevices] ADD  CONSTRAINT [DF__CraftDevic__Name__6442E2C9]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[CustomEffects] ADD  DEFAULT ((0)) FOR [IsStance]
GO
ALTER TABLE [dbo].[DatabaseVersions] ADD  DEFAULT ('') FOR [ScriptName]
GO
ALTER TABLE [dbo].[DatabaseVersions] ADD  DEFAULT (getutcdate()) FOR [DateApplied]
GO
ALTER TABLE [dbo].[DiscordChatQueue] ADD  DEFAULT ('') FOR [Message]
GO
ALTER TABLE [dbo].[DiscordChatQueue] ADD  DEFAULT (getutcdate()) FOR [DateSent]
GO
ALTER TABLE [dbo].[DiscordChatQueue] ADD  DEFAULT ((0)) FOR [RetryAttempts]
GO
ALTER TABLE [dbo].[DiscordChatQueue] ADD  DEFAULT ('') FOR [SenderAccountName]
GO
ALTER TABLE [dbo].[DiscordChatQueue] ADD  DEFAULT ('') FOR [SenderCDKey]
GO
ALTER TABLE [dbo].[Downloads] ADD  CONSTRAINT [DF__Downloads__Name__65370702]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Downloads] ADD  CONSTRAINT [DF__Downloads__Descr__662B2B3B]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Downloads] ADD  CONSTRAINT [DF__Downloads__Url__671F4F74]  DEFAULT ('') FOR [Url]
GO
ALTER TABLE [dbo].[Downloads] ADD  CONSTRAINT [DF__Downloads__IsAct__681373AD]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[EnmityAdjustmentRule] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[GameTopics] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[GameTopics] ADD  DEFAULT ((0)) FOR [Sequence]
GO
ALTER TABLE [dbo].[GameTopics] ADD  DEFAULT ('') FOR [Icon]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [DF__GrowingPl__Remai__690797E6]  DEFAULT ((0)) FOR [RemainingTicks]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [DF__GrowingPl__Locat__69FBBC1F]  DEFAULT ('') FOR [LocationAreaTag]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [df_GrowingPlants_LocationX]  DEFAULT ((0.0)) FOR [LocationX]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [df_GrowingPlants_LocationY]  DEFAULT ((0.0)) FOR [LocationY]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [df_GrowingPlants_LocationZ]  DEFAULT ((0.0)) FOR [LocationZ]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [df_GrowingPlants_LocationOrientation]  DEFAULT ((0.0)) FOR [LocationOrientation]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [DF__GrowingPl__DateC__6EC0713C]  DEFAULT (getutcdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [DF__GrowingPl__IsAct__6FB49575]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [DF__GrowingPl__Total__7869D707]  DEFAULT ((0)) FOR [TotalTicks]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [DF__GrowingPl__Water__7B4643B2]  DEFAULT ((0)) FOR [WaterStatus]
GO
ALTER TABLE [dbo].[GrowingPlants] ADD  CONSTRAINT [DF__GrowingPl__Longe__7C3A67EB]  DEFAULT ((0)) FOR [LongevityBonus]
GO
ALTER TABLE [dbo].[ItemTypes] ADD  CONSTRAINT [DF__ItemTypes__Name__7E02B4CC]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[LootTableItems] ADD  DEFAULT ('') FOR [SpawnRule]
GO
ALTER TABLE [dbo].[Mods] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Mods] ADD  DEFAULT ('') FOR [Script]
GO
ALTER TABLE [dbo].[Mods] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanPlaceEditStructures]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanAccessStructureInventory]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanManageBaseFuel]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanExtendLease]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanAdjustPermissions]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanEnterBuildings]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanRetrieveStructures]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanCancelLease]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanRenameStructures]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanEditPrimaryResidence]
GO
ALTER TABLE [dbo].[PCBasePermissions] ADD  DEFAULT ((0)) FOR [CanRemovePrimaryResidence]
GO
ALTER TABLE [dbo].[PCBases] ADD  DEFAULT (getutcdate()) FOR [DateInitialPurchase]
GO
ALTER TABLE [dbo].[PCBases] ADD  DEFAULT ((0)) FOR [ShieldHP]
GO
ALTER TABLE [dbo].[PCBases] ADD  DEFAULT ((0)) FOR [IsInReinforcedMode]
GO
ALTER TABLE [dbo].[PCBases] ADD  DEFAULT ((0)) FOR [Fuel]
GO
ALTER TABLE [dbo].[PCBases] ADD  DEFAULT ((0)) FOR [ReinforcedFuel]
GO
ALTER TABLE [dbo].[PCBases] ADD  DEFAULT (getutcdate()) FOR [DateFuelEnds]
GO
ALTER TABLE [dbo].[PCBases] ADD  DEFAULT ('') FOR [CustomName]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanPlaceEditStructures]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanAccessStructureInventory]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanEnterBuilding]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanRetrieveStructures]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanAdjustPermissions]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanRenameStructures]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanEditPrimaryResidence]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] ADD  DEFAULT ((0)) FOR [CanRemovePrimaryResidence]
GO
ALTER TABLE [dbo].[PCBaseStructures] ADD  DEFAULT ((0.0)) FOR [Durability]
GO
ALTER TABLE [dbo].[PCBaseStructures] ADD  DEFAULT ('') FOR [CustomName]
GO
ALTER TABLE [dbo].[PCBaseStructures] ADD  DEFAULT ((0)) FOR [StructureBonus]
GO
ALTER TABLE [dbo].[PCCraftedBlueprints] ADD  DEFAULT (getutcdate()) FOR [DateFirstCrafted]
GO
ALTER TABLE [dbo].[PCCustomEffects] ADD  DEFAULT ((0)) FOR [EffectiveLevel]
GO
ALTER TABLE [dbo].[PCCustomEffects] ADD  DEFAULT ('') FOR [Data]
GO
ALTER TABLE [dbo].[PCCustomEffects] ADD  DEFAULT ('') FOR [CasterNWNObjectID]
GO
ALTER TABLE [dbo].[PCImpoundedItems] ADD  DEFAULT (getutcdate()) FOR [DateImpounded]
GO
ALTER TABLE [dbo].[PCKeyItems] ADD  CONSTRAINT [df_PCKeyItems_AcquiredDate]  DEFAULT (getutcdate()) FOR [AcquiredDate]
GO
ALTER TABLE [dbo].[PCObjectVisibility] ADD  DEFAULT ((0)) FOR [IsVisible]
GO
ALTER TABLE [dbo].[PCPerkRefunds] ADD  DEFAULT (getutcdate()) FOR [DateRefunded]
GO
ALTER TABLE [dbo].[PCPerks] ADD  CONSTRAINT [DF__PCPerks__Acquire__7FEAFD3E]  DEFAULT (getutcdate()) FOR [AcquiredDate]
GO
ALTER TABLE [dbo].[PCPerks] ADD  CONSTRAINT [DF__PCPerks__PerkLev__00DF2177]  DEFAULT ((0)) FOR [PerkLevel]
GO
ALTER TABLE [dbo].[PCQuestItemProgress] ADD  DEFAULT ((0)) FOR [Remaining]
GO
ALTER TABLE [dbo].[PCQuestItemProgress] ADD  DEFAULT ((0)) FOR [MustBeCraftedByPlayer]
GO
ALTER TABLE [dbo].[PCRegionalFame] ADD  CONSTRAINT [DF__PCRegiona__Amoun__01D345B0]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[PCSkills] ADD  CONSTRAINT [DF__PCSkills__XP__02C769E9]  DEFAULT ((0)) FOR [XP]
GO
ALTER TABLE [dbo].[PCSkills] ADD  CONSTRAINT [DF__PCSkills__Rank__03BB8E22]  DEFAULT ((0)) FOR [Rank]
GO
ALTER TABLE [dbo].[PCSkills] ADD  CONSTRAINT [DF__PCSkills__IsLock__04AFB25B]  DEFAULT ((0)) FOR [IsLocked]
GO
ALTER TABLE [dbo].[PerkCategories] ADD  CONSTRAINT [DF__PerkCatego__Name__078C1F06]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[PerkCategories] ADD  CONSTRAINT [DF__PerkCateg__IsAct__0880433F]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PerkCategories] ADD  CONSTRAINT [DF__PerkCateg__Seque__09746778]  DEFAULT ((0)) FOR [Sequence]
GO
ALTER TABLE [dbo].[PerkExecutionTypes] ADD  CONSTRAINT [DF__PerkExecut__Name__0A688BB1]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[PerkLevels] ADD  CONSTRAINT [DF__PerkLevel__Level__0B5CAFEA]  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[PerkLevels] ADD  CONSTRAINT [DF__PerkLevel__Price__0C50D423]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[PerkLevels] ADD  CONSTRAINT [DF__PerkLevel__Descr__0D44F85C]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[PerkLevelSkillRequirements] ADD  CONSTRAINT [DF__PerkSkill__Requi__278EDA44]  DEFAULT ((0)) FOR [RequiredRank]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__Name__0F2D40CE]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__FeatID__10216507]  DEFAULT ((0)) FOR [FeatID]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__IsActive__11158940]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__JavaScrip__1209AD79]  DEFAULT ('') FOR [ScriptName]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__BaseFPC__12FDD1B2]  DEFAULT ((0)) FOR [BaseFPCost]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__BaseCasti__13F1F5EB]  DEFAULT ((0.0)) FOR [BaseCastingTime]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__Descripti__14E61A24]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__Execution__15DA3E5D]  DEFAULT ((0)) FOR [ExecutionTypeID]
GO
ALTER TABLE [dbo].[Perks] ADD  CONSTRAINT [DF__Perks__IsTargetS__16CE6296]  DEFAULT ((0)) FOR [IsTargetSelfOnly]
GO
ALTER TABLE [dbo].[Perks] ADD  DEFAULT ((0)) FOR [Enmity]
GO
ALTER TABLE [dbo].[Perks] ADD  DEFAULT ((0)) FOR [EnmityAdjustmentRuleID]
GO
ALTER TABLE [dbo].[Plants] ADD  CONSTRAINT [DF__Plants__Name__17C286CF]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Plants] ADD  CONSTRAINT [DF__Plants__BaseTick__18B6AB08]  DEFAULT ((0)) FOR [BaseTicks]
GO
ALTER TABLE [dbo].[Plants] ADD  CONSTRAINT [DF__Plants__Resref__19AACF41]  DEFAULT ('') FOR [Resref]
GO
ALTER TABLE [dbo].[Plants] ADD  DEFAULT ((0)) FOR [WaterTicks]
GO
ALTER TABLE [dbo].[Plants] ADD  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[Plants] ADD  DEFAULT ('') FOR [SeedResref]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [df_PlayerCharacters_CreateTimestamp]  DEFAULT (getutcdate()) FOR [CreateTimestamp]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__MaxMa__1B9317B3]  DEFAULT ((0)) FOR [MaxFP]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Curre__1C873BEC]  DEFAULT ((0)) FOR [CurrentFP]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Curre__1D7B6025]  DEFAULT ((0)) FOR [CurrentFPTick]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Respa__1F63A897]  DEFAULT ('') FOR [RespawnAreaResref]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Respa__2057CCD0]  DEFAULT ((0.0)) FOR [RespawnLocationX]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Respa__214BF109]  DEFAULT ((0.0)) FOR [RespawnLocationY]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Respa__22401542]  DEFAULT ((0.0)) FOR [RespawnLocationZ]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Respa__2334397B]  DEFAULT ((0.0)) FOR [RespawnLocationOrientation]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__DateS__24285DB4]  DEFAULT (dateadd(hour,(72),getutcdate())) FOR [DateSanctuaryEnds]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__IsSan__251C81ED]  DEFAULT ((0)) FOR [IsSanctuaryOverrideEnabled]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__STRBa__2610A626]  DEFAULT ((0)) FOR [STRBase]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__DEXBa__2704CA5F]  DEFAULT ((0)) FOR [DEXBase]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__CONBa__27F8EE98]  DEFAULT ((0)) FOR [CONBase]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__INTBa__28ED12D1]  DEFAULT ((0)) FOR [INTBase]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__WISBa__29E1370A]  DEFAULT ((0)) FOR [WISBase]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__CHABa__2AD55B43]  DEFAULT ((0)) FOR [CHABase]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  CONSTRAINT [DF__PlayerCha__Total__2BC97F7C]  DEFAULT ((0)) FOR [TotalSPAcquired]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  DEFAULT ((1)) FOR [DisplayHelmet]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  DEFAULT ((1)) FOR [DisplayHolonet]
GO
ALTER TABLE [dbo].[PlayerCharacters] ADD  DEFAULT ((1)) FOR [DisplayDiscord]
GO
ALTER TABLE [dbo].[QuestRequiredItemList] ADD  DEFAULT ((0)) FOR [MustBeCraftedByPlayer]
GO
ALTER TABLE [dbo].[Quests] ADD  CONSTRAINT [DF__Quests__AllowRew__2CBDA3B5]  DEFAULT ((0)) FOR [AllowRewardSelection]
GO
ALTER TABLE [dbo].[Quests] ADD  CONSTRAINT [DF__Quests__IsRepeat__2DB1C7EE]  DEFAULT ((0)) FOR [IsRepeatable]
GO
ALTER TABLE [dbo].[Quests] ADD  CONSTRAINT [DF__Quests__RemoveSt__2EA5EC27]  DEFAULT ((0)) FOR [RemoveStartKeyItemAfterCompletion]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnAcceptRule]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnAdvanceRule]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnCompleteRule]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnKillTargetRule]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnAcceptArgs]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnAdvanceArgs]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnCompleteArgs]
GO
ALTER TABLE [dbo].[Quests] ADD  DEFAULT ('') FOR [OnKillTargetArgs]
GO
ALTER TABLE [dbo].[ServerConfiguration] ADD  CONSTRAINT [DF__ServerCon__Serve__308E3499]  DEFAULT ('') FOR [ServerName]
GO
ALTER TABLE [dbo].[ServerConfiguration] ADD  CONSTRAINT [DF__ServerCon__Messa__318258D2]  DEFAULT ('') FOR [MessageOfTheDay]
GO
ALTER TABLE [dbo].[ServerConfiguration] ADD  DEFAULT ((2)) FOR [AreaBakeStep]
GO
ALTER TABLE [dbo].[SkillCategories] ADD  CONSTRAINT [DF__SkillCateg__Name__32767D0B]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[SkillCategories] ADD  CONSTRAINT [DF__SkillCate__IsAct__336AA144]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SkillCategories] ADD  CONSTRAINT [DF__SkillCate__Seque__345EC57D]  DEFAULT ((0)) FOR [Sequence]
GO
ALTER TABLE [dbo].[Skills] ADD  CONSTRAINT [DF__Skills__Name__3552E9B6]  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[Skills] ADD  CONSTRAINT [DF__Skills__MaxRank__36470DEF]  DEFAULT ((0)) FOR [MaxRank]
GO
ALTER TABLE [dbo].[Skills] ADD  CONSTRAINT [DF__Skills__IsActive__373B3228]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Skills] ADD  CONSTRAINT [DF__Skills__Descript__382F5661]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Skills] ADD  CONSTRAINT [DF__Skills__Primary__39237A9A]  DEFAULT ('') FOR [Primary]
GO
ALTER TABLE [dbo].[Skills] ADD  CONSTRAINT [DF__Skills__Secondar__3A179ED3]  DEFAULT ('') FOR [Secondary]
GO
ALTER TABLE [dbo].[Skills] ADD  CONSTRAINT [DF__Skills__Tertiary__3B0BC30C]  DEFAULT ('') FOR [Tertiary]
GO
ALTER TABLE [dbo].[Skills] ADD  DEFAULT ((1)) FOR [ContributesToSkillCap]
GO
ALTER TABLE [dbo].[SpawnObjects] ADD  DEFAULT ((1)) FOR [Weight]
GO
ALTER TABLE [dbo].[SpawnObjects] ADD  DEFAULT ('') FOR [SpawnRule]
GO
ALTER TABLE [dbo].[SpawnObjects] ADD  DEFAULT ('') FOR [BehaviourScript]
GO
ALTER TABLE [dbo].[SpawnObjects] ADD  DEFAULT ((0)) FOR [DeathVFXID]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF__Users__RoleID__4589517F]  DEFAULT ((3)) FOR [RoleID]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF__Users__DateRegis__467D75B8]  DEFAULT (getutcdate()) FOR [DateRegistered]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_NortheastLootTableID] FOREIGN KEY([NortheastLootTableID])
REFERENCES [dbo].[LootTables] ([LootTableID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_NortheastLootTableID]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_NortheastOwner] FOREIGN KEY([NortheastOwner])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_NortheastOwner]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_NorthwestLootTableID] FOREIGN KEY([NorthwestLootTableID])
REFERENCES [dbo].[LootTables] ([LootTableID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_NorthwestLootTableID]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_NorthwestOwner] FOREIGN KEY([NorthwestOwner])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_NorthwestOwner]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_ResourceSpawnTableID] FOREIGN KEY([ResourceSpawnTableID])
REFERENCES [dbo].[Spawns] ([SpawnID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_ResourceSpawnTableID]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_SoutheastLootTableID] FOREIGN KEY([SoutheastLootTableID])
REFERENCES [dbo].[LootTables] ([LootTableID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_SoutheastLootTableID]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_SoutheastOwner] FOREIGN KEY([SoutheastOwner])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_SoutheastOwner]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_SouthwestLootTableID] FOREIGN KEY([SouthwestLootTableID])
REFERENCES [dbo].[LootTables] ([LootTableID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_SouthwestLootTableID]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_SouthwestOwner] FOREIGN KEY([SouthwestOwner])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_SouthwestOwner]
GO
ALTER TABLE [dbo].[AreaWalkmesh]  WITH CHECK ADD  CONSTRAINT [FK_AreaWalkmesh_AreaID] FOREIGN KEY([AreaID])
REFERENCES [dbo].[Areas] ([AreaID])
GO
ALTER TABLE [dbo].[AreaWalkmesh] CHECK CONSTRAINT [FK_AreaWalkmesh_AreaID]
GO
ALTER TABLE [dbo].[BankItems]  WITH CHECK ADD  CONSTRAINT [FK_BankItems_BankID] FOREIGN KEY([BankID])
REFERENCES [dbo].[Banks] ([BankID])
GO
ALTER TABLE [dbo].[BankItems] CHECK CONSTRAINT [FK_BankItems_BankID]
GO
ALTER TABLE [dbo].[BankItems]  WITH CHECK ADD  CONSTRAINT [FK_BankItems_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[BankItems] CHECK CONSTRAINT [FK_BankItems_PlayerID]
GO
ALTER TABLE [dbo].[BaseStructures]  WITH CHECK ADD  CONSTRAINT [FK_BaseStructures_BaseStructureTypeID] FOREIGN KEY([BaseStructureTypeID])
REFERENCES [dbo].[BaseStructureType] ([BaseStructureTypeID])
GO
ALTER TABLE [dbo].[BaseStructures] CHECK CONSTRAINT [FK_BaseStructures_BaseStructureTypeID]
GO
ALTER TABLE [dbo].[BugReports]  WITH CHECK ADD  CONSTRAINT [FK_BugReports_SenderPlayerID] FOREIGN KEY([SenderPlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[BugReports] CHECK CONSTRAINT [FK_BugReports_SenderPlayerID]
GO
ALTER TABLE [dbo].[BuildingStyles]  WITH CHECK ADD  CONSTRAINT [FK_BuildingStyles_BaseStructureID] FOREIGN KEY([BaseStructureID])
REFERENCES [dbo].[BaseStructures] ([BaseStructureID])
GO
ALTER TABLE [dbo].[BuildingStyles] CHECK CONSTRAINT [FK_BuildingStyles_BaseStructureID]
GO
ALTER TABLE [dbo].[BuildingStyles]  WITH CHECK ADD  CONSTRAINT [FK_BuildingStyles_BuildingTypeID] FOREIGN KEY([BuildingTypeID])
REFERENCES [dbo].[BuildingTypes] ([BuildingTypeID])
GO
ALTER TABLE [dbo].[BuildingStyles] CHECK CONSTRAINT [FK_BuildingStyles_BuildingTypeID]
GO
ALTER TABLE [dbo].[ChatLog]  WITH CHECK ADD  CONSTRAINT [fk_ChatLog_ChatChannelID] FOREIGN KEY([ChatChannelID])
REFERENCES [dbo].[ChatChannelsDomain] ([ChatChannelID])
GO
ALTER TABLE [dbo].[ChatLog] CHECK CONSTRAINT [fk_ChatLog_ChatChannelID]
GO
ALTER TABLE [dbo].[ChatLog]  WITH CHECK ADD  CONSTRAINT [fk_ChatLog_ReceiverPlayerID] FOREIGN KEY([ReceiverPlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[ChatLog] CHECK CONSTRAINT [fk_ChatLog_ReceiverPlayerID]
GO
ALTER TABLE [dbo].[ChatLog]  WITH CHECK ADD  CONSTRAINT [fk_ChatLog_SenderPlayerID] FOREIGN KEY([SenderPlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[ChatLog] CHECK CONSTRAINT [fk_ChatLog_SenderPlayerID]
GO
ALTER TABLE [dbo].[ClientLogEvents]  WITH CHECK ADD  CONSTRAINT [FK_ClientLogEvents_ClientLogEventTypeID] FOREIGN KEY([ClientLogEventTypeID])
REFERENCES [dbo].[ClientLogEventTypesDomain] ([ClientLogEventTypeID])
GO
ALTER TABLE [dbo].[ClientLogEvents] CHECK CONSTRAINT [FK_ClientLogEvents_ClientLogEventTypeID]
GO
ALTER TABLE [dbo].[ClientLogEvents]  WITH CHECK ADD  CONSTRAINT [FK_ClientLogEvents_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[ClientLogEvents] CHECK CONSTRAINT [FK_ClientLogEvents_PlayerID]
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD FOREIGN KEY([BaseStructureID])
REFERENCES [dbo].[BaseStructures] ([BaseStructureID])
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD  CONSTRAINT [fk_CraftBlueprints_CraftCategoryID] FOREIGN KEY([CraftCategoryID])
REFERENCES [dbo].[CraftBlueprintCategories] ([CraftBlueprintCategoryID])
GO
ALTER TABLE [dbo].[CraftBlueprints] CHECK CONSTRAINT [fk_CraftBlueprints_CraftCategoryID]
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD  CONSTRAINT [FK_CraftBlueprints_CraftDeviceID] FOREIGN KEY([CraftDeviceID])
REFERENCES [dbo].[CraftDevices] ([CraftDeviceID])
GO
ALTER TABLE [dbo].[CraftBlueprints] CHECK CONSTRAINT [FK_CraftBlueprints_CraftDeviceID]
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD  CONSTRAINT [fk_CraftBlueprints_MainComponentTypeID] FOREIGN KEY([MainComponentTypeID])
REFERENCES [dbo].[ComponentTypes] ([ComponentTypeID])
GO
ALTER TABLE [dbo].[CraftBlueprints] CHECK CONSTRAINT [fk_CraftBlueprints_MainComponentTypeID]
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD  CONSTRAINT [FK_CraftBlueprints_PerkID] FOREIGN KEY([PerkID])
REFERENCES [dbo].[Perks] ([PerkID])
GO
ALTER TABLE [dbo].[CraftBlueprints] CHECK CONSTRAINT [FK_CraftBlueprints_PerkID]
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD  CONSTRAINT [fk_CraftBlueprints_SecondaryComponentTypeID] FOREIGN KEY([SecondaryComponentTypeID])
REFERENCES [dbo].[ComponentTypes] ([ComponentTypeID])
GO
ALTER TABLE [dbo].[CraftBlueprints] CHECK CONSTRAINT [fk_CraftBlueprints_SecondaryComponentTypeID]
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD  CONSTRAINT [FK_CraftBlueprints_SkillID] FOREIGN KEY([SkillID])
REFERENCES [dbo].[Skills] ([SkillID])
GO
ALTER TABLE [dbo].[CraftBlueprints] CHECK CONSTRAINT [FK_CraftBlueprints_SkillID]
GO
ALTER TABLE [dbo].[CraftBlueprints]  WITH CHECK ADD  CONSTRAINT [fk_CraftBlueprints_TertiaryComponentTypeID] FOREIGN KEY([TertiaryComponentTypeID])
REFERENCES [dbo].[ComponentTypes] ([ComponentTypeID])
GO
ALTER TABLE [dbo].[CraftBlueprints] CHECK CONSTRAINT [fk_CraftBlueprints_TertiaryComponentTypeID]
GO
ALTER TABLE [dbo].[GameTopics]  WITH CHECK ADD  CONSTRAINT [FK_GameTopics_GameTopicCategoryID] FOREIGN KEY([GameTopicCategoryID])
REFERENCES [dbo].[GameTopicCategories] ([GameTopicCategoryID])
GO
ALTER TABLE [dbo].[GameTopics] CHECK CONSTRAINT [FK_GameTopics_GameTopicCategoryID]
GO
ALTER TABLE [dbo].[GrowingPlants]  WITH CHECK ADD  CONSTRAINT [FK_GrowingPlants_PlantID] FOREIGN KEY([PlantID])
REFERENCES [dbo].[Plants] ([PlantID])
GO
ALTER TABLE [dbo].[GrowingPlants] CHECK CONSTRAINT [FK_GrowingPlants_PlantID]
GO
ALTER TABLE [dbo].[KeyItems]  WITH CHECK ADD  CONSTRAINT [fk_KeyItems_KeyItemCategoryID] FOREIGN KEY([KeyItemCategoryID])
REFERENCES [dbo].[KeyItemCategories] ([KeyItemCategoryID])
GO
ALTER TABLE [dbo].[KeyItems] CHECK CONSTRAINT [fk_KeyItems_KeyItemCategoryID]
GO
ALTER TABLE [dbo].[LootTableItems]  WITH CHECK ADD  CONSTRAINT [fk_LootTableItems_LootTableID] FOREIGN KEY([LootTableID])
REFERENCES [dbo].[LootTables] ([LootTableID])
GO
ALTER TABLE [dbo].[LootTableItems] CHECK CONSTRAINT [fk_LootTableItems_LootTableID]
GO
ALTER TABLE [dbo].[PCBasePermissions]  WITH CHECK ADD  CONSTRAINT [FK_PCBasePermissions_PCBaseID] FOREIGN KEY([PCBaseID])
REFERENCES [dbo].[PCBases] ([PCBaseID])
GO
ALTER TABLE [dbo].[PCBasePermissions] CHECK CONSTRAINT [FK_PCBasePermissions_PCBaseID]
GO
ALTER TABLE [dbo].[PCBasePermissions]  WITH CHECK ADD  CONSTRAINT [FK_PCBasePermissions_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCBasePermissions] CHECK CONSTRAINT [FK_PCBasePermissions_PlayerID]
GO
ALTER TABLE [dbo].[PCBases]  WITH CHECK ADD  CONSTRAINT [FK_PCBases_ApartmentBuildingID] FOREIGN KEY([ApartmentBuildingID])
REFERENCES [dbo].[ApartmentBuildings] ([ApartmentBuildingID])
GO
ALTER TABLE [dbo].[PCBases] CHECK CONSTRAINT [FK_PCBases_ApartmentBuildingID]
GO
ALTER TABLE [dbo].[PCBases]  WITH CHECK ADD  CONSTRAINT [FK_PCBases_AreaResref] FOREIGN KEY([AreaResref])
REFERENCES [dbo].[Areas] ([Resref])
GO
ALTER TABLE [dbo].[PCBases] CHECK CONSTRAINT [FK_PCBases_AreaResref]
GO
ALTER TABLE [dbo].[PCBases]  WITH CHECK ADD  CONSTRAINT [FK_PCBases_BuildingStyleID] FOREIGN KEY([BuildingStyleID])
REFERENCES [dbo].[BuildingStyles] ([BuildingStyleID])
GO
ALTER TABLE [dbo].[PCBases] CHECK CONSTRAINT [FK_PCBases_BuildingStyleID]
GO
ALTER TABLE [dbo].[PCBases]  WITH CHECK ADD  CONSTRAINT [FK_PCBases_PCBaseTypeID] FOREIGN KEY([PCBaseTypeID])
REFERENCES [dbo].[PCBaseTypes] ([PCBaseTypeID])
GO
ALTER TABLE [dbo].[PCBases] CHECK CONSTRAINT [FK_PCBases_PCBaseTypeID]
GO
ALTER TABLE [dbo].[PCBases]  WITH CHECK ADD  CONSTRAINT [FK_PCBases_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCBases] CHECK CONSTRAINT [FK_PCBases_PlayerID]
GO
ALTER TABLE [dbo].[PCBaseStructureItems]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructureItems_PCBaseStructureID] FOREIGN KEY([PCBaseStructureID])
REFERENCES [dbo].[PCBaseStructures] ([PCBaseStructureID])
GO
ALTER TABLE [dbo].[PCBaseStructureItems] CHECK CONSTRAINT [FK_PCBaseStructureItems_PCBaseStructureID]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructurePermissions_PCBaseStructureID] FOREIGN KEY([PCBaseStructureID])
REFERENCES [dbo].[PCBaseStructures] ([PCBaseStructureID])
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] CHECK CONSTRAINT [FK_PCBaseStructurePermissions_PCBaseStructureID]
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructurePermissions_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCBaseStructurePermissions] CHECK CONSTRAINT [FK_PCBaseStructurePermissions_PlayerID]
GO
ALTER TABLE [dbo].[PCBaseStructures]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructures_BaseStructureID] FOREIGN KEY([BaseStructureID])
REFERENCES [dbo].[BaseStructures] ([BaseStructureID])
GO
ALTER TABLE [dbo].[PCBaseStructures] CHECK CONSTRAINT [FK_PCBaseStructures_BaseStructureID]
GO
ALTER TABLE [dbo].[PCBaseStructures]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructures_ExteriorStyleID] FOREIGN KEY([ExteriorStyleID])
REFERENCES [dbo].[BuildingStyles] ([BuildingStyleID])
GO
ALTER TABLE [dbo].[PCBaseStructures] CHECK CONSTRAINT [FK_PCBaseStructures_ExteriorStyleID]
GO
ALTER TABLE [dbo].[PCBaseStructures]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructures_InteriorStyleID] FOREIGN KEY([InteriorStyleID])
REFERENCES [dbo].[BuildingStyles] ([BuildingStyleID])
GO
ALTER TABLE [dbo].[PCBaseStructures] CHECK CONSTRAINT [FK_PCBaseStructures_InteriorStyleID]
GO
ALTER TABLE [dbo].[PCBaseStructures]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructures_ParentPCBaseStructureID] FOREIGN KEY([ParentPCBaseStructureID])
REFERENCES [dbo].[PCBaseStructures] ([PCBaseStructureID])
GO
ALTER TABLE [dbo].[PCBaseStructures] CHECK CONSTRAINT [FK_PCBaseStructures_ParentPCBaseStructureID]
GO
ALTER TABLE [dbo].[PCBaseStructures]  WITH CHECK ADD  CONSTRAINT [FK_PCBaseStructures_PCBaseID] FOREIGN KEY([PCBaseID])
REFERENCES [dbo].[PCBases] ([PCBaseID])
GO
ALTER TABLE [dbo].[PCBaseStructures] CHECK CONSTRAINT [FK_PCBaseStructures_PCBaseID]
GO
ALTER TABLE [dbo].[PCCooldowns]  WITH CHECK ADD  CONSTRAINT [fk_PCCooldowns_CooldownCategoryID] FOREIGN KEY([CooldownCategoryID])
REFERENCES [dbo].[CooldownCategories] ([CooldownCategoryID])
GO
ALTER TABLE [dbo].[PCCooldowns] CHECK CONSTRAINT [fk_PCCooldowns_CooldownCategoryID]
GO
ALTER TABLE [dbo].[PCCooldowns]  WITH CHECK ADD  CONSTRAINT [fk_PCCooldowns_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCCooldowns] CHECK CONSTRAINT [fk_PCCooldowns_PlayerID]
GO
ALTER TABLE [dbo].[PCCraftedBlueprints]  WITH CHECK ADD  CONSTRAINT [FK_PCCraftedBlueprints_CraftBlueprintID] FOREIGN KEY([CraftBlueprintID])
REFERENCES [dbo].[CraftBlueprints] ([CraftBlueprintID])
GO
ALTER TABLE [dbo].[PCCraftedBlueprints] CHECK CONSTRAINT [FK_PCCraftedBlueprints_CraftBlueprintID]
GO
ALTER TABLE [dbo].[PCCraftedBlueprints]  WITH CHECK ADD  CONSTRAINT [FK_PCCraftedBlueprints_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCCraftedBlueprints] CHECK CONSTRAINT [FK_PCCraftedBlueprints_PlayerID]
GO
ALTER TABLE [dbo].[PCCustomEffects]  WITH CHECK ADD  CONSTRAINT [fk_PCCustomEffects_CustomEffectID] FOREIGN KEY([CustomEffectID])
REFERENCES [dbo].[CustomEffects] ([CustomEffectID])
GO
ALTER TABLE [dbo].[PCCustomEffects] CHECK CONSTRAINT [fk_PCCustomEffects_CustomEffectID]
GO
ALTER TABLE [dbo].[PCCustomEffects]  WITH CHECK ADD  CONSTRAINT [fk_PCCustomEffects_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCCustomEffects] CHECK CONSTRAINT [fk_PCCustomEffects_PlayerID]
GO
ALTER TABLE [dbo].[PCImpoundedItems]  WITH CHECK ADD  CONSTRAINT [FK_PCItemImpound_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCImpoundedItems] CHECK CONSTRAINT [FK_PCItemImpound_PlayerID]
GO
ALTER TABLE [dbo].[PCKeyItems]  WITH CHECK ADD  CONSTRAINT [fk_PCKeyItems_KeyItemID] FOREIGN KEY([KeyItemID])
REFERENCES [dbo].[KeyItems] ([KeyItemID])
GO
ALTER TABLE [dbo].[PCKeyItems] CHECK CONSTRAINT [fk_PCKeyItems_KeyItemID]
GO
ALTER TABLE [dbo].[PCKeyItems]  WITH CHECK ADD  CONSTRAINT [fk_PCKeyItems_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCKeyItems] CHECK CONSTRAINT [fk_PCKeyItems_PlayerID]
GO
ALTER TABLE [dbo].[PCMapPins]  WITH CHECK ADD  CONSTRAINT [FK_PCMapPins_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCMapPins] CHECK CONSTRAINT [FK_PCMapPins_PlayerID]
GO
ALTER TABLE [dbo].[PCMapProgression]  WITH CHECK ADD  CONSTRAINT [FK_PCMapProgression_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCMapProgression] CHECK CONSTRAINT [FK_PCMapProgression_PlayerID]
GO
ALTER TABLE [dbo].[PCMigrationItems]  WITH CHECK ADD  CONSTRAINT [fk_PCMigrationItems_BaseItemTypeID] FOREIGN KEY([BaseItemTypeID])
REFERENCES [dbo].[BaseItemTypes] ([BaseItemTypeID])
GO
ALTER TABLE [dbo].[PCMigrationItems] CHECK CONSTRAINT [fk_PCMigrationItems_BaseItemTypeID]
GO
ALTER TABLE [dbo].[PCMigrationItems]  WITH CHECK ADD  CONSTRAINT [fk_PCMigrationItems_PCMigrationID] FOREIGN KEY([PCMigrationID])
REFERENCES [dbo].[PCMigrations] ([PCMigrationID])
GO
ALTER TABLE [dbo].[PCMigrationItems] CHECK CONSTRAINT [fk_PCMigrationItems_PCMigrationID]
GO
ALTER TABLE [dbo].[PCObjectVisibility]  WITH CHECK ADD  CONSTRAINT [FK_PCObjectVisibility_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCObjectVisibility] CHECK CONSTRAINT [FK_PCObjectVisibility_PlayerID]
GO
ALTER TABLE [dbo].[PCOutfits]  WITH CHECK ADD  CONSTRAINT [fk_PCOutfits_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCOutfits] CHECK CONSTRAINT [fk_PCOutfits_PlayerID]
GO
ALTER TABLE [dbo].[PCOverflowItems]  WITH CHECK ADD  CONSTRAINT [fk_PCOverflowItems_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCOverflowItems] CHECK CONSTRAINT [fk_PCOverflowItems_PlayerID]
GO
ALTER TABLE [dbo].[PCPerkRefunds]  WITH CHECK ADD  CONSTRAINT [FK_PCPerkRefunds_PerkID] FOREIGN KEY([PerkID])
REFERENCES [dbo].[Perks] ([PerkID])
GO
ALTER TABLE [dbo].[PCPerkRefunds] CHECK CONSTRAINT [FK_PCPerkRefunds_PerkID]
GO
ALTER TABLE [dbo].[PCPerkRefunds]  WITH CHECK ADD  CONSTRAINT [FK_PCPerkRefunds_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCPerkRefunds] CHECK CONSTRAINT [FK_PCPerkRefunds_PlayerID]
GO
ALTER TABLE [dbo].[PCPerks]  WITH CHECK ADD  CONSTRAINT [fk_PCPerks_PerkID] FOREIGN KEY([PerkID])
REFERENCES [dbo].[Perks] ([PerkID])
GO
ALTER TABLE [dbo].[PCPerks] CHECK CONSTRAINT [fk_PCPerks_PerkID]
GO
ALTER TABLE [dbo].[PCPerks]  WITH CHECK ADD  CONSTRAINT [fk_PCPerks_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCPerks] CHECK CONSTRAINT [fk_PCPerks_PlayerID]
GO
ALTER TABLE [dbo].[PCQuestItemProgress]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestItemProgress_PCQuestStatusID] FOREIGN KEY([PCQuestStatusID])
REFERENCES [dbo].[PCQuestStatus] ([PCQuestStatusID])
GO
ALTER TABLE [dbo].[PCQuestItemProgress] CHECK CONSTRAINT [FK_PCQuestItemProgress_PCQuestStatusID]
GO
ALTER TABLE [dbo].[PCQuestItemProgress]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestItemProgress_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCQuestItemProgress] CHECK CONSTRAINT [FK_PCQuestItemProgress_PlayerID]
GO
ALTER TABLE [dbo].[PCQuestKillTargetProgress]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestKillTargetProgress_NPCGroupID] FOREIGN KEY([NPCGroupID])
REFERENCES [dbo].[NPCGroups] ([NPCGroupID])
GO
ALTER TABLE [dbo].[PCQuestKillTargetProgress] CHECK CONSTRAINT [FK_PCQuestKillTargetProgress_NPCGroupID]
GO
ALTER TABLE [dbo].[PCQuestKillTargetProgress]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestKillTargetProgress_PCQuestStatusID] FOREIGN KEY([PCQuestStatusID])
REFERENCES [dbo].[PCQuestStatus] ([PCQuestStatusID])
GO
ALTER TABLE [dbo].[PCQuestKillTargetProgress] CHECK CONSTRAINT [FK_PCQuestKillTargetProgress_PCQuestStatusID]
GO
ALTER TABLE [dbo].[PCQuestKillTargetProgress]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestKillTargetProgress_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCQuestKillTargetProgress] CHECK CONSTRAINT [FK_PCQuestKillTargetProgress_PlayerID]
GO
ALTER TABLE [dbo].[PCQuestStatus]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestStatus_CurrentQuestStateID] FOREIGN KEY([CurrentQuestStateID])
REFERENCES [dbo].[QuestStates] ([QuestStateID])
GO
ALTER TABLE [dbo].[PCQuestStatus] CHECK CONSTRAINT [FK_PCQuestStatus_CurrentQuestStateID]
GO
ALTER TABLE [dbo].[PCQuestStatus]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestStatus_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCQuestStatus] CHECK CONSTRAINT [FK_PCQuestStatus_PlayerID]
GO
ALTER TABLE [dbo].[PCQuestStatus]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestStatus_QuestID] FOREIGN KEY([QuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[PCQuestStatus] CHECK CONSTRAINT [FK_PCQuestStatus_QuestID]
GO
ALTER TABLE [dbo].[PCQuestStatus]  WITH CHECK ADD  CONSTRAINT [FK_PCQuestStatus_SelectedRewardID] FOREIGN KEY([SelectedItemRewardID])
REFERENCES [dbo].[QuestRewardItems] ([QuestRewardItemID])
GO
ALTER TABLE [dbo].[PCQuestStatus] CHECK CONSTRAINT [FK_PCQuestStatus_SelectedRewardID]
GO
ALTER TABLE [dbo].[PCRegionalFame]  WITH CHECK ADD  CONSTRAINT [FK_PCRegionalFame_FameRegionID] FOREIGN KEY([FameRegionID])
REFERENCES [dbo].[FameRegions] ([FameRegionID])
GO
ALTER TABLE [dbo].[PCRegionalFame] CHECK CONSTRAINT [FK_PCRegionalFame_FameRegionID]
GO
ALTER TABLE [dbo].[PCRegionalFame]  WITH CHECK ADD  CONSTRAINT [FK_PCRegionalFame_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCRegionalFame] CHECK CONSTRAINT [FK_PCRegionalFame_PlayerID]
GO
ALTER TABLE [dbo].[PCSearchSiteItems]  WITH CHECK ADD  CONSTRAINT [fk_PCSearchSiteItems_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCSearchSiteItems] CHECK CONSTRAINT [fk_PCSearchSiteItems_PlayerID]
GO
ALTER TABLE [dbo].[PCSearchSites]  WITH CHECK ADD  CONSTRAINT [fk_PCSearchSites_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCSearchSites] CHECK CONSTRAINT [fk_PCSearchSites_PlayerID]
GO
ALTER TABLE [dbo].[PCSkills]  WITH CHECK ADD  CONSTRAINT [FK_PCSkills_PlayerID] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[PlayerCharacters] ([PlayerID])
GO
ALTER TABLE [dbo].[PCSkills] CHECK CONSTRAINT [FK_PCSkills_PlayerID]
GO
ALTER TABLE [dbo].[PCSkills]  WITH CHECK ADD  CONSTRAINT [FK_PCSkills_SkillID] FOREIGN KEY([SkillID])
REFERENCES [dbo].[Skills] ([SkillID])
GO
ALTER TABLE [dbo].[PCSkills] CHECK CONSTRAINT [FK_PCSkills_SkillID]
GO
ALTER TABLE [dbo].[PerkLevelQuestRequirements]  WITH CHECK ADD  CONSTRAINT [FK_PerkLevelQuestRequirements_PerkLevelID] FOREIGN KEY([PerkLevelID])
REFERENCES [dbo].[PerkLevels] ([PerkLevelID])
GO
ALTER TABLE [dbo].[PerkLevelQuestRequirements] CHECK CONSTRAINT [FK_PerkLevelQuestRequirements_PerkLevelID]
GO
ALTER TABLE [dbo].[PerkLevelQuestRequirements]  WITH CHECK ADD  CONSTRAINT [FK_PerkLevelQuestRequirements_RequiredQuestID] FOREIGN KEY([RequiredQuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[PerkLevelQuestRequirements] CHECK CONSTRAINT [FK_PerkLevelQuestRequirements_RequiredQuestID]
GO
ALTER TABLE [dbo].[PerkLevels]  WITH CHECK ADD  CONSTRAINT [FK_PerkLevels_PerkID] FOREIGN KEY([PerkID])
REFERENCES [dbo].[Perks] ([PerkID])
GO
ALTER TABLE [dbo].[PerkLevels] CHECK CONSTRAINT [FK_PerkLevels_PerkID]
GO
ALTER TABLE [dbo].[PerkLevelSkillRequirements]  WITH CHECK ADD  CONSTRAINT [FK_PerkLevelSkillRequirements_PerkLevelID] FOREIGN KEY([PerkLevelID])
REFERENCES [dbo].[PerkLevels] ([PerkLevelID])
GO
ALTER TABLE [dbo].[PerkLevelSkillRequirements] CHECK CONSTRAINT [FK_PerkLevelSkillRequirements_PerkLevelID]
GO
ALTER TABLE [dbo].[PerkLevelSkillRequirements]  WITH CHECK ADD  CONSTRAINT [FK_PerkLevelSkillRequirements_SkillID] FOREIGN KEY([SkillID])
REFERENCES [dbo].[Skills] ([SkillID])
GO
ALTER TABLE [dbo].[PerkLevelSkillRequirements] CHECK CONSTRAINT [FK_PerkLevelSkillRequirements_SkillID]
GO
ALTER TABLE [dbo].[Perks]  WITH CHECK ADD  CONSTRAINT [fk_Perks_CooldownCategoryID] FOREIGN KEY([CooldownCategoryID])
REFERENCES [dbo].[CooldownCategories] ([CooldownCategoryID])
GO
ALTER TABLE [dbo].[Perks] CHECK CONSTRAINT [fk_Perks_CooldownCategoryID]
GO
ALTER TABLE [dbo].[Perks]  WITH CHECK ADD  CONSTRAINT [fk_Perks_EnmityAdjustmentRuleID] FOREIGN KEY([EnmityAdjustmentRuleID])
REFERENCES [dbo].[EnmityAdjustmentRule] ([EnmityAdjustmentRuleID])
GO
ALTER TABLE [dbo].[Perks] CHECK CONSTRAINT [fk_Perks_EnmityAdjustmentRuleID]
GO
ALTER TABLE [dbo].[Perks]  WITH CHECK ADD  CONSTRAINT [fk_Perks_ExecutionTypeID] FOREIGN KEY([ExecutionTypeID])
REFERENCES [dbo].[PerkExecutionTypes] ([PerkExecutionTypeID])
GO
ALTER TABLE [dbo].[Perks] CHECK CONSTRAINT [fk_Perks_ExecutionTypeID]
GO
ALTER TABLE [dbo].[Perks]  WITH CHECK ADD  CONSTRAINT [fk_Perks_PerkCategoryID] FOREIGN KEY([PerkCategoryID])
REFERENCES [dbo].[PerkCategories] ([PerkCategoryID])
GO
ALTER TABLE [dbo].[Perks] CHECK CONSTRAINT [fk_Perks_PerkCategoryID]
GO
ALTER TABLE [dbo].[PlayerCharacters]  WITH CHECK ADD  CONSTRAINT [FK_PlayerCharacters_AssociationID] FOREIGN KEY([AssociationID])
REFERENCES [dbo].[Associations] ([AssociationID])
GO
ALTER TABLE [dbo].[PlayerCharacters] CHECK CONSTRAINT [FK_PlayerCharacters_AssociationID]
GO
ALTER TABLE [dbo].[PlayerCharacters]  WITH CHECK ADD  CONSTRAINT [FK_PlayerCharacters_PrimaryResidencePCBaseID] FOREIGN KEY([PrimaryResidencePCBaseID])
REFERENCES [dbo].[PCBases] ([PCBaseID])
GO
ALTER TABLE [dbo].[PlayerCharacters] CHECK CONSTRAINT [FK_PlayerCharacters_PrimaryResidencePCBaseID]
GO
ALTER TABLE [dbo].[PlayerCharacters]  WITH CHECK ADD  CONSTRAINT [FK_PlayerCharacters_PrimaryResidencePCBaseStructureID] FOREIGN KEY([PrimaryResidencePCBaseStructureID])
REFERENCES [dbo].[PCBaseStructures] ([PCBaseStructureID])
GO
ALTER TABLE [dbo].[PlayerCharacters] CHECK CONSTRAINT [FK_PlayerCharacters_PrimaryResidencePCBaseStructureID]
GO
ALTER TABLE [dbo].[QuestKillTargetList]  WITH CHECK ADD  CONSTRAINT [FK_QuestKillTargetList_NPCGroupID] FOREIGN KEY([NPCGroupID])
REFERENCES [dbo].[NPCGroups] ([NPCGroupID])
GO
ALTER TABLE [dbo].[QuestKillTargetList] CHECK CONSTRAINT [FK_QuestKillTargetList_NPCGroupID]
GO
ALTER TABLE [dbo].[QuestKillTargetList]  WITH CHECK ADD  CONSTRAINT [FK_QuestKillTargetList_QuestID] FOREIGN KEY([QuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[QuestKillTargetList] CHECK CONSTRAINT [FK_QuestKillTargetList_QuestID]
GO
ALTER TABLE [dbo].[QuestKillTargetList]  WITH CHECK ADD  CONSTRAINT [FK_QuestKillTargetList_QuestStateID] FOREIGN KEY([QuestStateID])
REFERENCES [dbo].[QuestStates] ([QuestStateID])
GO
ALTER TABLE [dbo].[QuestKillTargetList] CHECK CONSTRAINT [FK_QuestKillTargetList_QuestStateID]
GO
ALTER TABLE [dbo].[QuestPrerequisites]  WITH CHECK ADD  CONSTRAINT [FK_QuestPrerequisites_QuestID] FOREIGN KEY([QuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[QuestPrerequisites] CHECK CONSTRAINT [FK_QuestPrerequisites_QuestID]
GO
ALTER TABLE [dbo].[QuestPrerequisites]  WITH CHECK ADD  CONSTRAINT [FK_QuestPrerequisites_RequiredQuestID] FOREIGN KEY([RequiredQuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[QuestPrerequisites] CHECK CONSTRAINT [FK_QuestPrerequisites_RequiredQuestID]
GO
ALTER TABLE [dbo].[QuestRequiredItemList]  WITH CHECK ADD  CONSTRAINT [FK_QuestRequiredItemList] FOREIGN KEY([QuestStateID])
REFERENCES [dbo].[QuestStates] ([QuestStateID])
GO
ALTER TABLE [dbo].[QuestRequiredItemList] CHECK CONSTRAINT [FK_QuestRequiredItemList]
GO
ALTER TABLE [dbo].[QuestRequiredItemList]  WITH CHECK ADD  CONSTRAINT [FK_QuestRequiredItemList_QuestID] FOREIGN KEY([QuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[QuestRequiredItemList] CHECK CONSTRAINT [FK_QuestRequiredItemList_QuestID]
GO
ALTER TABLE [dbo].[QuestRequiredKeyItemList]  WITH CHECK ADD  CONSTRAINT [FK_QuestRequiredKeyItemList] FOREIGN KEY([QuestStateID])
REFERENCES [dbo].[QuestStates] ([QuestStateID])
GO
ALTER TABLE [dbo].[QuestRequiredKeyItemList] CHECK CONSTRAINT [FK_QuestRequiredKeyItemList]
GO
ALTER TABLE [dbo].[QuestRequiredKeyItemList]  WITH CHECK ADD  CONSTRAINT [FK_QuestRequiredKeyItemList_KeyItemID] FOREIGN KEY([KeyItemID])
REFERENCES [dbo].[KeyItems] ([KeyItemID])
GO
ALTER TABLE [dbo].[QuestRequiredKeyItemList] CHECK CONSTRAINT [FK_QuestRequiredKeyItemList_KeyItemID]
GO
ALTER TABLE [dbo].[QuestRequiredKeyItemList]  WITH CHECK ADD  CONSTRAINT [FK_QuestRequiredKeyItemList_QuestID] FOREIGN KEY([QuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[QuestRequiredKeyItemList] CHECK CONSTRAINT [FK_QuestRequiredKeyItemList_QuestID]
GO
ALTER TABLE [dbo].[QuestRewardItems]  WITH CHECK ADD  CONSTRAINT [FK_QuestRewards_QuestID] FOREIGN KEY([QuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[QuestRewardItems] CHECK CONSTRAINT [FK_QuestRewards_QuestID]
GO
ALTER TABLE [dbo].[Quests]  WITH CHECK ADD  CONSTRAINT [FK_Quests_FameRegionID] FOREIGN KEY([FameRegionID])
REFERENCES [dbo].[FameRegions] ([FameRegionID])
GO
ALTER TABLE [dbo].[Quests] CHECK CONSTRAINT [FK_Quests_FameRegionID]
GO
ALTER TABLE [dbo].[Quests]  WITH CHECK ADD  CONSTRAINT [FK_Quests_RewardKeyItemID] FOREIGN KEY([RewardKeyItemID])
REFERENCES [dbo].[KeyItems] ([KeyItemID])
GO
ALTER TABLE [dbo].[Quests] CHECK CONSTRAINT [FK_Quests_RewardKeyItemID]
GO
ALTER TABLE [dbo].[Quests]  WITH CHECK ADD  CONSTRAINT [FK_Quests_TemporaryKeyItemID] FOREIGN KEY([StartKeyItemID])
REFERENCES [dbo].[KeyItems] ([KeyItemID])
GO
ALTER TABLE [dbo].[Quests] CHECK CONSTRAINT [FK_Quests_TemporaryKeyItemID]
GO
ALTER TABLE [dbo].[QuestStates]  WITH CHECK ADD  CONSTRAINT [FK_QuestStates_QuestID] FOREIGN KEY([QuestID])
REFERENCES [dbo].[Quests] ([QuestID])
GO
ALTER TABLE [dbo].[QuestStates] CHECK CONSTRAINT [FK_QuestStates_QuestID]
GO
ALTER TABLE [dbo].[QuestStates]  WITH CHECK ADD  CONSTRAINT [FK_QuestStates_QuestTypeID] FOREIGN KEY([QuestTypeID])
REFERENCES [dbo].[QuestTypeDomain] ([QuestTypeID])
GO
ALTER TABLE [dbo].[QuestStates] CHECK CONSTRAINT [FK_QuestStates_QuestTypeID]
GO
ALTER TABLE [dbo].[Skills]  WITH CHECK ADD  CONSTRAINT [FK_Skills_Primary] FOREIGN KEY([Primary])
REFERENCES [dbo].[Attributes] ([AttributeID])
GO
ALTER TABLE [dbo].[Skills] CHECK CONSTRAINT [FK_Skills_Primary]
GO
ALTER TABLE [dbo].[Skills]  WITH CHECK ADD  CONSTRAINT [FK_Skills_Secondary] FOREIGN KEY([Secondary])
REFERENCES [dbo].[Attributes] ([AttributeID])
GO
ALTER TABLE [dbo].[Skills] CHECK CONSTRAINT [FK_Skills_Secondary]
GO
ALTER TABLE [dbo].[Skills]  WITH CHECK ADD  CONSTRAINT [FK_Skills_SkillCategoryID] FOREIGN KEY([SkillCategoryID])
REFERENCES [dbo].[SkillCategories] ([SkillCategoryID])
GO
ALTER TABLE [dbo].[Skills] CHECK CONSTRAINT [FK_Skills_SkillCategoryID]
GO
ALTER TABLE [dbo].[Skills]  WITH CHECK ADD  CONSTRAINT [FK_Skills_Tertiary] FOREIGN KEY([Tertiary])
REFERENCES [dbo].[Attributes] ([AttributeID])
GO
ALTER TABLE [dbo].[Skills] CHECK CONSTRAINT [FK_Skills_Tertiary]
GO
ALTER TABLE [dbo].[SkillXPRequirement]  WITH CHECK ADD  CONSTRAINT [FK_SkillXPRequirement_SkillID] FOREIGN KEY([SkillID])
REFERENCES [dbo].[Skills] ([SkillID])
GO
ALTER TABLE [dbo].[SkillXPRequirement] CHECK CONSTRAINT [FK_SkillXPRequirement_SkillID]
GO
ALTER TABLE [dbo].[SpawnObjects]  WITH CHECK ADD  CONSTRAINT [FK_SpawnObjects_NPCGroupID] FOREIGN KEY([NPCGroupID])
REFERENCES [dbo].[NPCGroups] ([NPCGroupID])
GO
ALTER TABLE [dbo].[SpawnObjects] CHECK CONSTRAINT [FK_SpawnObjects_NPCGroupID]
GO
ALTER TABLE [dbo].[SpawnObjects]  WITH CHECK ADD  CONSTRAINT [FK_SpawnObjects_SpawnID] FOREIGN KEY([SpawnID])
REFERENCES [dbo].[Spawns] ([SpawnID])
GO
ALTER TABLE [dbo].[SpawnObjects] CHECK CONSTRAINT [FK_SpawnObjects_SpawnID]
GO
ALTER TABLE [dbo].[Spawns]  WITH CHECK ADD  CONSTRAINT [FK_Spawns_SpawnObjectTypeID] FOREIGN KEY([SpawnObjectTypeID])
REFERENCES [dbo].[SpawnObjectType] ([SpawnObjectTypeID])
GO
ALTER TABLE [dbo].[Spawns] CHECK CONSTRAINT [FK_Spawns_SpawnObjectTypeID]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [fk_Users_RoleID] FOREIGN KEY([RoleID])
REFERENCES [dbo].[DMRoleDomain] ([DMRoleDomainID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [fk_Users_RoleID]
GO
ALTER TABLE [dbo].[PCBases]  WITH CHECK ADD  CONSTRAINT [CK_PCBases_Sector] CHECK  (([Sector]='SE' OR [Sector]='SW' OR [Sector]='NE' OR [Sector]='NW' OR [Sector]='AP'))
GO
ALTER TABLE [dbo].[PCBases] CHECK CONSTRAINT [CK_PCBases_Sector]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAreaWalkmeshes]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-09-07
-- Description:	Removes all walkmesh tiles for a given area ID
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAreaWalkmeshes]
	@AreaID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM dbo.AreaWalkmesh
			WHERE AreaID = @AreaID

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		RAISERROR('Failed to delete all of baked area''s walkmeshes. ID = (DeleteAreaWalkmeshes)', -1, -1)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoriesAvailableToPC]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns crafting categories available for player based on
--				perk and skill levels.
-- =============================================
CREATE PROCEDURE [dbo].[GetCategoriesAvailableToPC]
	@PlayerID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT cbc.CraftBlueprintCategoryID ,
       cbc.Name ,
       cbc.IsActive
	FROM dbo.CraftBlueprintCategories cbc
	WHERE cbc.CraftBlueprintCategoryID IN (
		SELECT DISTINCT cb2.CraftCategoryID
		FROM dbo.CraftBlueprints AS cb2
		JOIN dbo.PCSkills pcs ON pcs.PlayerID = @PlayerID
		LEFT JOIN dbo.PCPerks pcp ON (cb2.PerkID IS NULL OR pcp.PerkID = cb2.PerkID)
			AND (pcp.PerkLevel >= cb2.RequiredPerkLevel)
			AND (pcs.PlayerID = pcp.PlayerID)
		WHERE cb2.IsActive = 1
			AND (cb2.BaseLevel <= pcs.Rank+5)
			AND (pcp.PCPerkID IS NOT NULL OR cb2.PerkID IS NULL)
	)
		AND cbc.IsActive = 1
	ORDER BY cbc.Name ASC
END


GO
/****** Object:  StoredProcedure [dbo].[GetCraftCategoriesAvailableToPCByDeviceID]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns all craft categories available to a PC
--				based on the device, their perks, and their skill levels.
-- =============================================
CREATE PROCEDURE [dbo].[GetCraftCategoriesAvailableToPCByDeviceID]
	@DeviceID INT,
	@PlayerID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT cbc.CraftBlueprintCategoryID ,
       cbc.Name ,
       cbc.IsActive
	FROM dbo.CraftBlueprintCategories cbc
	WHERE cbc.CraftBlueprintCategoryID IN (
		SELECT DISTINCT cb2.CraftCategoryID
		FROM dbo.CraftBlueprints AS cb2
		JOIN dbo.PCSkills pcs ON pcs.PlayerID = @PlayerID
		LEFT JOIN dbo.PCPerks pcp ON (cb2.PerkID IS NULL OR pcp.PerkID = cb2.PerkID)
			AND (pcp.PerkLevel >= cb2.RequiredPerkLevel)
			AND (pcs.PlayerID = pcp.PlayerID)
		WHERE cb2.IsActive = 1
			AND (cb2.BaseLevel <= pcs.Rank+5)
			AND (pcp.PCPerkID IS NOT NULL OR cb2.PerkID IS NULL)
			AND cb2.CraftDeviceID = @DeviceID
	)
		AND cbc.IsActive = 1
	ORDER BY cbc.Name ASC

END


GO
/****** Object:  StoredProcedure [dbo].[GetPCBlueprintsByCategoryID]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns the craft blueprints available to PC
--				based on skill and perk levels.
-- =============================================
CREATE PROCEDURE [dbo].[GetPCBlueprintsByCategoryID]
	@PlayerID NVARCHAR(60),
	@CraftCategoryID INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT cb2.CraftBlueprintID ,
           cb2.CraftCategoryID ,
           cb2.BaseLevel ,
           cb2.ItemName ,
           cb2.ItemResref ,
           cb2.Quantity ,
           cb2.SkillID ,
           cb2.CraftDeviceID ,
           cb2.PerkID ,
           cb2.RequiredPerkLevel ,
           cb2.IsActive ,
           cb2.MainComponentTypeID ,
           cb2.MainMinimum ,
           cb2.SecondaryComponentTypeID ,
           cb2.SecondaryMinimum ,
           cb2.TertiaryComponentTypeID ,
           cb2.TertiaryMinimum ,
           cb2.EnhancementSlots,
		   cb2.MainMaximum,
		   cb2.SecondaryMaximum,
		   cb2.TertiaryMaximum,
		   cb2.BaseStructureID
	FROM dbo.CraftBlueprints AS cb2
	JOIN dbo.PCSkills pcs ON pcs.PlayerID = @PlayerID AND cb2.SkillID = pcs.SkillID
	LEFT JOIN dbo.PCPerks pcp ON (cb2.PerkID IS NULL OR pcp.PerkID = cb2.PerkID)
		AND (pcp.PerkLevel >= cb2.RequiredPerkLevel)
		AND (pcs.PlayerID = pcp.PlayerID)
	WHERE cb2.IsActive = 1
		AND (cb2.BaseLevel <= pcs.Rank+5)
		AND (pcp.PCPerkID IS NOT NULL OR cb2.PerkID IS NULL)
		AND cb2.CraftCategoryID = @CraftCategoryID
END






GO
/****** Object:  StoredProcedure [dbo].[GetPCCraftBlueprintsByDeviceAndCategoryID]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns the available craft blueprints for a player
--				based on their skill, perks, and the device type
-- =============================================
CREATE PROCEDURE [dbo].[GetPCCraftBlueprintsByDeviceAndCategoryID]
	@DeviceID INT,
	@CraftCategoryID INT,
	@PlayerID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT cb2.CraftBlueprintID ,
           cb2.CraftCategoryID ,
           cb2.BaseLevel ,
           cb2.ItemName ,
           cb2.ItemResref ,
           cb2.Quantity ,
           cb2.SkillID ,
           cb2.CraftDeviceID ,
           cb2.PerkID ,
           cb2.RequiredPerkLevel ,
           cb2.IsActive ,
           cb2.MainComponentTypeID ,
           cb2.MainMinimum ,
           cb2.SecondaryComponentTypeID ,
           cb2.SecondaryMinimum ,
           cb2.TertiaryComponentTypeID ,
           cb2.TertiaryMinimum ,
           cb2.EnhancementSlots ,
           cb2.MainMaximum ,
           cb2.SecondaryMaximum ,
           cb2.TertiaryMaximum,
		   cb2.BaseStructureID
	FROM dbo.CraftBlueprints AS cb2
	JOIN dbo.PCSkills pcs ON pcs.PlayerID = @PlayerID AND cb2.SkillID = pcs.SkillID
	LEFT JOIN dbo.PCPerks pcp ON (cb2.PerkID IS NULL OR pcp.PerkID = cb2.PerkID)
		AND (pcp.PerkLevel >= cb2.RequiredPerkLevel)
		AND (pcs.PlayerID = pcp.PlayerID)
	WHERE cb2.IsActive = 1
		AND (cb2.BaseLevel <= pcs.Rank+5)
		AND (pcp.PCPerkID IS NOT NULL OR cb2.PerkID IS NULL)
		AND cb2.CraftDeviceID = @DeviceID
		AND cb2.CraftCategoryID = @CraftCategoryID
END







GO
/****** Object:  StoredProcedure [dbo].[GetPCPerksByExecutionType]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns the perks available to player which match the specified execution type.
-- =============================================
CREATE PROCEDURE [dbo].[GetPCPerksByExecutionType]
	@PlayerID NVARCHAR(60),
	@ExecutionTypeID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT pcp.PCPerkID ,
		   pcp.PlayerID ,
		   pcp.AcquiredDate ,
		   pcp.PerkID ,
		   pcp.PerkLevel
	FROM dbo.PCPerks pcp
	CROSS APPLY dbo.fn_GetPlayerEffectivePerkLevel(pcp.PlayerID, pcp.PerkID, NULL) ap
	JOIN dbo.Perks p ON p.PerkID = pcp.PerkID
	WHERE pcp.PlayerID = @PlayerID
		AND p.ExecutionTypeID = @ExecutionTypeID
END
GO
/****** Object:  StoredProcedure [dbo].[GetPCPerksForMenuHeader]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns perk data used for menu headers
-- =============================================
CREATE PROCEDURE [dbo].[GetPCPerksForMenuHeader]
	@PlayerID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT pcp.PCPerkID,
		   p.Name AS Name,
		   pcp.PerkLevel AS Level,
		   pl.Description AS BonusDescription
	FROM dbo.PCPerks pcp
	JOIN dbo.Perks p ON p.PerkID = pcp.PerkID
	JOIN dbo.PerkLevels pl ON pl.PerkID = p.PerkID AND pl.Level = pcp.PerkLevel
	WHERE pcp.PlayerID = @PlayerID
	ORDER BY p.Name
END


GO
/****** Object:  StoredProcedure [dbo].[GetPCPerksWithExecutionType]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns all PCPerks for a given player ID which also have
--				execution types.
-- =============================================
CREATE PROCEDURE [dbo].[GetPCPerksWithExecutionType]
	@PlayerID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT pcp.PCPerkID ,
		   pcp.PlayerID ,
		   pcp.AcquiredDate ,
		   pcp.PerkID ,
		   pcp.PerkLevel
	FROM dbo.PCPerks pcp
	CROSS APPLY dbo.fn_GetPlayerEffectivePerkLevel(pcp.PlayerID, pcp.PerkID, NULL) ap
	JOIN dbo.Perks p ON p.PerkID = pcp.PerkID
	WHERE pcp.PlayerID = @PlayerID
		AND p.ExecutionTypeID > 0

END

GO
/****** Object:  StoredProcedure [dbo].[GetPCSkillAdjustedPerkLevel]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns player's skill-adjusted perk level.
-- =============================================
CREATE PROCEDURE [dbo].[GetPCSkillAdjustedPerkLevel]
	@PlayerID NVARCHAR(60),
	@PerkID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT PerkLevelID ,
       PerkID ,
       Level ,
       Price ,
       Description
	FROM dbo.fn_GetPlayerEffectivePerkLevel(@PlayerID, @PerkID, NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[GetPerkCategoriesForPC]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Get available perk categories for PC
-- =============================================
CREATE PROCEDURE [dbo].[GetPerkCategoriesForPC]
	@PlayerID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT pc.PerkCategoryID ,
		   pc.Name ,
		   pc.IsActive ,
		   pc.Sequence
	FROM dbo.PerkCategories pc
	WHERE pc.PerkCategoryID IN (
		SELECT DISTINCT pc.PerkCategoryID
		FROM dbo.PerkCategories pc
		JOIN dbo.Perks p ON p.PerkCategoryID = pc.PerkCategoryID
		JOIN dbo.PlayerCharacters plc ON plc.PlayerID = @PlayerID
		LEFT JOIN dbo.PerkLevels pl ON pl.PerkID = p.PerkID
		LEFT JOIN dbo.PerkLevelSkillRequirements psr ON psr.PerkLevelID = pl.PerkLevelID
		LEFT JOIN dbo.PerkLevelQuestRequirements pqr ON pqr.PerkLevelID = pl.PerkLevelID
		LEFT JOIN dbo.PCSkills pcsk ON pcsk.PlayerID = plc.PlayerID AND pcsk.SkillID = psr.SkillID
		LEFT JOIN dbo.PCQuestStatus pqs ON pqs.PlayerID = plc.PlayerID AND pqs.QuestID = pqr.RequiredQuestID
		WHERE (psr.SkillID IS NULL OR psr.SkillID = pcsk.SkillID)
			AND (psr.RequiredRank IS NULL OR psr.RequiredRank <= pcsk.Rank)
			AND (pqr.RequiredQuestID IS NULL OR (pqr.RequiredQuestID = pqs.QuestID AND pqs.CompletionDate IS NOT NULL))
			AND pc.IsActive = 1
	)
	ORDER BY pc.Sequence

END

GO
/****** Object:  StoredProcedure [dbo].[GetPerksForPC]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-11
-- Description:	Returns all perks available to purchase for PC
-- =============================================
CREATE PROCEDURE [dbo].[GetPerksForPC]
	@PlayerID NVARCHAR(60),
	@CategoryID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	SELECT p.PerkID ,
           p.Name ,
           p.FeatID ,
           p.IsActive ,
           p.ScriptName ,
           p.BaseFPCost ,
           p.BaseCastingTime ,
           p.Description ,
           p.PerkCategoryID ,
           p.CooldownCategoryID ,
           p.ExecutionTypeID ,
           p.ItemResref ,
           p.IsTargetSelfOnly ,
           p.Enmity ,
           p.EnmityAdjustmentRuleID,
		   p.CastAnimationID
	FROM dbo.Perks p
	WHERE p.PerkID IN (
		SELECT DISTINCT p.PerkID
		FROM dbo.Perks p
		JOIN dbo.PlayerCharacters plc ON plc.PlayerID = @PlayerID
		LEFT JOIN dbo.PerkLevels pl ON pl.PerkID = p.PerkID
		LEFT JOIN dbo.PerkLevelSkillRequirements plsr ON plsr.PerkLevelID = pl.PerkLevelID
		LEFT JOIN dbo.PerkLevelQuestRequirements pqr ON pqr.PerkLevelID = pl.PerkLevelID
		LEFT JOIN dbo.PCSkills pcsk ON pcsk.PlayerID = plc.PlayerID AND plsr.SkillID = pcsk.SkillID
		LEFT JOIN dbo.PCQuestStatus pqs ON pqs.PlayerID = plc.PlayerID AND pqs.QuestID = pqr.RequiredQuestID
		WHERE (plsr.SkillID IS NULL OR plsr.SkillID = pcsk.SkillID)
			AND (plsr.RequiredRank IS NULL OR plsr.RequiredRank <= pcsk.Rank)
			AND (pqr.RequiredQuestID IS NULL OR (pqr.RequiredQuestID = pqs.QuestID AND pqs.CompletionDate IS NOT NULL))
			AND p.PerkCategoryID = @CategoryID
			AND p.IsActive = 1
	)

END


GO
/****** Object:  StoredProcedure [dbo].[GetTotalXPAmountsForPC]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-10
-- Description:	Returns a result set containing the skill ID and total skill XP earned by a player.
-- =============================================
CREATE PROCEDURE [dbo].[GetTotalXPAmountsForPC]
	@PlayerID NVARCHAR(60),
	@SkillID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	SELECT pcs.SkillID, CAST(SUM(xp.XP) + pcs.XP AS INTEGER) AS TotalSkillXP
	FROM dbo.PCSkills pcs
	JOIN dbo.SkillXPRequirement xp ON xp.SkillID = pcs.SkillID AND ((xp.Rank < pcs.Rank) OR (xp.Rank = 0 AND pcs.XP > 0))
	WHERE pcs.IsLocked = 0
		AND pcs.PlayerID = @PlayerID
		AND pcs.SkillID <> @SkillID
	GROUP BY pcs.SkillID, pcs.XP
	ORDER BY pcs.SkillID

END
GO
/****** Object:  StoredProcedure [dbo].[InsertAllPCSkillsByID]    Script Date: 10/22/2018 1:38:11 AM ******/

-- =============================================
-- Author:		zunath
-- Create date: 2018-08-10
-- Description:	Inserts any missing PCSkills records on player module entry.
-- =============================================
CREATE PROCEDURE [dbo].[InsertAllPCSkillsByID]
	@PlayerID NVARCHAR(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO dbo.PCSkills ( PlayerID ,
									   SkillID ,
									   XP ,
									   Rank,
									   IsLocked)
			SELECT @PlayerID,
				s.SkillID,
				0,
				0,
				0
			FROM dbo.Skills s
			WHERE s.SkillID NOT IN (
				SELECT pcs.SkillID
				FROM dbo.PCSkills pcs
				WHERE pcs.PlayerID = @PlayerID
			)

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		RAISERROR('Failed to insert all PC Skills from OnModuleEnter. (InsertAllPCSkillsByID)', -1, -1)
	END CATCH
END
GO