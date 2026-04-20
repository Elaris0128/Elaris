window.elarisRuntimeData = {
    "generated_at":  "2026-04-20T01:59:40.8770945+08:00",
    "slices":  [
                   {
                       "id":  "whispersea",
                       "title":  "幽語海",
                       "subtitle":  "白身開局單區原型",
                       "status":  "playable",
                       "progress":  "單區完整循環",
                       "entryScript":  "05-prototypes\\whispersea-cli-prototype.ps1",
                       "saveDirectory":  "05-prototypes\\saves",
                       "notes":  "目前最完整的區域切片，已支援白身開局、三條 starter quest、NPC 好感、同行、同行成長與同行支線。",
                       "starts":  [
                                      {
                                          "id":  "silent-rock-islet",
                                          "title":  "寂岩孤島",
                                          "note":  "你從近岸碎流帶被帶上這座小島，眼前是潮骨立石、守誓繩結與還沒乾透的海霧。這裡是最適合白身開局的落點，因為第一批人情、規矩與風險都看得見。",
                                          "whyStartHere":  "你從近岸碎流帶被帶上這座小島，眼前是潮骨立石、守誓繩結與還沒乾透的海霧。這裡是最適合白身開局的落點，因為第一批人情、規矩與風險都看得見。",
                                          "pressureTags":  [
                                                               "old-oath",
                                                               "ritual-dispute",
                                                               "social-pressure"
                                                           ],
                                          "linkedNpcIds":  [
                                                               "character-whispersea-chaoguheng",
                                                               "character-whispersea-yuhuanpo"
                                                           ],
                                          "recommendedFirstQuest":  "whispersea-quest-01"
                                      },
                                      {
                                          "id":  "tidesigh-sea-cave",
                                          "title":  "潮息海窟",
                                          "note":  "潮息海窟靠近潛路與短窗交易點，能最快碰到水路消息、潛行風險與借道規矩。你在這裡開局，通常會先學會分辨一條路是不是能走。",
                                          "whyStartHere":  "潮息海窟靠近潛路與短窗交易點，能最快碰到水路消息、潛行風險與借道規矩。你在這裡開局，通常會先學會分辨一條路是不是能走。",
                                          "pressureTags":  [
                                                               "wrong-route",
                                                               "short-stay-trade",
                                                               "dive-risk"
                                                           ],
                                          "linkedNpcIds":  [
                                                               "character-whispersea-fanchaoshu",
                                                               "character-whispersea-wuduocen"
                                                           ],
                                          "recommendedFirstQuest":  "whispersea-quest-02"
                                      },
                                      {
                                          "id":  "silent-chant-cape",
                                          "title":  "靜唱索岬",
                                          "note":  "索岬夜裡總有鈴聲與霧燈，界線、訊號與看守責任在這裡比什麼都重要。白身在此開局，常會先被捲進一件看似小、其實關係到整條路安危的事。",
                                          "whyStartHere":  "索岬夜裡總有鈴聲與霧燈，界線、訊號與看守責任在這裡比什麼都重要。白身在此開局，常會先被捲進一件看似小、其實關係到整條路安危的事。",
                                          "pressureTags":  [
                                                               "boundary-law",
                                                               "signal-anomaly",
                                                               "night-watch"
                                                           ],
                                          "linkedNpcIds":  [
                                                               "character-whispersea-jialingniang",
                                                               "character-whispersea-wuduocen"
                                                           ],
                                          "recommendedFirstQuest":  "whispersea-quest-06"
                                      }
                                  ],
                       "blankSlateRoles":  [
                                               {
                                                   "status":  "跟行者",
                                                   "why":  "你還沒有獨立走一條路的資格，但已經能跟在熟手旁邊學會怎麼看潮、怎麼閉嘴、什麼時候該先保命。",
                                                   "bestFit":  [
                                                                   "引水見習前身",
                                                                   "打撈助手",
                                                                   "聚落通跑"
                                                               ]
                                               },
                                               {
                                                   "status":  "見習",
                                                   "why":  "你已經有一點被交代事情的資格，但還不是能替人擔責的人。你做得好，地方會慢慢把更正式的工具和名義交給你。",
                                                   "bestFit":  [
                                                                   "判潮見習",
                                                                   "補修短工",
                                                                   "封樣學徒"
                                                               ]
                                               },
                                               {
                                                   "status":  "短工",
                                                   "why":  "你是最容易被捲進現場的人，因為大家都會先把最急、最不值錢、卻也最能看出你靠不靠得住的工作塞給你。",
                                                   "bestFit":  [
                                                                   "夜哨雜役",
                                                                   "借道跑腿",
                                                                   "近岸補給搬運"
                                                               ]
                                               }
                                           ],
                       "starterQuestPool":  [
                                                {
                                                    "questId":  "whispersea-quest-01",
                                                    "title":  "寂岩孤島的潮骨舊誓",
                                                    "entryPointId":  "silent-rock-islet",
                                                    "arc":  "守誓與近岸人情",
                                                    "chapterTier":  "starter",
                                                    "coreConflict":  "島上的潮骨立石被人動過，舊誓痕與新刻痕互相打架，若今晚前不查清，守誓人會把外來短工一律趕走。",
                                                    "decision":  "你要站在守誓的一邊，還是替怕被逐出的短工們找一條不傷規矩的退路？",
                                                    "progress":  {
                                                                     "steps":  [
                                                                                   {
                                                                                       "stepId":  "inspect-oath-stone",
                                                                                       "title":  "檢視潮骨立石",
                                                                                       "locationId":  "silent-rock-islet",
                                                                                       "goalText":  "先靠近潮骨立石，確認舊誓痕到底是被磨掉、被改刻，還是只是潮鹽覆住了。",
                                                                                       "advanceCommand":  "inspect-oath-stone"
                                                                                   },
                                                                                   {
                                                                                       "stepId":  "ask-yuhuanpo",
                                                                                       "title":  "向語環婆問舊歌",
                                                                                       "locationId":  "silent-rock-islet",
                                                                                       "goalText":  "把立石上的新痕描述給語環婆聽，請她對照舊歌中的誓紋順序。",
                                                                                       "advanceCommand":  "ask-yuhuanpo"
                                                                                   },
                                                                                   {
                                                                                       "stepId":  "compare-bell-line",
                                                                                       "title":  "去索岬對照鈴線記錄",
                                                                                       "locationId":  "silent-chant-cape",
                                                                                       "goalText":  "帶著你記下的刻痕去找岬鈴娘，看看索岬的舊鈴線簿有沒有相同手法。",
                                                                                       "advanceCommand":  "compare-bell-line"
                                                                                   }
                                                                               ],
                                                                     "completion":  {
                                                                                        "turnInLocationId":  "silent-rock-islet",
                                                                                        "turnInNpcId":  "character-whispersea-chaoguheng"
                                                                                    }
                                                                 }
                                                },
                                                {
                                                    "questId":  "whispersea-quest-02",
                                                    "title":  "潮息海窟的錯返潛路",
                                                    "entryPointId":  "tidesigh-sea-cave",
                                                    "arc":  "潛路與短窗交易",
                                                    "chapterTier":  "starter",
                                                    "coreConflict":  "一條本來給短窗採樣手用的潛路開始把人帶回錯的出口，若再不標出安全線，下一批人會在黑潮窗口裡失散。",
                                                    "decision":  "你要先保住採樣窗口，還是先封掉整條路，哪怕會惹怒等著吃這口飯的人？",
                                                    "progress":  {
                                                                     "steps":  [
                                                                                   {
                                                                                       "stepId":  "chart-bubbles",
                                                                                       "title":  "看氣泡與回流",
                                                                                       "locationId":  "tidesigh-sea-cave",
                                                                                       "goalText":  "先站到海窟邊，記下錯返窗口的氣泡節奏和回流方向。",
                                                                                       "advanceCommand":  "chart-bubbles"
                                                                                   },
                                                                                   {
                                                                                       "stepId":  "ask-fanchaoshu",
                                                                                       "title":  "問返潮叔舊路法",
                                                                                       "locationId":  "tidesigh-sea-cave",
                                                                                       "goalText":  "把你看到的回流節奏告訴返潮叔，確認以前遇到類似狀況怎麼留命。",
                                                                                       "advanceCommand":  "ask-fanchaoshu"
                                                                                   },
                                                                                   {
                                                                                       "stepId":  "set-safe-line",
                                                                                       "title":  "去索岬設安全線",
                                                                                       "locationId":  "silent-chant-cape",
                                                                                       "goalText":  "帶著返潮叔的說法去找霧舵岑，在索岬把暫時安全線的燈與記繩準備好。",
                                                                                       "advanceCommand":  "set-safe-line"
                                                                                   }
                                                                               ],
                                                                     "completion":  {
                                                                                        "turnInLocationId":  "tidesigh-sea-cave",
                                                                                        "turnInNpcId":  "character-whispersea-wuduocen"
                                                                                    }
                                                                 }
                                                },
                                                {
                                                    "questId":  "whispersea-quest-06",
                                                    "title":  "靜唱索岬的斷索號",
                                                    "entryPointId":  "silent-chant-cape",
                                                    "arc":  "岬哨與界線值夜",
                                                    "chapterTier":  "starter",
                                                    "coreConflict":  "索岬夜裡的斷索號響錯了兩次，若這不是繩結鬆脫，而是有人借著霧夜試探界線，那今晚就可能有船走進不該走的水域。",
                                                    "decision":  "你要把它當成單純維修，還是當成有人在試探海路紅線？",
                                                    "progress":  {
                                                                     "steps":  [
                                                                                   {
                                                                                       "stepId":  "inspect-broken-line",
                                                                                       "title":  "檢查斷索與鈴結",
                                                                                       "locationId":  "silent-chant-cape",
                                                                                       "goalText":  "先到索岬外端看斷索的磨損方向，確認是自然鬆脫還是有人動過。",
                                                                                       "advanceCommand":  "inspect-broken-line"
                                                                                   },
                                                                                   {
                                                                                       "stepId":  "ask-jialingniang",
                                                                                       "title":  "向岬鈴娘問夜號",
                                                                                       "locationId":  "silent-chant-cape",
                                                                                       "goalText":  "把斷口情況告訴岬鈴娘，問清楚近兩夜的錯號到底是哪一段訊序出錯。",
                                                                                       "advanceCommand":  "ask-jialingniang"
                                                                                   },
                                                                                   {
                                                                                       "stepId":  "carry-spare-line",
                                                                                       "title":  "去寂岩取備索",
                                                                                       "locationId":  "silent-rock-islet",
                                                                                       "goalText":  "去寂岩孤島搬回一捆備索，並向潮骨衡確認該不該把這件事視為正式試探。",
                                                                                       "advanceCommand":  "carry-spare-line"
                                                                                   }
                                                                               ],
                                                                     "completion":  {
                                                                                        "turnInLocationId":  "silent-chant-cape",
                                                                                        "turnInNpcId":  "character-whispersea-jialingniang"
                                                                                    }
                                                                 }
                                                }
                                            ],
                       "npcHooks":  [
                                        {
                                            "id":  "character-whispersea-chaoguheng",
                                            "name":  "潮骨衡",
                                            "role":  "寂岩孤島的守誓衡定者",
                                            "introUse":  "他看人的方式像在量潮線，不快不慢，但你會很清楚地知道他在判斷你能不能被留在這條路上。"
                                        },
                                        {
                                            "id":  "character-whispersea-yuhuanpo",
                                            "name":  "語環婆",
                                            "role":  "近岸舊歌與轉句記憶者",
                                            "introUse":  "她說話像唱舊潮歌，總把一句話留半拍，等你自己把沒說出口的那部分接上。"
                                        },
                                        {
                                            "id":  "character-whispersea-wuduocen",
                                            "name":  "霧舵岑",
                                            "role":  "錯返潛路與借道窗口的判讀手",
                                            "introUse":  "他看海窟和看人一樣，先看你會不會把話講成一條能走的線，再決定要不要替你補第二句。"
                                        },
                                        {
                                            "id":  "character-whispersea-fanchaoshu",
                                            "name":  "返潮叔",
                                            "role":  "熟悉舊潛路與回流脾氣的老路手",
                                            "introUse":  "他總是先看一眼水色才開口，像是每一句話都要先問過潮路自己肯不肯答應。"
                                        },
                                        {
                                            "id":  "character-whispersea-jialingniang",
                                            "name":  "岬鈴娘",
                                            "role":  "靜唱索岬的哨鈴看守",
                                            "introUse":  "她說話不大聲，卻總像隔著霧把聲音準確敲到你耳後，讓你很難裝作自己沒聽懂。"
                                        }
                                    ]
                   }
               ],
    "saves":  [
                  {
                      "id":  "無名潮客-whispersea-save",
                      "title":  "無名潮客",
                      "slice":  "whispersea",
                      "location":  "潮息海窟",
                      "time":  "Day 1 / dawn",
                      "note":  "Active: whispersea-quest-02",
                      "currency":  10,
                      "identity":  "見習",
                      "primaryDirection":  "未定",
                      "currentSceneId":  "tidesigh-sea-cave",
                      "rawFileName":  "無名潮客-whispersea-save.json",
                      "updatedAt":  "2026-04-05T00:43:18.9394972+08:00",
                      "character":  {
                                        "name":  "無名潮客",
                                        "race":  "諾魯因人",
                                        "branch":  null,
                                        "originRegion":  "whispersea",
                                        "blankSlateStatus":  "見習",
                                        "jobDirectionPrimary":  "未定",
                                        "jobDirectionSecondary":  "未定",
                                        "background":  "白身開局"
                                    },
                      "locationState":  {
                                            "currentRegionId":  "whispersea",
                                            "currentSceneId":  "tidesigh-sea-cave",
                                            "currentSceneName":  "潮息海窟",
                                            "timeOfDay":  "dawn",
                                            "dayCount":  1
                                        },
                      "inventory":  {
                                        "currency":  10,
                                        "equippedItems":  [

                                                          ],
                                        "inventorySlots":  [
                                                               "封聲袋",
                                                               "短窗照燈",
                                                               "簡索繩"
                                                           ],
                                        "containers":  [
                                                           "潮布肩包"
                                                       ]
                                    },
                      "activeQuest":  {
                                          "questId":  "whispersea-quest-02",
                                          "status":  "active",
                                          "stepIndex":  1,
                                          "progressLog":  "看氣泡與回流",
                                          "startedAt":  "2026-04-05T00:43:18.7557757+08:00",
                                          "completedAt":  null
                                      },
                      "clues":  [
                                    "錯返點只在一段短窗提早閉合",
                                    "潛路本體還能救"
                                ],
                      "linkedNpcIds":  [
                                           "character-whispersea-fanchaoshu",
                                           "character-whispersea-wuduocen"
                                       ],
                      "pressure":  [
                                       "wrong-route",
                                       "short-stay-trade",
                                       "dive-risk"
                                   ]
                  }
              ]
};