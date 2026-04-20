param(
    [string[]]$ScriptedInputs = @(),
    [switch]$AutoNewGame,
    [string]$PresetPlayerName = '',
    [string]$PresetRoleStatus = '',
    [string]$PresetStartPointId = '',
    [string]$AutoLoadSave = ''
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [Console]::OutputEncoding

$Script:PrototypeRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:ProjectRoot = Split-Path -Parent (Split-Path -Parent $Script:PrototypeRoot)
$Script:RegionPackPath = Join-Path $Script:ProjectRoot 'text-game\02-data\regions\whispersea-region-pack-v1.json'
$Script:SaveDirectory = Join-Path $Script:PrototypeRoot 'saves'
$Script:InputQueue = New-Object 'System.Collections.Generic.Queue[string]'
$Script:ScriptedMode = @($ScriptedInputs).Count -gt 0 -or $AutoNewGame.IsPresent -or -not [string]::IsNullOrWhiteSpace($AutoLoadSave)
$Script:AutoNewGame = $AutoNewGame.IsPresent
$Script:PresetPlayerName = $PresetPlayerName
$Script:PresetRoleStatus = $PresetRoleStatus
$Script:PresetStartPointId = $PresetStartPointId
$Script:AutoLoadSave = $AutoLoadSave
$Script:TimeCycle = @('night', 'dawn', 'day', 'dusk')
$Script:ServiceCatalog = @{
    'silent-rock-islet' = @(
        [ordered]@{
            id = 'salt-ration'
            title = '買一包岸鹽乾糧'
            cost = 2
            item = '岸鹽乾糧'
            description = '寂岩孤島最便宜也最實用的乾糧，適合白身撐一天。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        },
        [ordered]@{
            id = 'lamp-oil'
            title = '補一囊短窗燈油'
            cost = 3
            item = '短窗燈油囊'
            description = '給近岸短窗燈用的油囊，夜裡跑腿很有用。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        },
        [ordered]@{
            id = 'oath-cloth'
            title = '換一條誓結布條'
            cost = 1
            item = '誓結布條'
            description = '守誓和跑腿的人都會帶的便宜小物，能當記號也能當臨時綁帶。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        }
    )
    'tidesigh-sea-cave' = @(
        [ordered]@{
            id = 'dive-charms'
            title = '買一組潛路浮標片'
            cost = 4
            item = '潛路浮標片'
            description = '給短時下潛和回線記號用的廉價浮標片。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        },
        [ordered]@{
            id = 'brine-wrap'
            title = '買一包海鹽止浸布'
            cost = 3
            item = '海鹽止浸布'
            description = '給濕傷和擦破皮先壓一壓的常見材料。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        },
        [ordered]@{
            id = 'bubble-flask'
            title = '換一只淺層氣泡瓶'
            cost = 5
            item = '淺層氣泡瓶'
            description = '不是深潛用，但夠應付短距探洞和錯返潛路。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        }
    )
    'silent-chant-cape' = @(
        [ordered]@{
            id = 'signal-cloth'
            title = '買一套霧號布'
            cost = 3
            item = '霧號布'
            description = '給岬哨和引線人對遠處做簡號提示。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        },
        [ordered]@{
            id = 'spare-line'
            title = '換一卷備索'
            cost = 4
            item = '備索卷'
            description = '斷索號這種事見多了，很多白身都先把備索備著。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        },
        [ordered]@{
            id = 'watch-balm'
            title = '買一盒守夜暖膏'
            cost = 2
            item = '守夜暖膏'
            description = '夜風硬時抹在手臂和肩頸，至少不會冷得太快。'
            source_path = 'content/scenarios/regions/whispersea/shops-and-services.md'
        }
    )
}
$Script:CompanionQuestCatalog = [ordered]@{
    'companion-whispersea-chaoguheng-01' = [ordered]@{
        quest_id = 'companion-whispersea-chaoguheng-01'
        title = '寂岩孤島的返線舊扣'
        entry_point_id = 'silent-rock-islet'
        arc = '同行支線'
        chapter_tier = 'companion'
        board_hint = '潮骨衡終於願意把一枚只交給自己人處理的舊扣交給你。'
        unlock_requirements = [ordered]@{
            npc_id = 'character-whispersea-chaoguheng'
            minimum_affinity = 3
            minimum_milestones = 1
        }
        core_conflict = '一枚本該留在近岸守線裡的舊扣，被人偷偷換進了不該碰的手。潮骨衡不想把這件事鬧大，只想先把它從錯線裡帶回來。'
        key_npcs = @(
            'character-whispersea-chaoguheng',
            'character-whispersea-yuhuanpo',
            'character-whispersea-wuduocen'
        )
        decision = '你要替潮骨衡把這件事悄悄壓回可控，還是順手把牽出來的人也一起記住？'
        progress = [ordered]@{
            steps = @(
                [ordered]@{
                    step_id = 'hear-the-old-knot'
                    title = '聽潮骨衡把舊扣的來路說清'
                    location_id = 'silent-rock-islet'
                    goal_text = '先把潮骨衡不願寫上帳簿的那一小段舊事聽清楚。'
                    advance_command = 'hear-old-knot'
                    advance_aliases = @('hear', 'old-knot', '舊扣', '聽來路')
                    result_text = '潮骨衡把那枚舊扣翻給你看，說這不是值錢物，只是不能落進錯的人手裡。你聽完才知道，真正麻煩的不是東西，而是它一旦被拿來當藉口，近岸很多舊誓都會一起被拖下水。'
                    clues = @(
                        '潮骨衡想壓下的不是物件本身，而是它可能扯出的舊誓風波',
                        '這枚舊扣最近曾被人帶去潮息海窟一帶試探路線'
                    )
                },
                [ordered]@{
                    step_id = 'trace-the-false-hand'
                    title = '去潮息海窟把錯手的痕跡找出來'
                    location_id = 'tidesigh-sea-cave'
                    goal_text = '把這枚舊扣在潮息海窟一帶留下的錯手痕跡找出來。'
                    advance_command = 'trace-false-hand'
                    advance_aliases = @('trace', 'false-hand', '錯手', '追痕')
                    result_text = '你沿著潮息海窟的短窗記號一路問到浮標旁，最後從一片刻意被刮掉的記痕裡看出來：這不是單純拿錯，而是有人在試著看近岸守線能不能被外人拿來當借口。'
                    clues = @(
                        '有人在潮息海窟一帶試探近岸守線的反應',
                        '這枚舊扣被帶出去時，刻意避開了正式帳簿'
                    )
                },
                [ordered]@{
                    step_id = 'return-the-knot'
                    title = '把舊扣和錯手記號一起帶回寂岩孤島'
                    location_id = 'silent-rock-islet'
                    goal_text = '把能證明來路與錯手的東西一起帶回去，好讓潮骨衡自己收尾。'
                    advance_command = 'return-knot'
                    advance_aliases = @('return', 'knot', '帶回', '回島')
                    result_text = '你把舊扣和那段被刮掉的記痕一併帶回寂岩孤島。潮骨衡看過後沒有立刻發火，只是把它們分開收起來，像是終於能把這件事鎖回不會拖垮整片近岸守線的位置。'
                    clues = @(
                        '潮骨衡更在乎把局勢鎖回可控，而不是立刻追出所有人',
                        '近岸守線裡有一套不寫進大帳的收尾方式'
                    )
                }
            )
            completion = [ordered]@{
                turn_in_location_id = 'silent-rock-islet'
                turn_in_npc_id = 'character-whispersea-chaoguheng'
                turn_in_text = '潮骨衡把舊扣重新扣回誓結底下，只說這趟你不是替他跑腿，而是真的替近岸把一條差點鬆掉的線拽回來。從這之後，他看你時少了一層外人味。'
                rewards = [ordered]@{
                    currency = 14
                    items = @('近岸守扣', '潮骨封繩')
                    reputation = [ordered]@{
                        track_id = 'whispersea-local'
                        delta = 1
                        label = '幽語海地方守線'
                    }
                    job_directions = @('守誓學徒', '引路見習')
                }
            }
        }
        source_paths = @(
            'content/world/07-characters/whispersea/chaoguheng.md',
            'content/scenarios/regions/whispersea/questlines.md',
            'content/scenarios/regions/whispersea/starter-overview.md'
        )
    }
    'companion-whispersea-wuduocen-01' = [ordered]@{
        quest_id = 'companion-whispersea-wuduocen-01'
        title = '潮息海窟的假路頁'
        entry_point_id = 'tidesigh-sea-cave'
        arc = '同行支線'
        chapter_tier = 'companion'
        board_hint = '霧舵岑終於肯把一頁平常不給外人碰的潮窗簿殘頁交給你。'
        unlock_requirements = [ordered]@{
            npc_id = 'character-whispersea-wuduocen'
            minimum_affinity = 3
            minimum_milestones = 1
        }
        core_conflict = '霧舵岑發現有人拿假路頁去騙短工和新手下潛。他不想把整個潮息海窟鬧成公案，只想先把那頁假路從人群裡剝出來。'
        key_npcs = @(
            'character-whispersea-wuduocen',
            'character-whispersea-fanchaoshu',
            'character-whispersea-jialingniang'
        )
        decision = '你要先把假路頁的去向掐死，還是趁機把背後那批人常走的假窗口一起記住？'
        progress = [ordered]@{
            steps = @(
                [ordered]@{
                    step_id = 'read-the-torn-page'
                    title = '先把那頁被撕下的假路看懂'
                    location_id = 'tidesigh-sea-cave'
                    goal_text = '在霧舵岑身邊先把那頁假路頁的錯法看懂。'
                    advance_command = 'read-torn-page'
                    advance_aliases = @('read', 'torn-page', '假路頁', '看殘頁')
                    result_text = '霧舵岑指著殘頁上幾個看似無害的泡列給你看，告訴你真正可怕的不是它全錯，而是它只錯一小段，錯得剛好會害新手在最想快一點的地方送命。'
                    clues = @(
                        '假路頁最危險的地方在於它只錯最致命的一小段',
                        '這種假路像是故意拿來騙剛能看懂半套的人'
                    )
                },
                [ordered]@{
                    step_id = 'mark-the-false-window'
                    title = '去靜唱索岬把假窗口記號圈出來'
                    location_id = 'silent-chant-cape'
                    goal_text = '把那條假窗口在邊海留下的記號圈出來，免得再騙到下一批人。'
                    advance_command = 'mark-false-window'
                    advance_aliases = @('mark', 'false-window', '假窗口', '圈記號')
                    result_text = '你在靜唱索岬邊的舊號布旁比出那頁假路的節奏，果然對上了一串故意被做得像救急路線的假窗口。你把能害人的那段先圈死，至少今晚不會再有人順著它往裡鑽。'
                    clues = @(
                        '假路頁和靜唱索岬的舊號序是一起設的',
                        '有人故意把救急線和騙命線做得很像'
                    )
                },
                [ordered]@{
                    step_id = 'seal-the-page'
                    title = '把假路頁和號序記號帶回潮息海窟封起來'
                    location_id = 'tidesigh-sea-cave'
                    goal_text = '帶著比對後的記號回到潮息海窟，讓霧舵岑親手封掉這頁假路。'
                    advance_command = 'seal-page'
                    advance_aliases = @('seal', 'page', '封頁', '帶回封樣')
                    result_text = '霧舵岑把那頁假路頁和你帶回的號序記號一起釘進封樣夾裡，冷冷說了一句：這樣至少下一個想拿半套記法裝懂的人，會先撞到我們留在前面的牆。'
                    clues = @(
                        '潮息海窟對假路的處理不是公開鬧大，而是先封死可用性',
                        '霧舵岑對新手最大的善意，就是不讓半套記法先害死人'
                    )
                }
            )
            completion = [ordered]@{
                turn_in_location_id = 'tidesigh-sea-cave'
                turn_in_npc_id = 'character-whispersea-wuduocen'
                turn_in_text = '霧舵岑把封樣夾收回袖裡，只留一句很短的話給你：你現在不只是在看潮窗，已經開始會替別人拆假路了。那語氣比誇獎更像一種慢慢交出去的信任。'
                rewards = [ordered]@{
                    currency = 15
                    items = @('封樣潮頁', '短窗記線片')
                    reputation = [ordered]@{
                        track_id = 'whispersea-route'
                        delta = 1
                        label = '幽語海道路判讀'
                    }
                    job_directions = @('引水見習', '潮窗判讀手')
                }
            }
        }
        source_paths = @(
            'content/world/07-characters/whispersea/wuduocen.md',
            'content/scenarios/regions/whispersea/questlines.md',
            'content/scenarios/regions/whispersea/location-circuit.md'
        )
    }
    'companion-whispersea-jialingniang-01' = [ordered]@{
        quest_id = 'companion-whispersea-jialingniang-01'
        title = '靜唱索岬的回鈴夜線'
        entry_point_id = 'silent-chant-cape'
        arc = '同行支線'
        chapter_tier = 'companion'
        board_hint = '絞鈴娘終於肯讓你碰一段只在她守線圈裡流動的夜鈴路。'
        unlock_requirements = [ordered]@{
            npc_id = 'character-whispersea-jialingniang'
            minimum_affinity = 3
            minimum_milestones = 1
        }
        core_conflict = '靜唱索岬有一段只在夜裡傳的回鈴線最近總是慢半拍。絞鈴娘不想驚動整條邊線，只想先把節奏找回來。'
        key_npcs = @(
            'character-whispersea-jialingniang',
            'character-whispersea-chaoguheng',
            'character-whispersea-wuduocen'
        )
        decision = '你要先保住今晚的邊線節奏，還是趁機把那個故意讓回鈴慢半拍的人也一併記住？'
        progress = [ordered]@{
            steps = @(
                [ordered]@{
                    step_id = 'listen-night-bell'
                    title = '先聽靜唱索岬夜鈴哪裡慢半拍'
                    location_id = 'silent-chant-cape'
                    goal_text = '先在絞鈴娘旁邊把那段失序的夜鈴節奏聽清楚。'
                    advance_command = 'listen-night-bell'
                    advance_aliases = @('listen', 'night-bell', '夜鈴', '聽回鈴')
                    result_text = '你跟著絞鈴娘在夜風裡把回鈴一拍拍聽過去，終於分辨出真正不對勁的不是鈴聲本身，而是有人把備索掛位偷偷挪了半寸，讓接力總在最怕亂的時候慢上一口氣。'
                    clues = @(
                        '靜唱索岬的夜鈴失序來自備索掛位被人動過',
                        '這種慢半拍最容易在真正出事時害邊線斷氣'
                    )
                },
                [ordered]@{
                    step_id = 'borrow-the-right-line'
                    title = '去寂岩孤島借一段正確的守線索法'
                    location_id = 'silent-rock-islet'
                    goal_text = '去寂岩孤島把能補回節奏的正確綁法借回來。'
                    advance_command = 'borrow-right-line'
                    advance_aliases = @('borrow', 'right-line', '借索法', '借綁法')
                    result_text = '你把靜唱索岬那段錯位說給近岸的人聽，換回一套更老但更穩的守線綁法。那不是什麼新技巧，只是很多人嫌慢、不肯老實照做的笨功夫。'
                    clues = @(
                        '穩得住邊線的往往不是花俏手段，而是肯照老法慢慢補回去',
                        '寂岩孤島還留著一套能把夜鈴節奏拉回正拍的守線綁法'
                    )
                },
                [ordered]@{
                    step_id = 'reset-the-bell-line'
                    title = '回靜唱索岬把夜線節奏重新校回來'
                    location_id = 'silent-chant-cape'
                    goal_text = '把借回來的綁法和鈴位一起校回正拍，讓今晚整條邊線不再慢半拍。'
                    advance_command = 'reset-bell-line'
                    advance_aliases = @('reset', 'bell-line', '校回鈴線', '回正拍')
                    result_text = '你和絞鈴娘把那段夜線一寸寸重校回去，等回鈴重新沿著邊海敲開時，她只是很輕地點了一下頭。那點頭比一句誇獎還重，像是默許你真的站進了守線圈裡。'
                    clues = @(
                        '絞鈴娘把能一起守回節奏的人看得比會說話的人重',
                        '夜鈴線一旦被校回正拍，整條邊海的壓力都會安靜很多'
                    )
                }
            )
            completion = [ordered]@{
                turn_in_location_id = 'silent-chant-cape'
                turn_in_npc_id = 'character-whispersea-jialingniang'
                turn_in_text = '絞鈴娘把那枚夜鈴扣重新繫回你的腕邊，說你現在至少知道什麼叫把一整段節奏守回來。這不是稱號，卻比稱號更像真正被守線圈認下的一步。'
                rewards = [ordered]@{
                    currency = 15
                    items = @('夜鈴扣', '守線結索')
                    reputation = [ordered]@{
                        track_id = 'whispersea-watch'
                        delta = 1
                        label = '幽語海邊線守望'
                    }
                    job_directions = @('守岬候補', '斷索補線手')
                }
            }
        }
        source_paths = @(
            'content/world/07-characters/whispersea/jialingniang.md',
            'content/scenarios/regions/whispersea/questlines.md',
            'content/scenarios/regions/whispersea/location-circuit.md'
        )
    }
}
$Script:NpcConversationProfiles = @{
    'character-whispersea-chaoguheng' = [ordered]@{
        first_text = '潮骨衡沒有急著把你當自己人，只是先問你這次是來守事、跑事，還是單純想在幽語海活下去。你把話說得不滿不空，他便丟給你一句老話：先學會把人和路都帶回來，再談自己想成為什麼。'
        repeat_text = '潮骨衡這次不再多說，只提醒你別把幽語海的活路看成誰都能隨意借的便宜。'
        clues = @('潮骨衡看重的不是膽子，而是能不能把人和路都帶回來')
        reputation_track = 'whispersea-local'
        reputation_delta = 1
        job_directions = @('守誓學徒', '引路見習')
        pressure_tags = @()
        companion_role = '近岸守誓同行'
        companion_background = '寂岩孤島近岸守誓線的衡定者，長年替人分辨錯手、惡意與真正會害死人的失線。'
        companion_style = '守線型。先穩局，再逼亂流和亂心都沒有一口氣撲上來的機會。'
        companion_preferences = [ordered]@{
            likes = @('守誓工具', '備索', '肯把人帶回來的人')
            dislikes = @('逞勇硬闖', '把活路當便宜借道', '嘴比手快')
            preferred_supplies = @('備索卷', '海鹽止浸布', '誓結布條')
            preferred_equipment = @('武器', '防具')
        }
        growth_plan = [ordered]@{
            title = '近岸守誓路'
            milestones = @(
                [ordered]@{
                    id = 'nearshore-rhythm'
                    title = '近岸守線'
                    requirement_type = 'shared_steps'
                    requirement_value = 3
                    summary = '一起跑過幾段近岸路後，潮骨衡開始把你當成真的能守線的人。'
                },
                [ordered]@{
                    id = 'held-the-line'
                    title = '把局面壓回來'
                    requirement_type = 'danger_supports'
                    requirement_value = 2
                    summary = '在硬局裡一起頂過幾次後，他出手會更敢更穩。'
                },
                [ordered]@{
                    id = 'oath-supplies'
                    title = '誓結默契'
                    requirement_type = 'preferred_hits'
                    requirement_value = 2
                    summary = '你開始知道該給他什麼，他也開始知道你什麼時候真的懂了。'
                }
            )
        }
        companion_strengths = @('近岸守線', '扛壓', '把局面壓回可控')
        companion_cautions = @('不愛追擊', '不喜歡花俏手段', '對外人起步偏冷')
        companion_stats = [ordered]@{
            穩線 = 5
            守壓 = 5
            察流 = 3
            人情 = 2
            硬拼 = 4
        }
        recruit_threshold = 2
        stay_reason = '只要近岸這條線還有人肯一起守、也還沒被你拖進沒必要的亂局，他就不急著離開。'
        leave_triggers = @('你反覆拿活路去硬賭', '你把近岸守線當成可隨便借用的便宜', '你明知道會拖死人還硬闖')
        recruit_text = '潮骨衡看了你一眼，沒有把話說得太滿，只說：你既然能把線看回來，那就先跟我走一段近岸。別拖人下水。'
        dismiss_text = '潮骨衡把手裡的誓結重新束回腕上，只說你先自己把這段路走熟，之後再談要不要並肩。'
        companion_presence_text = '潮骨衡安靜地跟在你側後，不時抬眼量一下潮線和人心是不是都還站在該站的位置。'
        danger_support_text = '潮骨衡沒有替你硬扛一切，而是先一步卡住最容易失線的位置，逼那股亂流和亂心都不能一口氣撲到你身上。'
        danger_support_clues = @('潮骨衡替你守住了最容易失線的那一側')
        danger_support_reputation_track = 'whispersea-local'
        danger_support_reputation_delta = 1
        danger_support_clear_pressure = 1
    }
    'character-whispersea-yuhuanpo' = [ordered]@{
        first_text = '魚還婆邊收魚邊看你，最後只說了一句：在這片海上，很多人先學的不是怎麼賺，而是怎麼不把舊誓踩碎。她順手塞給你一片舊潮牌，叫你拿著去對一對島邊那些快散掉的記號。'
        repeat_text = '魚還婆把魚簍一合，叫你下次帶著真正看懂的東西再來，不要只拿風聲湊話。'
        clues = @('魚還婆知道不少舊誓和島邊記號的老故事')
        reputation_track = $null
        reputation_delta = 0
        job_directions = @('採樣短工')
        pressure_tags = @('舊誓牽掛')
        items = @('舊潮牌')
    }
    'character-whispersea-wuduocen' = [ordered]@{
        first_text = '霧舵岑一邊盯著潮窗簿，一邊讓你站到旁邊看他怎麼刪掉那些不該拿命去賭的短窗。他沒有說教，只冷冷補一句：能活著把窗口判對，就已經是一門職業。'
        repeat_text = '霧舵岑只把潮窗簿往你這邊推了一寸，示意你先把眼前這一頁看懂，再談別的。'
        clues = @('霧舵岑把錯返潛路和可用潮窗看得比什麼都嚴')
        reputation_track = 'whispersea-route'
        reputation_delta = 1
        job_directions = @('引水見習', '潮窗判讀手')
        pressure_tags = @()
        companion_role = '潮窗判路同行'
        companion_background = '潮息海窟一帶專看短窗與回流的老手，靠一頁頁潮窗簿把很多人從錯返潛路邊緣拉回來。'
        companion_style = '判路型。比起硬頂，更擅長在局勢翻壞前先把假路拆出來。'
        companion_preferences = [ordered]@{
            likes = @('記錄清楚的人', '浮標片', '會先看再動的人')
            dislikes = @('拿命賭短窗', '亂改潮窗簿', '吵鬧英雄氣')
            preferred_supplies = @('潛路浮標片', '淺層氣泡瓶', '海鹽止浸布')
            preferred_equipment = @('飾品', '武器')
        }
        growth_plan = [ordered]@{
            title = '潮窗判讀路'
            milestones = @(
                [ordered]@{
                    id = 'window-memory'
                    title = '短窗記性'
                    requirement_type = 'shared_steps'
                    requirement_value = 3
                    summary = '一起看過夠多次潮窗後，霧舵岑開始願意把更細的判讀法留給你。'
                },
                [ordered]@{
                    id = 'split-the-false-path'
                    title = '拆假路'
                    requirement_type = 'danger_supports'
                    requirement_value = 2
                    summary = '你們一起拆掉幾次假路後，他能更早把錯線挑出來。'
                },
                [ordered]@{
                    id = 'well-prepared'
                    title = '備得對路'
                    requirement_type = 'preferred_hits'
                    requirement_value = 2
                    summary = '你給的東西越來越貼手，讓他在危局裡也不必現想。'
                }
            )
        }
        companion_strengths = @('判潮窗', '拆假路', '讓隊伍活著退也活著進')
        companion_cautions = @('不愛硬拼', '脾氣偏冷', '對粗心的人耐性很低')
        companion_stats = [ordered]@{
            穩線 = 4
            守壓 = 3
            察流 = 5
            人情 = 2
            硬拼 = 2
        }
        recruit_threshold = 2
        stay_reason = '只要你還願意先看路、先拆假路，而不是把命拿去賭短窗，他通常會繼續陪你把這段路看深。'
        leave_triggers = @('你把短窗當賭局', '你反覆不看記號就亂衝', '你明知是假路還要拖人跟你一起試')
        recruit_text = '霧舵岑把潮窗簿合上，像是終於勉強承認你不是只會站在旁邊看熱鬧的人。若你還想把路看深一點，他可以陪你跑一段。'
        dismiss_text = '霧舵岑把簿頁往袖裡一收，讓你先自己記一段泡列再說，不打算每一步都替你補第二句。'
        companion_presence_text = '霧舵岑一路都在留意潮窗與回流，偶爾只用一句很短的提醒，把你從錯線邊緣扯回來。'
        danger_support_text = '霧舵岑在局勢翻壞前就先指出哪股回流是假路，讓你不是靠硬撐，而是靠準線把身位和節奏穩住。'
        danger_support_clues = @('霧舵岑替你拆出一條能活著退也能繼續頂的線')
        danger_support_reputation_track = 'whispersea-route'
        danger_support_reputation_delta = 1
        danger_support_clear_pressure = 1
    }
    'character-whispersea-fanchaoshu' = [ordered]@{
        first_text = '帆潮書看你像看一張還沒寫完的帳頁，先教你怎麼記泡、怎麼記錯返，最後才說：白身也能學會一套自己的海路字，只要你不是看一半就急著裝懂。'
        repeat_text = '帆潮書這次只要你把上一回記下的泡列再對一遍，不想讓你把半套記法當成本事。'
        clues = @('帆潮書會先教記法，再看人配不配碰真正的潛路')
        reputation_track = $null
        reputation_delta = 0
        job_directions = @('採樣短工', '引水見習')
        pressure_tags = @('記法還不穩')
    }
    'character-whispersea-jialingniang' = [ordered]@{
        first_text = '絞鈴娘把斷索和舊號一件件攤開給你看，讓你第一次意識到邊海守望不是喊兩聲就算數，而是一整套不讓人白死的細活。她說你要是肯學，先從看懂哪條索快斷開始。'
        repeat_text = '絞鈴娘沒有再多說，只叫你自己盯著風和索的節奏去看，別老等別人把答案塞過來。'
        clues = @('絞鈴娘把斷索、風變和號路看成同一套守線技藝')
        reputation_track = 'whispersea-watch'
        reputation_delta = 1
        job_directions = @('守岬候補', '斷索補線手')
        pressure_tags = @()
        companion_role = '岬哨守線同行'
        companion_background = '長年守在靜唱索岬的老哨手，把斷索、風變與霧號記成同一套活命節奏。'
        companion_style = '節奏型。擅長在場面最亂時先把步點敲穩，讓人不至於被危險拖著跑。'
        companion_preferences = [ordered]@{
            likes = @('備索', '霧號布', '守得住節奏的人')
            dislikes = @('亂改號序', '嘴上逞強', '把守線當例行公事')
            preferred_supplies = @('備索卷', '霧號布', '守夜暖膏')
            preferred_equipment = @('防具', '飾品')
        }
        growth_plan = [ordered]@{
            title = '岬哨守望路'
            milestones = @(
                [ordered]@{
                    id = 'watch-rhythm'
                    title = '守線節奏'
                    requirement_type = 'shared_steps'
                    requirement_value = 3
                    summary = '一起巡過幾次邊線後，絞鈴娘開始把你算進她的守望節奏。'
                },
                [ordered]@{
                    id = 'hold-the-cape'
                    title = '岬線不亂'
                    requirement_type = 'danger_supports'
                    requirement_value = 2
                    summary = '在亂局裡一起穩過節奏後，她會更快替你把場面敲回正拍。'
                },
                [ordered]@{
                    id = 'gifted-gear'
                    title = '順手守具'
                    requirement_type = 'preferred_hits'
                    requirement_value = 2
                    summary = '你開始知道什麼裝備和補給真能讓她守得更久、更準。'
                }
            )
        }
        companion_strengths = @('守哨節奏', '扛亂局', '邊線穩場')
        companion_cautions = @('不愛長談', '對失序很敏感', '對新手要求高')
        companion_stats = [ordered]@{
            穩線 = 4
            守壓 = 4
            察流 = 4
            人情 = 3
            硬拼 = 3
        }
        recruit_threshold = 2
        stay_reason = '只要你還把邊線、風和索當成真要命的事，而不是把她的守望當免費保險，她就不會急著抽身。'
        leave_triggers = @('你把守線節奏當耳邊風', '你明知道要斷還硬拖人上', '你把她的守望當成理所當然')
        recruit_text = '絞鈴娘把一枚哨鈴扣到你手裡，意思比話還清楚。若你這趟真要往邊線走，她可以陪你看一段風和索。'
        dismiss_text = '絞鈴娘把鈴扣收回袖裡，只讓你先自己記住風和索的節奏，別太快把旁人的守望當成理所當然。'
        companion_presence_text = '絞鈴娘行走時幾乎不出聲，只有在風向和索線開始不對時，才會用極短的一句話把你敲回正線。'
        danger_support_text = '絞鈴娘在最亂的時候先把節奏敲穩，讓你不是被危險追著跑，而是能重新抓回自己和局勢的步點。'
        danger_support_clues = @('絞鈴娘用守線節奏替你把場面重新壓回可控')
        danger_support_reputation_track = 'whispersea-watch'
        danger_support_reputation_delta = 1
        danger_support_clear_pressure = 1
    }
}
$Script:OddJobCatalog = @{
    'silent-rock-islet' = @(
        [ordered]@{
            id = 'shore-oath-run'
            title = '替島邊跑一趟舊誓口信'
            description = '跟著老島民把一句不方便大聲講的舊誓口信送到礁邊。'
            reward_text = '你把話帶到，又沒有多問，對方回了你一枚小小的潮結扣。'
            currency = 3
            items = @('潮結扣')
            clues = @('島邊很多工作不是跑得快，而是嘴要夠緊')
            reputation_track = 'whispersea-local'
            reputation_delta = 1
            job_directions = @('短工跑腿', '守誓學徒')
            source_path = 'content/scenarios/regions/whispersea/learning-entrypoints.md'
        },
        [ordered]@{
            id = 'rock-pool-sorting'
            title = '幫忙分揀潮池採樣'
            description = '把一整籃混著鹽藻、碎殼和潮泥的採樣先分乾淨。'
            reward_text = '你做得不快，但手夠穩，沒有把可用樣本全毀掉。'
            currency = 2
            items = @('鹽藻樣包')
            clues = @('採樣手的第一課常常只是別把好東西全弄壞')
            reputation_track = $null
            reputation_delta = 0
            job_directions = @('採樣短工')
            source_path = 'content/scenarios/regions/whispersea/learning-entrypoints.md'
        }
    )
    'tidesigh-sea-cave' = @(
        [ordered]@{
            id = 'bubble-watch'
            title = '替潛路口記一輪泡列'
            description = '站在潮息海窟口，把短窗內冒出的泡列先記成粗表。'
            reward_text = '霧舵線上的人看了你的粗表，雖然改了不少，還是願意給你一點辛苦錢。'
            currency = 4
            items = @()
            clues = @('泡列不是死的，時間和回流一變，整行就得重記')
            reputation_track = 'whispersea-route'
            reputation_delta = 1
            job_directions = @('引水見習', '潮窗判讀手')
            source_path = 'content/scenarios/regions/whispersea/learning-entrypoints.md'
        },
        [ordered]@{
            id = 'salt-wrap-delivery'
            title = '幫潛手送一趟止浸布'
            description = '把剛曬好的止浸布送到剛上岸的潛手那邊。'
            reward_text = '你沒有多問傷口和貨，只把該送的東西準時送到，對方看你的眼神也軟了點。'
            currency = 3
            items = @('海鹽止浸布')
            clues = @('幽語海很多關係，是靠準時和不多嘴慢慢養出來的')
            reputation_track = 'whispersea-local'
            reputation_delta = 1
            job_directions = @('短工跑腿', '引水見習')
            source_path = 'content/scenarios/regions/whispersea/learning-entrypoints.md'
        }
    )
    'silent-chant-cape' = @(
        [ordered]@{
            id = 'signal-cloth-drying'
            title = '替岬哨曬一輪霧號布'
            description = '把夜裡受潮的霧號布重新曬好，再按號序疊回去。'
            reward_text = '你把號布順序沒弄亂，守線的人終於願意讓你碰這些平常不隨便給外人摸的東西。'
            currency = 3
            items = @('霧號布角片')
            clues = @('很多岬哨技藝，最開始都只是從不把東西搞亂開始')
            reputation_track = 'whispersea-watch'
            reputation_delta = 1
            job_directions = @('守岬候補')
            source_path = 'content/scenarios/regions/whispersea/learning-entrypoints.md'
        },
        [ordered]@{
            id = 'spare-line-coiling'
            title = '幫忙重捲一批備索'
            description = '把舊備索挑掉壞段，再照守線習慣重捲成能即拿即用的樣子。'
            reward_text = '你手法還生，但至少知道哪種索不能硬留。這一點常識在這裡很值錢。'
            currency = 4
            items = @('備索短段')
            clues = @('斷索不是意外而已，很多時候也是平常手腳有沒有做實')
            reputation_track = 'whispersea-watch'
            reputation_delta = 1
            job_directions = @('斷索補線手', '守岬候補')
            source_path = 'content/scenarios/regions/whispersea/learning-entrypoints.md'
        }
    )
}
$Script:EncounterProfiles = @{
    'social-anomaly' = [ordered]@{
        title = '霧邊低歌'
        category = 'social'
        options = @(
            [ordered]@{
                key = 'observe'
                title = '先停下來觀察'
                result_text = '你先壓住動作，任海霧和低低的潮歌從耳邊擦過。很快你就聽出來，那不是單純的怪聲，而是有人在用半斷的舊歌確認來者懂不懂這片水路的規矩。'
                clues = @('霧邊低歌常被用來試探來者是否懂潮路規矩')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('採樣短工')
                pressure_tags = @('霧歌餘響')
                followup = [ordered]@{
                    title = '霧歌回句'
                    category = 'followup-social'
                    text = '那陣低歌沒有立刻散去，霧裡反而像故意留出了一小段空白，等著看你是懂節奏的人，還是只會靠運氣撞水路的外人。'
                    options = @(
                        [ordered]@{
                            key = 'echo-song'
                            title = '照著舊調回一句'
                            result_text = '你沒有唱得多漂亮，卻把最重要的句尾接住了。霧裡那人沒有現身，只把一段偏安全的潮窗時間留給你，像是在說這次先算你懂規矩。'
                            clues = @('有些潮路情報只會留給聽得懂舊調的人')
                            currency = 1
                            items = @()
                            reputation_track = 'whispersea-route'
                            reputation_delta = 1
                            job_directions = @('引路見習')
                            pressure_tags = @()
                        },
                        [ordered]@{
                            key = 'memorize-rhythm'
                            title = '不回句，只記住節奏'
                            result_text = '你沒有急著回應，而是把那段節奏死死記進腦裡。對方沒有再多給你什麼，但你也因此記住了幽語海某種只在近霧邊才會出現的暗號。'
                            clues = @('幽語海有些暗號是用節奏而不是話在傳')
                            currency = 0
                            items = @('潮痕短記片')
                            reputation_track = $null
                            reputation_delta = 0
                            job_directions = @('採樣短工')
                            pressure_tags = @('記下了半套霧歌')
                        }
                    )
                }
            },
            [ordered]@{
                key = 'approach'
                title = '靠近並開口搭話'
                result_text = '你沒有把場面往壞處想，而是先照著本地人的節奏報上來意。霧裡的人聲沒有立刻親近你，但至少不再把你當成亂闖的人，還反手塞來一點潮路消息。'
                clues = @('幽語海的陌生接觸常靠歌句和語序辨認敵我')
                currency = 2
                items = @()
                reputation_track = 'whispersea-local'
                reputation_delta = 1
                job_directions = @('引路見習')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'withdraw'
                title = '先退一步保命'
                result_text = '你沒有逞強，先讓自己脫離那團不對勁的霧。你失去了一次接觸的機會，但也沒有把自己硬塞進不確定的局裡。'
                clues = @('有些海霧裡的聲音不是給白身硬接的')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('錯過一次霧邊接觸')
            }
        )
    }
    'monster-blockage' = [ordered]@{
        title = '海獸阻路'
        category = 'danger'
        options = @(
            [ordered]@{
                key = 'detour'
                title = '先找繞行線'
                result_text = '你不和那團不安分的影子硬頂，而是貼著較淺的回流邊找到一條勉強能過的替代線。慢是慢了些，但至少人和貨都還在。'
                clues = @('幽語海很多阻路海獸都有可避讓的側線')
                currency = 0
                items = @()
                reputation_track = 'whispersea-route'
                reputation_delta = 1
                job_directions = @('引水見習')
                pressure_tags = @('行程延後')
                followup = [ordered]@{
                    title = '側線餘波'
                    category = 'followup-danger'
                    text = '你雖然繞了過去，但那條側線顯然不是常走的正路。眼下你得決定，是把這條線正式記下來，還是趁窗口還沒關死前趕快把行程接回去。'
                    options = @(
                        [ordered]@{
                            key = 'mark-route'
                            title = '先把側線記成可用標記'
                            result_text = '你花了點時間把水勢、礁影和霧向都對好，替這條不穩的繞行線留下了日後可用的記號。'
                            clues = @('阻路海獸的側線若記得夠細，之後能救很多人一趟')
                            currency = 0
                            items = @('側線記號片')
                            reputation_track = 'whispersea-route'
                            reputation_delta = 1
                            job_directions = @('引水見習')
                            pressure_tags = @()
                        },
                        [ordered]@{
                            key = 'rush-window'
                            title = '趁窗口還在先趕路'
                            result_text = '你把繞出的那點空間全拿去趕路，勉強把延誤壓了下來。這讓你保住了時程，卻也讓這條側線依舊只是你腦中的模糊印象。'
                            clues = @('有些繞行線要嘛當場記清，要嘛下次就像沒見過')
                            currency = 2
                            items = @()
                            reputation_track = $null
                            reputation_delta = 0
                            job_directions = @('短工跑腿')
                            pressure_tags = @('側線記錄不足')
                        }
                    )
                }
            },
            [ordered]@{
                key = 'drive'
                title = '試著驅離'
                result_text = '你舉燈、敲繩、用最笨但也最直接的法子把那頭攔路的東西逼開。場面很狼狽，但總算替後面的人搶出一小段能用的窗口。'
                clues = @('高聲與燈影在近岸海獸面前比武器更常派上用場')
                currency = 4
                items = @()
                reputation_track = 'whispersea-watch'
                reputation_delta = 1
                job_directions = @('夜巡短工')
                pressure_tags = @('手臂發麻')
            },
            [ordered]@{
                key = 'retreat'
                title = '後撤保線'
                result_text = '你沒有賭那一瞬的勇氣，而是先把人和物往後帶，留下明確的避讓標記。這次沒賺到什麼，但也沒有把局勢變成事故。'
                clues = @('保線和保命有時比硬過去更重要')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('岬哨候補')
                pressure_tags = @('退讓記號')
            }
        )
    }
    'ambush' = [ordered]@{
        title = '霧中試探'
        category = 'danger'
        options = @(
            [ordered]@{
                key = 'hide'
                title = '先壓低身形藏住'
                result_text = '你沒有急著動，而是先把自己的呼吸藏到潮聲後面。那幾道試探的影子晃過去時，並沒有真抓到你的準位置，反而讓你摸清了他們是從哪邊來的。'
                clues = @('霧中包夾常先試聲，不先露位就還有轉圜')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('夜巡短工')
                pressure_tags = @('心跳未平')
                followup = [ordered]@{
                    title = '影退後的潮痕'
                    category = 'followup-danger'
                    text = '那幾道影子滑開後，霧裡還留著一點很淡的踏浪節奏。你知道自己現在可以繼續縮著不動，也可以趁痕跡還沒散，反過來摸一點對方留下的線。'
                    options = @(
                        [ordered]@{
                            key = 'track-steps'
                            title = '順著殘痕摸回去'
                            result_text = '你沒有貪多，只沿著最明顯的一兩步去看，很快就判斷出對方不是本地老手，而是借霧裝熟的人。'
                            clues = @('這次霧中試探更像外來探手，不像本地守線')
                            currency = 0
                            items = @()
                            reputation_track = 'whispersea-watch'
                            reputation_delta = 1
                            job_directions = @('夜巡短工')
                            pressure_tags = @()
                        },
                        [ordered]@{
                            key = 'stay-still'
                            title = '繼續縮著等霧過'
                            result_text = '你沒有貪那一點多餘的線索，而是等到潮聲重新蓋過所有可疑聲響後才慢慢起身。你少知道了一些事，但也把自己從更深的試探裡抽了出來。'
                            clues = @('有時候不追，反而是白身能活下來的關鍵')
                            currency = 0
                            items = @()
                            reputation_track = $null
                            reputation_delta = 0
                            job_directions = @('岬哨候補')
                            pressure_tags = @('錯過反查窗口')
                        }
                    )
                }
            },
            [ordered]@{
                key = 'callout'
                title = '先出聲壓住對方'
                result_text = '你先一步喝出聲，逼對方意識到這裡不是完全無人的暗口。那幾道影子沒有戀戰，只留下一句試探意味很重的話就退了。'
                clues = @('有些伏影不是來殺人，而是來試誰敢站線')
                currency = 3
                items = @()
                reputation_track = 'whispersea-watch'
                reputation_delta = 1
                job_directions = @('岬哨候補')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'breakaway'
                title = '趁亂抽身離開'
                result_text = '你沒有跟那幾道影子糾纏，抓準一個浪頭就抽身離開。這讓你少聽到一些內情，但也保住了接下來還能繼續跑事的本錢。'
                clues = @('霧裡的試探往往比真正動手更常見')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('留了個背影給對方')
            }
        )
    }
    'grayline-pressure' = [ordered]@{
        title = '灰線施壓'
        category = 'social'
        options = @(
            [ordered]@{
                key = 'stall'
                title = '先拖字句，不立刻表態'
                result_text = '你沒有正面答應，也沒有把話說死，只把對方的條件記進心裡，再把自己從那條灰線的嘴上慢慢抽開。對方不滿，但也知道你不是完全沒腦子。'
                clues = @('灰線買手最常測的是白身會不會為小利直接鬆口')
                currency = 1
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('引路見習')
                pressure_tags = @('灰線記住了你的臉')
                followup = [ordered]@{
                    title = '灰線留手'
                    category = 'followup-social'
                    text = '對方沒有真的纏上來，只在你退開時故意把一句半真半假的路線消息留在耳邊。你可以現在就把它當線索處理，也可以選擇先把這筆接觸洗乾淨。'
                    options = @(
                        [ordered]@{
                            key = 'mark-buyer'
                            title = '把這個買手記下來'
                            result_text = '你沒有碰那筆生意，但把對方的語氣、步子和願意出的價都記得很清楚。以後再見到同一路人，你不會再完全毫無準備。'
                            clues = @('這名灰線買手偏愛用半真半假的航線消息換白身鬆口')
                            currency = 0
                            items = @()
                            reputation_track = $null
                            reputation_delta = 0
                            job_directions = @('採樣短工')
                            pressure_tags = @('灰線人脈索引')
                        },
                        [ordered]@{
                            key = 'wash-hands'
                            title = '立刻找地方把這次接觸洗掉'
                            result_text = '你沒有讓這次接觸在身上停太久，轉頭就去能見人的地方露臉，讓灰線很難再把你往他們的線上認。'
                            clues = @('灰線壓力最怕你立刻回到守線與公開視野裡')
                            currency = 0
                            items = @()
                            reputation_track = 'whispersea-local'
                            reputation_delta = 1
                            job_directions = @('守誓學徒')
                            pressure_tags = @()
                        }
                    )
                }
            },
            [ordered]@{
                key = 'refuse'
                title = '直接拒絕'
                result_text = '你把話說得夠硬，讓對方知道這件事今天在你身上過不了。這不會讓灰線喜歡你，但至少守線的人會知道你沒有亂開口子。'
                clues = @('灰線會記仇，但地方守線也會記得你有沒有守住底線')
                currency = 0
                items = @()
                reputation_track = 'whispersea-local'
                reputation_delta = 1
                job_directions = @('守誓學徒')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'trade'
                title = '只換不碰底線'
                result_text = '你沒有讓對方碰真正要命的東西，只用一點邊角消息換到自己眼下用得上的補給。這筆買賣不乾淨，但還沒壞到不可收拾。'
                clues = @('灰線往往先用小換小，慢慢試你能退到哪')
                currency = 3
                items = @('灰線乾鹽包')
                reputation_track = $null
                reputation_delta = 0
                job_directions = @('採樣短工')
                pressure_tags = @('灰線欠條')
            }
        )
    }
    'inspection' = [ordered]@{
        title = '水路查驗'
        category = 'social'
        options = @(
            [ordered]@{
                key = 'cooperate'
                title = '照規矩配合查驗'
                result_text = '你老老實實把身上的東西攤開，讓查驗的人一件件過。過程不舒服，但也因此少了很多猜忌，對方最後還順手提醒了你這一帶最近的禁線。'
                clues = @('配合查驗雖然慢，卻能換到更穩的地方信任')
                currency = 0
                items = @()
                reputation_track = 'whispersea-local'
                reputation_delta = 1
                job_directions = @('守誓學徒')
                pressure_tags = @()
                followup = [ordered]@{
                    title = '查驗後的窗口'
                    category = 'followup-social'
                    text = '查驗的人沒有立刻散去，反而像在看你接下來會不會把這點信任拿去換真正有用的東西。你可以趁這個窗口多問一句，或者安靜退開，把這次查驗留成乾淨紀錄。'
                    options = @(
                        [ordered]@{
                            key = 'ask-safe-line'
                            title = '順勢問一條最近可走的安全線'
                            result_text = '你沒有浪費這點難得的善意，低聲問了一句最近哪條線還算乾淨。對方沒有說得很滿，但至少給了你一段夠用的方向。'
                            clues = @('最近的安全線往往掌握在第一線查驗人員口中')
                            currency = 0
                            items = @()
                            reputation_track = 'whispersea-route'
                            reputation_delta = 1
                            job_directions = @('引水見習')
                            pressure_tags = @()
                        },
                        [ordered]@{
                            key = 'leave-clean'
                            title = '不多問，保持乾淨退場'
                            result_text = '你把該說的話留在查驗線裡，沒有再追問多餘內容。這讓你不像消息獵手，但也讓對方更願意把你看成守規矩的白身。'
                            clues = @('有時候少問，也是累積可信度的一部分')
                            currency = 0
                            items = @()
                            reputation_track = 'whispersea-local'
                            reputation_delta = 1
                            job_directions = @('守誓學徒')
                            pressure_tags = @()
                        }
                    )
                }
            },
            [ordered]@{
                key = 'explain'
                title = '主動把來意講清楚'
                result_text = '你不是只把東西掏出來，而是把自己為什麼在這裡、接的是哪條事也講明白。對方不見得完全信你，但至少知道你不是憑空冒出來的影子。'
                clues = @('在水路查驗裡，說得清自己站在哪條線上，本身就是一種本事')
                currency = 2
                items = @()
                reputation_track = 'whispersea-route'
                reputation_delta = 1
                job_directions = @('引水見習')
                pressure_tags = @()
            },
            [ordered]@{
                key = 'slip'
                title = '找縫先溜'
                result_text = '你在查驗線真正收緊前先滑了出去。這讓你保住了時間，但也讓某些人對你的臉和步子多留了心。'
                clues = @('躲過查驗不一定等於安全，只是把問題往後推')
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('查驗名單上多了一筆未明記號')
            }
        )
    }
}

foreach ($scripted in $ScriptedInputs) {
    $Script:InputQueue.Enqueue([string]$scripted)
}

function Read-GameInput {
    param([string]$Prompt)

    if ($Script:InputQueue.Count -gt 0) {
        $value = $Script:InputQueue.Dequeue()
        Write-Host ("{0}: {1}" -f $Prompt, $value) -ForegroundColor DarkGray
        return $value
    }

    return Read-Host $Prompt
}

function Ensure-SaveDirectory {
    if (-not (Test-Path $Script:SaveDirectory)) {
        New-Item -ItemType Directory -Force -Path $Script:SaveDirectory | Out-Null
    }
}

function ConvertTo-Hashtable {
    param([Parameter(ValueFromPipeline = $true)]$InputObject)

    if ($null -eq $InputObject) {
        return $null
    }

    if ($InputObject -is [System.Collections.IDictionary]) {
        $hash = [ordered]@{}
        foreach ($key in $InputObject.Keys) {
            $hash[$key] = ConvertTo-Hashtable -InputObject $InputObject[$key]
        }
        return $hash
    }

    if ($InputObject -is [pscustomobject]) {
        $hash = [ordered]@{}
        foreach ($property in $InputObject.PSObject.Properties) {
            $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
        }
        return $hash
    }

    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $collection = @()
        foreach ($item in $InputObject) {
            $collection += ConvertTo-Hashtable -InputObject $item
        }
        return $collection
    }

    return $InputObject
}

function Load-RegionPack {
    if (-not (Test-Path $Script:RegionPackPath)) {
        throw "找不到幽語海 region pack：$Script:RegionPackPath"
    }

    return Get-Content -Raw -Encoding utf8 $Script:RegionPackPath | ConvertFrom-Json
}

function Show-Title {
    Write-Host ''
    Write-Host '=========================================' -ForegroundColor DarkCyan
    Write-Host ' Elaris CLI Prototype - 幽語海白身開局 ' -ForegroundColor Cyan
    Write-Host '=========================================' -ForegroundColor DarkCyan
    Write-Host ''
}

function Show-Menu {
    Write-Host '1. 新遊戲'
    Write-Host '2. 讀取存檔'
    Write-Host '3. 離開'
}

function Read-Choice {
    param(
        [string]$Prompt,
        [int]$Min,
        [int]$Max
    )

    while ($true) {
        $raw = Read-GameInput $Prompt
        $number = 0
        if ([int]::TryParse($raw, [ref]$number) -and $number -ge $Min -and $number -le $Max) {
            return $number
        }
        Write-Host "請輸入 $Min 到 $Max 之間的數字。" -ForegroundColor Yellow
    }
}

function Add-UniqueString {
    param(
        [object[]]$Collection,
        [string]$Value
    )

    $base = @($Collection)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $base
    }
    if ($base -contains $Value) {
        return $base
    }
    return @($base + $Value)
}

function Add-UniqueStrings {
    param(
        [object[]]$Collection,
        [object[]]$Values
    )

    $result = @($Collection)
    foreach ($value in @($Values)) {
        $result = Add-UniqueString -Collection $result -Value ([string]$value)
    }
    return $result
}

function Remove-String {
    param(
        [object[]]$Collection,
        [string]$Value
    )

    $result = @()
    foreach ($entry in @($Collection)) {
        if ([string]$entry -ne [string]$Value) {
            $result += [string]$entry
        }
    }
    return @($result)
}

function Convert-EncounterOptions {
    param([object[]]$Options)

    $converted = @()
    foreach ($option in @($Options)) {
        $converted += [ordered]@{
            key = [string]$option.key
            title = [string]$option.title
            result_text = [string]$option.result_text
            clues = @($option.clues)
            currency = [int]$option.currency
            items = @($option.items)
            reputation_track = [string]$option.reputation_track
            reputation_delta = [int]$option.reputation_delta
            job_directions = @($option.job_directions)
            pressure_tags = @($option.pressure_tags)
            followup = $option.followup
        }
    }

    return @($converted)
}

function New-EncounterState {
    param(
        [string]$Type,
        [string]$Title,
        [string]$Category,
        [string]$SceneId,
        [string]$SceneName,
        [string]$Text,
        [object[]]$Options,
        [string]$Stage = 'primary',
        [string]$SourcePath = '',
        [string]$ParentTitle = ''
    )

    return [ordered]@{
        type = $Type
        title = $Title
        category = $Category
        scene_id = $SceneId
        scene_name = $SceneName
        text = $Text
        stage = $Stage
        source_path = $SourcePath
        parent_title = $ParentTitle
        options = @(Convert-EncounterOptions -Options $Options)
    }
}

function Add-ReputationDelta {
    param(
        [hashtable]$GameState,
        [string]$TrackId,
        [int]$Delta
    )

    if ([string]::IsNullOrWhiteSpace($TrackId) -or $Delta -eq 0) {
        return
    }

    $existingValue = 0
    if ($GameState.reputation.tracks.Contains($TrackId)) {
        $existingValue = [int]$GameState.reputation.tracks[$TrackId]
    }
    $GameState.reputation.tracks[$TrackId] = $existingValue + $Delta
}

function Get-NpcAffinityScore {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    if ([string]::IsNullOrWhiteSpace($NpcId)) {
        return 0
    }

    if ($null -eq $GameState.relationships -or -not $GameState.relationships.Contains('npc_affinity')) {
        return 0
    }

    if (-not $GameState.relationships.npc_affinity.Contains([string]$NpcId)) {
        return 0
    }

    return [int]$GameState.relationships.npc_affinity[[string]$NpcId]
}

function Get-NpcAffinityLabel {
    param([int]$Score)

    if ($Score -ge 9) { return '視作自己人' }
    if ($Score -ge 7) { return '願意帶你' }
    if ($Score -ge 5) { return '開始信任' }
    if ($Score -ge 3) { return '願意搭話' }
    if ($Score -ge 1) { return '點頭之交' }
    if ($Score -le -2) { return '戒備' }
    if ($Score -lt 0) { return '冷淡' }
    return '陌生'
}

function Add-NpcAffinityDelta {
    param(
        [hashtable]$GameState,
        [string]$NpcId,
        [int]$Delta
    )

    if ([string]::IsNullOrWhiteSpace($NpcId) -or $Delta -eq 0) {
        return (Get-NpcAffinityScore -GameState $GameState -NpcId $NpcId)
    }

    if ($null -eq $GameState.relationships) {
        $GameState.relationships = [ordered]@{
            npc_affinity = @{}
            companion_supplies = @{}
            companion_equipment = @{}
            companion_growth = @{}
        }
    }
    elseif (-not $GameState.relationships.Contains('npc_affinity')) {
        $GameState.relationships.npc_affinity = @{}
    }

    $current = Get-NpcAffinityScore -GameState $GameState -NpcId $NpcId
    $next = $current + $Delta
    $GameState.relationships.npc_affinity[[string]$NpcId] = $next
    return $next
}

function Get-CompanionSupplies {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    if ([string]::IsNullOrWhiteSpace($NpcId)) {
        return @()
    }

    if ($null -eq $GameState.relationships -or -not $GameState.relationships.Contains('companion_supplies')) {
        return @()
    }

    if (-not $GameState.relationships.companion_supplies.Contains([string]$NpcId)) {
        return @()
    }

    return @($GameState.relationships.companion_supplies[[string]$NpcId])
}

function Set-CompanionSupplies {
    param(
        [hashtable]$GameState,
        [string]$NpcId,
        [object[]]$Items
    )

    if ([string]::IsNullOrWhiteSpace($NpcId)) {
        return
    }

    if ($null -eq $GameState.relationships) {
        $GameState.relationships = [ordered]@{
            npc_affinity = @{}
            companion_supplies = @{}
            companion_equipment = @{}
            companion_growth = @{}
        }
    }
    elseif (-not $GameState.relationships.Contains('companion_supplies') -or $null -eq $GameState.relationships.companion_supplies) {
        $GameState.relationships.companion_supplies = @{}
    }

    $normalized = @($Items | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
    $GameState.relationships.companion_supplies[[string]$NpcId] = $normalized
}

function Get-CompanionEquipment {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    $empty = [ordered]@{
        weapon = $null
        armor = $null
        accessory = $null
    }

    if ([string]::IsNullOrWhiteSpace($NpcId)) {
        return $empty
    }

    if ($null -eq $GameState.relationships -or -not $GameState.relationships.Contains('companion_equipment')) {
        return $empty
    }

    if (-not $GameState.relationships.companion_equipment.Contains([string]$NpcId)) {
        return $empty
    }

    $entry = $GameState.relationships.companion_equipment[[string]$NpcId]
    if ($entry -isnot [System.Collections.IDictionary]) {
        return $empty
    }

    return [ordered]@{
        weapon = if ($entry.Contains('weapon')) { $entry.weapon } else { $null }
        armor = if ($entry.Contains('armor')) { $entry.armor } else { $null }
        accessory = if ($entry.Contains('accessory')) { $entry.accessory } else { $null }
    }
}

function Set-CompanionEquipment {
    param(
        [hashtable]$GameState,
        [string]$NpcId,
        [hashtable]$Equipment
    )

    if ([string]::IsNullOrWhiteSpace($NpcId)) {
        return
    }

    if ($null -eq $GameState.relationships) {
        $GameState.relationships = [ordered]@{
            npc_affinity = @{}
            companion_supplies = @{}
            companion_equipment = @{}
            companion_growth = @{}
        }
    }
    elseif (-not $GameState.relationships.Contains('companion_equipment') -or $null -eq $GameState.relationships.companion_equipment) {
        $GameState.relationships.companion_equipment = @{}
    }

    $normalized = [ordered]@{
        weapon = if ($Equipment.Contains('weapon')) { [string]$Equipment.weapon } else { $null }
        armor = if ($Equipment.Contains('armor')) { [string]$Equipment.armor } else { $null }
        accessory = if ($Equipment.Contains('accessory')) { [string]$Equipment.accessory } else { $null }
    }

    if ([string]::IsNullOrWhiteSpace($normalized.weapon)) { $normalized.weapon = $null }
    if ([string]::IsNullOrWhiteSpace($normalized.armor)) { $normalized.armor = $null }
    if ([string]::IsNullOrWhiteSpace($normalized.accessory)) { $normalized.accessory = $null }

    $GameState.relationships.companion_equipment[[string]$NpcId] = $normalized
}

function Get-CompanionGrowthPlan {
    param([string]$NpcId)

    $profile = Get-NpcCompanionProfile -NpcId $NpcId
    if ($null -eq $profile -or -not $profile.Contains('growth_plan')) {
        return $null
    }

    return $profile['growth_plan']
}

function Ensure-CompanionGrowthState {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    if ([string]::IsNullOrWhiteSpace($NpcId)) {
        return $null
    }

    if ($null -eq $GameState.relationships) {
        $GameState.relationships = [ordered]@{
            npc_affinity = @{}
            companion_supplies = @{}
            companion_equipment = @{}
            companion_growth = @{}
        }
    }
    if (-not $GameState.relationships.Contains('companion_growth') -or $null -eq $GameState.relationships.companion_growth) {
        $GameState.relationships.companion_growth = @{}
    }
    if (-not $GameState.relationships.companion_growth.Contains([string]$NpcId) -or $null -eq $GameState.relationships.companion_growth[[string]$NpcId]) {
        $GameState.relationships.companion_growth[[string]$NpcId] = [ordered]@{
            shared_steps = 0
            danger_supports = 0
            preferred_hits = 0
            unlocked_milestones = @()
        }
    }

    $state = $GameState.relationships.companion_growth[[string]$NpcId]
    if (-not $state.Contains('shared_steps')) { $state.shared_steps = 0 }
    if (-not $state.Contains('danger_supports')) { $state.danger_supports = 0 }
    if (-not $state.Contains('preferred_hits')) { $state.preferred_hits = 0 }
    if (-not $state.Contains('unlocked_milestones') -or $null -eq $state.unlocked_milestones) {
        $state.unlocked_milestones = @()
    }
    elseif ($state.unlocked_milestones -is [string]) {
        $state.unlocked_milestones = @([string]$state.unlocked_milestones)
    }
    else {
        $state.unlocked_milestones = @($state.unlocked_milestones)
    }

    return $state
}

function Get-CompanionGrowthState {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    return Ensure-CompanionGrowthState -GameState $GameState -NpcId $NpcId
}

function Get-CompanionGrowthStageLabel {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    $state = Get-CompanionGrowthState -GameState $GameState -NpcId $NpcId
    $count = @($state.unlocked_milestones).Count
    switch ($count) {
        { $_ -ge 3 } { return '生死默契' }
        2 { return '老搭子' }
        1 { return '開始對線' }
        default { return '初同行' }
    }
}

function Get-NextCompanionGrowthMilestone {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    $plan = Get-CompanionGrowthPlan -NpcId $NpcId
    if ($null -eq $plan) {
        return $null
    }
    $state = Get-CompanionGrowthState -GameState $GameState -NpcId $NpcId
    foreach ($milestone in @($plan.milestones)) {
        if (-not (@($state.unlocked_milestones) -contains [string]$milestone.id)) {
            return $milestone
        }
    }
    return $null
}

function Get-CompanionGrowthProgressText {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    $next = Get-NextCompanionGrowthMilestone -GameState $GameState -NpcId $NpcId
    if ($null -eq $next) {
        return '已完成這條同行成長線的目前里程碑。'
    }
    $state = Get-CompanionGrowthState -GameState $GameState -NpcId $NpcId
    $field = [string]$next.requirement_type
    $current = if ($state.Contains($field)) { [int]$state[$field] } else { 0 }
    return ("下一里程碑：{0}（{1}/{2}）" -f $next.title, $current, [int]$next.requirement_value)
}

function Add-CompanionGrowthProgress {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$NpcId,
        [string]$Metric,
        [int]$Amount = 1
    )

    if ([string]::IsNullOrWhiteSpace($NpcId) -or [string]::IsNullOrWhiteSpace($Metric) -or $Amount -le 0) {
        return @()
    }

    $state = Ensure-CompanionGrowthState -GameState $GameState -NpcId $NpcId
    if ($null -eq $state) {
        return @()
    }
    if (-not $state.Contains($Metric)) {
        $state[$Metric] = 0
    }
    $state[$Metric] = [int]$state[$Metric] + $Amount

    $plan = Get-CompanionGrowthPlan -NpcId $NpcId
    if ($null -eq $plan) {
        return @()
    }

    $newlyUnlocked = @()
    foreach ($milestone in @($plan.milestones)) {
        $id = [string]$milestone.id
        if (@($state.unlocked_milestones) -contains $id) {
            continue
        }
        $requirementField = [string]$milestone.requirement_type
        $requiredValue = [int]$milestone.requirement_value
        $currentValue = if ($state.Contains($requirementField)) { [int]$state[$requirementField] } else { 0 }
        if ($currentValue -ge $requiredValue) {
            $state.unlocked_milestones = Add-UniqueString -Collection $state.unlocked_milestones -Value $id
            $newlyUnlocked += $milestone
        }
    }

    return @($newlyUnlocked)
}

function Show-CompanionGrowthUnlocks {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$NpcId,
        [object[]]$Milestones
    )

    if (@($Milestones).Count -eq 0) {
        return
    }

    $npc = Get-NpcById -RegionPack $RegionPack -NpcId $NpcId
    if ($null -eq $npc) {
        return
    }

    foreach ($milestone in @($Milestones)) {
        Write-Host ''
        Write-Host ("--- {0} 的同行成長解鎖 ---" -f $npc.name) -ForegroundColor Cyan
        Write-Host ("{0}：{1}" -f $milestone.title, $milestone.summary) -ForegroundColor DarkGreen
        Write-Host ("目前階段：{0}" -f (Get-CompanionGrowthStageLabel -GameState $GameState -NpcId $NpcId)) -ForegroundColor DarkCyan
    }
}

function Get-CompanionEquipmentSummaryText {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    $equipment = Get-CompanionEquipment -GameState $GameState -NpcId $NpcId
    $parts = @()
    if ($null -ne $equipment.weapon) {
        $parts += ("武器：{0}" -f $equipment.weapon)
    }
    if ($null -ne $equipment.armor) {
        $parts += ("防具：{0}" -f $equipment.armor)
    }
    if ($null -ne $equipment.accessory) {
        $parts += ("飾品：{0}" -f $equipment.accessory)
    }

    if ($parts.Count -eq 0) {
        return '未配置'
    }

    return ($parts -join '、')
}

function Get-NpcAffinityEntries {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if ($null -eq $GameState.relationships -or -not $GameState.relationships.Contains('npc_affinity')) {
        return @()
    }

    $entries = @()
    foreach ($npcId in @($GameState.relationships.npc_affinity.Keys)) {
        $score = [int]$GameState.relationships.npc_affinity[$npcId]
        $npc = Get-NpcById -RegionPack $RegionPack -NpcId ([string]$npcId)
        $entries += [ordered]@{
            npc_id = [string]$npcId
            npc_name = if ($null -ne $npc) { [string]$npc.name } else { [string]$npcId }
            score = $score
            label = Get-NpcAffinityLabel -Score $score
        }
    }

    return @($entries | Sort-Object @{ Expression = { [int]$_.score }; Descending = $true }, @{ Expression = { [string]$_.npc_name }; Descending = $false })
}

function Get-NpcCompanionProfile {
    param([string]$NpcId)

    $profile = Get-NpcConversationProfile -NpcId $NpcId
    if ($null -eq $profile) {
        return $null
    }

    if (-not $profile.Contains('companion_role') -or [string]::IsNullOrWhiteSpace([string]$profile['companion_role'])) {
        return $null
    }

    return $profile
}

function Get-ActiveCompanionNpcIds {
    param([hashtable]$GameState)

    if ($null -eq $GameState.runtime) {
        return @()
    }

    if ($GameState.runtime.Contains('active_companion_npc_ids') -and $null -ne $GameState.runtime.active_companion_npc_ids) {
        if ($GameState.runtime.active_companion_npc_ids -is [string]) {
            return @([string]$GameState.runtime.active_companion_npc_ids)
        }
        return @($GameState.runtime.active_companion_npc_ids | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    }

    if ($GameState.runtime.Contains('active_companion_npc_id') -and -not [string]::IsNullOrWhiteSpace([string]$GameState.runtime.active_companion_npc_id)) {
        return @([string]$GameState.runtime.active_companion_npc_id)
    }

    return @()
}

function Get-CompanionCapacity {
    param([hashtable]$GameState)

    if ($null -ne $GameState.runtime -and $GameState.runtime.Contains('adventure_company_established') -and [bool]$GameState.runtime.adventure_company_established) {
        return 3
    }

    return 2
}

function Get-CompanionCapacityLabel {
    param([hashtable]$GameState)

    $capacity = Get-CompanionCapacity -GameState $GameState
    if ($capacity -ge 3) {
        return '冒險團編制'
    }
    return '一般同行編制'
}

function Get-ActiveCompanionNpcs {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $npcs = @()
    foreach ($npcId in @(Get-ActiveCompanionNpcIds -GameState $GameState)) {
        $npc = Get-NpcById -RegionPack $RegionPack -NpcId ([string]$npcId)
        if ($null -ne $npc) {
            $npcs += $npc
        }
    }
    return @($npcs)
}

function Update-AdventureCompanyState {
    param([hashtable]$GameState)

    if ($null -eq $GameState.runtime) {
        return
    }

    if (-not $GameState.runtime.Contains('adventure_company_established')) {
        $GameState.runtime.adventure_company_established = $false
    }

    if ([bool]$GameState.runtime.adventure_company_established) {
        return
    }

    if (@($GameState.quests.completed_quests).Count -ge 3) {
        $GameState.runtime.adventure_company_established = $true
    }
}

function Get-EncounterBaseCategory {
    param([string]$Category)

    $value = [string]$Category
    if ($value.StartsWith('followup-')) {
        return $value.Substring(9)
    }
    return $value
}

function Get-ActiveCompanionNpc {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if ($null -eq $RegionPack -and $null -ne $Script:RegionPack) {
        $RegionPack = $Script:RegionPack
    }

    $npcIds = @(Get-ActiveCompanionNpcIds -GameState $GameState)
    if ($npcIds.Count -eq 0) {
        return $null
    }

    $focusNpcId = $null
    if ($null -ne $GameState.runtime -and $GameState.runtime.Contains('focus_companion_npc_id') -and -not [string]::IsNullOrWhiteSpace([string]$GameState.runtime.focus_companion_npc_id)) {
        $focusNpcId = [string]$GameState.runtime.focus_companion_npc_id
    }

    if ([string]::IsNullOrWhiteSpace($focusNpcId) -or -not ($npcIds -contains $focusNpcId)) {
        $focusNpcId = [string]$npcIds[0]
    }

    return Get-NpcById -RegionPack $RegionPack -NpcId $focusNpcId
}

function Normalize-CompanionEquipmentSlotName {
    param([string]$SlotName)

    switch ([string]$SlotName) {
        'weapon' { return 'weapon' }
        '武器' { return 'weapon' }
        'armor' { return 'armor' }
        '防具' { return 'armor' }
        'accessory' { return 'accessory' }
        '飾品' { return 'accessory' }
        default { return [string]$SlotName }
    }
}

function Get-CompanionEquipmentSlotLabel {
    param([string]$SlotName)

    switch (Normalize-CompanionEquipmentSlotName -SlotName $SlotName) {
        'weapon' { return '武器' }
        'armor' { return '防具' }
        'accessory' { return '飾品' }
        default { return [string]$SlotName }
    }
}

function Get-CompanionPreferenceState {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    $result = [ordered]@{
        preferred_supplies_in_hand = @()
        preferred_equipment_slots = @()
    }

    $profile = Get-NpcCompanionProfile -NpcId $NpcId
    if ($null -eq $profile -or -not $profile.Contains('companion_preferences')) {
        return $result
    }

    $preferences = $profile['companion_preferences']
    $supplies = @(Get-CompanionSupplies -GameState $GameState -NpcId $NpcId)
    foreach ($item in @($preferences.preferred_supplies)) {
        if ($supplies -contains [string]$item) {
            $result.preferred_supplies_in_hand += [string]$item
        }
    }

    $equipment = Get-CompanionEquipment -GameState $GameState -NpcId $NpcId
    foreach ($slot in @($preferences.preferred_equipment)) {
        $slotName = Normalize-CompanionEquipmentSlotName -SlotName ([string]$slot)
        if ($slotName -in @('weapon', 'armor', 'accessory') -and $null -ne $equipment[$slotName]) {
            $result.preferred_equipment_slots += [ordered]@{
                slot = $slotName
                label = Get-CompanionEquipmentSlotLabel -SlotName $slotName
                item = [string]$equipment[$slotName]
            }
        }
    }

    return $result
}

function Get-CompanionDangerSupport {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [hashtable]$EncounterState
    )

    $baseCategory = Get-EncounterBaseCategory -Category ([string]$EncounterState.category)
    if ($baseCategory -ne 'danger') {
        return $null
    }

    $npc = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $npc) {
        return $null
    }

    $profile = Get-NpcCompanionProfile -NpcId ([string]$npc.id)
    if ($null -eq $profile -or -not $profile.Contains('danger_support_text')) {
        return $null
    }

    $growthState = Get-CompanionGrowthState -GameState $GameState -NpcId ([string]$npc.id)
    $bonusClues = @()
    $bonusReputationDelta = 0
    $bonusClearPressure = 0
    $bonusText = $null
    if (@($growthState.unlocked_milestones) -contains 'held-the-line') {
        $bonusClearPressure += 1
        $bonusText = ("{0} 已經跟你磨出硬局裡的默契，這次幾乎在你動之前就先把最容易崩的那條線頂住了。" -f $npc.name)
        $bonusClues += ("{0} 在真正要崩的那一刻比以前更能提前卡位" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'nearshore-rhythm') {
        $bonusText = ("{0} 已經記住你在近岸換位的節奏，這次連補位都比以前更順。" -f $npc.name)
        $bonusClues += ("{0} 對你的近岸步點已經開始有默契" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'split-the-false-path') {
        $bonusClearPressure += 1
        $bonusText = ("{0} 幾乎在亂流露頭前就先拆掉了假路，讓你們少吃了一口硬壓。" -f $npc.name)
        $bonusClues += ("{0} 現在能更快把假路從危局裡挑出來" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'window-memory') {
        $bonusText = ("{0} 已經摸熟你的移動節奏，這次幾乎是順著你那一拍就把短窗接住了。" -f $npc.name)
        $bonusClues += ("{0} 現在更能和你一起把短窗記到身上" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'hold-the-cape') {
        $bonusClearPressure += 1
        $bonusText = ("{0} 這次幾乎不必多看第二眼，就把整個場面的節奏敲回了正拍。" -f $npc.name)
        $bonusClues += ("{0} 現在在亂局裡更能先把節奏搶回來" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'watch-rhythm') {
        $bonusText = ("{0} 已經熟了你跟她的守線拍子，這次一出聲就把人和風都拉回正路。" -f $npc.name)
        $bonusClues += ("{0} 現在和你配合守線時更有拍子了" -f $npc.name)
    }

    return [ordered]@{
        npc = $npc
        text = if ($null -ne $bonusText) { ([string]$profile['danger_support_text'] + ' ' + $bonusText) } else { [string]$profile['danger_support_text'] }
        clues = @(@($profile['danger_support_clues']) + $bonusClues)
        reputation_track = [string]$profile['danger_support_reputation_track']
        reputation_delta = ([int]$profile['danger_support_reputation_delta'] + $bonusReputationDelta)
        clear_pressure = ([int]$profile['danger_support_clear_pressure'] + $bonusClearPressure)
    }
}

function Get-CompanionEquipmentBoost {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [hashtable]$EncounterState
    )

    $baseCategory = Get-EncounterBaseCategory -Category ([string]$EncounterState.category)
    if ($baseCategory -ne 'danger') {
        return $null
    }

    $npc = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $npc) {
        return $null
    }

    $equipment = Get-CompanionEquipment -GameState $GameState -NpcId ([string]$npc.id)
    if ($null -eq $equipment.weapon -and $null -eq $equipment.armor -and $null -eq $equipment.accessory) {
        return $null
    }

    $profile = Get-NpcCompanionProfile -NpcId ([string]$npc.id)
    $preferences = if ($null -ne $profile -and $profile.Contains('companion_preferences')) { $profile['companion_preferences'] } else { $null }
    $texts = @()
    $clues = @()
    $clearPressure = 0
    $reputationTrack = $null
    $reputationDelta = 0
    $preferredSlotHits = @()

    if ($null -ne $equipment.weapon) {
        $texts += ("{0} 把 {1} 壓上最吃力的位置，讓整個場面不再只剩死撐。" -f $npc.name, $equipment.weapon)
        $clues += ("{0} 手上的 {1} 讓他能更硬地往前頂住一線" -f $npc.name, $equipment.weapon)
        $clearPressure += 1
        if ($null -ne $preferences -and @(@($preferences.preferred_equipment) | ForEach-Object { Normalize-CompanionEquipmentSlotName -SlotName ([string]$_) }) -contains 'weapon') {
            $preferredSlotHits += 'weapon'
        }
    }

    if ($null -ne $equipment.armor) {
        $texts += ("{0} 靠著 {1} 把最危險的一下先吃住，沒有讓你們被局勢直接掀翻。" -f $npc.name, $equipment.armor)
        $clues += ("{0} 穿著的 {1} 讓他能先替你把最硬的一波扛下來" -f $npc.name, $equipment.armor)
        $clearPressure += 1
        if ($null -ne $preferences -and @(@($preferences.preferred_equipment) | ForEach-Object { Normalize-CompanionEquipmentSlotName -SlotName ([string]$_) }) -contains 'armor') {
            $preferredSlotHits += 'armor'
        }
    }

    if ($null -ne $equipment.accessory) {
        $texts += ("{0} 身上的 {1} 幫他把節奏和判斷拉回正線，旁人也更願意信你們不是在亂闖。" -f $npc.name, $equipment.accessory)
        $clues += ("{0} 身上的 {1} 讓這次出手看起來更像有準備的人" -f $npc.name, $equipment.accessory)
        if ($null -ne $profile -and $profile.Contains('danger_support_reputation_track')) {
            $reputationTrack = [string]$profile['danger_support_reputation_track']
            $reputationDelta += 1
        }
        if ($null -ne $preferences -and @(@($preferences.preferred_equipment) | ForEach-Object { Normalize-CompanionEquipmentSlotName -SlotName ([string]$_) }) -contains 'accessory') {
            $preferredSlotHits += 'accessory'
        }
    }

    if ($preferredSlotHits.Count -gt 0) {
        $labels = @($preferredSlotHits | ForEach-Object {
            Get-CompanionEquipmentSlotLabel -SlotName ([string]$_)
        })
        $texts += ("{0} 這次用上的正好是他最順手的欄位：{1}，整個出手顯得更老練。" -f $npc.name, ($labels -join '、'))
        $clues += ("{0} 在自己最慣用的裝備欄位上明顯更能發揮" -f $npc.name)
        $clearPressure += 1
        if (-not [string]::IsNullOrWhiteSpace([string]$reputationTrack)) {
            $reputationDelta += 1
        }
    }

    $growthState = Get-CompanionGrowthState -GameState $GameState -NpcId ([string]$npc.id)
    if (@($growthState.unlocked_milestones) -contains 'oath-supplies') {
        $texts += ("{0} 手上的守誓裝具和你的配給早就磨出一套默契，這次出手幾乎沒有半點多餘動作。" -f $npc.name)
        $clearPressure += 1
        if (-not [string]::IsNullOrWhiteSpace([string]$reputationTrack)) { $reputationDelta += 1 }
        $clues += ("{0} 已經把你交出去的守具用成自己的一套節奏" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'well-prepared') {
        $texts += ("{0} 對你替他配的裝具越來越熟，幾乎一上手就能把判路和動作接成同一口氣。" -f $npc.name)
        $clearPressure += 1
        $clues += ("{0} 對你替他準備的裝具明顯更熟手了" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'gifted-gear') {
        $texts += ("{0} 現在已經把你交出去的那套守具用成自己身體的一部分，守線時更穩。" -f $npc.name)
        $clearPressure += 1
        $clues += ("{0} 對你交出去的守具已經熟到不必再分神適應" -f $npc.name)
    }

    return [ordered]@{
        npc = $npc
        weapon = $equipment.weapon
        armor = $equipment.armor
        accessory = $equipment.accessory
        texts = @($texts)
        clues = @($clues)
        clear_pressure = $clearPressure
        reputation_track = $reputationTrack
        reputation_delta = $reputationDelta
    }
}

function Get-CompanionSupplyBoost {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [hashtable]$EncounterState
    )

    $baseCategory = Get-EncounterBaseCategory -Category ([string]$EncounterState.category)
    if ($baseCategory -ne 'danger') {
        return $null
    }

    $npc = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $npc) {
        return $null
    }

    $supplies = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$npc.id))
    if ($supplies.Count -eq 0) {
        return $null
    }

    $usedItem = [string]$supplies[0]
    $remaining = @($supplies | Select-Object -Skip 1)
    Set-CompanionSupplies -GameState $GameState -NpcId ([string]$npc.id) -Items $remaining

    $profile = Get-NpcCompanionProfile -NpcId ([string]$npc.id)
    $preferences = if ($null -ne $profile -and $profile.Contains('companion_preferences')) { $profile['companion_preferences'] } else { $null }
    $clearPressure = 1
    $preferred = $false
    $texts = @()
    $clues = @()
    $reputationTrack = $null
    $reputationDelta = 0

    if ($null -ne $preferences -and @($preferences.preferred_supplies) -contains $usedItem) {
        $preferred = $true
        $clearPressure += 1
        $texts += ("{0} 一摸到 {1} 就知道該怎麼用，這顯然是他平常最順手的那類補給。" -f $npc.name, $usedItem)
        $clues += ("{0} 對 {1} 這類補給明顯熟得多" -f $npc.name, $usedItem)
        if ($null -ne $profile -and $profile.Contains('danger_support_reputation_track')) {
            $reputationTrack = [string]$profile['danger_support_reputation_track']
            $reputationDelta = 1
        }
    }

    $growthState = Get-CompanionGrowthState -GameState $GameState -NpcId ([string]$npc.id)
    if (@($growthState.unlocked_milestones) -contains 'oath-supplies') {
        $texts += ("{0} 幾乎不用多看就把 {1} 用在最對的位置，像是你們早就練過這一手。" -f $npc.name, $usedItem)
        $clearPressure += 1
        $clues += ("{0} 對你交出去的補給已經養成固定手感" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'well-prepared') {
        $texts += ("{0} 現在很懂你會交什麼樣的補給給他，拿到手就知道該怎麼先穩局。" -f $npc.name)
        $clearPressure += 1
        $clues += ("{0} 與你的物資默契已經開始成形" -f $npc.name)
    }
    elseif (@($growthState.unlocked_milestones) -contains 'gifted-gear') {
        $texts += ("{0} 平常就把這類守線補給收得很順，這次一用上就把亂勢先卡掉一截。" -f $npc.name)
        $clearPressure += 1
        $clues += ("{0} 對守線補給的收用節奏變得更成熟了" -f $npc.name)
    }

    return [ordered]@{
        npc = $npc
        used_item = $usedItem
        clear_pressure = $clearPressure
        preferred = $preferred
        texts = @($texts)
        clues = @($clues)
        reputation_track = $reputationTrack
        reputation_delta = $reputationDelta
    }
}

function Get-EncounterProfile {
    param([string]$Type)

    if ($Script:EncounterProfiles.Contains($Type)) {
        return $Script:EncounterProfiles[$Type]
    }

    return [ordered]@{
        title = '未分類遭遇'
        category = 'unknown'
        options = @(
            [ordered]@{
                key = 'withdraw'
                title = '先退一步保命'
                result_text = '你先讓自己從不明局勢裡抽身，至少沒有把事情變得更糟。'
                clues = @()
                currency = 0
                items = @()
                reputation_track = $null
                reputation_delta = 0
                job_directions = @()
                pressure_tags = @('遇到未分類風險')
            }
        )
    }
}

function Select-EncounterSeed {
    param(
        [object]$RegionPack,
        [string]$Selection
    )

    $allSeeds = @($RegionPack.encounter_seeds)
    if ([string]::IsNullOrWhiteSpace($Selection)) {
        return Get-Random -InputObject $allSeeds
    }

    $token = ([string]$Selection).Trim().ToLowerInvariant()
    $matchingSeeds = @()

    foreach ($seed in $allSeeds) {
        $seedType = ([string]$seed.type).Trim().ToLowerInvariant()
        $profile = Get-EncounterProfile -Type ([string]$seed.type)
        $baseCategory = Get-EncounterBaseCategory -Category ([string]$profile.category)

        if ($seedType -eq $token -or $baseCategory -eq $token) {
            $matchingSeeds += $seed
        }
    }

    if ($matchingSeeds.Count -gt 0) {
        return Get-Random -InputObject $matchingSeeds
    }

    return $null
}

function Get-ActiveEncounter {
    param([hashtable]$GameState)

    if ($null -eq $GameState.runtime.active_encounter) {
        return $null
    }

    if ([string]::IsNullOrWhiteSpace([string]$GameState.runtime.active_encounter.type)) {
        return $null
    }

    return $GameState.runtime.active_encounter
}

function Ensure-NoActiveEncounter {
    param(
        [hashtable]$GameState,
        [string]$ActionLabel
    )

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -eq $activeEncounter) {
        return $true
    }

    Write-Host ("你眼前還有一個遭遇沒有處理完：{0}。先用 respond <number> 做出選擇，再來{1}。" -f $activeEncounter.title, $ActionLabel) -ForegroundColor Yellow
    return $false
}

function Get-StartPointById {
    param(
        [object]$RegionPack,
        [string]$PointId
    )

    return $RegionPack.start_points | Where-Object { $_.id -eq $PointId } | Select-Object -First 1
}

function Get-AllQuestDefinitions {
    param([object]$RegionPack)

    $starterQuests = @($RegionPack.starter_quest_pool)
    $companionQuests = @($Script:CompanionQuestCatalog.Values)
    return @($starterQuests + $companionQuests)
}

function Get-CompanionQuestCatalogEntry {
    param([object]$QuestDefinition)

    if ($null -eq $QuestDefinition) {
        return $null
    }

    $questId = ''
    if ($QuestDefinition.PSObject.Properties.Match('quest_id').Count -gt 0) {
        $questId = [string]$QuestDefinition.quest_id
    }
    if ([string]::IsNullOrWhiteSpace($questId)) {
        $questId = [string](Get-ObjectFieldValue -InputObject $QuestDefinition -FieldName 'quest_id')
    }
    if (-not [string]::IsNullOrWhiteSpace($questId) -and $Script:CompanionQuestCatalog.Contains($questId)) {
        return $Script:CompanionQuestCatalog[$questId]
    }

    $title = ''
    if ($QuestDefinition.PSObject.Properties.Match('title').Count -gt 0) {
        $title = [string]$QuestDefinition.title
    }
    if ([string]::IsNullOrWhiteSpace($title)) {
        $title = [string](Get-ObjectFieldValue -InputObject $QuestDefinition -FieldName 'title')
    }
    if ([string]::IsNullOrWhiteSpace($title)) {
        return $null
    }

    foreach ($entry in @($Script:CompanionQuestCatalog.Values)) {
        if ([string]$entry.title -eq $title) {
            return $entry
        }
    }

    return $null
}

function Get-CompanionQuestCatalogEntryByTitle {
    param([string]$Title)

    if ([string]::IsNullOrWhiteSpace($Title)) {
        return $null
    }

    foreach ($entry in @($Script:CompanionQuestCatalog.Values)) {
        if ([string]$entry.title -eq $Title) {
            return $entry
        }
    }

    return $null
}

function Get-ObjectFieldValue {
    param(
        [object]$InputObject,
        [string]$FieldName
    )

    if ($null -eq $InputObject -or [string]::IsNullOrWhiteSpace($FieldName)) {
        return $null
    }

    if ($InputObject -is [System.Collections.Specialized.OrderedDictionary]) {
        if ($InputObject.Contains($FieldName)) {
            return $InputObject[$FieldName]
        }
        return $null
    }

    if ($InputObject -is [System.Collections.IDictionary]) {
        if ($InputObject.Contains($FieldName)) {
            return $InputObject[$FieldName]
        }
        return $null
    }

    $property = @($InputObject.PSObject.Properties.Match($FieldName) | Select-Object -First 1)[0]
    if ($null -ne $property) {
        return $property.Value
    }

    return $null
}

function Get-CompanionUnlockedMilestoneCount {
    param(
        [hashtable]$GameState,
        [string]$NpcId
    )

    $state = Get-CompanionGrowthState -GameState $GameState -NpcId $NpcId
    if ($null -eq $state) {
        return 0
    }

    return @($state.unlocked_milestones).Count
}

function Test-QuestUnlockRequirements {
    param(
        [hashtable]$GameState,
        [object]$QuestDefinition
    )

    if ($null -eq $QuestDefinition) {
        return $true
    }

    $requirements = Get-ObjectFieldValue -InputObject $QuestDefinition -FieldName 'unlock_requirements'
    if ($null -eq $requirements) {
        return $true
    }
    $npcId = [string]$requirements.npc_id
    if ([string]::IsNullOrWhiteSpace($npcId)) {
        return $true
    }

    $minimumAffinity = 0
    if ($null -ne (Get-ObjectFieldValue -InputObject $requirements -FieldName 'minimum_affinity')) {
        $minimumAffinity = [int]$requirements.minimum_affinity
    }

    $minimumMilestones = 0
    if ($null -ne (Get-ObjectFieldValue -InputObject $requirements -FieldName 'minimum_milestones')) {
        $minimumMilestones = [int]$requirements.minimum_milestones
    }

    $affinityScore = Get-NpcAffinityScore -GameState $GameState -NpcId $npcId
    if ($affinityScore -lt $minimumAffinity) {
        return $false
    }

    $milestoneCount = Get-CompanionUnlockedMilestoneCount -GameState $GameState -NpcId $npcId
    if ($milestoneCount -lt $minimumMilestones) {
        return $false
    }

    return $true
}

function Get-QuestById {
    param(
        [object]$RegionPack,
        [string]$QuestId
    )

    return Get-AllQuestDefinitions -RegionPack $RegionPack | Where-Object { $_.quest_id -eq $QuestId } | Select-Object -First 1
}

function Get-NpcById {
    param(
        [object]$RegionPack,
        [string]$NpcId
    )

    return $RegionPack.npc_hooks | Where-Object { $_.id -eq $NpcId } | Select-Object -First 1
}

function Get-SceneServices {
    param([hashtable]$GameState)

    $sceneId = [string]$GameState.location.current_scene_id
    if ($Script:ServiceCatalog.Contains($sceneId)) {
        return @($Script:ServiceCatalog[$sceneId])
    }

    return @()
}

function Get-SceneOddJobs {
    param([hashtable]$GameState)

    $sceneId = [string]$GameState.location.current_scene_id
    if ($Script:OddJobCatalog.Contains($sceneId)) {
        return @($Script:OddJobCatalog[$sceneId])
    }

    return @()
}

function Get-NpcConversationProfile {
    param([string]$NpcId)

    if ($Script:NpcConversationProfiles.Contains($NpcId)) {
        return $Script:NpcConversationProfiles[$NpcId]
    }

    return $null
}

function Get-TodaysOddJobKey {
    param(
        [hashtable]$GameState,
        [string]$JobId
    )

    return ('day{0}:{1}' -f $GameState.location.day_count, $JobId)
}

function Get-ActiveQuestRecord {
    param([hashtable]$GameState)

    foreach ($record in @($GameState.quests.active_quests)) {
        if ($record.status -eq 'active' -or $record.status -eq 'ready_to_turn_in') {
            return $record
        }
    }

    return $null
}

function Get-ActiveQuestDefinition {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        return $null
    }

    return Get-QuestById -RegionPack $RegionPack -QuestId $record.quest_id
}

function Get-CurrentQuestStep {
    param(
        [hashtable]$QuestRecord,
        [object]$QuestDefinition
    )

    if ($null -eq $QuestRecord -or $null -eq $QuestDefinition) {
        return $null
    }

    if ($QuestRecord.status -ne 'active') {
        return $null
    }

    $steps = @($QuestDefinition.progress.steps)
    if ($QuestRecord.step_index -lt 0 -or $QuestRecord.step_index -ge $steps.Count) {
        return $null
    }

    return $steps[$QuestRecord.step_index]
}

function Get-TrackedQuestIds {
    param([hashtable]$GameState)

    $ids = @()
    foreach ($record in @($GameState.quests.active_quests)) {
        $ids += [string]$record.quest_id
    }
    foreach ($record in @($GameState.quests.completed_quests)) {
        $ids += [string]$record.quest_id
    }
    foreach ($record in @($GameState.quests.failed_quests)) {
        $ids += [string]$record.quest_id
    }
    return ,@($ids | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
}

function Get-AvailableQuestsForCurrentScene {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $tracked = Get-TrackedQuestIds -GameState $GameState
    $sceneId = [string]$GameState.location.current_scene_id
    $available = @()
    foreach ($quest in @(Get-AllQuestDefinitions -RegionPack $RegionPack)) {
        if ($quest.entry_point_id -eq $sceneId -and -not ($tracked -contains [string]$quest.quest_id) -and (Test-QuestUnlockRequirements -GameState $GameState -QuestDefinition $quest)) {
            $available += $quest
        }
    }
    return ,@($available)
}

function Get-UnlockedCompanionQuestForNpcAtCurrentScene {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$NpcId
    )

    $tracked = Get-TrackedQuestIds -GameState $GameState
    $sceneId = [string]$GameState.location.current_scene_id
    foreach ($quest in @($Script:CompanionQuestCatalog.Values)) {
        $questNpcId = [string](Get-ObjectFieldValue -InputObject (Get-ObjectFieldValue -InputObject $quest -FieldName 'unlock_requirements') -FieldName 'npc_id')
        if ($quest.entry_point_id -eq $sceneId -and $questNpcId -eq $NpcId -and -not ($tracked -contains [string]$quest.quest_id) -and (Test-QuestUnlockRequirements -GameState $GameState -QuestDefinition $quest)) {
            return $quest
        }
    }

    return $null
}

function New-QuestRecord {
    param([string]$QuestId)

    return [ordered]@{
        quest_id = $QuestId
        status = 'active'
        step_index = 0
        progress_log = @()
        started_at = (Get-Date).ToString('o')
        completed_at = $null
    }
}

function Get-QuestCategoryLabel {
    param([object]$QuestDefinition)

    if ($null -eq $QuestDefinition) {
        return '任務'
    }

    $questId = ''
    if ($QuestDefinition.PSObject.Properties.Match('quest_id').Count -gt 0) {
        $questId = [string]$QuestDefinition.quest_id
    }
    if ([string]::IsNullOrWhiteSpace($questId)) {
        $questId = [string](Get-ObjectFieldValue -InputObject $QuestDefinition -FieldName 'quest_id')
    }
    if ($questId -like 'companion-*') {
        return '同行支線'
    }
    if ($questId -like 'whispersea-quest-*') {
        return '起步任務'
    }

    $tier = ''
    if ($QuestDefinition.PSObject.Properties.Match('chapter_tier').Count -gt 0) {
        $tier = [string]$QuestDefinition.chapter_tier
    }
    if ([string]::IsNullOrWhiteSpace($tier)) {
        $tier = [string](Get-ObjectFieldValue -InputObject $QuestDefinition -FieldName 'chapter_tier')
    }
    switch ($tier) {
        'starter' { return '起步任務' }
        'companion' { return '同行支線' }
        default {
            $companionEntry = Get-CompanionQuestCatalogEntry -QuestDefinition $QuestDefinition
            if ($null -ne $companionEntry) {
                return '同行支線'
            }
            $arc = ''
            if ($QuestDefinition.PSObject.Properties.Match('arc').Count -gt 0) {
                $arc = [string]$QuestDefinition.arc
            }
            if ([string]::IsNullOrWhiteSpace($arc)) {
                $arc = [string](Get-ObjectFieldValue -InputObject $QuestDefinition -FieldName 'arc')
            }
            if ($arc -match '同行') {
                return '同行支線'
            }
            if ($arc -match '守誓|潛路|岬哨') {
                return '起步任務'
            }
            if (-not [string]::IsNullOrWhiteSpace($arc)) {
                return $arc
            }
            return '任務'
        }
    }
}

function Select-BlankSlateRole {
    param([object]$RegionPack)

    Write-Host ''
    Write-Host '選擇你的白身狀態：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $RegionPack.blank_slate_roles.Count; $i++) {
        $role = $RegionPack.blank_slate_roles[$i]
        Write-Host ("{0}. {1} - {2}" -f ($i + 1), $role.status, $role.why)
    }

    $selectedIndex = Read-Choice -Prompt '請選擇白身狀態編號' -Min 1 -Max $RegionPack.blank_slate_roles.Count
    return $RegionPack.blank_slate_roles[$selectedIndex - 1]
}

function Select-StartPoint {
    param([object]$RegionPack)

    Write-Host ''
    Write-Host '選擇你的起始落點：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $RegionPack.start_points.Count; $i++) {
        $point = $RegionPack.start_points[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $point.name)
        Write-Host ("   {0}" -f $point.why_start_here) -ForegroundColor DarkGray
    }

    $selectedIndex = Read-Choice -Prompt '請選擇起始落點編號' -Min 1 -Max $RegionPack.start_points.Count
    return $RegionPack.start_points[$selectedIndex - 1]
}

function Resolve-BlankSlateRole {
    param(
        [object]$RegionPack,
        [string]$PresetStatus
    )

    if ([string]::IsNullOrWhiteSpace($PresetStatus)) {
        return Select-BlankSlateRole -RegionPack $RegionPack
    }

    $normalizedStatus = switch ([string]$PresetStatus) {
        'wanderer' { '漂泊者'; break }
        'displaced' { '流離者'; break }
        'local' { '在地者'; break }
        'follower' { '跟行者'; break }
        'apprentice' { '見習'; break }
        'oddjob' { '短工'; break }
        default { [string]$PresetStatus }
    }

    foreach ($role in @($RegionPack.blank_slate_roles)) {
        if ([string]$role.status -eq $normalizedStatus) {
            Write-Host ("已套用白身狀態：{0}" -f $role.status) -ForegroundColor DarkCyan
            return $role
        }
    }

    $fallbackRole = switch ($normalizedStatus) {
        '漂泊者' {
            [ordered]@{
                status = '漂泊者'
                best_fit = @('尋憶起點', '借宿旅人', '臨時引路')
                why = '你帶著斷裂的記憶抵達此地，接下來可以追尋過去，也可以從白身重新生活。'
                source_paths = @('content/game/00-player-kit/player-blank-slate-opening-mode.md')
            }
            break
        }
        '流離者' {
            [ordered]@{
                status = '流離者'
                best_fit = @('避難新民', '邊緣求生', '復仇線索')
                why = '你因戰事、魔物或災變離開原本的生活，開局會更靠近邊境、難民點或危險痕跡。'
                source_paths = @('content/game/00-player-kit/player-blank-slate-opening-mode.md')
            }
            break
        }
        '在地者' {
            [ordered]@{
                status = '在地者'
                best_fit = @('地方住民', '日常起步', '自由生活')
                why = '你本來就在這裡生活，沒有被任務追著跑；開局會先問你想把日子過成什麼樣。'
                source_paths = @('content/game/00-player-kit/player-blank-slate-opening-mode.md')
            }
            break
        }
        default { $null }
    }

    if ($null -ne $fallbackRole) {
        Write-Host ("已套用新版白身狀態：{0}" -f $fallbackRole.status) -ForegroundColor DarkCyan
        return $fallbackRole
    }

    Write-Host ("找不到指定的白身狀態「{0}」，改回手動選擇。" -f $PresetStatus) -ForegroundColor Yellow
    return Select-BlankSlateRole -RegionPack $RegionPack
}

function Resolve-StartPoint {
    param(
        [object]$RegionPack,
        [string]$PresetPointId
    )

    if ([string]::IsNullOrWhiteSpace($PresetPointId)) {
        return Select-StartPoint -RegionPack $RegionPack
    }

    foreach ($point in @($RegionPack.start_points)) {
        if ([string]$point.id -eq $PresetPointId) {
            Write-Host ("已套用起始落點：{0}" -f $point.name) -ForegroundColor DarkCyan
            return $point
        }
    }

    Write-Host ("找不到指定的起始落點「{0}」，改回手動選擇。" -f $PresetPointId) -ForegroundColor Yellow
    return Select-StartPoint -RegionPack $RegionPack
}

function Advance-TimeState {
    param(
        [hashtable]$GameState,
        [int]$Steps = 1
    )

    for ($i = 0; $i -lt $Steps; $i++) {
        $currentIndex = [array]::IndexOf($Script:TimeCycle, $GameState.location.time_of_day)
        if ($currentIndex -lt 0) {
            $currentIndex = 0
        }
        $nextIndex = ($currentIndex + 1) % $Script:TimeCycle.Count
        if ($nextIndex -eq 0) {
            $GameState.location.day_count += 1
        }
        $GameState.location.time_of_day = $Script:TimeCycle[$nextIndex]
    }
}

function New-GameState {
    param([object]$RegionPack)

    $name = $Script:PresetPlayerName
    if ([string]::IsNullOrWhiteSpace($name)) {
        if ([bool]$Script:AutoNewGame) {
            $name = '無名潮客'
        }
        else {
            $name = Read-GameInput '角色名字（留空則使用「無名潮客」）'
            if ([string]::IsNullOrWhiteSpace($name)) {
                $name = '無名潮客'
            }
        }
    }
    else {
        Write-Host ("已套用角色名字：{0}" -f $name) -ForegroundColor DarkCyan
    }

    $role = Resolve-BlankSlateRole -RegionPack $RegionPack -PresetStatus $Script:PresetRoleStatus
    $startPoint = Resolve-StartPoint -RegionPack $RegionPack -PresetPointId $Script:PresetStartPointId
    $quest = Get-QuestById -RegionPack $RegionPack -QuestId $startPoint.recommended_first_quest

    $timestamp = Get-Date
    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars() + ' '
    $safeName = -join ($name.ToCharArray() | ForEach-Object {
        if ($invalidChars -contains $_) { '_' } else { $_ }
    })

    return [ordered]@{
        save_version = 'v7'
        created_at = $timestamp.ToString('o')
        updated_at = $timestamp.ToString('o')
        playtime_minutes = 0
        seed = ('whispersea-{0}' -f $startPoint.id)
        character = [ordered]@{
            name = $name
            race = '諾魯因人'
            branch = $null
            origin_region = 'whispersea'
            blank_slate_status = $role.status
            job_direction_primary = '未定'
            job_direction_secondary = '未定'
            traits = @()
            flaws = @()
            background = '白身開局'
        }
        location = [ordered]@{
            current_region_id = 'whispersea'
            current_scene_id = $startPoint.id
            current_scene_name = $startPoint.name
            time_of_day = 'night'
            day_count = 1
        }
        quests = [ordered]@{
            active_quests = @((New-QuestRecord -QuestId $quest.quest_id))
            completed_quests = @()
            failed_quests = @()
        }
        notebook = [ordered]@{
            known_clues = @()
            revealed_truths = @()
        }
        reputation = [ordered]@{
            region = 'neutral'
            factions = @{}
            tracks = @{}
        }
        relationships = [ordered]@{
            npc_affinity = @{}
            companion_supplies = @{}
            companion_equipment = @{}
            companion_growth = @{}
        }
        inventory = [ordered]@{
            currency = 10
            equipped_items = @()
            inventory_slots = @('封聲袋', '短窗照燈', '簡索繩')
            containers = @('潮布肩包')
        }
        runtime = [ordered]@{
            current_pressure_tags = @($startPoint.pressure_tags)
            linked_npcs = @($startPoint.linked_npcs)
            save_name = ('{0}-whispersea-save.json' -f $safeName)
            learned_job_directions = @()
            active_encounter = $null
            active_companion_npc_id = $null
            active_companion_npc_ids = @()
            focus_companion_npc_id = $null
            adventure_company_established = $false
            talked_npcs = @()
            day_job_log = @()
        }
    }
}

function Normalize-GameState {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if ($GameState.save_version -ne 'v7') {
        $GameState.save_version = 'v7'
    }

    if (-not $GameState.reputation.tracks) {
        $GameState.reputation.tracks = @{}
    }

    if ($null -eq $GameState.relationships) {
        $GameState.relationships = [ordered]@{
            npc_affinity = @{}
            companion_supplies = @{}
            companion_equipment = @{}
            companion_growth = @{}
        }
    }
    elseif (-not $GameState.relationships.Contains('npc_affinity') -or $null -eq $GameState.relationships.npc_affinity) {
        $GameState.relationships.npc_affinity = @{}
    }

    if (-not $GameState.relationships.Contains('companion_supplies') -or $null -eq $GameState.relationships.companion_supplies) {
        $GameState.relationships.companion_supplies = @{}
    }
    else {
        $normalizedCompanionSupplies = @{}
        foreach ($npcId in @($GameState.relationships.companion_supplies.Keys)) {
            $value = $GameState.relationships.companion_supplies[$npcId]
            if ($value -is [string]) {
                $normalizedCompanionSupplies[[string]$npcId] = @([string]$value)
            }
            else {
                $normalizedCompanionSupplies[[string]$npcId] = @($value)
            }
        }
        $GameState.relationships.companion_supplies = $normalizedCompanionSupplies
    }

    if (-not $GameState.relationships.Contains('companion_equipment') -or $null -eq $GameState.relationships.companion_equipment) {
        $GameState.relationships.companion_equipment = @{}
    }
    else {
        $normalizedCompanionEquipment = @{}
        foreach ($npcId in @($GameState.relationships.companion_equipment.Keys)) {
            $equipment = $GameState.relationships.companion_equipment[$npcId]
            if ($equipment -isnot [System.Collections.IDictionary]) {
                $equipment = @{}
            }
            $normalizedCompanionEquipment[[string]$npcId] = [ordered]@{
                weapon = if ($equipment.Contains('weapon')) { [string]$equipment.weapon } else { $null }
                armor = if ($equipment.Contains('armor')) { [string]$equipment.armor } else { $null }
                accessory = if ($equipment.Contains('accessory')) { [string]$equipment.accessory } else { $null }
            }
        }
        $GameState.relationships.companion_equipment = $normalizedCompanionEquipment
    }

    if (-not $GameState.relationships.Contains('companion_growth') -or $null -eq $GameState.relationships.companion_growth) {
        $GameState.relationships.companion_growth = @{}
    }
    else {
        $normalizedCompanionGrowth = @{}
        foreach ($npcId in @($GameState.relationships.companion_growth.Keys)) {
            $growth = $GameState.relationships.companion_growth[$npcId]
            if ($growth -isnot [System.Collections.IDictionary]) {
                $growth = @{}
            }
            $unlocked = if ($growth.Contains('unlocked_milestones') -and $null -ne $growth.unlocked_milestones) {
                if ($growth.unlocked_milestones -is [string]) { @([string]$growth.unlocked_milestones) } else { @($growth.unlocked_milestones) }
            }
            else {
                @()
            }
            $normalizedCompanionGrowth[[string]$npcId] = [ordered]@{
                shared_steps = if ($growth.Contains('shared_steps')) { [int]$growth.shared_steps } else { 0 }
                danger_supports = if ($growth.Contains('danger_supports')) { [int]$growth.danger_supports } else { 0 }
                preferred_hits = if ($growth.Contains('preferred_hits')) { [int]$growth.preferred_hits } else { 0 }
                unlocked_milestones = $unlocked
            }
        }
        $GameState.relationships.companion_growth = $normalizedCompanionGrowth
    }

    if (-not $GameState.runtime.learned_job_directions) {
        $GameState.runtime.learned_job_directions = @()
    }

    if (-not $GameState.runtime.Contains('talked_npcs')) {
        $GameState.runtime.talked_npcs = @()
    }
    elseif ($GameState.runtime.talked_npcs -is [string]) {
        $GameState.runtime.talked_npcs = @([string]$GameState.runtime.talked_npcs)
    }
    else {
        $GameState.runtime.talked_npcs = @($GameState.runtime.talked_npcs)
    }

    if (-not $GameState.runtime.Contains('day_job_log')) {
        $GameState.runtime.day_job_log = @()
    }
    elseif ($GameState.runtime.day_job_log -is [string]) {
        $GameState.runtime.day_job_log = @([string]$GameState.runtime.day_job_log)
    }
    else {
        $GameState.runtime.day_job_log = @($GameState.runtime.day_job_log)
    }

    if (-not $GameState.runtime.Contains('active_encounter')) {
        $GameState.runtime.active_encounter = $null
    }
    if (-not $GameState.runtime.Contains('active_companion_npc_ids') -or $null -eq $GameState.runtime.active_companion_npc_ids) {
        if ($GameState.runtime.Contains('active_companion_npc_id') -and -not [string]::IsNullOrWhiteSpace([string]$GameState.runtime.active_companion_npc_id)) {
            $GameState.runtime.active_companion_npc_ids = @([string]$GameState.runtime.active_companion_npc_id)
        }
        else {
            $GameState.runtime.active_companion_npc_ids = @()
        }
    }
    elseif ($GameState.runtime.active_companion_npc_ids -is [string]) {
        $GameState.runtime.active_companion_npc_ids = @([string]$GameState.runtime.active_companion_npc_ids)
    }
    else {
        $GameState.runtime.active_companion_npc_ids = @($GameState.runtime.active_companion_npc_ids | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    }
    if (-not $GameState.runtime.Contains('focus_companion_npc_id') -or [string]::IsNullOrWhiteSpace([string]$GameState.runtime.focus_companion_npc_id) -or -not (@($GameState.runtime.active_companion_npc_ids) -contains [string]$GameState.runtime.focus_companion_npc_id)) {
        $GameState.runtime.focus_companion_npc_id = if (@($GameState.runtime.active_companion_npc_ids).Count -gt 0) { [string]@($GameState.runtime.active_companion_npc_ids)[0] } else { $null }
    }
    $GameState.runtime.active_companion_npc_id = if ([string]::IsNullOrWhiteSpace([string]$GameState.runtime.focus_companion_npc_id)) { $null } else { [string]$GameState.runtime.focus_companion_npc_id }
    if (-not $GameState.runtime.Contains('adventure_company_established')) {
        $GameState.runtime.adventure_company_established = $false
    }
    Update-AdventureCompanyState -GameState $GameState
    if ($null -ne $GameState.runtime.active_encounter -and $GameState.runtime.active_encounter.options) {
        $GameState.runtime.active_encounter.options = @($GameState.runtime.active_encounter.options)
        foreach ($option in @($GameState.runtime.active_encounter.options)) {
            if ($option.followup -and $option.followup.options) {
                $option.followup.options = @($option.followup.options)
            }
        }
    }

    if ($GameState.quests.active_quests -is [System.Collections.IDictionary]) {
        $GameState.quests.active_quests = @($GameState.quests.active_quests)
    }
    else {
        $GameState.quests.active_quests = @($GameState.quests.active_quests)
    }

    if ($GameState.quests.completed_quests -is [System.Collections.IDictionary]) {
        $GameState.quests.completed_quests = @($GameState.quests.completed_quests)
    }
    else {
        $GameState.quests.completed_quests = @($GameState.quests.completed_quests)
    }

    if ($GameState.quests.failed_quests -is [System.Collections.IDictionary]) {
        $GameState.quests.failed_quests = @($GameState.quests.failed_quests)
    }
    else {
        $GameState.quests.failed_quests = @($GameState.quests.failed_quests)
    }

    if ($GameState.quests.active_quests.Count -gt 0 -and $GameState.quests.active_quests[0] -is [string]) {
        $newRecords = @()
        foreach ($questId in @($GameState.quests.active_quests)) {
            $newRecords += New-QuestRecord -QuestId ([string]$questId)
        }
        $GameState.quests.active_quests = $newRecords
    }

    foreach ($record in @($GameState.quests.active_quests)) {
        if (-not $record.progress_log) {
            $record.progress_log = @()
        }
        elseif ($record.progress_log -is [string]) {
            $record.progress_log = @([string]$record.progress_log)
        }
    }

    return $GameState
}

function Save-GameState {
    param([hashtable]$GameState)

    Ensure-SaveDirectory
    $GameState.updated_at = (Get-Date).ToString('o')
    $savePath = Join-Path $Script:SaveDirectory $GameState.runtime.save_name
    $GameState | ConvertTo-Json -Depth 20 | Set-Content -Encoding utf8 $savePath
    Write-Host ("已存檔：{0}" -f $savePath) -ForegroundColor Green
}

function Load-GameState {
    param([object]$RegionPack)

    Ensure-SaveDirectory
    $saveFiles = Get-ChildItem $Script:SaveDirectory -Filter '*.json' | Sort-Object LastWriteTime -Descending

    if (-not $saveFiles) {
        Write-Host '目前沒有可讀取的存檔。' -ForegroundColor Yellow
        return $null
    }

    if (-not [string]::IsNullOrWhiteSpace($Script:AutoLoadSave)) {
        $normalizedAutoTarget = [System.IO.Path]::GetFileName($Script:AutoLoadSave)
        $selectedFile = $saveFiles | Where-Object { $_.Name -eq $normalizedAutoTarget } | Select-Object -First 1
        if ($null -eq $selectedFile) {
            Write-Host ("找不到指定存檔「{0}」，改回手動選擇。" -f $normalizedAutoTarget) -ForegroundColor Yellow
        }
        else {
            Write-Host ("已套用存檔：{0}" -f $selectedFile.Name) -ForegroundColor DarkCyan
            $loaded = Get-Content -Raw -Encoding utf8 $selectedFile.FullName | ConvertFrom-Json
            $state = ConvertTo-Hashtable -InputObject $loaded
            return Normalize-GameState -GameState $state -RegionPack $RegionPack
        }
    }

    Write-Host ''
    Write-Host '可讀取存檔：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $saveFiles.Count; $i++) {
        $file = $saveFiles[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $file.Name)
    }

    $selectedIndex = Read-Choice -Prompt '請選擇存檔編號' -Min 1 -Max $saveFiles.Count
    $selectedFile = $saveFiles[$selectedIndex - 1]
    $loaded = Get-Content -Raw -Encoding utf8 $selectedFile.FullName | ConvertFrom-Json
    $state = ConvertTo-Hashtable -InputObject $loaded
    return Normalize-GameState -GameState $state -RegionPack $RegionPack
}

function Show-Opening {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $scene = Get-StartPointById -RegionPack $RegionPack -PointId $GameState.location.current_scene_id
    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack

    Write-Host ''
    Write-Host '--- 開場 ---' -ForegroundColor Cyan
    Write-Host ("你在 {0} 醒來。" -f $scene.name)
    Write-Host $scene.why_start_here
    Write-Host ("你現在的身分是：{0}" -f $GameState.character.blank_slate_status)
    if ($null -ne $quest) {
        Write-Host ("你眼前第一個最明確的麻煩是：{0}" -f $quest.core_conflict)
        Write-Host ("目前掛在你身上的任務：{0}" -f $quest.title) -ForegroundColor Yellow
    }
    Write-Host '你也可以先用 talk / jobs / services 看看這地方怎麼活。' -ForegroundColor DarkCyan
    Write-Host ''
}

function Show-Status {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 狀態 ---' -ForegroundColor Cyan
    Write-Host ("角色：{0}" -f $GameState.character.name)
    Write-Host ("種族：{0}" -f $GameState.character.race)
    Write-Host ("白身狀態：{0}" -f $GameState.character.blank_slate_status)
    Write-Host ("地區：{0}" -f $RegionPack.display_name)
    Write-Host ("位置：{0}" -f $GameState.location.current_scene_name)
    Write-Host ("第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day)
    $activeCompanions = @(Get-ActiveCompanionNpcs -GameState $GameState -RegionPack $RegionPack)
    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    $companionCapacity = Get-CompanionCapacity -GameState $GameState
    Write-Host ("同行編制：{0}（{1}/{2}）" -f (Get-CompanionCapacityLabel -GameState $GameState), $activeCompanions.Count, $companionCapacity) -ForegroundColor DarkCyan
    if ($null -ne $activeCompanion) {
        Write-Host ("同行名單：{0}" -f (@($activeCompanions | ForEach-Object { $_.name }) -join '、')) -ForegroundColor Magenta
        $companionScore = Get-NpcAffinityScore -GameState $GameState -NpcId ([string]$activeCompanion.id)
        $companionLabel = Get-NpcAffinityLabel -Score $companionScore
        Write-Host ("主同行：{0}（{1} / {2}）" -f $activeCompanion.name, $activeCompanion.role, $companionLabel) -ForegroundColor Magenta
        $companionSupplies = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id))
        $companionPreferenceState = Get-CompanionPreferenceState -GameState $GameState -NpcId ([string]$activeCompanion.id)
        if ($companionSupplies.Count -gt 0) {
            Write-Host ("同行攜行：{0}" -f ($companionSupplies -join '、')) -ForegroundColor DarkMagenta
        }
        $companionEquipmentText = Get-CompanionEquipmentSummaryText -GameState $GameState -NpcId ([string]$activeCompanion.id)
        if ($companionEquipmentText -ne '未配置') {
            Write-Host ("同行裝備：{0}" -f $companionEquipmentText) -ForegroundColor DarkMagenta
        }
        if ($companionPreferenceState.preferred_supplies_in_hand.Count -gt 0 -or $companionPreferenceState.preferred_equipment_slots.Count -gt 0) {
            $synergyNotes = @()
            if ($companionPreferenceState.preferred_supplies_in_hand.Count -gt 0) {
                $synergyNotes += ("對味補給：{0}" -f ($companionPreferenceState.preferred_supplies_in_hand -join '、'))
            }
            if ($companionPreferenceState.preferred_equipment_slots.Count -gt 0) {
                $slotNotes = @($companionPreferenceState.preferred_equipment_slots | ForEach-Object { "{0}（{1}）" -f $_.label, $_.item })
                $synergyNotes += ("對味裝備：{0}" -f ($slotNotes -join '、'))
            }
            Write-Host ("同行默契：{0}" -f ($synergyNotes -join '；')) -ForegroundColor DarkCyan
        }
        $growthState = Get-CompanionGrowthState -GameState $GameState -NpcId ([string]$activeCompanion.id)
        $growthStage = Get-CompanionGrowthStageLabel -GameState $GameState -NpcId ([string]$activeCompanion.id)
        Write-Host ("同行成長：{0}（已解鎖 {1} 段）" -f $growthStage, @($growthState.unlocked_milestones).Count) -ForegroundColor DarkCyan
        Write-Host (Get-CompanionGrowthProgressText -GameState $GameState -NpcId ([string]$activeCompanion.id)) -ForegroundColor DarkGray
        Write-Host '可用 companion 查看主同行資料，party 看整體同行名單，focus <number> 可切換主同行。' -ForegroundColor DarkGray
    }
    Write-Host ("身上物資：{0}" -f ($GameState.inventory.inventory_slots -join '、'))
    Write-Host ("現金：{0}" -f $GameState.inventory.currency)
    if (@($GameState.runtime.current_pressure_tags).Count -gt 0) {
        Write-Host ("眼前壓力：{0}" -f (@($GameState.runtime.current_pressure_tags) -join '、')) -ForegroundColor Yellow
    }
    if ($GameState.runtime.learned_job_directions.Count -gt 0) {
        Write-Host ("已開出的職業方向：{0}" -f ($GameState.runtime.learned_job_directions -join '、')) -ForegroundColor DarkCyan
    }
    if (@($GameState.runtime.talked_npcs).Count -gt 0) {
        Write-Host ("已搭過話的人數：{0}" -f @($GameState.runtime.talked_npcs).Count) -ForegroundColor DarkGray
    }
    $affinityEntries = @(Get-NpcAffinityEntries -GameState $GameState -RegionPack $RegionPack)
    if ($GameState.runtime.adventure_company_established) {
        Write-Host '你們現在已經被地方當成一支像樣的冒險團，同行上限提高到 3 位。' -ForegroundColor DarkCyan
    }
    if ($affinityEntries.Count -gt 0) {
        $topEntries = @($affinityEntries | Select-Object -First 3)
        $topText = @($topEntries | ForEach-Object { "{0}（{1} {2}）" -f $_.npc_name, $_.label, $_.score }) -join '、'
        Write-Host ("好感較高的人：{0}" -f $topText) -ForegroundColor Magenta
    }
    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -ne $activeEncounter) {
        $stageLabel = if ($activeEncounter.stage -eq 'followup') { '後續' } else { '主遭遇' }
        $categoryLabel = [string]$activeEncounter.category
        if ($categoryLabel.StartsWith('followup-')) {
            $categoryLabel = $categoryLabel.Substring(9)
        }
        Write-Host ("目前遭遇：{0}（{1} / {2}）" -f $activeEncounter.title, $categoryLabel, $stageLabel) -ForegroundColor Yellow
    }
    if ($GameState.notebook.known_clues.Count -gt 0) {
        Write-Host ("已知線索：{0}" -f ($GameState.notebook.known_clues -join '；')) -ForegroundColor DarkGray
    }
    Write-Host ("完成任務數：{0}" -f @($GameState.quests.completed_quests).Count) -ForegroundColor DarkGray
}

function Show-Quest {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host ''
        Write-Host '目前沒有進行中的任務。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    $keyNpcNames = @()
    foreach ($npcId in @($quest.key_npcs)) {
        $npc = Get-NpcById -RegionPack $RegionPack -NpcId ([string]$npcId)
        if ($null -ne $npc) {
            $keyNpcNames += $npc.name
        }
        else {
            $keyNpcNames += [string]$npcId
        }
    }
    Write-Host ''
    Write-Host '--- 任務 ---' -ForegroundColor Cyan
    Write-Host ("任務：{0}" -f $quest.title) -ForegroundColor Yellow
    Write-Host ("類型：{0}" -f (Get-QuestCategoryLabel -QuestDefinition $quest)) -ForegroundColor DarkMagenta
    Write-Host ("衝突：{0}" -f $quest.core_conflict)
    Write-Host ("抉擇：{0}" -f $quest.decision)
    Write-Host ("關鍵人物：{0}" -f ($keyNpcNames -join '、'))

    if ($record.status -eq 'ready_to_turn_in') {
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $quest.progress.completion.turn_in_location_id
        $turnInNpc = Get-NpcById -RegionPack $RegionPack -NpcId $quest.progress.completion.turn_in_npc_id
        $turnInScore = Get-NpcAffinityScore -GameState $GameState -NpcId ([string]$quest.progress.completion.turn_in_npc_id)
        $turnInLabel = Get-NpcAffinityLabel -Score $turnInScore
        Write-Host ''
        Write-Host '你已經完成調查，現在可以交付任務。' -ForegroundColor Green
        Write-Host ("交付地點：{0}" -f $turnInPoint.name)
        Write-Host ("交付對象：{0}" -f $turnInNpc.name)
        Write-Host ("目前和對方的熟悉度：{0}（{1}）" -f $turnInLabel, $turnInScore) -ForegroundColor DarkMagenta
        Write-Host ("可得報酬：{0} 現金、{1}" -f $quest.progress.completion.rewards.currency, ($quest.progress.completion.rewards.items -join '、'))
        return
    }

    $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
    $stepPoint = Get-StartPointById -RegionPack $RegionPack -PointId $step.location_id
    Write-Host ''
    Write-Host ("目前進度：第 {0}/{1} 步 - {2}" -f ($record.step_index + 1), @($quest.progress.steps).Count, $step.title) -ForegroundColor Green
    Write-Host ("目標地點：{0}" -f $stepPoint.name)
    Write-Host ("目標內容：{0}" -f $step.goal_text)
    Write-Host ("推進指令：do {0}" -f $step.advance_command) -ForegroundColor DarkCyan
    Write-Host ("完成後可交付報酬：{0} 現金、{1}" -f $quest.progress.completion.rewards.currency, ($quest.progress.completion.rewards.items -join '、')) -ForegroundColor DarkGray
}

function Show-Actions {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host ''
        Write-Host '目前沒有可推進的任務動作。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    Write-Host ''
    Write-Host '--- 可用任務動作 ---' -ForegroundColor Cyan

    if ($record.status -eq 'ready_to_turn_in') {
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $quest.progress.completion.turn_in_location_id
        Write-Host ("- turnin（前往 {0} 交付任務）" -f $turnInPoint.name) -ForegroundColor Green
        return
    }

    $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
    $stepPoint = Get-StartPointById -RegionPack $RegionPack -PointId $step.location_id
    Write-Host ("- do {0}" -f $step.advance_command) -ForegroundColor Green
    Write-Host ("  地點：{0}" -f $stepPoint.name)
    Write-Host ("  目標：{0}" -f $step.goal_text)
    Write-Host ("  別名：{0}" -f ($step.advance_aliases -join '、')) -ForegroundColor DarkGray
    Write-Host '- advance（在正確地點時，直接執行當前步驟）' -ForegroundColor DarkGray
}

function Show-Npcs {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 眼前可能接觸的人 ---' -ForegroundColor Cyan
    $index = 1
    foreach ($npcId in $GameState.runtime.linked_npcs) {
        $npc = Get-NpcById -RegionPack $RegionPack -NpcId $npcId
        if ($null -ne $npc) {
            $spoken = if ($GameState.runtime.talked_npcs -contains [string]$npc.id) { '（已搭過話）' } else { '' }
            $score = Get-NpcAffinityScore -GameState $GameState -NpcId ([string]$npc.id)
            $label = Get-NpcAffinityLabel -Score $score
            $companionProfile = Get-NpcCompanionProfile -NpcId ([string]$npc.id)
            $companionState = ''
            if ($null -ne $companionProfile) {
                $threshold = [int]$companionProfile['recruit_threshold']
                $activeCompanionIds = @(Get-ActiveCompanionNpcIds -GameState $GameState)
                $capacity = Get-CompanionCapacity -GameState $GameState
                if ($activeCompanionIds -contains [string]$npc.id) {
                    $focusTail = if ([string]$GameState.runtime.focus_companion_npc_id -eq [string]$npc.id) { ' / 主同行' } else { '' }
                    $companionState = ("（同行中{0}）" -f $focusTail)
                }
                elseif ($score -ge $threshold) {
                    if ($activeCompanionIds.Count -ge $capacity) {
                        $companionState = '（可邀同行，但目前滿員）'
                    }
                    else {
                        $companionState = '（可邀同行）'
                    }
                }
                else {
                    $companionState = ("（同行門檻 {0}）" -f $threshold)
                }
            }
            Write-Host ("{0}. {1}{2}：{3}" -f $index, $npc.name, $spoken, $npc.role)
            Write-Host ("  {0}" -f $npc.intro_use) -ForegroundColor DarkGray
            Write-Host ("  好感：{0}（{1}）{2}" -f $label, $score, $companionState) -ForegroundColor DarkMagenta
            $index += 1
        }
    }
    if ($index -gt 1) {
        Write-Host '可用 talk 1 搭話、relations 看整體好感，少數 NPC 在好感達標後可用 recruit 1 邀同行。若已有多人同行，可用 focus 1 切換主同行。' -ForegroundColor DarkCyan
    }
}

function Show-Relations {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $entries = @(Get-NpcAffinityEntries -GameState $GameState -RegionPack $RegionPack)
    Write-Host ''
    Write-Host '--- NPC 好感 ---' -ForegroundColor Cyan
    if ($entries.Count -eq 0) {
        Write-Host '你目前還沒有和任何關鍵人物建立可追蹤的好感。' -ForegroundColor Yellow
        return
    }

    $index = 1
    foreach ($entry in $entries) {
        $companionProfile = Get-NpcCompanionProfile -NpcId ([string]$entry.npc_id)
        $tail = ''
        if ($null -ne $companionProfile) {
            $threshold = [int]$companionProfile['recruit_threshold']
            $growthStage = Get-CompanionGrowthStageLabel -GameState $GameState -NpcId ([string]$entry.npc_id)
            if (@(Get-ActiveCompanionNpcIds -GameState $GameState) -contains [string]$entry.npc_id) {
                $focusTail = if ([string]$GameState.runtime.focus_companion_npc_id -eq [string]$entry.npc_id) { ' / 主同行' } else { '' }
                $tail = (" / 同行中{0} / {1}" -f $focusTail, $growthStage)
            }
            elseif ([int]$entry.score -ge $threshold) {
                $tail = (" / 可邀同行 / {0}" -f $growthStage)
            }
            else {
                $tail = (" / 同行門檻 {0} / {1}" -f $threshold, $growthStage)
            }
        }
        Write-Host ("{0}. {1}：{2}（{3}）{4}" -f $index, $entry.npc_name, $entry.label, $entry.score, $tail) -ForegroundColor Magenta
        $storedSupplies = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$entry.npc_id))
        $equipmentText = Get-CompanionEquipmentSummaryText -GameState $GameState -NpcId ([string]$entry.npc_id)
        if ($storedSupplies.Count -gt 0) {
            Write-Host ("   手上仍帶著：{0}" -f ($storedSupplies -join '、')) -ForegroundColor DarkMagenta
        }
        if ($equipmentText -ne '未配置') {
            Write-Host ("   身上裝備：{0}" -f $equipmentText) -ForegroundColor DarkMagenta
        }
        $index += 1
    }
}

function Show-PartyRoster {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $activeCompanions = @(Get-ActiveCompanionNpcs -GameState $GameState -RegionPack $RegionPack)
    $capacity = Get-CompanionCapacity -GameState $GameState

    Write-Host ''
    Write-Host '--- 同行名單 ---' -ForegroundColor Cyan
    Write-Host ("目前編制：{0}（{1}/{2}）" -f (Get-CompanionCapacityLabel -GameState $GameState), $activeCompanions.Count, $capacity) -ForegroundColor DarkCyan
    if ($GameState.runtime.adventure_company_established) {
        Write-Host '你們現在已被地方默認成一支小型冒險團，所以同行上限已提升。' -ForegroundColor DarkCyan
    }

    if ($activeCompanions.Count -eq 0) {
        Write-Host '你目前沒有正式同行者。這區每個落點通常只有 0-2 位地方人物願意在好感達標後與你同行。' -ForegroundColor Yellow
        return
    }

    for ($i = 0; $i -lt $activeCompanions.Count; $i++) {
        $npc = $activeCompanions[$i]
        $profile = Get-NpcCompanionProfile -NpcId ([string]$npc.id)
        $score = Get-NpcAffinityScore -GameState $GameState -NpcId ([string]$npc.id)
        $label = Get-NpcAffinityLabel -Score $score
        $focusTail = if ([string]$GameState.runtime.focus_companion_npc_id -eq [string]$npc.id) { '（主同行）' } else { '' }
        Write-Host ("{0}. {1}{2}：{3} / {4}（{5}）" -f ($i + 1), $npc.name, $focusTail, $npc.role, $label, $score) -ForegroundColor Magenta
        if ($null -ne $profile -and $profile.Contains('stay_reason')) {
            Write-Host ("   留下理由：{0}" -f $profile['stay_reason']) -ForegroundColor DarkGray
        }
    }

    Write-Host '可用 companion 看主同行詳情，focus <number> 切換主同行，dismiss <number> 讓某位同行先留在安全點。' -ForegroundColor DarkCyan
}

function Set-CompanionFocus {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    $activeCompanions = @(Get-ActiveCompanionNpcs -GameState $GameState -RegionPack $RegionPack)
    if ($activeCompanions.Count -eq 0) {
        Write-Host '你目前沒有同行者。' -ForegroundColor Yellow
        return
    }

    if ([string]::IsNullOrWhiteSpace($Selection)) {
        Show-PartyRoster -GameState $GameState -RegionPack $RegionPack
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt $activeCompanions.Count) {
        Write-Host ("請輸入 1 到 {0} 之間的同行編號。" -f $activeCompanions.Count) -ForegroundColor Yellow
        return
    }

    $npc = $activeCompanions[$selectedIndex - 1]
    $GameState.runtime.focus_companion_npc_id = [string]$npc.id
    $GameState.runtime.active_companion_npc_id = [string]$npc.id
    Write-Host ''
    Write-Host ("--- 主同行切換為 {0} ---" -f $npc.name) -ForegroundColor Cyan
    Write-Host '之後 companion / gear / supplies 這些細部指令，會先以這位同行者為主。' -ForegroundColor Green
}

function Show-QuestBoard {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if ($null -ne (Get-ActiveQuestRecord -GameState $GameState)) {
        Write-Host ''
        Write-Host '你手上已經有進行中的任務，先把它推完或交付再來接下一條。' -ForegroundColor Yellow
        return
    }

    $available = @(Get-AvailableQuestsForCurrentScene -GameState $GameState -RegionPack $RegionPack)
    Write-Host ''
    Write-Host '--- 當地任務板 ---' -ForegroundColor Cyan
    if ($available.Count -eq 0) {
        Write-Host '這個落點目前沒有新的任務可接。你可以先移動、休整，或再和熟人多跑幾段路。' -ForegroundColor Yellow
        return
    }

    for ($i = 0; $i -lt $available.Count; $i++) {
        $quest = $available[$i]
        $questTypeLabel = Get-QuestCategoryLabel -QuestDefinition $quest
        $companionEntry = Get-CompanionQuestCatalogEntryByTitle -Title ([string]$quest.title)
        if ($null -ne $companionEntry) {
            $questTypeLabel = '同行支線'
        }
        Write-Host ("{0}. [{1}] {2}" -f ($i + 1), $questTypeLabel, $quest.title) -ForegroundColor Green
        Write-Host ("   衝突：{0}" -f $quest.core_conflict)
        $boardHint = [string](Get-ObjectFieldValue -InputObject $quest -FieldName 'board_hint')
        if ([string]::IsNullOrWhiteSpace($boardHint)) {
            if ($null -ne $companionEntry) {
                $boardHint = [string]$companionEntry.board_hint
            }
        }
        if (-not [string]::IsNullOrWhiteSpace($boardHint)) {
            Write-Host ("   熟人話頭：{0}" -f $boardHint) -ForegroundColor DarkMagenta
        }
        Write-Host ("   完成後可得：{0} 現金、{1}" -f $quest.progress.completion.rewards.currency, ($quest.progress.completion.rewards.items -join '、')) -ForegroundColor DarkGray
    }

    Write-Host '輸入 take 1 之類的指令即可接任務。' -ForegroundColor DarkCyan
}

function Show-Services {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 補給與服務 ---' -ForegroundColor Cyan
    foreach ($tag in $RegionPack.service_tags) {
        Write-Host ("- {0}" -f $tag)
    }
    $services = @(Get-SceneServices -GameState $GameState)
    if ($services.Count -gt 0) {
        Write-Host ''
        Write-Host '這個落點目前可直接買到：' -ForegroundColor Green
        for ($i = 0; $i -lt $services.Count; $i++) {
            $service = $services[$i]
            $owned = if ($GameState.inventory.inventory_slots -contains [string]$service.item) { '（已持有）' } else { '' }
            Write-Host ("{0}. {1} - {2} 現金 {3}" -f ($i + 1), $service.title, $service.description, $service.cost)
            if (-not [string]::IsNullOrWhiteSpace([string]$owned)) {
                Write-Host ("   {0}" -f $owned) -ForegroundColor DarkGray
            }
        }
        Write-Host '可用 buy 1 之類的方式購買。' -ForegroundColor DarkCyan
    }
}

function Show-OddJobs {
    param([hashtable]$GameState)

    $jobs = @(Get-SceneOddJobs -GameState $GameState)
    Write-Host ''
    Write-Host '--- 白身短工與雜活 ---' -ForegroundColor Cyan
    if ($jobs.Count -eq 0) {
        Write-Host '這裡目前沒有能讓白身立刻接手的短工。' -ForegroundColor Yellow
        return
    }

    for ($i = 0; $i -lt $jobs.Count; $i++) {
        $job = $jobs[$i]
        $jobKey = Get-TodaysOddJobKey -GameState $GameState -JobId ([string]$job.id)
        $doneToday = if ($GameState.runtime.day_job_log -contains $jobKey) { '（今天已做）' } else { '' }
        Write-Host ("{0}. {1}{2}" -f ($i + 1), $job.title, $doneToday) -ForegroundColor Green
        Write-Host ("   {0}" -f $job.description)
        Write-Host ("   報酬：{0} 現金" -f $job.currency) -ForegroundColor DarkGray
    }
    Write-Host '可用 work 1 之類的方式接一個短工。' -ForegroundColor DarkCyan
}

function Talk-ToNpc {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '搭話')) {
        return
    }

    if ([string]::IsNullOrWhiteSpace($Selection)) {
        Show-Npcs -GameState $GameState -RegionPack $RegionPack
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt @($GameState.runtime.linked_npcs).Count) {
        Write-Host ("請輸入 1 到 {0} 之間的人物編號。" -f @($GameState.runtime.linked_npcs).Count) -ForegroundColor Yellow
        return
    }

    $npcId = [string]@($GameState.runtime.linked_npcs)[$selectedIndex - 1]
    $npc = Get-NpcById -RegionPack $RegionPack -NpcId $npcId
    if ($null -eq $npc) {
        Write-Host '這個人現在不在你能接上的名單裡。' -ForegroundColor Yellow
        return
    }

    $profile = Get-NpcConversationProfile -NpcId $npcId
    $firstTime = -not ($GameState.runtime.talked_npcs -contains $npcId)
    if ($null -eq $profile) {
        Write-Host ''
        Write-Host ("你和 {0} 搭了幾句話。" -f $npc.name) -ForegroundColor Cyan
        Write-Host $npc.intro_use -ForegroundColor DarkGray
        if ($firstTime) {
            $GameState.runtime.talked_npcs = Add-UniqueString -Collection $GameState.runtime.talked_npcs -Value $npcId
            $affinityScore = Add-NpcAffinityDelta -GameState $GameState -NpcId $npcId -Delta 1
            $affinityLabel = Get-NpcAffinityLabel -Score $affinityScore
            Write-Host ("和 {0} 的好感提升到：{1}（{2}）" -f $npc.name, $affinityLabel, $affinityScore) -ForegroundColor Magenta
        }
        Advance-TimeState -GameState $GameState -Steps 1
        return
    }

    $text = if ($firstTime) { [string]$profile['first_text'] } else { [string]$profile['repeat_text'] }
    $profileItems = @()
    if ($null -ne $profile['items']) {
        $profileItems = @($profile['items'])
    }
    $profileJobDirections = @()
    if ($null -ne $profile['job_directions']) {
        $profileJobDirections = @($profile['job_directions'])
    }
    $profilePressureTags = @()
    if ($null -ne $profile['pressure_tags']) {
        $profilePressureTags = @($profile['pressure_tags'])
    }
    $profileClues = @()
    if ($null -ne $profile['clues']) {
        $profileClues = @($profile['clues'])
    }

    Write-Host ''
    Write-Host ("--- 與 {0} 交談 ---" -f $npc.name) -ForegroundColor Cyan
    Write-Host $text -ForegroundColor Green

    if ($firstTime) {
        $GameState.runtime.talked_npcs = Add-UniqueString -Collection $GameState.runtime.talked_npcs -Value $npcId
        $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values $profileClues
        $GameState.runtime.learned_job_directions = Add-UniqueStrings -Collection $GameState.runtime.learned_job_directions -Values $profileJobDirections
        $GameState.runtime.current_pressure_tags = Add-UniqueStrings -Collection $GameState.runtime.current_pressure_tags -Values $profilePressureTags
        $GameState.inventory.inventory_slots = Add-UniqueStrings -Collection $GameState.inventory.inventory_slots -Values $profileItems
        Add-ReputationDelta -GameState $GameState -TrackId ([string]$profile['reputation_track']) -Delta ([int]$profile['reputation_delta'])
        $affinityScore = Add-NpcAffinityDelta -GameState $GameState -NpcId $npcId -Delta 1
        $affinityLabel = Get-NpcAffinityLabel -Score $affinityScore

        if ($profileItems.Count -gt 0) {
            Write-Host ("獲得物品：{0}" -f ($profileItems -join '、')) -ForegroundColor Yellow
        }
        if ($profileJobDirections.Count -gt 0) {
            Write-Host ("開出的職業方向：{0}" -f ($profileJobDirections -join '、')) -ForegroundColor DarkCyan
        }
        Write-Host ("和 {0} 的好感提升到：{1}（{2}）" -f $npc.name, $affinityLabel, $affinityScore) -ForegroundColor Magenta
    }

    Advance-TimeState -GameState $GameState -Steps 1
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray

    $companionProfile = Get-NpcCompanionProfile -NpcId $npcId
    if ($null -ne $companionProfile) {
        $currentScore = Get-NpcAffinityScore -GameState $GameState -NpcId $npcId
        $threshold = [int]$companionProfile['recruit_threshold']
        if ($currentScore -ge $threshold -and -not (@(Get-ActiveCompanionNpcIds -GameState $GameState) -contains $npcId)) {
            Write-Host ("{0} 現在已經願意和你一起跑一段路。可用 recruit {1} 邀他同行。" -f $npc.name, $Selection) -ForegroundColor DarkCyan
        }
    }

    if ($null -eq (Get-ActiveQuestRecord -GameState $GameState)) {
        $personalQuest = Get-UnlockedCompanionQuestForNpcAtCurrentScene -GameState $GameState -RegionPack $RegionPack -NpcId $npcId
        if ($null -ne $personalQuest) {
            $hint = [string](Get-ObjectFieldValue -InputObject $personalQuest -FieldName 'board_hint')
            if ([string]::IsNullOrWhiteSpace($hint)) {
                $hint = ("{0} 像是終於有件只想交給熟人處理的私事。" -f $npc.name)
            }
            Write-Host ("{0} 話裡留了一個口子：{1}" -f $npc.name, $hint) -ForegroundColor DarkMagenta
            Write-Host '你現在去看 board，應該會看到這條熟人委託。' -ForegroundColor DarkCyan
        }
    }
}

function Recruit-Companion {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '邀人同行')) {
        return
    }

    $activeCompanionIds = @(Get-ActiveCompanionNpcIds -GameState $GameState)
    $capacity = Get-CompanionCapacity -GameState $GameState
    if ($activeCompanionIds.Count -ge $capacity) {
        Write-Host ("你目前的同行編制已滿（{0}/{1}）。先用 dismiss 讓一位同行先留在安全地點，再邀另一位。" -f $activeCompanionIds.Count, $capacity) -ForegroundColor Yellow
        if (-not $GameState.runtime.adventure_company_established) {
            Write-Host '完成更多地方任務、讓隊伍真正成形後，之後才能把上限提到 3 位。' -ForegroundColor DarkGray
        }
        return
    }

    if ([string]::IsNullOrWhiteSpace($Selection)) {
        Show-Npcs -GameState $GameState -RegionPack $RegionPack
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt @($GameState.runtime.linked_npcs).Count) {
        Write-Host ("請輸入 1 到 {0} 之間的人物編號。" -f @($GameState.runtime.linked_npcs).Count) -ForegroundColor Yellow
        return
    }

    $npcId = [string]@($GameState.runtime.linked_npcs)[$selectedIndex - 1]
    $npc = Get-NpcById -RegionPack $RegionPack -NpcId $npcId
    if ($null -eq $npc) {
        Write-Host '這個人現在不在你能接上的名單裡。' -ForegroundColor Yellow
        return
    }

    $companionProfile = Get-NpcCompanionProfile -NpcId $npcId
    if ($null -eq $companionProfile) {
        Write-Host ("{0} 不屬於會跟你一起外跑的那類人。至少在目前這區，不是這樣。" -f $npc.name) -ForegroundColor Yellow
        return
    }

    $score = Get-NpcAffinityScore -GameState $GameState -NpcId $npcId
    $threshold = [int]$companionProfile['recruit_threshold']
    if ($activeCompanionIds -contains $npcId) {
        Write-Host ("{0} 已經在你的同行名單裡了。若只是想改成主同行，可用 focus。" -f $npc.name) -ForegroundColor Yellow
        return
    }
    if ($score -lt $threshold) {
        Write-Host ("{0} 現在對你的態度還是 {1}（{2}），還不到願意同行的程度。" -f $npc.name, (Get-NpcAffinityLabel -Score $score), $score) -ForegroundColor Yellow
        Write-Host ("至少要到 {0} 才能邀同行。" -f $threshold) -ForegroundColor DarkGray
        return
    }

    $GameState.runtime.active_companion_npc_ids = Add-UniqueString -Collection $activeCompanionIds -Value $npcId
    $GameState.runtime.focus_companion_npc_id = $npcId
    $GameState.runtime.active_companion_npc_id = $npcId
    $null = Ensure-CompanionGrowthState -GameState $GameState -NpcId $npcId
    Write-Host ''
    Write-Host ("--- {0} 願意同行 ---" -f $npc.name) -ForegroundColor Cyan
    Write-Host ([string]$companionProfile['recruit_text']) -ForegroundColor Green
    if ($companionProfile.Contains('stay_reason')) {
        Write-Host ("留下理由：{0}" -f $companionProfile['stay_reason']) -ForegroundColor DarkGray
    }
    Write-Host ("目前同行編制：{0}/{1}" -f @($GameState.runtime.active_companion_npc_ids).Count, $capacity) -ForegroundColor DarkCyan
}

function Dismiss-Companion {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '讓同行者離隊')) {
        return
    }

    $activeCompanions = @(Get-ActiveCompanionNpcs -GameState $GameState -RegionPack $RegionPack)
    if ($activeCompanions.Count -eq 0) {
        Write-Host '你目前沒有同行者。' -ForegroundColor Yellow
        return
    }

    $npc = $null
    if ([string]::IsNullOrWhiteSpace($Selection)) {
        $npc = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
        if ($activeCompanions.Count -gt 1) {
            Write-Host '未指定編號時，會讓目前的主同行先留在安全點。若要指定人選，可用 dismiss <number>。' -ForegroundColor DarkGray
        }
    }
    else {
        $selectedIndex = 0
        if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt $activeCompanions.Count) {
            Write-Host ("請輸入 1 到 {0} 之間的同行編號。" -f $activeCompanions.Count) -ForegroundColor Yellow
            return
        }
        $npc = $activeCompanions[$selectedIndex - 1]
    }

    $profile = Get-NpcCompanionProfile -NpcId ([string]$npc.id)
    $carriedItems = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$npc.id))
    $equipmentText = Get-CompanionEquipmentSummaryText -GameState $GameState -NpcId ([string]$npc.id)
    $GameState.runtime.active_companion_npc_ids = Remove-String -Collection @(Get-ActiveCompanionNpcIds -GameState $GameState) -Value ([string]$npc.id)
    $GameState.runtime.focus_companion_npc_id = if (@($GameState.runtime.active_companion_npc_ids).Count -gt 0) { [string]@($GameState.runtime.active_companion_npc_ids)[0] } else { $null }
    $GameState.runtime.active_companion_npc_id = $GameState.runtime.focus_companion_npc_id
    Write-Host ''
    Write-Host ("--- {0} 暫時離隊 ---" -f $npc.name) -ForegroundColor Cyan
    if ($null -ne $profile -and $profile.Contains('dismiss_text')) {
        Write-Host ([string]$profile['dismiss_text']) -ForegroundColor Green
    }
    else {
        Write-Host ("{0} 先留在這段安全路上，等你下次再來接人。" -f $npc.name) -ForegroundColor Green
    }
    if ($carriedItems.Count -gt 0) {
        Write-Host ("{0} 仍把你先前交出去的物資帶在身上：{1}" -f $npc.name, ($carriedItems -join '、')) -ForegroundColor DarkCyan
    }
    if ($equipmentText -ne '未配置') {
        Write-Host ("{0} 也把你替他配上的裝備一起帶走了：{1}" -f $npc.name, $equipmentText) -ForegroundColor DarkCyan
    }
    $growthState = Get-CompanionGrowthState -GameState $GameState -NpcId ([string]$npc.id)
    if (@($growthState.unlocked_milestones).Count -gt 0) {
        Write-Host ("你們累積下來的默契還在：{0} 已解鎖 {1} 段同行成長。" -f $npc.name, @($growthState.unlocked_milestones).Count) -ForegroundColor DarkCyan
    }
    if (@($GameState.runtime.active_companion_npc_ids).Count -gt 0) {
        Write-Host ("目前還有同行者：{0}" -f (@((Get-ActiveCompanionNpcs -GameState $GameState -RegionPack $RegionPack) | ForEach-Object { $_.name }) -join '、')) -ForegroundColor DarkMagenta
    }
}

function Buy-ServiceItem {
    param(
        [hashtable]$GameState,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '購買')) {
        return
    }

    $services = @(Get-SceneServices -GameState $GameState)
    if ($services.Count -eq 0) {
        Write-Host '這裡沒有可直接購買的補給。' -ForegroundColor Yellow
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt $services.Count) {
        Write-Host ("請輸入 1 到 {0} 之間的服務編號。" -f $services.Count) -ForegroundColor Yellow
        return
    }

    $service = $services[$selectedIndex - 1]
    if ($GameState.inventory.currency -lt [int]$service.cost) {
        Write-Host '你現在的現金不夠。' -ForegroundColor Yellow
        return
    }
    if ($GameState.inventory.inventory_slots -contains [string]$service.item) {
        Write-Host ("你身上已經有 {0} 了，這版原型先不疊加同物品。" -f $service.item) -ForegroundColor Yellow
        return
    }

    $GameState.inventory.currency -= [int]$service.cost
    $GameState.inventory.inventory_slots = Add-UniqueString -Collection $GameState.inventory.inventory_slots -Value ([string]$service.item)
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 完成補給 ---' -ForegroundColor Cyan
    Write-Host ("你花了 {0} 現金，買下：{1}" -f $service.cost, $service.item) -ForegroundColor Green
    Write-Host $service.description -ForegroundColor DarkGray
    Write-Host ("剩餘現金：{0}" -f $GameState.inventory.currency) -ForegroundColor Yellow
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Show-Supplies {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 物資與同行攜行 ---' -ForegroundColor Cyan
    if (@($GameState.inventory.inventory_slots).Count -eq 0) {
        Write-Host '你身上目前沒有可交付的物資。' -ForegroundColor Yellow
    }
    else {
        Write-Host '你身上的物資：' -ForegroundColor Green
        for ($i = 0; $i -lt @($GameState.inventory.inventory_slots).Count; $i++) {
            Write-Host ("{0}. {1}" -f ($i + 1), @($GameState.inventory.inventory_slots)[$i])
        }
    }

    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $activeCompanion) {
        Write-Host '目前沒有同行者，因此也沒有可分配的同行物資欄。' -ForegroundColor DarkGray
        return
    }

    $carried = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id))
    Write-Host ''
    Write-Host ("主同行 {0} 正替你保管：" -f $activeCompanion.name) -ForegroundColor Magenta
    if ($carried.Count -eq 0) {
        Write-Host '目前沒有。' -ForegroundColor DarkGray
    }
    else {
        for ($i = 0; $i -lt $carried.Count; $i++) {
            Write-Host ("{0}. {1}" -f ($i + 1), $carried[$i])
        }
    }
    Write-Host '可用 give <number> 把身上物資交給主同行，也可用 takeback <number> 拿回。若你有多位同行，可先用 focus <number> 切換主同行。' -ForegroundColor DarkCyan
}

function Give-CompanionSupply {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '交付同行物資')) {
        return
    }

    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $activeCompanion) {
        Write-Host '你目前沒有同行者，還沒有人能替你分攤物資。' -ForegroundColor Yellow
        return
    }

    if ([string]::IsNullOrWhiteSpace($Selection)) {
        Show-Supplies -GameState $GameState -RegionPack $RegionPack
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt @($GameState.inventory.inventory_slots).Count) {
        Write-Host ("請輸入 1 到 {0} 之間的物資編號。" -f @($GameState.inventory.inventory_slots).Count) -ForegroundColor Yellow
        return
    }

    $inventoryItems = @($GameState.inventory.inventory_slots)
    $item = [string]$inventoryItems[$selectedIndex - 1]
    $remaining = @()
    for ($i = 0; $i -lt $inventoryItems.Count; $i++) {
        if ($i -ne ($selectedIndex - 1)) {
            $remaining += $inventoryItems[$i]
        }
    }
    $GameState.inventory.inventory_slots = $remaining

    $carried = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id))
    $carried = Add-UniqueString -Collection $carried -Value $item
    Set-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id) -Items $carried
    $profile = Get-NpcCompanionProfile -NpcId ([string]$activeCompanion.id)
    $preferredText = $null
    if ($null -ne $profile -and $profile.Contains('companion_preferences')) {
        $preferences = $profile['companion_preferences']
        if (@($preferences.preferred_supplies) -contains $item) {
            $preferredText = ("這剛好是 {0} 很順手的那類補給，之後在硬局裡通常能發揮得更好。" -f $activeCompanion.name)
        }
    }

    Write-Host ''
    Write-Host ("--- 交付物資給 {0} ---" -f $activeCompanion.name) -ForegroundColor Cyan
    Write-Host ("你把 {0} 交給了 {1} 保管。" -f $item, $activeCompanion.name) -ForegroundColor Green
    Write-Host '之後若遇到危險局，對方會優先動用手邊能用的一份補給，替你多穩一口氣；就算暫時離隊，也會先留在對方身上。' -ForegroundColor DarkCyan
    if ($null -ne $preferredText) {
        Write-Host $preferredText -ForegroundColor DarkMagenta
    }
}

function TakeBack-CompanionSupply {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '收回同行物資')) {
        return
    }

    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $activeCompanion) {
        Write-Host '你目前沒有同行者。' -ForegroundColor Yellow
        return
    }

    $carried = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id))
    if ($carried.Count -eq 0) {
        Write-Host ("{0} 目前沒有替你保管任何物資。" -f $activeCompanion.name) -ForegroundColor Yellow
        return
    }

    if ([string]::IsNullOrWhiteSpace($Selection)) {
        Show-Supplies -GameState $GameState -RegionPack $RegionPack
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt $carried.Count) {
        Write-Host ("請輸入 1 到 {0} 之間的同行物資編號。" -f $carried.Count) -ForegroundColor Yellow
        return
    }

    $item = [string]$carried[$selectedIndex - 1]
    $remaining = @()
    for ($i = 0; $i -lt $carried.Count; $i++) {
        if ($i -ne ($selectedIndex - 1)) {
            $remaining += $carried[$i]
        }
    }
    Set-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id) -Items $remaining
    $GameState.inventory.inventory_slots = Add-UniqueString -Collection $GameState.inventory.inventory_slots -Value $item

    Write-Host ''
    Write-Host ("--- 從 {0} 手上收回物資 ---" -f $activeCompanion.name) -ForegroundColor Cyan
    Write-Host ("你把 {0} 收回自己身上。" -f $item) -ForegroundColor Green
}

function Show-CompanionGear {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 同行裝備 ---' -ForegroundColor Cyan
    if (@($GameState.inventory.inventory_slots).Count -eq 0) {
        Write-Host '你身上目前沒有可分配給同行者的物品。' -ForegroundColor Yellow
    }
    else {
        Write-Host '你身上的可分配物品：' -ForegroundColor Green
        for ($i = 0; $i -lt @($GameState.inventory.inventory_slots).Count; $i++) {
            Write-Host ("{0}. {1}" -f ($i + 1), @($GameState.inventory.inventory_slots)[$i])
        }
    }

    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $activeCompanion) {
        Write-Host '目前沒有同行者，因此無法配置同行裝備。' -ForegroundColor DarkGray
        return
    }

    $equipment = Get-CompanionEquipment -GameState $GameState -NpcId ([string]$activeCompanion.id)
    Write-Host ''
    Write-Host ("主同行 {0} 目前穿戴：" -f $activeCompanion.name) -ForegroundColor Magenta
    Write-Host ("- 武器：{0}" -f $(if ($null -ne $equipment.weapon) { $equipment.weapon } else { '未配置' }))
    Write-Host ("- 防具：{0}" -f $(if ($null -ne $equipment.armor) { $equipment.armor } else { '未配置' }))
    Write-Host ("- 飾品：{0}" -f $(if ($null -ne $equipment.accessory) { $equipment.accessory } else { '未配置' }))
    Write-Host '可用 equipcompanion <weapon|armor|accessory> <number> 配裝，也可用 unequipcompanion <weapon|armor|accessory> 收回。若你有多位同行，可先用 focus <number> 切換主同行。' -ForegroundColor DarkCyan
}

function Show-ActiveCompanionProfile {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Write-Host ''
    Write-Host '--- 同行者詳情 ---' -ForegroundColor Cyan

    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $activeCompanion) {
        Write-Host '你目前沒有同行者。先把關係養到位，再用 recruit <number> 邀人一起跑。' -ForegroundColor Yellow
        return
    }

    $profile = Get-NpcCompanionProfile -NpcId ([string]$activeCompanion.id)
    $score = Get-NpcAffinityScore -GameState $GameState -NpcId ([string]$activeCompanion.id)
    $label = Get-NpcAffinityLabel -Score $score
    $supplies = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id))
    $equipment = Get-CompanionEquipment -GameState $GameState -NpcId ([string]$activeCompanion.id)
    $preferenceState = Get-CompanionPreferenceState -GameState $GameState -NpcId ([string]$activeCompanion.id)

    Write-Host ("姓名：{0}" -f $activeCompanion.name) -ForegroundColor Magenta
    Write-Host ("目前身分：{0}" -f $activeCompanion.role)
    Write-Host ("同行定位：{0}" -f $(if ($null -ne $profile -and $profile.Contains('companion_role')) { $profile['companion_role'] } else { '未定義' }))
    Write-Host ("好感：{0}（{1}）" -f $label, $score) -ForegroundColor DarkMagenta
    Write-Host ("隊內位置：主同行 / 目前隊伍 {0}/{1}" -f @(Get-ActiveCompanionNpcIds -GameState $GameState).Count, (Get-CompanionCapacity -GameState $GameState)) -ForegroundColor DarkCyan

    if ($null -ne $profile -and $profile.Contains('companion_background')) {
        Write-Host ''
        Write-Host '背景：' -ForegroundColor Green
        Write-Host ([string]$profile['companion_background'])
    }

    if ($null -ne $profile -and $profile.Contains('companion_style')) {
        Write-Host ''
        Write-Host '風格：' -ForegroundColor Green
        Write-Host ([string]$profile['companion_style'])
    }

    if ($null -ne $profile -and $profile.Contains('stay_reason')) {
        Write-Host ''
        Write-Host '為什麼願意留下：' -ForegroundColor Green
        Write-Host ([string]$profile['stay_reason'])
    }
    Write-Host '目前狀態：只要沒碰到真正踩線的理由，他不會無故離隊。' -ForegroundColor DarkGray
    if ($null -ne $profile -and $profile.Contains('leave_triggers')) {
        Write-Host ("可能離開的理由：{0}" -f (@($profile['leave_triggers']) -join '、')) -ForegroundColor Yellow
    }

    if ($null -ne $profile -and $profile.Contains('companion_stats')) {
        Write-Host ''
        Write-Host '數據：' -ForegroundColor Green
        foreach ($key in @($profile['companion_stats'].Keys)) {
            Write-Host ("- {0}：{1}" -f $key, $profile['companion_stats'][$key])
        }
    }

    if ($null -ne $profile -and $profile.Contains('companion_strengths')) {
        Write-Host ''
        Write-Host ("擅長：{0}" -f (@($profile['companion_strengths']) -join '、')) -ForegroundColor Green
    }
    if ($null -ne $profile -and $profile.Contains('companion_cautions')) {
        Write-Host ("注意點：{0}" -f (@($profile['companion_cautions']) -join '、')) -ForegroundColor Yellow
    }

    if ($null -ne $profile -and $profile.Contains('companion_preferences')) {
        $preferences = $profile['companion_preferences']
        Write-Host ''
        Write-Host '偏好：' -ForegroundColor Green
        Write-Host ("- 喜歡：{0}" -f (@($preferences.likes) -join '、'))
        Write-Host ("- 不喜歡：{0}" -f (@($preferences.dislikes) -join '、'))
        Write-Host ("- 偏好物資：{0}" -f (@($preferences.preferred_supplies) -join '、'))
        Write-Host ("- 偏好裝備欄：{0}" -f (@($preferences.preferred_equipment) -join '、'))
    }

    Write-Host ''
    Write-Host ("目前攜行：{0}" -f $(if ($supplies.Count -gt 0) { $supplies -join '、' } else { '無' })) -ForegroundColor DarkMagenta
    Write-Host ("目前裝備：武器：{0} / 防具：{1} / 飾品：{2}" -f `
            $(if ($null -ne $equipment.weapon) { $equipment.weapon } else { '未配置' }), `
            $(if ($null -ne $equipment.armor) { $equipment.armor } else { '未配置' }), `
            $(if ($null -ne $equipment.accessory) { $equipment.accessory } else { '未配置' })) -ForegroundColor DarkMagenta
    $growthPlan = Get-CompanionGrowthPlan -NpcId ([string]$activeCompanion.id)
    $growthState = Get-CompanionGrowthState -GameState $GameState -NpcId ([string]$activeCompanion.id)
    if ($null -ne $growthPlan) {
        Write-Host ''
        Write-Host ("成長線：{0}" -f $growthPlan.title) -ForegroundColor Green
        Write-Host ("目前階段：{0}" -f (Get-CompanionGrowthStageLabel -GameState $GameState -NpcId ([string]$activeCompanion.id))) -ForegroundColor DarkGreen
        if (@($growthState.unlocked_milestones).Count -gt 0) {
            Write-Host '已解鎖里程碑：' -ForegroundColor Green
            foreach ($milestone in @($growthPlan.milestones)) {
                if (@($growthState.unlocked_milestones) -contains [string]$milestone.id) {
                    Write-Host ("- {0}：{1}" -f $milestone.title, $milestone.summary) -ForegroundColor DarkGreen
                }
            }
        }
        else {
            Write-Host '已解鎖里程碑：目前還沒有。' -ForegroundColor DarkGray
        }
        Write-Host (Get-CompanionGrowthProgressText -GameState $GameState -NpcId ([string]$activeCompanion.id)) -ForegroundColor DarkGray
    }
    Write-Host ''
    Write-Host '目前對味配置：' -ForegroundColor Green
    if ($preferenceState.preferred_supplies_in_hand.Count -gt 0) {
        Write-Host ("- 補給：{0}" -f ($preferenceState.preferred_supplies_in_hand -join '、')) -ForegroundColor DarkGreen
    }
    if ($preferenceState.preferred_equipment_slots.Count -gt 0) {
        foreach ($entry in @($preferenceState.preferred_equipment_slots)) {
            Write-Host ("- 裝備欄：{0}（{1}）" -f $entry.label, $entry.item) -ForegroundColor DarkGreen
        }
    }
    if ($preferenceState.preferred_supplies_in_hand.Count -eq 0 -and $preferenceState.preferred_equipment_slots.Count -eq 0) {
        Write-Host '尚未湊到這位同行者最順手的補給或裝備欄。' -ForegroundColor DarkGray
    }
    if (@(Get-ActiveCompanionNpcIds -GameState $GameState).Count -gt 1) {
        Write-Host ''
        Write-Host '若你想改看別位同行者，可先用 focus <number> 切換主同行，再輸入 companion。' -ForegroundColor DarkCyan
    }
}

function Equip-CompanionItem {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Arguments
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '替同行者配置裝備')) {
        return
    }

    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $activeCompanion) {
        Write-Host '你目前沒有同行者。' -ForegroundColor Yellow
        return
    }

    if ([string]::IsNullOrWhiteSpace($Arguments)) {
        Show-CompanionGear -GameState $GameState -RegionPack $RegionPack
        return
    }

    $parts = $Arguments -split '\s+', 2
    if ($parts.Count -lt 2) {
        Write-Host '請用 equipcompanion <weapon|armor|accessory> <number>。' -ForegroundColor Yellow
        return
    }

    $slot = $parts[0].Trim().ToLowerInvariant()
    if ($slot -notin @('weapon', 'armor', 'accessory')) {
        Write-Host '裝備欄只能是 weapon、armor 或 accessory。' -ForegroundColor Yellow
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($parts[1].Trim(), [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt @($GameState.inventory.inventory_slots).Count) {
        Write-Host ("請輸入 1 到 {0} 之間的物品編號。" -f @($GameState.inventory.inventory_slots).Count) -ForegroundColor Yellow
        return
    }

    $equipment = Get-CompanionEquipment -GameState $GameState -NpcId ([string]$activeCompanion.id)
    if ($null -ne $equipment[$slot]) {
        Write-Host ("{0} 的 {1} 欄已經有：{2}。先用 unequipcompanion {1} 才能換新。" -f $activeCompanion.name, $slot, $equipment[$slot]) -ForegroundColor Yellow
        return
    }

    $inventoryItems = @($GameState.inventory.inventory_slots)
    $item = [string]$inventoryItems[$selectedIndex - 1]
    $remaining = @()
    for ($i = 0; $i -lt $inventoryItems.Count; $i++) {
        if ($i -ne ($selectedIndex - 1)) {
            $remaining += $inventoryItems[$i]
        }
    }
    $GameState.inventory.inventory_slots = $remaining

    $equipment[$slot] = $item
    Set-CompanionEquipment -GameState $GameState -NpcId ([string]$activeCompanion.id) -Equipment $equipment

    $slotLabel = switch ($slot) {
        'weapon' { '武器' }
        'armor' { '防具' }
        default { '飾品' }
    }

    Write-Host ''
    Write-Host ("--- 替 {0} 配置裝備 ---" -f $activeCompanion.name) -ForegroundColor Cyan
    Write-Host ("你把 {0} 交給了 {1}，作為他的{2}。" -f $item, $activeCompanion.name, $slotLabel) -ForegroundColor Green
    Write-Host '這份裝備會跟著他一起累積，就算暫時離隊也會留在他身上。' -ForegroundColor DarkCyan
    $profile = Get-NpcCompanionProfile -NpcId ([string]$activeCompanion.id)
    if ($null -ne $profile -and $profile.Contains('companion_preferences')) {
        $preferences = $profile['companion_preferences']
        if (@(@($preferences.preferred_equipment) | ForEach-Object { Normalize-CompanionEquipmentSlotName -SlotName ([string]$_) }) -contains $slot) {
            Write-Host ("這個欄位正好是 {0} 最順手的配置之一，之後在危險局裡通常會更有發揮。" -f $activeCompanion.name) -ForegroundColor DarkMagenta
        }
    }
}

function Unequip-CompanionItem {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Slot
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '收回同行裝備')) {
        return
    }

    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -eq $activeCompanion) {
        Write-Host '你目前沒有同行者。' -ForegroundColor Yellow
        return
    }

    $normalizedSlot = [string]$Slot
    if ([string]::IsNullOrWhiteSpace($normalizedSlot)) {
        Show-CompanionGear -GameState $GameState -RegionPack $RegionPack
        return
    }

    $normalizedSlot = $normalizedSlot.Trim().ToLowerInvariant()
    if ($normalizedSlot -notin @('weapon', 'armor', 'accessory')) {
        Write-Host '裝備欄只能是 weapon、armor 或 accessory。' -ForegroundColor Yellow
        return
    }

    $equipment = Get-CompanionEquipment -GameState $GameState -NpcId ([string]$activeCompanion.id)
    $item = $equipment[$normalizedSlot]
    if ($null -eq $item) {
        Write-Host ("{0} 的 {1} 欄目前沒有裝備。" -f $activeCompanion.name, $normalizedSlot) -ForegroundColor Yellow
        return
    }

    $equipment[$normalizedSlot] = $null
    Set-CompanionEquipment -GameState $GameState -NpcId ([string]$activeCompanion.id) -Equipment $equipment
    $GameState.inventory.inventory_slots = Add-UniqueString -Collection $GameState.inventory.inventory_slots -Value ([string]$item)

    Write-Host ''
    Write-Host ("--- 從 {0} 身上收回裝備 ---" -f $activeCompanion.name) -ForegroundColor Cyan
    Write-Host ("你把 {0} 收回自己身上。" -f $item) -ForegroundColor Green
}

function Work-OddJob {
    param(
        [hashtable]$GameState,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '做短工')) {
        return
    }

    $jobs = @(Get-SceneOddJobs -GameState $GameState)
    if ($jobs.Count -eq 0) {
        Write-Host '這裡目前沒有短工可接。' -ForegroundColor Yellow
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt $jobs.Count) {
        Write-Host ("請輸入 1 到 {0} 之間的短工編號。" -f $jobs.Count) -ForegroundColor Yellow
        return
    }

    $job = $jobs[$selectedIndex - 1]
    $jobKey = Get-TodaysOddJobKey -GameState $GameState -JobId ([string]$job.id)
    if ($GameState.runtime.day_job_log -contains $jobKey) {
        Write-Host '這份短工你今天已經做過了，先讓別人也混口飯吃。' -ForegroundColor Yellow
        return
    }

    $GameState.runtime.day_job_log = Add-UniqueString -Collection $GameState.runtime.day_job_log -Value $jobKey
    $GameState.inventory.currency += [int]$job.currency
    $GameState.inventory.inventory_slots = Add-UniqueStrings -Collection $GameState.inventory.inventory_slots -Values @($job.items)
    $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($job.clues)
    $GameState.runtime.learned_job_directions = Add-UniqueStrings -Collection $GameState.runtime.learned_job_directions -Values @($job.job_directions)
    Add-ReputationDelta -GameState $GameState -TrackId ([string]$job.reputation_track) -Delta ([int]$job.reputation_delta)
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 白身短工完成 ---' -ForegroundColor Cyan
    Write-Host $job.reward_text -ForegroundColor Green
    Write-Host ("獲得現金：{0}" -f $job.currency) -ForegroundColor Yellow
    if (@($job.items).Count -gt 0) {
        Write-Host ("獲得物品：{0}" -f (@($job.items) -join '、'))
    }
    if (@($job.job_directions).Count -gt 0) {
        Write-Host ("職業方向更明確了：{0}" -f (@($job.job_directions) -join '、')) -ForegroundColor DarkCyan
    }
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Rest-AtScene {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '休整')) {
        return
    }

    $scene = Get-StartPointById -RegionPack $RegionPack -PointId $GameState.location.current_scene_id
    $clearedTag = $null
    if (@($GameState.runtime.current_pressure_tags).Count -gt 0) {
        $clearedTag = @($GameState.runtime.current_pressure_tags)[0]
        $GameState.runtime.current_pressure_tags = @($GameState.runtime.current_pressure_tags | Select-Object -Skip 1)
    }
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 短暫休整 ---' -ForegroundColor Cyan
    Write-Host ("你在 {0} 找了個能暫時安身的角落，先把肩背和呼吸都慢慢放下來。" -f $scene.name) -ForegroundColor Green
    if ($null -ne $clearedTag) {
        Write-Host ("壓力稍微緩掉了一點：{0}" -f $clearedTag) -ForegroundColor DarkCyan
    }
    else {
        Write-Host '這次休整沒有額外洗掉什麼麻煩，但至少人是穩下來了。' -ForegroundColor DarkGray
    }
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -ne $activeCompanion) {
        $unlocks = Add-CompanionGrowthProgress -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$activeCompanion.id) -Metric 'shared_steps' -Amount 1
        Show-CompanionGrowthUnlocks -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$activeCompanion.id) -Milestones $unlocks
    }
}

function Show-Circuits {
    param([object]$RegionPack)

    Write-Host ''
    Write-Host '--- 地方迴路 ---' -ForegroundColor Cyan
    foreach ($circuit in $RegionPack.location_circuits) {
        Write-Host ("- {0}：{1}" -f $circuit.name, ($circuit.route -join ' -> '))
    }
}

function Show-ActiveEncounter {
    param([hashtable]$GameState)

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -eq $activeEncounter) {
        Write-Host '目前沒有正在進行中的遭遇。' -ForegroundColor Yellow
        return
    }

    Write-Host ''
    if ($activeEncounter.stage -eq 'followup') {
        Write-Host '--- 遭遇後續 ---' -ForegroundColor Cyan
        if (-not [string]::IsNullOrWhiteSpace([string]$activeEncounter.parent_title)) {
            Write-Host ("前段局勢：{0}" -f $activeEncounter.parent_title) -ForegroundColor DarkGray
        }
    }
    else {
        Write-Host '--- 遭遇 ---' -ForegroundColor Cyan
    }
    Write-Host ("類型：{0}" -f $activeEncounter.title) -ForegroundColor Yellow
    Write-Host $activeEncounter.text
    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $Script:RegionPack
    if ($null -ne $activeCompanion) {
        $baseCategory = Get-EncounterBaseCategory -Category ([string]$activeEncounter.category)
        if ($baseCategory -eq 'danger') {
            Write-Host ("{0} 沒有退開，手上和眼神都已經準備好陪你把這場硬局一起頂完。" -f $activeCompanion.name) -ForegroundColor DarkMagenta
        }
        else {
            Write-Host ("{0} 沒有退開，顯然是打算陪你把這件事一起處理完。" -f $activeCompanion.name) -ForegroundColor DarkMagenta
        }
    }
    Write-Host ''
    Write-Host '你可以這樣應對：' -ForegroundColor Cyan
    for ($i = 0; $i -lt @($activeEncounter.options).Count; $i++) {
        $option = $activeEncounter.options[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $option.title) -ForegroundColor Green
    }
    Write-Host '輸入 respond 1 之類的指令即可處理這次遭遇。' -ForegroundColor DarkCyan
}

function Trigger-Encounter {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection = ''
    )

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -ne $activeEncounter) {
        Show-ActiveEncounter -GameState $GameState
        return
    }

    $encounter = Select-EncounterSeed -RegionPack $RegionPack -Selection $Selection
    if ($null -eq $encounter) {
        Write-Host '找不到這種遭遇。可用 encounter 隨機抽，或用 encounter danger / encounter social / encounter ambush 之類的方式指定。' -ForegroundColor Yellow
        return
    }

    $profile = Get-EncounterProfile -Type ([string]$encounter.type)
    $GameState.runtime.active_encounter = New-EncounterState `
        -Type ([string]$encounter.type) `
        -Title ([string]$profile.title) `
        -Category ([string]$profile.category) `
        -SceneId ([string]$GameState.location.current_scene_id) `
        -SceneName ([string]$GameState.location.current_scene_name) `
        -Text ([string]$encounter.text) `
        -Options @($profile.options) `
        -Stage 'primary' `
        -SourcePath ([string]$encounter.source_path)
    Advance-TimeState -GameState $GameState -Steps 1
    Show-ActiveEncounter -GameState $GameState
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Resolve-Encounter {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -eq $activeEncounter) {
        Write-Host '目前沒有需要處理的遭遇。' -ForegroundColor Yellow
        return
    }

    $selectedIndex = 0
    if (-not [int]::TryParse($Selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt @($activeEncounter.options).Count) {
        Write-Host ("請輸入 1 到 {0} 之間的遭遇選項編號。" -f @($activeEncounter.options).Count) -ForegroundColor Yellow
        return
    }

    $resolution = @($activeEncounter.options)[$selectedIndex - 1]

    $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($resolution.clues)
    $GameState.inventory.inventory_slots = Add-UniqueStrings -Collection $GameState.inventory.inventory_slots -Values @($resolution.items)
    $GameState.runtime.learned_job_directions = Add-UniqueStrings -Collection $GameState.runtime.learned_job_directions -Values @($resolution.job_directions)
    $GameState.runtime.current_pressure_tags = Add-UniqueStrings -Collection $GameState.runtime.current_pressure_tags -Values @($resolution.pressure_tags)
    $GameState.inventory.currency += [int]$resolution.currency
    Add-ReputationDelta -GameState $GameState -TrackId ([string]$resolution.reputation_track) -Delta ([int]$resolution.reputation_delta)
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 遭遇結果 ---' -ForegroundColor Cyan
    Write-Host $resolution.result_text -ForegroundColor Green
    if ([int]$resolution.currency -ne 0) {
        Write-Host ("現金變動：{0}" -f $resolution.currency) -ForegroundColor Yellow
    }
    if (@($resolution.items).Count -gt 0) {
        Write-Host ("獲得物品：{0}" -f (@($resolution.items) -join '、'))
    }
    if ([int]$resolution.reputation_delta -ne 0 -and -not [string]::IsNullOrWhiteSpace([string]$resolution.reputation_track)) {
        Write-Host ("地區評價：{0} +{1}" -f $resolution.reputation_track, $resolution.reputation_delta) -ForegroundColor DarkCyan
    }
    if (@($resolution.job_directions).Count -gt 0) {
        Write-Host ("開出的職業方向：{0}" -f (@($resolution.job_directions) -join '、')) -ForegroundColor DarkCyan
    }

    $companionSupport = Get-CompanionDangerSupport -GameState $GameState -RegionPack $RegionPack -EncounterState $activeEncounter
    if ($null -ne $companionSupport) {
        $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($companionSupport.clues)
        Add-ReputationDelta -GameState $GameState -TrackId ([string]$companionSupport.reputation_track) -Delta ([int]$companionSupport.reputation_delta)
        $clearedPressure = @()
        $clearCount = [Math]::Max(0, [int]$companionSupport.clear_pressure)
        while ($clearCount -gt 0 -and @($GameState.runtime.current_pressure_tags).Count -gt 0) {
            $tag = [string]@($GameState.runtime.current_pressure_tags)[0]
            $clearedPressure += $tag
            $GameState.runtime.current_pressure_tags = @($GameState.runtime.current_pressure_tags | Select-Object -Skip 1)
            $clearCount -= 1
        }

        Write-Host ''
        Write-Host ("--- {0} 一起出手 ---" -f $companionSupport.npc.name) -ForegroundColor Magenta
        Write-Host $companionSupport.text -ForegroundColor Green
        if (@($clearedPressure).Count -gt 0) {
            Write-Host ("對方幫你穩住了一段壓力：{0}" -f (@($clearedPressure) -join '、')) -ForegroundColor DarkCyan
        }
        if ([int]$companionSupport.reputation_delta -ne 0 -and -not [string]::IsNullOrWhiteSpace([string]$companionSupport.reputation_track)) {
            Write-Host ("同行援手帶來額外評價：{0} +{1}" -f $companionSupport.reputation_track, $companionSupport.reputation_delta) -ForegroundColor DarkCyan
        }
        $unlocks = Add-CompanionGrowthProgress -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$companionSupport.npc.id) -Metric 'danger_supports' -Amount 1
        Show-CompanionGrowthUnlocks -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$companionSupport.npc.id) -Milestones $unlocks
    }

    $supplyBoost = Get-CompanionSupplyBoost -GameState $GameState -RegionPack $RegionPack -EncounterState $activeEncounter
    if ($null -ne $supplyBoost) {
        $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($supplyBoost.clues)
        Add-ReputationDelta -GameState $GameState -TrackId ([string]$supplyBoost.reputation_track) -Delta ([int]$supplyBoost.reputation_delta)
        $extraCleared = @()
        $extraCount = [Math]::Max(0, [int]$supplyBoost.clear_pressure)
        while ($extraCount -gt 0 -and @($GameState.runtime.current_pressure_tags).Count -gt 0) {
            $tag = [string]@($GameState.runtime.current_pressure_tags)[0]
            $extraCleared += $tag
            $GameState.runtime.current_pressure_tags = @($GameState.runtime.current_pressure_tags | Select-Object -Skip 1)
            $extraCount -= 1
        }

        Write-Host ''
        Write-Host ("--- {0} 動用了你交給他的補給 ---" -f $supplyBoost.npc.name) -ForegroundColor Magenta
        Write-Host ("{0} 立刻把 {1} 用在最該頂住的那一刻，讓局勢沒有繼續往更壞的地方塌。" -f $supplyBoost.npc.name, $supplyBoost.used_item) -ForegroundColor Green
        foreach ($text in @($supplyBoost.texts)) {
            Write-Host $text -ForegroundColor Green
        }
        if ($extraCleared.Count -gt 0) {
            Write-Host ("補給額外穩住了一段壓力：{0}" -f ($extraCleared -join '、')) -ForegroundColor DarkCyan
        }
        else {
            Write-Host '這次補給雖然沒有再多清掉一段壓力，但至少確保你們沒有在最糟的時候手上空空。' -ForegroundColor DarkCyan
        }
        if ([int]$supplyBoost.reputation_delta -ne 0 -and -not [string]::IsNullOrWhiteSpace([string]$supplyBoost.reputation_track)) {
            Write-Host ("這份補給也替你們多撐出一點可信度：{0} +{1}" -f $supplyBoost.reputation_track, $supplyBoost.reputation_delta) -ForegroundColor DarkCyan
        }
        if ($supplyBoost.preferred) {
            $unlocks = Add-CompanionGrowthProgress -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$supplyBoost.npc.id) -Metric 'preferred_hits' -Amount 1
            Show-CompanionGrowthUnlocks -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$supplyBoost.npc.id) -Milestones $unlocks
        }
    }

    $equipmentBoost = Get-CompanionEquipmentBoost -GameState $GameState -RegionPack $RegionPack -EncounterState $activeEncounter
    if ($null -ne $equipmentBoost) {
        $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($equipmentBoost.clues)
        Add-ReputationDelta -GameState $GameState -TrackId ([string]$equipmentBoost.reputation_track) -Delta ([int]$equipmentBoost.reputation_delta)
        $equipmentCleared = @()
        $equipmentCount = [Math]::Max(0, [int]$equipmentBoost.clear_pressure)
        while ($equipmentCount -gt 0 -and @($GameState.runtime.current_pressure_tags).Count -gt 0) {
            $tag = [string]@($GameState.runtime.current_pressure_tags)[0]
            $equipmentCleared += $tag
            $GameState.runtime.current_pressure_tags = @($GameState.runtime.current_pressure_tags | Select-Object -Skip 1)
            $equipmentCount -= 1
        }

        Write-Host ''
        Write-Host ("--- {0} 身上的裝備也發揮了作用 ---" -f $equipmentBoost.npc.name) -ForegroundColor Magenta
        foreach ($text in @($equipmentBoost.texts)) {
            Write-Host $text -ForegroundColor Green
        }
        if ($equipmentCleared.Count -gt 0) {
            Write-Host ("裝備額外穩住了一段壓力：{0}" -f ($equipmentCleared -join '、')) -ForegroundColor DarkCyan
        }
        if ([int]$equipmentBoost.reputation_delta -ne 0 -and -not [string]::IsNullOrWhiteSpace([string]$equipmentBoost.reputation_track)) {
            Write-Host ("這身裝備也替你們多撐出一點可信度：{0} +{1}" -f $equipmentBoost.reputation_track, $equipmentBoost.reputation_delta) -ForegroundColor DarkCyan
        }
        if (@($equipmentBoost.texts | Where-Object { $_ -like '*最順手的欄位*' }).Count -gt 0) {
            $unlocks = Add-CompanionGrowthProgress -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$equipmentBoost.npc.id) -Metric 'preferred_hits' -Amount 1
            Show-CompanionGrowthUnlocks -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$equipmentBoost.npc.id) -Milestones $unlocks
        }
    }

    if ($resolution.followup) {
        $followup = $resolution.followup
        $GameState.runtime.active_encounter = New-EncounterState `
            -Type ([string]$activeEncounter.type) `
            -Title ([string]$followup.title) `
            -Category ([string]$followup.category) `
            -SceneId ([string]$GameState.location.current_scene_id) `
            -SceneName ([string]$GameState.location.current_scene_name) `
            -Text ([string]$followup.text) `
            -Options @($followup.options) `
            -Stage 'followup' `
            -SourcePath ([string]$activeEncounter.source_path) `
            -ParentTitle ([string]$activeEncounter.title)
        Write-Host ''
        Write-Host '局勢還沒完全收尾。' -ForegroundColor Yellow
        Show-ActiveEncounter -GameState $GameState
    }
    else {
        $GameState.runtime.active_encounter = $null
    }

    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Move-Location {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '移動')) {
        return
    }

    Write-Host ''
    Write-Host '你可以往哪裡轉移：' -ForegroundColor Cyan
    for ($i = 0; $i -lt $RegionPack.start_points.Count; $i++) {
        $point = $RegionPack.start_points[$i]
        Write-Host ("{0}. {1}" -f ($i + 1), $point.name)
    }

    $selectedIndex = Read-Choice -Prompt '請選擇要移動的地點編號' -Min 1 -Max $RegionPack.start_points.Count
    $target = $RegionPack.start_points[$selectedIndex - 1]
    $GameState.location.current_scene_id = $target.id
    $GameState.location.current_scene_name = $target.name
    $GameState.runtime.current_pressure_tags = @($target.pressure_tags)
    $GameState.runtime.linked_npcs = @($target.linked_npcs)
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ("你轉移到了 {0}。" -f $target.name) -ForegroundColor Green
    Write-Host $target.why_start_here
    $activeCompanion = Get-ActiveCompanionNpc -GameState $GameState -RegionPack $RegionPack
    if ($null -ne $activeCompanion) {
        Write-Host ("{0} 也跟著你把這段路跑完了。" -f $activeCompanion.name) -ForegroundColor DarkMagenta
        $unlocks = Add-CompanionGrowthProgress -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$activeCompanion.id) -Metric 'shared_steps' -Amount 1
        Show-CompanionGrowthUnlocks -GameState $GameState -RegionPack $RegionPack -NpcId ([string]$activeCompanion.id) -Milestones $unlocks
    }
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Show-Help {
    Write-Host ''
    Write-Host '可用指令：' -ForegroundColor Cyan
    Write-Host '- look              看目前場景'
    Write-Host '- status            看角色狀態'
    Write-Host '- quest             看目前任務與進度'
    Write-Host '- board             看當地可接任務'
    Write-Host '- jobs              看當地白身短工'
    Write-Host '- actions           看目前任務可推進的動作'
    Write-Host '- take <number>     接下任務板上的一條任務'
    Write-Host '- work <number>     接一個當地短工'
    Write-Host '- do <keyword>      執行當前任務步驟'
    Write-Host '- advance           在正確地點時直接推進當前步驟'
    Write-Host '- turnin            交付已完成任務並領報酬'
    Write-Host '- npcs              看目前關鍵人物'
    Write-Host '- relations         看目前已建立的 NPC 好感'
    Write-Host '- talk <number>     主動和眼前人物搭話'
    Write-Host '- recruit <number>  邀少數好感達標的 NPC 同行'
    Write-Host '- party             看目前整隊同行名單與編制'
    Write-Host '- focus <number>    切換主同行（gear / supplies / companion 會先看他）'
    Write-Host '- companion         看主同行的數據、背景、偏好與風格'
    Write-Host '- dismiss [number]  讓主同行或指定同行先留在安全點'
    Write-Host '- supplies          看自己和主同行目前各帶著什麼'
    Write-Host '- give <number>     把一項物資交給主同行保管'
    Write-Host '- takeback <number> 從主同行手上收回一項物資'
    Write-Host '- gear              看主同行的武器 / 防具 / 飾品'
    Write-Host '- equipcompanion <weapon|armor|accessory> <number>  替同行者配置裝備'
    Write-Host '- unequipcompanion <weapon|armor|accessory>         從同行者身上收回裝備'
    Write-Host '- services          看當地補給與服務'
    Write-Host '- buy <number>      購買當地可用補給'
    Write-Host '- circuits          看地方迴路'
    Write-Host '- rest              短暫休整，讓時間往前走'
    Write-Host '- move              移動到其他起始點'
    Write-Host '- encounter         抽出或重看當前遭遇'
    Write-Host '- encounter danger  指定抽出危險遭遇，方便驗證同行援手'
    Write-Host '- respond <number>  處理眼前遭遇'
    Write-Host '- save              存檔'
    Write-Host '- help              顯示指令'
    Write-Host '- exit              離開原型'
    Write-Host ''
    Write-Host '同行規則：每個落點通常只有 0-2 位人物願意同行。一般上限 2 位；完成夠多任務後會被地方默認成小型冒險團，上限提高到 3 位。' -ForegroundColor DarkCyan
    Write-Host '目前原型中，同行者不會無故離隊；除非你主動讓他離隊，或之後真的碰到踩線事件。' -ForegroundColor DarkGray
}

function Show-Look {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    $scene = Get-StartPointById -RegionPack $RegionPack -PointId $GameState.location.current_scene_id
    Write-Host ''
    Write-Host '--- 場景 ---' -ForegroundColor Cyan
    Write-Host ("你現在在 {0}。" -f $scene.name)
    Write-Host $scene.why_start_here
    Write-Host ("眼前壓力：{0}" -f ($scene.pressure_tags -join '、')) -ForegroundColor Yellow
    $activeCompanions = @(Get-ActiveCompanionNpcs -GameState $GameState -RegionPack $RegionPack)
    foreach ($activeCompanion in $activeCompanions) {
        $profile = Get-NpcCompanionProfile -NpcId ([string]$activeCompanion.id)
        if ($null -ne $profile -and $profile.Contains('companion_presence_text')) {
            Write-Host ([string]$profile['companion_presence_text']) -ForegroundColor DarkMagenta
        }
        else {
            Write-Host ("{0} 正跟在你身邊，和你一起看著這一小段路怎麼呼吸。" -f $activeCompanion.name) -ForegroundColor DarkMagenta
        }
        $companionSupplies = @(Get-CompanionSupplies -GameState $GameState -NpcId ([string]$activeCompanion.id))
        if ($companionSupplies.Count -gt 0) {
            Write-Host ("{0} 手上還替你帶著：{1}" -f $activeCompanion.name, ($companionSupplies -join '、')) -ForegroundColor DarkMagenta
        }
        $companionEquipmentText = Get-CompanionEquipmentSummaryText -GameState $GameState -NpcId ([string]$activeCompanion.id)
        if ($companionEquipmentText -ne '未配置') {
            Write-Host ("{0} 現在身上帶著：{1}" -f $activeCompanion.name, $companionEquipmentText) -ForegroundColor DarkMagenta
        }
    }

    $activeEncounter = Get-ActiveEncounter -GameState $GameState
    if ($null -ne $activeEncounter) {
        Write-Host ("眼前還有一個未處理的遭遇：{0}" -f $activeEncounter.title) -ForegroundColor Yellow
        Write-Host '可先輸入 encounter 重新看選項，或用 respond <number> 處理。' -ForegroundColor DarkCyan
        return
    }

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -ne $record) {
        $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
        if ($record.status -eq 'ready_to_turn_in') {
            if ($quest.progress.completion.turn_in_location_id -eq $scene.id) {
                Write-Host '你已經能在這裡交付任務，輸入 turnin 即可結算。' -ForegroundColor Green
            }
        }
        else {
            $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
            if ($step.location_id -eq $scene.id) {
                Write-Host ("這裡可以推進任務：{0}" -f $step.title) -ForegroundColor Green
                Write-Host ("建議指令：do {0}" -f $step.advance_command) -ForegroundColor DarkCyan
            }
        }
    }
    else {
        $available = @(Get-AvailableQuestsForCurrentScene -GameState $GameState -RegionPack $RegionPack)
        if ($available.Count -gt 0) {
            Write-Host '這裡有新的 starter quest 可接，輸入 board 可查看。' -ForegroundColor Green
        }
    }
}

function Accept-Quest {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$Selection
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '接任務')) {
        return
    }

    if ($null -ne (Get-ActiveQuestRecord -GameState $GameState)) {
        Write-Host '你目前還有進行中的任務，先把它處理完。' -ForegroundColor Yellow
        return
    }

    $available = @(Get-AvailableQuestsForCurrentScene -GameState $GameState -RegionPack $RegionPack)
    if ($available.Count -eq 0) {
        Write-Host '這裡沒有可接的新任務。' -ForegroundColor Yellow
        return
    }

    $selectedIndex = 1
    if (-not [string]::IsNullOrWhiteSpace($Selection)) {
        $parsed = 0
        if (-not ([int]::TryParse($Selection, [ref]$parsed)) -or $parsed -lt 1 -or $parsed -gt $available.Count) {
            Write-Host ("請輸入 1 到 {0} 之間的任務編號。" -f $available.Count) -ForegroundColor Yellow
            return
        }
        $selectedIndex = $parsed
    }
    elseif ($available.Count -gt 1) {
        Write-Host '這裡有不只一條任務，請用 take 1 之類的方式指定。' -ForegroundColor Yellow
        return
    }

    $quest = $available[$selectedIndex - 1]
    $companionEntry = Get-CompanionQuestCatalogEntryByTitle -Title ([string]$quest.title)
    $GameState.quests.active_quests = @((New-QuestRecord -QuestId ([string]$quest.quest_id)))
    Write-Host ''
    Write-Host '--- 接下任務 ---' -ForegroundColor Cyan
    Write-Host ("你接下了：{0}" -f $quest.title) -ForegroundColor Green
    $questTypeLabel = if ($null -ne $companionEntry) { '同行支線' } else { Get-QuestCategoryLabel -QuestDefinition $quest }
    Write-Host ("類型：{0}" -f $questTypeLabel) -ForegroundColor DarkMagenta
    Write-Host ("衝突：{0}" -f $quest.core_conflict)
    Write-Host ("第一步建議：{0}" -f $quest.progress.steps[0].title) -ForegroundColor Yellow
    Write-Host ("可先輸入：do {0}" -f $quest.progress.steps[0].advance_command) -ForegroundColor DarkCyan
}

function Resolve-QuestAction {
    param(
        [hashtable]$GameState,
        [object]$RegionPack,
        [string]$ActionToken,
        [switch]$AdvanceCurrent
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '推進任務')) {
        return
    }

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host '目前沒有進行中的任務。' -ForegroundColor Yellow
        return
    }

    if ($record.status -eq 'ready_to_turn_in') {
        Write-Host '這條任務已可交付，請改用 turnin。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    $step = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
    $requiredScene = Get-StartPointById -RegionPack $RegionPack -PointId $step.location_id

    if ($GameState.location.current_scene_id -ne $step.location_id) {
        Write-Host ("你現在不在正確地點。這一步要去 {0}。" -f $requiredScene.name) -ForegroundColor Yellow
        return
    }

    $matched = $AdvanceCurrent.IsPresent
    if (-not $matched) {
        $candidates = @($step.advance_command) + @($step.advance_aliases)
        foreach ($candidate in $candidates) {
            if ($candidate -eq $ActionToken) {
                $matched = $true
                break
            }
        }
    }

    if (-not $matched) {
        Write-Host ("這一步的有效指令是 do {0}，或使用 advance。" -f $step.advance_command) -ForegroundColor Yellow
        return
    }

    $record.progress_log = Add-UniqueString -Collection $record.progress_log -Value ([string]$step.title)
    $GameState.notebook.known_clues = Add-UniqueStrings -Collection $GameState.notebook.known_clues -Values @($step.clues)
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 任務推進 ---' -ForegroundColor Cyan
    Write-Host $step.result_text -ForegroundColor Green

    $nextIndex = $record.step_index + 1
    if ($nextIndex -ge @($quest.progress.steps).Count) {
        $record.status = 'ready_to_turn_in'
        Write-Host ''
        Write-Host '你已完成這條任務的調查或處理階段。' -ForegroundColor Green
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $quest.progress.completion.turn_in_location_id
        $turnInNpc = Get-NpcById -RegionPack $RegionPack -NpcId $quest.progress.completion.turn_in_npc_id
        Write-Host ("接下來請前往 {0}，找 {1} 交付任務。" -f $turnInPoint.name, $turnInNpc.name) -ForegroundColor Yellow
    }
    else {
        $record.step_index = $nextIndex
        $nextStep = Get-CurrentQuestStep -QuestRecord $record -QuestDefinition $quest
        $nextPoint = Get-StartPointById -RegionPack $RegionPack -PointId $nextStep.location_id
        Write-Host ''
        Write-Host ("下一步：{0}" -f $nextStep.title) -ForegroundColor Yellow
        Write-Host ("前往地點：{0}" -f $nextPoint.name)
        Write-Host ("目標：{0}" -f $nextStep.goal_text)
    }

    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Complete-QuestTurnIn {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    if (-not (Ensure-NoActiveEncounter -GameState $GameState -ActionLabel '交付任務')) {
        return
    }

    $record = Get-ActiveQuestRecord -GameState $GameState
    if ($null -eq $record) {
        Write-Host '目前沒有可交付的任務。' -ForegroundColor Yellow
        return
    }

    if ($record.status -ne 'ready_to_turn_in') {
        Write-Host '這條任務還沒完成到可交付的階段。' -ForegroundColor Yellow
        return
    }

    $quest = Get-ActiveQuestDefinition -GameState $GameState -RegionPack $RegionPack
    $completion = $quest.progress.completion
    if ($GameState.location.current_scene_id -ne $completion.turn_in_location_id) {
        $turnInPoint = Get-StartPointById -RegionPack $RegionPack -PointId $completion.turn_in_location_id
        Write-Host ("你還沒到交付地點，請先前往 {0}。" -f $turnInPoint.name) -ForegroundColor Yellow
        return
    }

    $GameState.inventory.currency += [int]$completion.rewards.currency
    $GameState.inventory.inventory_slots = Add-UniqueStrings -Collection $GameState.inventory.inventory_slots -Values @($completion.rewards.items)
    $GameState.runtime.learned_job_directions = Add-UniqueStrings -Collection $GameState.runtime.learned_job_directions -Values @($completion.rewards.job_directions)
    $turnInNpcId = [string]$completion.turn_in_npc_id
    $turnInNpc = Get-NpcById -RegionPack $RegionPack -NpcId $turnInNpcId
    $GameState.runtime.talked_npcs = Add-UniqueString -Collection $GameState.runtime.talked_npcs -Value $turnInNpcId
    $affinityScore = Add-NpcAffinityDelta -GameState $GameState -NpcId $turnInNpcId -Delta 2
    $affinityLabel = Get-NpcAffinityLabel -Score $affinityScore

    $trackId = [string]$completion.rewards.reputation.track_id
    $existingValue = 0
    if ($GameState.reputation.tracks.Contains($trackId)) {
        $existingValue = [int]$GameState.reputation.tracks[$trackId]
    }
    $GameState.reputation.tracks[$trackId] = $existingValue + [int]$completion.rewards.reputation.delta
    $GameState.notebook.revealed_truths = Add-UniqueString -Collection $GameState.notebook.revealed_truths -Value ([string]$completion.turn_in_text)

    $questTypeLabel = Get-QuestCategoryLabel -QuestDefinition $quest
    $companionQuestUnlockedMilestones = @()
    if ([string](Get-ObjectFieldValue -InputObject $quest -FieldName 'chapter_tier') -eq 'companion') {
        $affinityScore = Add-NpcAffinityDelta -GameState $GameState -NpcId $turnInNpcId -Delta 1
        $affinityLabel = Get-NpcAffinityLabel -Score $affinityScore
        $GameState.notebook.revealed_truths = Add-UniqueString -Collection $GameState.notebook.revealed_truths -Value ("你和 {0} 之間多了一層不寫進帳簿的默契。" -f $turnInNpc.name)
        if (@(Get-ActiveCompanionNpcIds -GameState $GameState) -contains $turnInNpcId) {
            $companionQuestUnlockedMilestones = Add-CompanionGrowthProgress -GameState $GameState -RegionPack $RegionPack -NpcId $turnInNpcId -Metric 'shared_steps' -Amount 1
        }
    }

    $record.status = 'completed'
    $record.completed_at = (Get-Date).ToString('o')
    $completedEntry = [ordered]@{
        quest_id = $record.quest_id
        completed_at = $record.completed_at
        rewards = [ordered]@{
            currency = $completion.rewards.currency
            items = @($completion.rewards.items)
            reputation_track = $completion.rewards.reputation.track_id
            reputation_delta = $completion.rewards.reputation.delta
            job_directions = @($completion.rewards.job_directions)
        }
    }

    $remainingActive = @()
    foreach ($active in @($GameState.quests.active_quests)) {
        if ($active.quest_id -ne $record.quest_id) {
            $remainingActive += $active
        }
    }
    $GameState.quests.active_quests = $remainingActive
    $GameState.quests.completed_quests += $completedEntry
    $hadCompanyBefore = [bool]$GameState.runtime.adventure_company_established
    Update-AdventureCompanyState -GameState $GameState
    Advance-TimeState -GameState $GameState -Steps 1

    Write-Host ''
    Write-Host '--- 任務完成 ---' -ForegroundColor Cyan
    Write-Host ("類型：{0}" -f $questTypeLabel) -ForegroundColor DarkMagenta
    Write-Host $completion.turn_in_text -ForegroundColor Green
    Write-Host ("獲得現金：{0}" -f $completion.rewards.currency) -ForegroundColor Yellow
    Write-Host ("獲得物品：{0}" -f ($completion.rewards.items -join '、'))
    Write-Host ("地區評價：{0} +{1}" -f $completion.rewards.reputation.label, $completion.rewards.reputation.delta)
    Write-Host ("開出的職業方向：{0}" -f ($completion.rewards.job_directions -join '、')) -ForegroundColor DarkCyan
    if ($null -ne $turnInNpc) {
        Write-Host ("和 {0} 的好感提升到：{1}（{2}）" -f $turnInNpc.name, $affinityLabel, $affinityScore) -ForegroundColor Magenta
    }
    if (@($companionQuestUnlockedMilestones).Count -gt 0) {
        Show-CompanionGrowthUnlocks -GameState $GameState -RegionPack $RegionPack -NpcId $turnInNpcId -Milestones $companionQuestUnlockedMilestones
    }
    if (-not $hadCompanyBefore -and [bool]$GameState.runtime.adventure_company_established) {
        Write-Host ''
        Write-Host '--- 小型冒險團成立 ---' -ForegroundColor Cyan
        Write-Host '你們在幽語海幾個落點之間的來回與交付，已經讓地方人開始把你們當成一支能信的隊伍。' -ForegroundColor Green
        Write-Host '同行上限提升到：3 位。' -ForegroundColor DarkCyan
    }
    Write-Host ("時間推進到：第 {0} 日 / {1}" -f $GameState.location.day_count, $GameState.location.time_of_day) -ForegroundColor DarkGray
}

function Start-Loop {
    param(
        [hashtable]$GameState,
        [object]$RegionPack
    )

    Show-Opening -GameState $GameState -RegionPack $RegionPack
    Show-Help

    while ($true) {
        $inputLine = (Read-GameInput "`n你要做什麼").Trim()
        if ([string]::IsNullOrWhiteSpace($inputLine)) {
            continue
        }

        $parts = $inputLine -split '\s+', 2
        $command = $parts[0].ToLowerInvariant()
        $argument = ''
        if ($parts.Count -gt 1) {
            $argument = $parts[1].Trim().ToLowerInvariant()
        }

        switch ($command) {
            'look' { Show-Look -GameState $GameState -RegionPack $RegionPack }
            'status' { Show-Status -GameState $GameState -RegionPack $RegionPack }
            'quest' { Show-Quest -GameState $GameState -RegionPack $RegionPack }
            'board' { Show-QuestBoard -GameState $GameState -RegionPack $RegionPack }
            'jobs' { Show-OddJobs -GameState $GameState }
            'actions' { Show-Actions -GameState $GameState -RegionPack $RegionPack }
            'take' { Accept-Quest -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'work' { Work-OddJob -GameState $GameState -Selection $argument }
            'do' { Resolve-QuestAction -GameState $GameState -RegionPack $RegionPack -ActionToken $argument }
            'advance' { Resolve-QuestAction -GameState $GameState -RegionPack $RegionPack -AdvanceCurrent }
            'turnin' { Complete-QuestTurnIn -GameState $GameState -RegionPack $RegionPack }
            'npcs' { Show-Npcs -GameState $GameState -RegionPack $RegionPack }
            'relations' { Show-Relations -GameState $GameState -RegionPack $RegionPack }
            'talk' { Talk-ToNpc -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'recruit' { Recruit-Companion -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'party' { Show-PartyRoster -GameState $GameState -RegionPack $RegionPack }
            'focus' { Set-CompanionFocus -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'companion' { Show-ActiveCompanionProfile -GameState $GameState -RegionPack $RegionPack }
            'dismiss' { Dismiss-Companion -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'supplies' { Show-Supplies -GameState $GameState -RegionPack $RegionPack }
            'give' { Give-CompanionSupply -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'takeback' { TakeBack-CompanionSupply -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'gear' { Show-CompanionGear -GameState $GameState -RegionPack $RegionPack }
            'equipcompanion' { Equip-CompanionItem -GameState $GameState -RegionPack $RegionPack -Arguments $argument }
            'unequipcompanion' { Unequip-CompanionItem -GameState $GameState -RegionPack $RegionPack -Slot $argument }
            'services' { Show-Services -GameState $GameState -RegionPack $RegionPack }
            'buy' { Buy-ServiceItem -GameState $GameState -Selection $argument }
            'circuits' { Show-Circuits -RegionPack $RegionPack }
            'rest' { Rest-AtScene -GameState $GameState -RegionPack $RegionPack }
            'move' { Move-Location -GameState $GameState -RegionPack $RegionPack }
            'encounter' { Trigger-Encounter -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'respond' { Resolve-Encounter -GameState $GameState -RegionPack $RegionPack -Selection $argument }
            'save' { Save-GameState -GameState $GameState }
            'help' { Show-Help }
            'exit' {
                $saveBeforeExit = Read-GameInput '離開前要先存檔嗎？(y/n)'
                if ($saveBeforeExit.Trim().ToLowerInvariant() -eq 'y') {
                    Save-GameState -GameState $GameState
                }
                Write-Host '已離開幽語海原型。' -ForegroundColor Cyan
                break
            }
            default {
                Write-Host '目前原型只支援 help 顯示的指令。' -ForegroundColor Yellow
            }
        }

        if ($command -eq 'exit') {
            break
        }
    }
}

function Main {
    Show-Title
    $regionPack = Load-RegionPack
    $Script:RegionPack = $regionPack

    if (-not [string]::IsNullOrWhiteSpace($Script:AutoLoadSave)) {
        $gameState = Load-GameState -RegionPack $regionPack
        if ($null -ne $gameState) {
            Start-Loop -GameState $gameState -RegionPack $regionPack
        }
        return
    }

    if ([bool]$Script:AutoNewGame) {
        $gameState = New-GameState -RegionPack $regionPack
        if ($null -ne $gameState) {
            Start-Loop -GameState $gameState -RegionPack $regionPack
        }
        return
    }

    while ($true) {
        Show-Menu
        $choice = Read-Choice -Prompt '請選擇功能編號' -Min 1 -Max 3
        switch ($choice) {
            1 {
                $gameState = New-GameState -RegionPack $regionPack
                Start-Loop -GameState $gameState -RegionPack $regionPack
                if ($Script:ScriptedMode -and $Script:InputQueue.Count -eq 0) {
                    return
                }
            }
            2 {
                $gameState = Load-GameState -RegionPack $regionPack
                if ($null -ne $gameState) {
                    Start-Loop -GameState $gameState -RegionPack $regionPack
                    if ($Script:ScriptedMode -and $Script:InputQueue.Count -eq 0) {
                        return
                    }
                }
            }
            3 {
                Write-Host '結束原型。' -ForegroundColor Cyan
                return
            }
        }
    }
}

Main


