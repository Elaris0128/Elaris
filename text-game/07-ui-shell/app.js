(function () {
  "use strict";

  const runtime = window.elarisRuntimeData || {};
  const fallback = window.prototypeData || {};
  const LOCAL_SAVE_KEY = "elaris.uiShell.localSaves.v1";

  const refs = {
    appShell: document.getElementById("app-shell"),
    leftRail: document.getElementById("left-rail"),
    leftRailBrandToggle: document.getElementById("left-rail-brand-toggle"),
    leftRailToggle: document.getElementById("left-rail-toggle"),
    rightRail: document.getElementById("right-rail"),
    rightRailToggle: document.getElementById("right-rail-toggle"),
    rightRailClose: document.getElementById("right-rail-close"),
    screens: document.querySelectorAll(".screen"),
    navButtons: document.querySelectorAll(".nav-btn"),
    modalButtons: document.querySelectorAll("[data-modal]"),
    dockButtons: document.querySelectorAll(".dock-btn"),
    drawerShell: document.getElementById("drawer-shell"),
    drawerTitle: document.getElementById("drawer-title"),
    drawerBody: document.getElementById("drawer-body"),
    drawerClose: document.getElementById("drawer-close"),
    adventurePopout: document.getElementById("adventure-popout"),
    adventurePopoutTitle: document.getElementById("adventure-popout-title"),
    adventurePopoutBody: document.getElementById("adventure-popout-body"),
    adventurePopoutClose: document.getElementById("adventure-popout-close"),
    summaryBody: document.getElementById("summary-body"),
    systemCurrentSlice: document.getElementById("system-current-slice"),
    systemCurrentMode: document.getElementById("system-current-mode"),
    systemUiState: document.getElementById("system-ui-state"),
    ingameBannerTitle: document.getElementById("ingame-banner-title"),
    ingameBannerCopy: document.getElementById("ingame-banner-copy"),
    openingTitle: document.getElementById("opening-title"),
    openingCopy: document.getElementById("opening-copy"),
    sceneLocationTitle: document.getElementById("scene-location-title"),
    sceneCopy: document.getElementById("scene-copy"),
    choiceGrid: document.getElementById("choice-grid"),
    setupStepper: document.getElementById("setup-stepper"),
    setupRaceGroups: document.getElementById("setup-race-groups"),
    setupRaces: document.getElementById("setup-races"),
    setupIdentities: document.getElementById("setup-identities"),
    setupAgeStages: document.getElementById("setup-age-stages"),
    setupGenders: document.getElementById("setup-genders"),
    setupInterests: document.getElementById("setup-interests"),
    setupPersonalities: document.getElementById("setup-personalities"),
    setupHabits: document.getElementById("setup-habits"),
    setupSlices: document.getElementById("setup-slices"),
    setupStarts: document.getElementById("setup-starts"),
    playerNameInput: document.getElementById("player-name-input"),
    setupSummary: document.getElementById("setup-summary"),
    setupBack: document.getElementById("setup-back"),
    setupNext: document.getElementById("setup-next"),
    confirmStart: document.getElementById("confirm-start"),
    continueBody: document.getElementById("continue-body"),
    saveCatalogBody: document.getElementById("save-catalog-body"),
    noticeTitle: document.getElementById("notice-title"),
    noticeBody: document.getElementById("notice-body"),
    settingSoftBackground: document.getElementById("setting-soft-background"),
    settingShowOpening: document.getElementById("setting-show-opening"),
    settingShowSummary: document.getElementById("setting-show-summary"),
    modals: document.querySelectorAll(".modal"),
    debugPanel: document.getElementById("debug-panel"),
  };

  const state = {
    screen: "menu",
    activeModal: null,
    setupStep: 1,
    activeDrawer: null,
    leftCollapsed: true,
    rightCollapsed: true,
    activeVariant: "observe",
    selectedRaceGroupId: null,
    selectedRaceId: null,
    selectedSliceId: null,
    selectedIdentityId: null,
    selectedAgeStageId: null,
    selectedGenderId: null,
    selectedInterestId: null,
    selectedPersonalityId: null,
    selectedHabitId: null,
    selectedStartId: null,
    selectedSaveId: null,
    currentSave: null,
    localSaves: [],
    playerName: "",
    settings: {
      softBackground: false,
      showOpening: true,
      showSummary: true,
    },
  };

  const drawerLabels = {
    quests: "任務",
    inventory: "背包",
    companions: "同行",
    relations: "關係",
    map: "地圖",
  };

  const timeLabels = {
    dawn: "晨潮",
    day: "日潮",
    dusk: "暮潮",
    night: "夜潮",
  };

  const defaultRaceGroups = [
    { id: "human", title: "人類", note: "先選人類，再選具體族群，例如諾魯因人、極光徙裔或柯沙里人。" },
    { id: "seafolk", title: "海人", note: "海人需要再選三大正式分支之一。" },
    { id: "elf", title: "精靈", note: "精靈需要再選正式十支之一。" },
    { id: "orc", title: "獸人", note: "獸人需要再選正式支系；十獸之環的席位屬於支系內部細節。" },
    { id: "demon", title: "魔人", note: "魔人需要再選七血裔之一。" },
    { id: "avian", title: "翼人", note: "直接可選種族，下一步會以本族作為分支確認。" },
    { id: "dwarf", title: "矮人", note: "直接可選種族，起始區域為杜羅山邦。" },
    { id: "goblin", title: "地精", note: "直接可選種族，起始區域為杜魯摩克隱域。" },
    { id: "forest-runner", title: "森馳裔", note: "直接可選種族，下一步會以本族作為分支確認。" },
  ];

  const humanRaceIds = new Set([
    "faao",
    "valewin",
    "farean",
    "aurora-migrant",
    "xiaoyang",
    "cliffshadow",
    "rockdome",
    "salruun",
    "koshari",
    "noruin",
  ]);

  const defaultChoices = {
    observe: {
      title: "先把眼前看清",
      paragraphs: [
        "你先不急著證明自己，只讓眼睛和呼吸都回到能做判斷的節奏。真正會害死人的，往往不是謹慎，而是匆忙。",
      ],
    },
    talk: {
      title: "先聽別人怎麼說",
      paragraphs: [
        "你先把話留給熟手。很多真正有用的資訊，不在一句完整的答案裡，而在那一下欲言又止的停頓。",
      ],
    },
    move: {
      title: "先換個角度",
      paragraphs: [
        "你先換了一個站位，再重新看整個局面。從另一個角度看過去，原本看起來平順的地方開始露出不自然的節奏。",
      ],
    },
    rest: {
      title: "先把自己安頓好",
      paragraphs: [
        "你先理順肩上的東西、手裡的工具和自己的呼吸。很多局面，得先把自己安頓好，才會開始講理。",
      ],
    },
  };

  function toArray(value) {
    return Array.isArray(value) ? value : [];
  }

  function firstItem(items) {
    return toArray(items)[0] || null;
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function showDebug(error) {
    if (!refs.debugPanel) return;
    refs.debugPanel.hidden = false;
    refs.debugPanel.textContent = error && error.stack ? error.stack : String(error);
  }

  function cloneData(value) {
    try {
      return JSON.parse(JSON.stringify(value));
    } catch (_error) {
      return value;
    }
  }

  function makeId(prefix) {
    return `${prefix}-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 8)}`;
  }

  function loadLocalSaves() {
    try {
      const raw = window.localStorage?.getItem(LOCAL_SAVE_KEY);
      state.localSaves = raw ? toArray(JSON.parse(raw)) : [];
    } catch (_error) {
      state.localSaves = [];
    }
  }

  function persistLocalSaves() {
    try {
      window.localStorage?.setItem(LOCAL_SAVE_KEY, JSON.stringify(state.localSaves));
    } catch (error) {
      console.warn("Unable to persist local Elaris saves.", error);
    }
  }

  function upsertLocalSave(save) {
    if (!save?.id) return;
    const cloned = cloneData(save);
    state.localSaves = [cloned, ...state.localSaves.filter((item) => item.id !== cloned.id)];
    state.currentSave = cloned;
    state.selectedSaveId = cloned.id;
    persistLocalSaves();
  }

  window.addEventListener("error", (event) => showDebug(event.error || event.message));
  window.addEventListener("unhandledrejection", (event) => showDebug(event.reason || event));

  function getSliceList() {
    const runtimeSlices = toArray(runtime.slices);
    const fallbackSlices = toArray(fallback.slices);
    if (!runtimeSlices.length) return fallbackSlices;
    const runtimeIds = new Set(runtimeSlices.map((slice) => slice.id));
    return [...runtimeSlices, ...fallbackSlices.filter((slice) => !runtimeIds.has(slice.id))];
  }

  function getRaceList() {
    const runtimeRaces = toArray(runtime.playableRaces);
    return runtimeRaces.length ? runtimeRaces : toArray(fallback.playableRaces);
  }

  function raceGroupIdForRace(race) {
    if (!race) return null;
    if (race.groupId || race.raceGroupId || race.speciesId) {
      return race.groupId || race.raceGroupId || race.speciesId;
    }
    if (humanRaceIds.has(race.id)) return "human";
    if (race.id === "avian") return "avian";
    if (race.id === "dwarf") return "dwarf";
    if (race.id === "goblin") return "goblin";
    if (race.id === "forest-runner") return "forest-runner";
    if (String(race.kind || "").includes("海人")) return "seafolk";
    if (String(race.kind || "").includes("精靈")) return "elf";
    if (String(race.kind || "").includes("獸人") || String(race.kind || "").includes("十獸之環")) return "orc";
    if (String(race.kind || "").includes("魔人")) return "demon";
    return "human";
  }

  function isInternalRaceOption(race) {
    const kind = String(race.kind || "");
    return kind.includes("分類") || kind.includes("內部席位") || kind.includes("細席位");
  }

  function getRaceGroupList() {
    const raceGroups = toArray(fallback.raceGroups);
    return raceGroups.length ? raceGroups : defaultRaceGroups;
  }

  function branchesForRaceGroup(groupId) {
    return getRaceList().filter((race) => raceGroupIdForRace(race) === groupId && !isInternalRaceOption(race));
  }

  function getIdentityList() {
    return toArray(fallback.identities);
  }

  function getAgeStageList() {
    return toArray(fallback.ageStages);
  }

  function getGenderList() {
    return toArray(fallback.genders);
  }

  function getInterestList() {
    return toArray(fallback.interests);
  }

  function getPersonalityList() {
    return toArray(fallback.personalities);
  }

  function getHabitList() {
    return toArray(fallback.habits);
  }

  function getSaveList() {
    const runtimeSaves = toArray(runtime.saves);
    const baseSaves = runtimeSaves.length ? runtimeSaves : toArray(fallback.saves);
    const localIds = new Set(state.localSaves.map((item) => item.id));
    return [...state.localSaves, ...baseSaves.filter((item) => !localIds.has(item.id))];
  }

  function sliceById(sliceId) {
    return getSliceList().find((item) => item.id === sliceId) || null;
  }

  function currentRaceGroup() {
    const groups = getRaceGroupList();
    return groups.find((item) => item.id === state.selectedRaceGroupId) || firstItem(groups);
  }

  function currentRace() {
    const races = branchesForRaceGroup(state.selectedRaceGroupId);
    return races.find((item) => item.id === state.selectedRaceId) || firstItem(races);
  }

  function raceSlice(race = currentRace()) {
    return sliceById(race?.startRegionId);
  }

  function applyRaceSelection(raceId) {
    const race = branchesForRaceGroup(state.selectedRaceGroupId).find((item) => item.id === raceId) || currentRace();
    state.selectedRaceId = race?.id || null;
    state.selectedRaceGroupId = raceGroupIdForRace(race) || state.selectedRaceGroupId;
    syncRegionSelection({ forceRaceRegion: currentIdentity()?.regionMode === "local" });
  }

  function applyRaceGroupSelection(groupId) {
    const group = getRaceGroupList().find((item) => item.id === groupId) || currentRaceGroup();
    state.selectedRaceGroupId = group?.id || null;
    const branches = branchesForRaceGroup(state.selectedRaceGroupId);
    const branch = branches.find((item) => sliceById(item.startRegionId)) || firstItem(branches);
    state.selectedRaceId = branch?.id || null;
    syncRegionSelection({ forceRaceRegion: currentIdentity()?.regionMode === "local" });
  }

  function currentSlice() {
    return sliceById(state.selectedSliceId) || raceSlice() || null;
  }

  function playableSlices() {
    return getSliceList().filter((slice) => toArray(slice?.starts).length);
  }

  function setupRegionOptions() {
    const identity = currentIdentity();
    const raceDefaultSlice = raceSlice();
    const allSlices = playableSlices();
    if (identity?.regionMode === "local") {
      return raceDefaultSlice ? [raceDefaultSlice] : [];
    }

    const recommendedIds = new Set(toArray(identity?.recommendedRegionIds));
    const sorted = [...allSlices].sort((a, b) => {
      const aScore = recommendedIds.has(a.id) ? 0 : 1;
      const bScore = recommendedIds.has(b.id) ? 0 : 1;
      return aScore - bScore || String(a.title || "").localeCompare(String(b.title || ""), "zh-Hant");
    });

    if (identity?.regionMode === "crisis") return sorted;
    if (raceDefaultSlice && !sorted.some((slice) => slice.id === raceDefaultSlice.id)) {
      return [raceDefaultSlice, ...sorted];
    }
    return sorted;
  }

  function syncRegionSelection(options = {}) {
    const { forceRaceRegion = false } = options;
    const identity = currentIdentity();
    const regions = setupRegionOptions();
    const raceDefaultSlice = raceSlice();
    const current = regions.find((slice) => slice.id === state.selectedSliceId);
    let nextSlice = current || null;

    if (!nextSlice || forceRaceRegion || identity?.regionMode === "local") {
      nextSlice = (raceDefaultSlice && regions.find((slice) => slice.id === raceDefaultSlice.id))
        || firstItem(regions);
    }

    state.selectedSliceId = nextSlice?.id || null;
    const starts = toArray(nextSlice?.starts);
    if (!starts.find((item) => item.id === state.selectedStartId)) {
      state.selectedStartId = firstItem(starts)?.id || null;
    }
  }

  function currentStart() {
    const starts = toArray(currentSlice()?.starts);
    return starts.find((item) => item.id === state.selectedStartId) || firstItem(starts);
  }

  function currentIdentity() {
    const identities = getIdentityList();
    return identities.find((item) => item.id === state.selectedIdentityId) || firstItem(identities);
  }

  function currentAgeStage() {
    const ageStages = getAgeStageList();
    return ageStages.find((item) => item.id === state.selectedAgeStageId) || firstItem(ageStages);
  }

  function currentGender() {
    const genders = getGenderList();
    return genders.find((item) => item.id === state.selectedGenderId) || firstItem(genders);
  }

  function currentInterest() {
    const interests = getInterestList();
    return interests.find((item) => item.id === state.selectedInterestId) || firstItem(interests);
  }

  function currentPersonality() {
    const personalities = getPersonalityList();
    return personalities.find((item) => item.id === state.selectedPersonalityId) || firstItem(personalities);
  }

  function currentHabit() {
    const habits = getHabitList();
    return habits.find((item) => item.id === state.selectedHabitId) || firstItem(habits);
  }

  function currentSave() {
    if (state.currentSave) return state.currentSave;
    const saves = getSaveList();
    return saves.find((item) => item.id === state.selectedSaveId) || null;
  }

  function currentQuest() {
    const save = currentSave();
    const questId = save?.activeQuest?.questId;
    return toArray(currentSlice()?.starterQuestPool).find((item) => item.questId === questId) || firstItem(currentSlice()?.starterQuestPool);
  }

  function currentQuestStep() {
    const save = currentSave();
    const stepIndex = save?.activeQuest?.stepIndex || 0;
    return toArray(currentQuest()?.progress?.steps)[stepIndex] || null;
  }

  function currentTimeLabel(save) {
    const timeOfDay = save?.locationState?.timeOfDay || "dawn";
    return timeLabels[timeOfDay] || timeOfDay;
  }

  function advanceTime(save) {
    const order = ["dawn", "day", "dusk", "night"];
    const locationState = save.locationState || {};
    const currentIndex = Math.max(0, order.indexOf(locationState.timeOfDay || "dawn"));
    const nextIndex = (currentIndex + 1) % order.length;
    locationState.timeOfDay = order[nextIndex];
    if (nextIndex === 0) locationState.dayCount = (locationState.dayCount || 1) + 1;
    save.locationState = locationState;
    save.time = `Day ${locationState.dayCount || 1} / ${currentTimeLabel(save)}`;
  }

  function addUnique(list, value, key = null) {
    const items = toArray(list);
    if (value === undefined || value === null || value === "") return items;
    const exists = items.some((item) => {
      if (!key) return item === value;
      return item?.[key] === value?.[key];
    });
    return exists ? items : [...items, value];
  }

  function findFirstNpc(save) {
    const slice = currentSlice();
    const linkedIds = toArray(save?.linkedNpcIds);
    return toArray(slice?.npcHooks).find((npc) => linkedIds.includes(npc.id)) || firstItem(slice?.npcHooks);
  }

  function ensureRelation(save, npc, patch = {}) {
    if (!npc?.id) return;
    const relations = toArray(save.relations);
    const existing = relations.find((relation) => relation.npcId === npc.id);
    if (existing) {
      Object.assign(existing, patch);
    } else {
      relations.push({
        npcId: npc.id,
        name: npc.name,
        label: patch.label || npc.initialRelation || "剛認識",
        summary: patch.summary || "對方開始記得你做過的事。",
      });
    }
    save.relations = relations;
    save.linkedNpcIds = addUnique(save.linkedNpcIds, npc.id);
  }

  function parseQuestReward(quest) {
    return toArray(quest?.rewardPreview).reduce((result, reward) => {
      const text = String(reward || "");
      const currencyMatch = text.match(/\+(\d+)/);
      if (text.includes("潮刻") && currencyMatch) {
        result.currency += Number(currencyMatch[1]);
      } else if (text) {
        result.items.push({
          name: text,
          category: text.includes("熟面孔") ? "關係" : "任務物",
          quantity: 1,
          note: "任務報酬。",
        });
      }
      return result;
    }, { currency: 0, items: [] });
  }

  function createOpeningSeed(identity, race, slice) {
    if (identity?.id === "wanderer") {
      return {
        type: "memory",
        title: "尋憶種子",
        summary: `${race?.title || "你的出身"}、${slice?.title || "這片地方"}與身上的模糊信物之間，藏著第一段可追的記憶。`,
        firstLead: "先找出誰認得你身上的信物，或哪個地方會對你的身體特徵、口音、器官反應產生回應。",
      };
    }
    if (identity?.id === "displaced") {
      return {
        type: "aftermath",
        title: "劫後種子",
        summary: `${slice?.title || "這片地方"}留下了戰爭、魔物或災禍的痕跡。你可以追索失去的源頭，也可以先讓自己活下去。`,
        firstLead: "先確認你逃來的路上，哪一段仍在出事，哪一個人還需要被帶離危險。",
      };
    }
    return {
      type: "daily-life",
      title: "日常種子",
      summary: `你原本就在${slice?.title || "當地"}生活。今天沒有強制任務，只有你想怎麼開始。`,
      firstLead: "先選擇今天要做的事：找活、學手藝、拜訪熟人、照看家務，或去看看最近不太對勁的地方。",
    };
  }

  function createPlayableSave() {
    const raceGroup = currentRaceGroup();
    const race = currentRace();
    const slice = currentSlice() || raceSlice(race);
    const starts = toArray(slice?.starts);
    const start = starts.find((item) => item.id === state.selectedStartId) || firstItem(starts);
    if (!slice || !start) return null;

    const identity = currentIdentity();
    const ageStage = currentAgeStage();
    const gender = currentGender();
    const interest = currentInterest();
    const personality = currentPersonality();
    const habit = currentHabit();
    const quest = toArray(slice?.starterQuestPool).find((item) => item.questId === start?.recommendedFirstQuest) || firstItem(slice?.starterQuestPool);
    const name = state.playerName || refs.playerNameInput?.value?.trim() || "無名旅人";
    const starterItems = [...toArray(identity?.starterItems), ...toArray(identity?.starterContainers)];
    const openingSeed = createOpeningSeed(identity, race, slice);

    return {
      id: makeId("save"),
      title: name,
      slice: slice?.id || "whispersea",
      location: start?.title || "未知地點",
      time: "Day 1 / 晨潮",
      note: `Active: ${quest?.questId || "none"}`,
      currentSceneId: start?.id || null,
      character: {
        name,
        race: raceGroup?.title || race?.title || "未定",
        branch: race?.title || "未定",
        blankSlateStatus: identity?.title || "未定",
        ageStage: ageStage?.title || "未定",
        gender: gender?.title || "未定",
        pronoun: gender?.pronoun || "",
        interest: interest?.title || "未定",
        personality: personality?.title || "未定",
        habit: habit?.title || "未定",
        tags: [raceGroup?.title, race?.title, race?.regionLabel, slice?.title, start?.title, identity?.title].filter(Boolean),
      },
      raceGroupId: raceGroup?.id || null,
      raceGroupTitle: raceGroup?.title || "未定",
      raceId: race?.id || null,
      startRegionLabel: slice?.title || race?.regionLabel || "未定",
      openingPack: race?.openingPack || "未定",
      locationState: {
        currentRegionId: slice?.id || "whispersea",
        currentSceneId: start?.id || null,
        currentSceneName: start?.title || "未知地點",
        timeOfDay: "dawn",
        dayCount: 1,
        exploredSceneIds: start?.id ? [start.id] : [],
      },
      mapState: {
        knownRegionIds: slice?.id ? [slice.id] : [],
        exploredSceneIds: start?.id ? [start.id] : [],
        currentRegionId: slice?.id || "whispersea",
        currentSceneId: start?.id || null,
      },
      inventory: {
        currency: 0,
        equippedItems: [],
        inventorySlots: starterItems.length ? starterItems : ["舊布包", "抄記板"],
        containers: toArray(identity?.starterContainers),
        groups: {
          隨身物: starterItems.length ? starterItems : ["舊布包", "抄記板"],
        },
      },
      activeQuest: {
        questId: quest?.questId || null,
        status: "active",
        stepIndex: 0,
        progressLog: "剛開始觀察局勢。",
        completedSteps: [],
      },
      clues: [],
      linkedNpcIds: [],
      companions: [],
      relations: [],
      flags: {},
      openingSeed,
      setupSource: {
        raceGroupId: raceGroup?.id || null,
        raceGroupTitle: raceGroup?.title || "未定",
        raceId: race?.id || null,
        branchTitle: race?.title || "未定",
        identityId: identity?.id || null,
        identityTitle: identity?.title || "未定",
        ageStageId: ageStage?.id || null,
        ageStageTitle: ageStage?.title || "未定",
        genderId: gender?.id || null,
        genderTitle: gender?.title || "未定",
        startRegionId: slice?.id || race?.startRegionId || null,
        startRegionLabel: slice?.title || race?.regionLabel || "未定",
        openingPack: race?.openingPack || "未定",
      },
      sceneHistory: [],
      actionLog: [],
      lastOutcome: null,
    };
  }

  function completeQuestIfReady(save, quest) {
    const steps = toArray(quest?.progress?.steps);
    if (save.activeQuest.status === "completed" || save.activeQuest.stepIndex < steps.length) return null;

    const reward = parseQuestReward(quest);
    save.activeQuest.status = "completed";
    save.activeQuest.progressLog = "任務完成，報酬已結算。";
    save.inventory.currency = (save.inventory.currency || 0) + reward.currency;
    save.inventory.inventorySlots = [
      ...toArray(save.inventory.inventorySlots),
      ...reward.items,
    ];
    const npc = findFirstNpc(save);
    ensureRelation(save, npc, {
      label: "願意多說幾句",
      summary: "你完成了第一件小事，對方開始把你當成能派上用場的人。",
    });
    return {
      title: "任務完成",
      paragraphs: [
        `你把眼前這件事收了尾。${reward.currency ? `你拿到 ${reward.currency} 潮刻。` : "這次沒有拿到潮刻。"}真正重要的是，這地方開始留下你的痕跡。`,
        reward.items.length ? `你也得到：${reward.items.map((item) => item.name).join("、")}。` : "你沒有得到物品，但換來一點信任。",
      ],
    };
  }

  function applyChoiceEffect(choiceId) {
    const save = currentSave();
    if (!save) return;

    const start = currentStart();
    const quest = currentQuest();
    const steps = toArray(quest?.progress?.steps);
    const currentStep = steps[save.activeQuest?.stepIndex] || null;
    const npc = findFirstNpc(save);
    const actionText = {
      observe: "你多看了一眼，找出一個能用的線索。",
      talk: "你開口問得不重，讓對方願意留下一點話。",
      move: "你換了位置，確認哪一段路還能走。",
      rest: "你先整理身上的東西，讓下一步不至於手忙腳亂。",
    }[choiceId] || "你先做了一個穩妥的選擇。";

    save.activeQuest = save.activeQuest || {};
    save.locationState = save.locationState || {};
    save.inventory = save.inventory || { currency: 0, inventorySlots: [] };
    save.activeQuest.completedSteps = addUnique(save.activeQuest.completedSteps, currentStep?.title || choiceId);
    save.activeQuest.stepIndex = Math.min((save.activeQuest.stepIndex || 0) + 1, steps.length);
    save.activeQuest.progressLog = currentStep?.goalText || actionText;
    save.actionLog = [
      {
        choiceId,
        text: actionText,
        time: save.time,
      },
      ...toArray(save.actionLog),
    ].slice(0, 12);
    save.sceneHistory = addUnique(save.sceneHistory, start?.id);
    save.locationState.exploredSceneIds = addUnique(save.locationState.exploredSceneIds, start?.id);
    save.mapState = save.mapState || {};
    save.mapState.knownRegionIds = addUnique(save.mapState.knownRegionIds, save.slice);
    save.mapState.exploredSceneIds = addUnique(save.mapState.exploredSceneIds, start?.id);
    save.mapState.currentRegionId = save.slice;
    save.mapState.currentSceneId = start?.id || save.currentSceneId;

    if (choiceId === "observe") {
      save.clues = addUnique(save.clues, `${start?.title || "此地"}：看見不自然的痕跡`);
    }
    if (choiceId === "talk") {
      ensureRelation(save, npc, {
        label: "記得你問過話",
        summary: "你沒有亂插手，而是先問清楚，這讓對方稍微放下戒心。",
      });
    }
    if (choiceId === "move") {
      save.clues = addUnique(save.clues, `${start?.title || "此地"}：確認可通行路線`);
    }
    if (choiceId === "rest") {
      save.inventory.inventorySlots = addUnique(save.inventory.inventorySlots, {
        name: "整理好的隨身包",
        category: "狀態",
        quantity: 1,
        note: "不是新物品，而是你把隨身物收整到能快速取用的狀態。",
      }, "name");
    }

    const completion = completeQuestIfReady(save, quest);
    save.lastOutcome = completion || {
      title: currentStep?.title || "行動完成",
      paragraphs: [
        actionText,
        steps[save.activeQuest.stepIndex]?.title
          ? `下一步：${steps[save.activeQuest.stepIndex].title}`
          : "這件事快要收尾了。",
      ],
    };
    advanceTime(save);
    save.note = save.activeQuest.status === "completed" ? "Completed first loop" : `Active: ${save.activeQuest.questId}`;
    upsertLocalSave(save);
  }

  function handleChoice(choiceId) {
    state.activeVariant = choiceId || state.activeVariant || "observe";
    applyChoiceEffect(state.activeVariant);
    renderAll();
  }

  function renderTraitCards(items, selectedId, dataAttribute) {
    return toArray(items).map((item) => `
      <button class="select-card compact-card${item.id === selectedId ? " is-selected" : ""}" ${dataAttribute}="${escapeHtml(item.id)}" type="button">
        <strong>${escapeHtml(item.title)}</strong>
        <small class="card-note">${escapeHtml(item.note || "")}</small>
        <div class="trait-meta">
          <span class="trait-chip is-bonus">加成</span>
          <small>${escapeHtml(item.bonusTitle || "未定")}</small>
        </div>
        <div class="trait-meta">
          <span class="trait-chip is-tradeoff">代價</span>
          <small>${escapeHtml(item.tradeoffTitle || "未定")}</small>
        </div>
      </button>
    `).join("");
  }

  function previewSnapshot() {
    const raceGroup = currentRaceGroup();
    const race = currentRace();
    const slice = currentSlice() || raceSlice(race);
    const starts = toArray(slice?.starts);
    const start = starts.find((item) => item.id === state.selectedStartId) || firstItem(starts);
    const identity = currentIdentity();
    const ageStage = currentAgeStage();
    const gender = currentGender();
    const interest = currentInterest();
    const personality = currentPersonality();
    const habit = currentHabit();
    const quest = toArray(slice?.starterQuestPool).find((item) => item.questId === start?.recommendedFirstQuest) || firstItem(slice?.starterQuestPool);

    return {
      name: state.playerName || "無名旅人",
      race: raceGroup?.title || race?.title || "未定",
      branch: race?.title || "未定",
      blankSlateStatus: identity?.title || "未定",
      ageStage: ageStage?.title || "未定",
      gender: gender?.title || "未定",
      interest: interest?.title || "未定",
      personality: personality?.title || "未定",
      habit: habit?.title || "未定",
      sliceTitle: slice?.title || "未定",
      startTitle: start?.title || "未定",
      startRegionLabel: slice?.title || race?.regionLabel || "未定",
      openingPack: race?.openingPack || "未定",
      currency: 0,
      companions: "0 / 2",
      currentQuestTitle: quest?.title || "尚未接到正式任務",
      currentQuestNote: quest?.coreConflict || "先把第一步踩穩。",
      currentQuestProgress: "待開始",
      inventory: [...toArray(identity?.starterItems), ...toArray(identity?.starterContainers)],
      relations: [],
      npcHooks: toArray(slice?.npcHooks).slice(0, 3),
      start,
      quest,
    };
  }

  function activeSnapshot() {
    const save = currentSave();
    if (!save) return previewSnapshot();

    const slice = currentSlice();
    const start = toArray(slice?.starts).find((item) => item.id === save.currentSceneId) || currentStart();
    const quest = toArray(slice?.starterQuestPool).find((item) => item.questId === save.activeQuest?.questId) || firstItem(slice?.starterQuestPool);

    return {
      name: save.character?.name || save.title || "無名潮客",
      race: save.character?.race || "未定",
      branch: save.character?.branch || save.setupSource?.branchTitle || "未定",
      blankSlateStatus: save.character?.blankSlateStatus || currentIdentity()?.title || "未定",
      ageStage: save.character?.ageStage || currentAgeStage()?.title || "未定",
      gender: save.character?.gender || currentGender()?.title || "未定",
      interest: save.character?.interest || currentInterest()?.title || "未定",
      personality: save.character?.personality || currentPersonality()?.title || "未定",
      habit: save.character?.habit || currentHabit()?.title || "未定",
      sliceTitle: slice?.title || save.slice || "未定",
      startTitle: start?.title || save.location || "未定",
      startRegionLabel: save.startRegionLabel || slice?.title || "未定",
      openingPack: save.openingPack || save.setupSource?.openingPack || "未定",
      currency: save.inventory?.currency ?? save.currency ?? 0,
      companions: `${toArray(save.companions).length} / 2`,
      currentQuestTitle: quest?.title || save.activeQuest?.questId || "未定",
      currentQuestNote: quest?.coreConflict || save.activeQuest?.progressLog || "故事正在推進。",
      currentQuestProgress: currentQuestStep()?.title || save.activeQuest?.progressLog || "進行中",
      inventory: toArray(save.inventory?.inventorySlots),
      relations: toArray(save.relations),
      npcHooks: toArray(slice?.npcHooks).filter((npc) => toArray(save.linkedNpcIds).includes(npc.id)),
      start,
      quest,
      rawSave: save,
    };
  }

  function ensureDefaults() {
    if (!state.selectedIdentityId) state.selectedIdentityId = firstItem(getIdentityList())?.id || null;
    if (!state.selectedAgeStageId) state.selectedAgeStageId = firstItem(getAgeStageList())?.id || null;
    if (!state.selectedGenderId) state.selectedGenderId = firstItem(getGenderList())?.id || null;
    if (!state.selectedRaceGroupId) {
      const playableRace = getRaceList().find((race) => !isInternalRaceOption(race) && sliceById(race.startRegionId))
        || getRaceList().find((race) => !isInternalRaceOption(race))
        || firstItem(getRaceList());
      state.selectedRaceGroupId = raceGroupIdForRace(playableRace) || firstItem(getRaceGroupList())?.id || null;
    }
    const branches = branchesForRaceGroup(state.selectedRaceGroupId);
    if (!branches.find((item) => item.id === state.selectedRaceId)) {
      const playableBranch = branches.find((race) => sliceById(race.startRegionId)) || firstItem(branches);
      state.selectedRaceId = playableBranch?.id || null;
    }
    if (!state.selectedInterestId) state.selectedInterestId = firstItem(getInterestList())?.id || null;
    if (!state.selectedPersonalityId) state.selectedPersonalityId = firstItem(getPersonalityList())?.id || null;
    if (!state.selectedHabitId) state.selectedHabitId = firstItem(getHabitList())?.id || null;
    syncRegionSelection();
    const starts = toArray(currentSlice()?.starts);
    if (!starts.find((item) => item.id === state.selectedStartId)) {
      state.selectedStartId = firstItem(starts)?.id || null;
    }
  }

  function renderSystemInfo() {
    const slice = currentSlice();
    refs.systemCurrentSlice.textContent = slice?.title || "未定";
    refs.systemCurrentMode.textContent = state.screen === "menu"
      ? "首頁模式"
      : `遊玩中 / ${activeSnapshot().blankSlateStatus}`;
    refs.systemUiState.textContent = [
      state.leftCollapsed ? "系統欄收起" : "系統欄展開",
      state.rightCollapsed ? "冒險簿收起" : "冒險簿展開",
    ].join(" / ");
    refs.leftRailToggle.setAttribute("title", state.leftCollapsed ? "展開系統欄" : "收起系統欄");
    refs.leftRailToggle.setAttribute("aria-label", state.leftCollapsed ? "展開系統欄" : "收起系統欄");
    refs.rightRailToggle.textContent = state.rightCollapsed ? "冒險簿" : "收起";
    refs.rightRailToggle.setAttribute("title", state.rightCollapsed ? "展開冒險簿" : "收起冒險簿");
    refs.rightRailToggle.setAttribute("aria-label", state.rightCollapsed ? "展開冒險簿" : "收起冒險簿");
  }

  function renderNotice() {
    refs.noticeTitle.textContent = fallback.notices?.title || "更新說明";
    refs.noticeBody.innerHTML = toArray(fallback.notices?.body).map((line) => `<p>${escapeHtml(line)}</p>`).join("");
  }

  function renderSetup() {
    const raceGroups = getRaceGroupList();
    const raceGroup = currentRaceGroup();
    const branches = branchesForRaceGroup(raceGroup?.id);
    const identities = getIdentityList();
    const ageStages = getAgeStageList();
    const genders = getGenderList();
    const interests = getInterestList();
    const personalities = getPersonalityList();
    const habits = getHabitList();
    const race = currentRace();
    const regionOptions = setupRegionOptions();
    const regionSlice = currentSlice();
    const starts = toArray(regionSlice?.starts);
    const stepTitles = ["白身", "年齡", "性別", "種族", "分支", "區域", "地點", "傾向", "姓名"];
    const identity = currentIdentity();
    const ageStage = currentAgeStage();
    const gender = currentGender();
    const interest = currentInterest();
    const personality = currentPersonality();
    const habit = currentHabit();
    const start = starts.find((item) => item.id === state.selectedStartId) || firstItem(starts);
    const setupReady = Boolean(regionSlice && start);

    refs.setupStepper.innerHTML = stepTitles.map((title, index) => {
      const step = index + 1;
      const className = step === state.setupStep ? "is-current" : step < state.setupStep ? "is-done" : "";
      return `<div class="step-chip ${className}"><span>${step}</span><strong>${escapeHtml(title)}</strong></div>`;
    }).join("");

    document.querySelectorAll(".setup-step").forEach((section) => {
      section.classList.toggle("is-active", Number(section.dataset.step) === state.setupStep);
    });

    refs.setupIdentities.innerHTML = identities.map((item) => `
      <button class="select-card${item.id === state.selectedIdentityId ? " is-selected" : ""}" data-select-identity="${escapeHtml(item.id)}" type="button">
        <span class="race-card-head">
          <strong>${escapeHtml(item.title)}</strong>
          <small>${escapeHtml(item.playDirection || "")}</small>
        </span>
        <small>${escapeHtml(item.note || "")}</small>
        <small>區域規則：${escapeHtml(item.regionRule || "依角色設定決定")}</small>
      </button>
    `).join("");

    refs.setupAgeStages.innerHTML = ageStages.map((item) => `
      <button class="select-card compact-card${item.id === state.selectedAgeStageId ? " is-selected" : ""}" data-select-age-stage="${escapeHtml(item.id)}" type="button">
        <strong>${escapeHtml(item.title)}</strong>
        <small class="card-note">${escapeHtml(item.note || "")}</small>
        <small>${escapeHtml(item.tone || "")}</small>
      </button>
    `).join("");

    refs.setupGenders.innerHTML = genders.map((item) => `
      <button class="select-card compact-card${item.id === state.selectedGenderId ? " is-selected" : ""}" data-select-gender="${escapeHtml(item.id)}" type="button">
        <strong>${escapeHtml(item.title)}</strong>
        <small class="card-note">${escapeHtml(item.note || "")}</small>
        <small>旁白稱謂：${escapeHtml(item.pronoun || "未定")}</small>
      </button>
    `).join("");

    refs.setupRaceGroups.innerHTML = raceGroups.map((item) => {
      const branchCount = branchesForRaceGroup(item.id).length;
      return `
      <button class="select-card race-card${item.id === state.selectedRaceGroupId ? " is-selected" : ""}" data-select-race-group="${escapeHtml(item.id)}" type="button">
        <span class="race-card-head">
          <strong>${escapeHtml(item.title)}</strong>
          <small>${escapeHtml(branchCount > 1 ? `${branchCount} 支可選` : "直接確認")}</small>
        </span>
        <small>${escapeHtml(item.note || "")}</small>
      </button>
    `;
    }).join("");

    refs.setupRaces.innerHTML = branches.map((item) => {
      const availableSlice = sliceById(item.startRegionId);
      const statusLabel = availableSlice ? "可進入原型" : "地區待建立";
      const cardClass = [
        "select-card",
        "branch-card",
        item.id === state.selectedRaceId ? "is-selected" : "",
        availableSlice ? "" : "is-pending",
      ].filter(Boolean).join(" ");

      return `
      <button class="${cardClass}" data-select-race="${escapeHtml(item.id)}" type="button">
        <span class="race-card-head">
          <strong>${escapeHtml(item.title)}</strong>
          <small>${escapeHtml(item.kind || "分支")}</small>
        </span>
        <small>起始地區：${escapeHtml(item.regionLabel || item.startRegionId || "未定")}</small>
        <small>開局包：${escapeHtml(item.openingPack || "未定")} / ${escapeHtml(item.tier || "未分級")}</small>
        <span class="race-status${availableSlice ? "" : " is-pending"}">${escapeHtml(statusLabel)}</span>
        <small>${escapeHtml(item.note || "")}</small>
      </button>
    `;
    }).join("");

    refs.setupSlices.innerHTML = regionOptions.length
      ? regionOptions.map((item) => {
          const isRecommended = toArray(identity?.recommendedRegionIds).includes(item.id);
          const isRaceDefault = item.id === race?.startRegionId;
          const label = identity?.regionMode === "local"
            ? "在地起點"
            : isRaceDefault
              ? "種族原鄉"
              : isRecommended
                ? "流離推薦"
                : "可選區域";
          return `
          <button class="select-card${item.id === state.selectedSliceId ? " is-selected" : ""}" data-select-slice="${escapeHtml(item.id)}" type="button">
            <span class="race-card-head">
              <strong>${escapeHtml(item.title)}</strong>
              <small>${escapeHtml(label)}</small>
            </span>
            <small>${escapeHtml(item.subtitle || item.notes || "")}</small>
            <small>可選落點：${toArray(item.starts).length}</small>
          </button>
        `;
        }).join("")
      : `
        <div class="list-card setup-empty-card">
          <strong>目前沒有符合這個白身身分的可開局區域</strong>
          <div class="list-note">可以先切換成漂泊者，或選擇已經有可玩切片的種族 / 分支。</div>
        </div>
      `;

    refs.setupInterests.innerHTML = renderTraitCards(interests, state.selectedInterestId, "data-select-interest");
    refs.setupPersonalities.innerHTML = renderTraitCards(personalities, state.selectedPersonalityId, "data-select-personality");
    refs.setupHabits.innerHTML = renderTraitCards(habits, state.selectedHabitId, "data-select-habit");

    refs.setupStarts.innerHTML = starts.length
      ? starts.map((item) => `
          <button class="select-card${item.id === state.selectedStartId ? " is-selected" : ""}" data-select-start="${escapeHtml(item.id)}" type="button">
            <strong>${escapeHtml(item.title)}</strong>
            <small>${escapeHtml(item.note || "")}</small>
          </button>
        `).join("")
      : `
        <div class="list-card setup-empty-card">
          <strong>${escapeHtml(regionSlice?.title || "此起始地區")}的城市 / 鄉鎮 / 落點尚未建立</strong>
          <div class="list-note">這個區域已經被選為起始區，但還沒做成可遊玩的細部落點。之後補上城市、鄉鎮或地方落點後，就能從這裡開局。</div>
        </div>
      `;

    refs.setupSummary.innerHTML = `
      <p class="section-label">目前總覽</p>
      <strong>${escapeHtml(state.playerName || "無名旅人")}</strong>
      <div class="list-note">白身：${escapeHtml(identity?.title || "未定")} / ${escapeHtml(identity?.playDirection || "未定")}</div>
      <div class="list-note">年齡：${escapeHtml(ageStage?.title || "未定")}</div>
      <div class="list-note">性別 / 稱謂：${escapeHtml(gender?.title || "未定")} / ${escapeHtml(gender?.pronoun || "未定")}</div>
      <div class="list-note">種族：${escapeHtml(raceGroup?.title || "未定")}</div>
      <div class="list-note">分支 / 族群：${escapeHtml(race?.title || "未定")}（${escapeHtml(race?.kind || "未定")}）</div>
      <div class="list-note">種族原鄉：${escapeHtml(race?.regionLabel || "未定")}</div>
      <div class="list-note">實際起始區：${escapeHtml(regionSlice?.title || "未定")}</div>
      <div class="list-note">開局包：${escapeHtml(race?.openingPack || "未定")} / ${escapeHtml(race?.tier || "未分級")}</div>
      <div class="list-note">切片狀態：${escapeHtml(regionSlice ? `${regionSlice.title} 可進入` : "地區切片待建立")}</div>
      <div class="list-note">關注點：${escapeHtml(interest?.title || "未定")} / ${escapeHtml(interest?.bonusTitle || "未定")} / ${escapeHtml(interest?.tradeoffTitle || "未定")}</div>
      <div class="list-note">性格：${escapeHtml(personality?.title || "未定")} / ${escapeHtml(personality?.bonusTitle || "未定")} / ${escapeHtml(personality?.tradeoffTitle || "未定")}</div>
      <div class="list-note">小習慣：${escapeHtml(habit?.title || "未定")} / ${escapeHtml(habit?.bonusTitle || "未定")} / ${escapeHtml(habit?.tradeoffTitle || "未定")}</div>
      <div class="list-note">地點：${escapeHtml(start?.title || "未定")}</div>
      <hr>
      <div class="list-note">${escapeHtml(start?.whyStartHere || "先把前面的步驟選好，這裡會慢慢長出更完整的開場印象。")}</div>
    `;

    if (document.activeElement !== refs.playerNameInput) {
      refs.playerNameInput.value = state.playerName;
    }
    refs.setupBack.disabled = state.setupStep === 1;
    refs.setupNext.hidden = state.setupStep === 9;
    refs.setupNext.disabled = (state.setupStep === 4 && !branches.length) || (state.setupStep === 5 && !regionOptions.length) || (state.setupStep === 6 && !regionSlice) || (state.setupStep === 7 && !start);
    refs.confirmStart.hidden = state.setupStep !== 9;
    refs.confirmStart.disabled = !setupReady;
    refs.confirmStart.title = setupReady ? "" : "此開局的詳細地區或落點尚未建立，暫時不能開始。";
  }

  function renderSaves() {
    const saves = getSaveList();
    const html = saves.length
      ? saves.map((item) => `
          <button class="save-item" data-load-save="${escapeHtml(item.id)}" type="button">
            <strong>${escapeHtml(item.title)}</strong>
            <div class="list-note">${escapeHtml(item.location || item.currentSceneId || "未知位置")}</div>
            <div class="list-note">${escapeHtml(item.time || "")}</div>
            <div class="list-note">${escapeHtml(item.note || "")}</div>
          </button>
        `).join("")
      : `<div class="list-card"><strong>目前沒有存檔</strong><div class="list-note">先從開始遊玩進去，這裡之後才會長出可以再續的篇章。</div></div>`;

    refs.continueBody.innerHTML = html;
    refs.saveCatalogBody.innerHTML = html;
  }

  function renderStory() {
    const snapshot = activeSnapshot();
    const start = snapshot.start || currentStart();
    const chosen = start?.choiceNarratives?.[state.activeVariant] || defaultChoices[state.activeVariant] || defaultChoices.observe;
    const choices = toArray(start?.sceneChoices);

    refs.ingameBannerTitle.textContent = start?.bannerTitle || `${snapshot.sliceTitle}．白身起步`;
    refs.ingameBannerCopy.textContent = start?.bannerCopy || "先活下來，先看懂，再讓這個地方願意把下一句話交給你。";
    refs.openingTitle.textContent = start?.openingTitle || "故事從這裡開始";
    refs.openingCopy.textContent = start?.openingCopy || start?.whyStartHere || "先把第一步踩穩。";
    refs.sceneLocationTitle.textContent = chosen.title || start?.title || "眼前局勢";

    const outcome = currentSave()?.lastOutcome;
    const paragraphs = [
      ...toArray(start?.storyParagraphs),
      ...toArray(chosen.paragraphs),
      ...toArray(outcome?.paragraphs),
    ];
    refs.sceneCopy.innerHTML = paragraphs.map((paragraph) => `<p>${escapeHtml(paragraph)}</p>`).join("");

    refs.choiceGrid.innerHTML = `
      <div class="choice-prompt">
        <span>可選行動</span>
        <strong>下一步要怎麼做？</strong>
        <small>點選一個行動來推進劇情、任務與冒險簿資料。</small>
      </div>
      ${choices.map((choice) => `
        <button class="choice-btn${choice.id === state.activeVariant ? " is-selected" : ""}" data-choice="${escapeHtml(choice.id)}" type="button">
          <span class="choice-btn-label">${escapeHtml(choice.label)}</span>
          <small>點擊執行</small>
        </button>
      `).join("")}
    `;

    refs.choiceGrid.querySelectorAll("[data-choice]").forEach((button) => {
      button.addEventListener("click", (event) => {
        event.stopPropagation();
        handleChoice(button.dataset.choice);
      });
    });
  }

  function renderSummary() {
    const snapshot = activeSnapshot();
    const interest = getInterestList().find((item) => item.title === snapshot.interest || item.id === state.selectedInterestId) || currentInterest();
    const personality = getPersonalityList().find((item) => item.title === snapshot.personality || item.id === state.selectedPersonalityId) || currentPersonality();
    const habit = getHabitList().find((item) => item.title === snapshot.habit || item.id === state.selectedHabitId) || currentHabit();

    refs.summaryBody.innerHTML = `
      <div class="summary-stat-grid">
        <div class="summary-stat"><span>姓名</span><strong>${escapeHtml(snapshot.name)}</strong></div>
        <div class="summary-stat"><span>種族</span><strong>${escapeHtml(snapshot.race)}</strong></div>
        <div class="summary-stat"><span>分支</span><strong>${escapeHtml(snapshot.branch)}</strong></div>
        <div class="summary-stat"><span>白身身分</span><strong>${escapeHtml(snapshot.blankSlateStatus)}</strong></div>
        <div class="summary-stat"><span>年齡</span><strong>${escapeHtml(snapshot.ageStage)}</strong></div>
        <div class="summary-stat"><span>稱謂</span><strong>${escapeHtml(snapshot.gender)}</strong></div>
        <div class="summary-stat"><span>現金</span><strong>${escapeHtml(snapshot.currency)} 潮刻</strong></div>
        <div class="summary-stat"><span>同行</span><strong>${escapeHtml(snapshot.companions)}</strong></div>
      </div>
      <div class="list-note">起始區：${escapeHtml(snapshot.startRegionLabel || snapshot.sliceTitle)}</div>
      <div class="list-note">開局包：${escapeHtml(snapshot.openingPack || "未定")}</div>
      <div class="list-note">關注點：${escapeHtml(snapshot.interest)} / ${escapeHtml(interest?.bonusTitle || "未定")} / ${escapeHtml(interest?.tradeoffTitle || "未定")}</div>
      <div class="list-note">性格：${escapeHtml(snapshot.personality)} / ${escapeHtml(personality?.bonusTitle || "未定")} / ${escapeHtml(personality?.tradeoffTitle || "未定")}</div>
      <div class="list-note">習慣：${escapeHtml(snapshot.habit)} / ${escapeHtml(habit?.bonusTitle || "未定")} / ${escapeHtml(habit?.tradeoffTitle || "未定")}</div>
      <div class="list-note">位置：${escapeHtml(snapshot.startTitle)}</div>
      <div class="list-note">目前任務：${escapeHtml(snapshot.currentQuestTitle)}</div>
    `;

    refs.summaryBody.parentElement.style.display = state.settings.showSummary ? "" : "none";
  }

  function normalizeInventoryItem(item, index) {
    if (typeof item === "string") {
      return {
        name: item,
        category: "未分類",
        quantity: 1,
        note: "尚未登錄細節。",
      };
    }

    return {
      name: item?.name || item?.title || item?.id || `未命名物品 ${index + 1}`,
      category: item?.category || item?.type || "未分類",
      quantity: item?.quantity || item?.qty || 1,
      note: item?.note || item?.summary || item?.description || "尚未登錄細節。",
    };
  }

  function buildInventoryPanel(snapshot) {
    const items = toArray(snapshot.inventory).map(normalizeInventoryItem);
    const categories = ["全部", "裝備", "消耗品", "材料", "任務物", "未分類"];
    const itemCards = items.length
      ? items.map((item) => `
          <article class="inventory-item-card">
            <div class="inventory-item-head">
              <strong>${escapeHtml(item.name)}</strong>
              <span class="item-pill">x${escapeHtml(item.quantity)}</span>
            </div>
            <div class="list-note">${escapeHtml(item.category)}</div>
            <p>${escapeHtml(item.note)}</p>
          </article>
        `).join("")
      : `<article class="inventory-empty-card"><strong>背包目前是空的</strong><p>之後取得的工具、食物、材料、武器、防具、飾品與任務物會集中放在這裡。</p></article>`;

    return `
      <section class="inventory-panel">
        <div class="inventory-toolbar">
          <div>
            <p class="section-label">背包管理</p>
            <strong>${items.length} 件物品</strong>
          </div>
          <span class="item-pill">分類與排序預留</span>
        </div>
        <div class="inventory-layout">
          <aside class="inventory-categories">
            ${categories.map((category, index) => `<span class="inventory-category${index === 0 ? " is-selected" : ""}">${escapeHtml(category)}</span>`).join("")}
          </aside>
          <div class="inventory-grid">${itemCards}</div>
        </div>
      </section>
    `;
  }

  function buildMapPanel() {
    const save = currentSave();
    const slice = currentSlice();
    const allSlices = getSliceList();
    const starts = toArray(slice?.starts);
    const knownRegionIds = new Set([
      ...toArray(save?.mapState?.knownRegionIds),
      ...(save?.slice ? [save.slice] : []),
      ...(slice?.id ? [slice.id] : []),
    ]);
    const exploredSceneIds = new Set([
      ...toArray(save?.mapState?.exploredSceneIds),
      ...toArray(save?.locationState?.exploredSceneIds),
      ...(save?.currentSceneId ? [save.currentSceneId] : []),
    ]);

    const regions = allSlices.length
      ? allSlices.map((region, index) => {
          const isCurrent = region.id === slice?.id;
          const isKnown = knownRegionIds.has(region.id);
          return `
            <article class="map-region-card${isCurrent ? " is-current" : ""}${isKnown ? " is-known" : " is-unknown"}">
              <span>${index + 1}</span>
              <strong>${escapeHtml(region.title || region.id)}</strong>
              <small>${escapeHtml(region.subtitle || region.notes || "尚未登錄區域說明。")}</small>
            </article>
          `;
        }).join("")
      : `<article class="map-region-card is-unknown"><span>?</span><strong>尚未載入世界地圖</strong><small>目前沒有可顯示的區域。</small></article>`;

    const nodes = starts.length
      ? starts.map((start, index) => `
          <article class="map-node-card${exploredSceneIds.has(start.id) ? " is-explored" : " is-unexplored"}">
            <span>${index + 1}</span>
            <strong>${escapeHtml(start.title)}</strong>
            <small>${escapeHtml(start.note || "尚未登錄地點說明。")}</small>
            <em>${exploredSceneIds.has(start.id) ? "已探索" : "尚未探索"}</em>
          </article>
        `).join("")
      : `<article class="map-node-card"><span>?</span><strong>尚未載入地點</strong><small>目前切片還沒有可顯示的地點。</small></article>`;

    return `
      <section class="map-panel">
        <div class="map-board">
          <div class="map-watermark">Elaris</div>
          <div class="map-region-grid">${regions}</div>
        </div>
        <aside class="map-side-note">
          <p class="section-label">目前區域</p>
          <strong>${escapeHtml(slice?.title || "未知區域")}</strong>
          <div class="list-note">${escapeHtml(slice?.notes || "這裡之後可以換成真正的大地圖、區域圖或可點擊地點。")}</div>
          <div class="map-node-grid is-side">${nodes}</div>
        </aside>
      </section>
    `;
  }

  function buildPeoplePanel(items, emptyTitle, emptyNote) {
    return items.length
      ? items.map((item) => `
          <article class="panel-list-card people-card">
            <strong>${escapeHtml(item.name || item.npcId || "未命名人物")}</strong>
            <div class="list-note">${escapeHtml(item.role || item.label || item.reasonToStay || "資料尚未完整。")}</div>
            <div class="list-note">${escapeHtml(item.summary || "")}</div>
          </article>
        `).join("")
      : `<article class="panel-list-card people-card"><strong>${escapeHtml(emptyTitle)}</strong><div class="list-note">${escapeHtml(emptyNote)}</div></article>`;
  }

  function buildAdventurePopoutContent(drawerId, snapshot) {
    const save = snapshot.rawSave || {};
    const companions = toArray(save.companions);
    const relations = toArray(save.relations);

    if (drawerId === "quests") {
      return `
        <section class="quest-panel">
          <article class="panel-list-card">
            <p class="section-label">目前任務</p>
            <strong>${escapeHtml(snapshot.currentQuestTitle)}</strong>
            <div class="list-note">${escapeHtml(snapshot.currentQuestNote)}</div>
            <div class="list-note">進度：${escapeHtml(snapshot.currentQuestProgress)}</div>
          </article>
        </section>
      `;
    }

    if (drawerId === "inventory") return buildInventoryPanel(snapshot);
    if (drawerId === "map") return buildMapPanel();
    if (drawerId === "companions") return buildPeoplePanel(companions, "目前沒有同行者", "一般開局不會硬塞夥伴，只有有理由同行的人才會加入。");
    if (drawerId === "relations") return buildPeoplePanel(relations, "目前沒有明確關係", "你遇見、幫助、冒犯或長期來往的人，會慢慢累積到這裡。");

    return `<article class="panel-list-card"><strong>尚未開放</strong><div class="list-note">這個冒險簿頁面還在整理中。</div></article>`;
  }

  function buildAdventurePanelContent(drawerId, snapshot) {
    return buildAdventurePopoutContent(drawerId, snapshot);
    const save = snapshot.rawSave || {};
    const companions = toArray(save.companions);
    const relations = toArray(save.relations);

    if (drawerId === "quests") {
      return `
        <div class="panel-list-card">
          <p class="section-label">目前任務</p>
          <strong>${escapeHtml(snapshot.currentQuestTitle)}</strong>
          <div class="list-note">${escapeHtml(snapshot.currentQuestNote)}</div>
          <div class="list-note">進度：${escapeHtml(snapshot.currentQuestProgress)}</div>
        </div>
      `;
    }

    if (drawerId === "inventory") {
      return snapshot.inventory.length
        ? snapshot.inventory.map((item) => {
            const name = typeof item === "string" ? item : item.name || item.title || item.id || "未命名物品";
            const note = typeof item === "string" ? "" : item.note || item.summary || item.type || "";
            return `
              <div class="panel-list-card">
                <strong>${escapeHtml(name)}</strong>
                ${note ? `<div class="list-note">${escapeHtml(note)}</div>` : ""}
              </div>
            `;
          }).join("")
        : `<div class="panel-list-card"><strong>背包目前是空的</strong><div class="list-note">之後取得的工具、食物、材料與裝備會放在這裡。</div></div>`;
    }

    if (drawerId === "companions") {
      return companions.length
        ? companions.map((companion) => `
            <div class="panel-list-card">
              <strong>${escapeHtml(companion.name || companion.npcId || "未命名同行者")}</strong>
              <div class="list-note">${escapeHtml(companion.role || companion.reasonToStay || "正在與你同行。")}</div>
            </div>
          `).join("")
        : `<div class="panel-list-card"><strong>目前沒有同行者</strong><div class="list-note">一般開局不會硬塞夥伴，只有有理由同行的人才會加入。</div></div>`;
    }

    if (drawerId === "relations") {
      return relations.length
        ? relations.map((relation) => `
            <div class="panel-list-card">
              <strong>${escapeHtml(relation.name || relation.npcId || "未命名人物")}</strong>
              <div class="list-note">${escapeHtml(relation.label || "關係尚未穩定")}</div>
              <div class="list-note">${escapeHtml(relation.summary || "")}</div>
            </div>
          `).join("")
        : `<div class="panel-list-card"><strong>目前沒有明確關係</strong><div class="list-note">你遇見、幫助、冒犯或長期來往的人，會慢慢累積到這裡。</div></div>`;
    }

    if (drawerId === "map") {
      const starts = toArray(currentSlice()?.starts);
      return starts.length
        ? starts.map((start) => `
            <div class="panel-list-card">
              <strong>${escapeHtml(start.title)}</strong>
              <div class="list-note">${escapeHtml(start.note || "")}</div>
            </div>
          `).join("")
        : `<div class="panel-list-card"><strong>尚未載入地圖資料</strong><div class="list-note">目前切片還沒有可顯示的地點。</div></div>`;
    }

    return `<div class="panel-list-card"><strong>尚未開放</strong><div class="list-note">這個冒險簿頁面還在整理中。</div></div>`;
  }

  function renderDrawer() {
    const snapshot = activeSnapshot();
    const save = snapshot.rawSave || {};
    const companions = toArray(save.companions);
    const relations = toArray(save.relations);

    refs.drawerShell.classList.remove("is-open");
    refs.drawerBody.innerHTML = "";

    if (!state.activeDrawer) {
      refs.adventurePopout.hidden = true;
      refs.adventurePopout.classList.remove("is-open");
      delete refs.adventurePopout.dataset.panel;
      refs.adventurePopoutBody.innerHTML = "";
      return;
    }

    refs.adventurePopout.hidden = false;
    refs.adventurePopout.classList.add("is-open");
    refs.adventurePopout.dataset.panel = state.activeDrawer;
    refs.adventurePopoutTitle.textContent = drawerLabels[state.activeDrawer] || "冒險簿";
    refs.adventurePopoutBody.innerHTML = buildAdventurePanelContent(state.activeDrawer, snapshot);
    return;

    if (!state.activeDrawer) {
      refs.drawerShell.classList.remove("is-open");
      refs.drawerBody.innerHTML = "";
      return;
    }

    refs.drawerShell.classList.add("is-open");
    refs.drawerTitle.textContent = drawerLabels[state.activeDrawer] || "冒險簿";

    if (state.activeDrawer === "quests") {
      refs.drawerBody.innerHTML = `
        <div class="list-card">
          <strong>${escapeHtml(snapshot.currentQuestTitle)}</strong>
          <div class="list-note">${escapeHtml(snapshot.currentQuestNote)}</div>
          <div class="list-note">進度：${escapeHtml(snapshot.currentQuestProgress)}</div>
        </div>
      `;
      return;
    }

    if (state.activeDrawer === "inventory") {
      refs.drawerBody.innerHTML = snapshot.inventory.length
        ? snapshot.inventory.map((item) => `<div class="list-card"><strong>${escapeHtml(item)}</strong></div>`).join("")
        : `<div class="list-card"><strong>目前沒有額外物資</strong></div>`;
      return;
    }

    if (state.activeDrawer === "companions") {
      refs.drawerBody.innerHTML = companions.length
        ? companions.map((companion) => `<div class="list-card"><strong>${escapeHtml(companion.npcId)}</strong><div class="list-note">${escapeHtml(companion.reasonToStay || "目前仍願意留下。")}</div></div>`).join("")
        : `<div class="list-card"><strong>目前沒有正式同行者</strong><div class="list-note">每張地圖通常只有 0-2 位真的願意同行的人。</div></div>`;
      return;
    }

    if (state.activeDrawer === "relations") {
      refs.drawerBody.innerHTML = relations.length
        ? relations.map((relation) => `<div class="list-card"><strong>${escapeHtml(relation.npcId)}</strong><div class="list-note">${escapeHtml(relation.label || "點頭之交")}</div><div class="list-note">${escapeHtml(relation.summary || "")}</div></div>`).join("")
        : `<div class="list-card"><strong>目前沒有關係紀錄</strong><div class="list-note">等你真正和地方人物互動後，這裡會長出好感與信任。</div></div>`;
      return;
    }

    if (state.activeDrawer === "map") {
      refs.drawerBody.innerHTML = toArray(currentSlice()?.starts).map((start) => `
        <div class="list-card">
          <strong>${escapeHtml(start.title)}</strong>
          <div class="list-note">${escapeHtml(start.note || "")}</div>
        </div>
      `).join("");
    }
  }

  function renderSettings() {
    refs.settingSoftBackground.checked = state.settings.softBackground;
    refs.settingShowOpening.checked = state.settings.showOpening;
    refs.settingShowSummary.checked = state.settings.showSummary;
    document.body.classList.toggle("soft-background", state.settings.softBackground);
    document.querySelector(".opening-panel").style.display = state.settings.showOpening ? "" : "none";
  }

  function renderRails() {
    refs.appShell.classList.toggle("menu-mode", state.screen === "menu");
    refs.appShell.classList.toggle("ingame-mode", state.screen === "ingame");
    refs.appShell.classList.toggle("left-collapsed", state.leftCollapsed);
    refs.appShell.classList.toggle("right-collapsed", state.rightCollapsed);
    refs.screens.forEach((screen) => screen.classList.toggle("is-active", screen.id === `screen-${state.screen}`));
    refs.dockButtons.forEach((button) => {
      const isActive = !state.rightCollapsed && button.dataset.drawer === state.activeDrawer;
      button.classList.toggle("is-selected", isActive);
      button.setAttribute("aria-pressed", isActive ? "true" : "false");
    });
  }

  function renderModals() {
    refs.modals.forEach((modal) => {
      const open = modal.id === `modal-${state.activeModal}`;
      modal.hidden = !open;
      modal.classList.toggle("is-open", open);
    });
  }

  function renderAll() {
    ensureDefaults();
    renderRails();
    renderModals();
    renderSystemInfo();
    renderNotice();
    renderSetup();
    renderSaves();
    renderStory();
    renderSummary();
    renderDrawer();
    renderSettings();
  }

  function openModal(name) {
    state.activeModal = name;
    if (name === "setup") state.setupStep = 1;
    renderAll();
  }

  function closeModal() {
    state.activeModal = null;
    renderAll();
  }

  function setScreen(screen) {
    state.screen = screen;
    state.activeModal = null;
    state.activeDrawer = null;
    if (screen === "menu") {
      state.leftCollapsed = true;
      state.rightCollapsed = true;
    } else {
      state.leftCollapsed = true;
      state.rightCollapsed = true;
    }
    renderAll();
  }

  function setLeftCollapsed(next) {
    state.leftCollapsed = Boolean(next);
    renderAll();
  }

  function setRightCollapsed(next) {
    state.rightCollapsed = Boolean(next);
    if (state.rightCollapsed) state.activeDrawer = null;
    renderAll();
  }

  function closeDrawer() {
    state.activeDrawer = null;
    renderAll();
  }

  function openDrawer(drawerId) {
    if (!state.rightCollapsed && state.activeDrawer === drawerId) {
      closeDrawer();
      return;
    }
    state.activeDrawer = drawerId;
    state.rightCollapsed = false;
    renderAll();
  }

  async function postJson(url, payload) {
    const response = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    const body = await response.json();
    if (!response.ok || body.ok === false) throw new Error(body.message || "操作失敗。");
    return body;
  }

  function showNotice(title, lines) {
    refs.noticeTitle.textContent = title;
    refs.noticeBody.innerHTML = toArray(lines).map((line) => `<p>${escapeHtml(line)}</p>`).join("");
    state.activeModal = "notice";
    renderAll();
  }

  async function handleStart() {
    const save = createPlayableSave();
    if (!save) {
      showNotice("此種族地區尚未開放", [
        "這個種族已經有對應的起始地區，但該地區還沒建立可遊玩的城市、鄉鎮或落點。",
        "請先選擇標示為「可進入原型」的種族，或等該地區切片補完後再開局。",
      ]);
      return;
    }

    upsertLocalSave(save);
    state.selectedRaceGroupId = save.raceGroupId || state.selectedRaceGroupId;
    state.selectedRaceId = save.raceId || state.selectedRaceId;
    state.selectedSliceId = save.slice;
    state.selectedStartId = save.currentSceneId;
    state.activeVariant = "observe";
    setScreen("ingame");
    closeModal();

    void postJson("/api/start", {
        sliceId: state.selectedSliceId,
        raceGroupId: state.selectedRaceGroupId,
        branchId: state.selectedRaceId,
        identityId: state.selectedIdentityId,
        ageStageId: state.selectedAgeStageId,
        genderId: state.selectedGenderId,
        interestId: state.selectedInterestId,
        personalityId: state.selectedPersonalityId,
        habitId: state.selectedHabitId,
        startId: state.selectedStartId,
        playerName: save.character.name,
      }).catch((error) => console.warn("Local API start hook unavailable.", error));
  }

  async function handleContinue(saveId) {
    const source = getSaveList().find((item) => item.id === saveId);
    const save = cloneData(source);
    if (!save) return;

    state.selectedSaveId = save.id;
    state.currentSave = save;
    state.selectedRaceGroupId = save.raceGroupId || save.setupSource?.raceGroupId || state.selectedRaceGroupId;
    state.selectedRaceId = save.raceId || save.setupSource?.raceId || state.selectedRaceId;
    state.selectedAgeStageId = save.setupSource?.ageStageId || state.selectedAgeStageId;
    state.selectedGenderId = save.setupSource?.genderId || state.selectedGenderId;
    state.selectedSliceId = save.slice || state.selectedSliceId;
    state.selectedStartId = save.currentSceneId || state.selectedStartId;
    setScreen("ingame");
    closeModal();

    void postJson("/api/continue", {
        sliceId: save.slice,
        saveFileName: save.rawFileName || save.id,
      }).catch((error) => console.warn("Local API continue hook unavailable.", error));
  }

  function bindEvents() {
    refs.leftRailBrandToggle.addEventListener("click", () => setLeftCollapsed(true));
    refs.leftRailToggle.addEventListener("click", () => setLeftCollapsed(!state.leftCollapsed));
    refs.rightRailToggle.addEventListener("click", () => {
      setRightCollapsed(!state.rightCollapsed);
    });
    refs.rightRailClose.addEventListener("click", () => setRightCollapsed(true));
    refs.drawerClose.addEventListener("click", () => closeDrawer());
    refs.adventurePopoutClose.addEventListener("click", () => closeDrawer());
    refs.adventurePopout.addEventListener("click", (event) => {
      if (event.target === refs.adventurePopout) closeDrawer();
    });
    refs.sceneCopy.addEventListener("click", () => handleChoice(state.activeVariant));

    refs.setupBack.addEventListener("click", () => {
      state.setupStep = Math.max(1, state.setupStep - 1);
      renderAll();
    });

    refs.setupNext.addEventListener("click", () => {
      state.setupStep = Math.min(9, state.setupStep + 1);
      renderAll();
    });

    refs.confirmStart.addEventListener("click", () => {
      state.playerName = refs.playerNameInput.value.trim();
      void handleStart();
    });

    refs.playerNameInput.addEventListener("input", () => {
      state.playerName = refs.playerNameInput.value;
      renderSetup();
    });

    document.addEventListener("click", (event) => {
      const rawTarget = event.target;
      if (!(rawTarget instanceof HTMLElement)) return;

      const target = rawTarget.closest(
        "[data-screen], [data-modal], [data-close-modal], [data-action], [data-select-race-group], [data-select-race], [data-select-slice], [data-select-identity], [data-select-age-stage], [data-select-gender], [data-select-interest], [data-select-personality], [data-select-habit], [data-select-start], [data-load-save], [data-drawer], [data-choice]"
      );

      if (!(target instanceof HTMLElement)) return;

      if (target.dataset.screen) {
        setScreen(target.dataset.screen);
        return;
      }

      if (target.dataset.modal) {
        openModal(target.dataset.modal);
        return;
      }

      if (target.dataset.closeModal) {
        closeModal();
        return;
      }

      if (target.dataset.action === "back-to-menu") {
        setScreen("menu");
        return;
      }

      if (target.dataset.selectRaceGroup) {
        applyRaceGroupSelection(target.dataset.selectRaceGroup);
        renderAll();
        return;
      }

      if (target.dataset.selectRace) {
        applyRaceSelection(target.dataset.selectRace);
        renderAll();
        return;
      }

      if (target.dataset.selectSlice) {
        state.selectedSliceId = target.dataset.selectSlice;
        state.selectedStartId = firstItem(currentSlice()?.starts)?.id || null;
        renderAll();
        return;
      }

      if (target.dataset.selectIdentity) {
        state.selectedIdentityId = target.dataset.selectIdentity;
        syncRegionSelection({ forceRaceRegion: currentIdentity()?.regionMode === "local" });
        renderAll();
        return;
      }

      if (target.dataset.selectAgeStage) {
        state.selectedAgeStageId = target.dataset.selectAgeStage;
        renderSetup();
        return;
      }

      if (target.dataset.selectGender) {
        state.selectedGenderId = target.dataset.selectGender;
        renderSetup();
        return;
      }

      if (target.dataset.selectInterest) {
        state.selectedInterestId = target.dataset.selectInterest;
        renderSetup();
        return;
      }

      if (target.dataset.selectPersonality) {
        state.selectedPersonalityId = target.dataset.selectPersonality;
        renderSetup();
        return;
      }

      if (target.dataset.selectHabit) {
        state.selectedHabitId = target.dataset.selectHabit;
        renderSetup();
        return;
      }

      if (target.dataset.selectStart) {
        state.selectedStartId = target.dataset.selectStart;
        renderSetup();
        return;
      }

      if (target.dataset.loadSave) {
        void handleContinue(target.dataset.loadSave);
        return;
      }

      if (target.dataset.drawer) {
        openDrawer(target.dataset.drawer);
        return;
      }

      if (target.dataset.choice) {
        handleChoice(target.dataset.choice);
        return;
      }
    });

    refs.settingSoftBackground.addEventListener("change", (event) => {
      state.settings.softBackground = event.target.checked;
      renderSettings();
    });
    refs.settingShowOpening.addEventListener("change", (event) => {
      state.settings.showOpening = event.target.checked;
      renderSettings();
    });
    refs.settingShowSummary.addEventListener("change", (event) => {
      state.settings.showSummary = event.target.checked;
      renderAll();
    });
  }

  function initialize() {
    loadLocalSaves();
    ensureDefaults();
    bindEvents();
    renderAll();
  }

  try {
    initialize();
  } catch (error) {
    showDebug(error);
  }
})();
