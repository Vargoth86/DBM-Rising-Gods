if GetLocale() ~= "zhTW" then return end
if not DBM_CORE_L then DBM_CORE_L = {} end

local L = DBM_CORE_L

L.HOW_TO_USE_MOD				= "歡迎使用"..L.DBM.."。在聊天頻道輸入 /dbm 打開設定開始設定。你可以載入特定區域後為任何首領設定你喜歡的特別設置。DBM會在設定你的職業天賦的預設值，但有些選項可能需要調整。"
L.SILENT_REMINDER				= "提醒："..L.DBM.."正處於無聲模式。"

L.LOAD_MOD_ERROR				= "載入%s模組時發生錯誤：%s"
L.LOAD_MOD_SUCCESS				= "成功載入%s模組。更多選項例如自訂警告音效或是個人提醒註記請輸入/dbm或/dbm help。"
L.LOAD_MOD_COMBAT				= "延遲載入'%s'直到離開戰鬥"
L.LOAD_GUI_ERROR				= "無法載入圖形介面：%s"
L.LOAD_GUI_COMBAT				= "圖形介面不能在戰鬥中初始化。圖形介面將在脫離戰鬥後自動讀取，這樣就能夠再次在戰鬥中使用。"
L.BAD_LOAD						= L.DBM.."偵測到你的此副本的模組在戰鬥中讀取失敗。一旦脫離戰鬥，請立即輸入/consoel reloadui重新載入。"
L.LOAD_MOD_VER_MISMATCH			= "%s不能被讀取因為你的DBM核心未達需求，請更新版本。"
L.LOAD_MOD_EXP_MISMATCH			= "%s不能被讀取因為這是設計給WoW資料片而目前尚未開放。當資料片開放時，此模組會自動啟用。"
L.LOAD_MOD_TOC_MISMATCH			= "%s不能被讀取因為這是設計給WoW更新檔(%s)而目前尚未開放。當更新檔更新時，此模組會自動啟用。"
L.LOAD_MOD_DISABLED				= "%s已安裝但目前停用中。此模組不會載入除非你啟用它。"
L.LOAD_MOD_DISABLED_PLURAL		= "%s已安裝但目前停用中。這些模組不會載入除非你啟用它們。"

L.COPY_URL_DIALOG				= "複製網址"

--Post Patch 7.1
L.NO_RANGE						= "距離雷達不能在副本中使用，使用傳統文字距離框架取代"
L.NO_ARROW						= "箭頭不能在副本中使用"
L.NO_HUD						= "HUDMap不能在副本中使用"

L.DYNAMIC_DIFFICULTY_CLUMP		= L.DBM.."已中禁用動態距離框架，你目前的團隊人數在這場戰鬥中的機制資訊不足。"
L.DYNAMIC_ADD_COUNT				= L.DBM.."已中禁用小怪計數警告，你目前的團隊人數在這場戰鬥中的機制資訊不足。"
L.DYNAMIC_MULTIPLE				= L.DBM.."已中禁用多項功能，你目前的團隊人數在這場戰鬥中的機制資訊不足。"

L.LOOT_SPEC_REMINDER			= "你目前的專精為:%s。而你目前的拾取選擇為:%s。"

L.BIGWIGS_ICON_CONFLICT			= L.DBM.."偵測到你同時開啟BigWigs和DBM的團隊圖示。請關閉其中之一的團隊圖示功能以免產生衝突。"

L.MOD_AVAILABLE					= "%s在此區域有模組可用。你可以在Curse或WoWI下載。"

L.COMBAT_STARTED				= "%s開戰。祝好運與盡興! :)"
L.COMBAT_STARTED_IN_PROGRESS	= "與%s開戰已進行的戰鬥。祝好運與盡興! :)"
L.GUILD_COMBAT_STARTED			= "公會已跟%s開戰"
L.SCENARIO_STARTED				= "%s開始。祝好運與盡興! :)"
L.SCENARIO_STARTED_IN_PROGRESS	= "加入進行中的%s事件。祝好運與盡興! :)"
L.BOSS_DOWN						= "擊敗%s，用了%s!"
L.BOSS_DOWN_I					= "擊敗%s!你已勝利了%d次。"
L.BOSS_DOWN_L					= "擊敗%s!本次用了%s，上次用了%s，最快紀錄為%s。你總共戰勝了%d次。"
L.BOSS_DOWN_NR					= "擊敗%s!用了%s! 這是一個新記錄! (舊紀錄為%s) 你總共戰勝了%d次。"
L.RAID_DOWN						= "%s清除 用了%s！"
L.RAID_DOWN_L					= "%s清除 用時%s！你最快的清除紀錄 %s。"
L.RAID_DOWN_NR					= "%s清除 用時%s！這是一個新紀錄！(舊紀錄為 %s)。"
L.GUILD_BOSS_DOWN				= "公會已擊敗%s，用了%s!"
L.SCENARIO_COMPLETE				= "%s完成!用了%s!"
L.SCENARIO_COMPLETE_I			= "%s完成! 你總共完成了%d次。"
L.SCENARIO_COMPLETE_L			= "%s完成!本次用了%s，上次用了%s，最快紀錄為%s。你總共完成了%d次。"
L.SCENARIO_COMPLETE_NR			= "%s完成!用了%s! 這是一個新記錄! (舊紀錄為%s) 你總共完成了%d次。"
L.COMBAT_ENDED_AT				= "%s(%s)的戰鬥經過%s結束。"
L.COMBAT_ENDED_AT_LONG			= "%s(%s)的戰鬥經過%s結束。你在這個難度總共滅團了%d次。"
L.GUILD_COMBAT_ENDED_AT			= "公會在%s (%s)的戰鬥滅團，經過%s."
L.SCENARIO_ENDED_AT				= "%s結束!用了%s!"
L.SCENARIO_ENDED_AT_LONG		= "%s結束!本次用了%s，你已有共%d次未完成的嘗試在這個難度裡。"
L.COMBAT_STATE_RECOVERED		= "%s的戰鬥在%s前開始，恢復計時器中..."
L.TRANSCRIPTOR_LOG_START		= "Transcriptor開始記錄。"
L.TRANSCRIPTOR_LOG_END			= "Transcriptor結束紀錄。"

L.MOVIE_SKIPPED					= L.DBM.."已嘗試自動略過一個過場動畫。"
L.BONUS_SKIPPED					= L.DBM.."已經自動關閉額外戰利品擲骰框架。如果你需要恢復此框架，在三分鐘內輸入/dbmbonusroll"

L.AFK_WARNING					= "你正在暫離並戰鬥中(血量還剩餘%d百分比)所以發出警告。如果你並非暫離，請清除暫離的標籤或是在'額外功能'停用此選項。"

L.COMBAT_STARTED_AI_TIMER		= "我的CPU是一個神經網路處理器;一個學習中的電腦 (這場戰鬥將使用新的計時器AI功能生成近似值的計時條)"

L.PROFILE_NOT_FOUND				= "<"..L.DBM..">你目前的配置檔已經損毀。"..L.DBM.."會載入'Default'配置檔。"
L.PROFILE_CREATED				= "配置檔'%s'已建立。"
L.PROFILE_CREATE_ERROR			= "建立配置檔失敗，無效的配置檔名稱。"
L.PROFILE_CREATE_ERROR_D		= "建立配置檔失敗，配置檔'%s'已存在。"
L.PROFILE_APPLIED				= "配置檔'%s'已套用。"
L.PROFILE_APPLY_ERROR			= "套用配置檔失敗，配置檔'%s'不存在。"
L.PROFILE_COPIED				= "配置檔'%s'已複製。"
L.PROFILE_COPY_ERROR			= "複製配置檔失敗，配置檔'%s'不存在。"
L.PROFILE_COPY_ERROR_SELF		= "不能複製配置檔到本身來源。"
L.PROFILE_DELETED				= "配置檔'%s'已刪除。配置檔'Default'會被套用。"
L.PROFILE_DELETE_ERROR			= "刪除配置檔失敗，配置檔'%s'不存在。"
L.PROFILE_CANNOT_DELETE			= "不能刪除'Default'配置檔。"
L.MPROFILE_COPY_SUCCESS			= "%s's (%d專精)模組設定已被複製。"
L.MPROFILE_COPY_SELF_ERROR		= "不能複製角色設定到本身來源"
L.MPROFILE_COPY_S_ERROR			= "配置檔來源已經損毀，設定不能被複製或是部分複製，複製已失敗。"
L.MPROFILE_COPYS_SUCCESS		= "%s's (%d專精)模組音效或註記設定已被複製。"
L.MPROFILE_COPYS_SELF_ERROR		= "不能複製角色音效或註記設定到本身來源"
L.MPROFILE_COPYS_S_ERROR		= "配置檔來源已經損毀，音效或註記設定不能被複製或是部分複製，複製已失敗。"
L.MPROFILE_DELETE_SUCCESS		= "%s's (%d專精)模組設定已被刪除。"
L.MPROFILE_DELETE_SELF_ERROR	= "不能刪除使用中的模組設定。"
L.MPROFILE_DELETE_S_ERROR		= "配置檔來源已經損毀，設定不能被刪除或是部分刪除，刪除已失敗。"

L.NOTE_SHARE_SUCCESS			= "%s已分享他的%s的註記"
L.NOTE_SHARE_LINK				= "點擊這裡打開註記"
L.NOTE_SHARE_FAIL				= "%s嘗試與你分享%s的註記。模組相關的技能沒有安裝或是載入。請確定你載入此模組並請求他們在分享一次。"

L.NOTEHEADER					= "為%s輸入你的註記。在><插入腳色名稱可套用職業顏色。多個註記請使用'/'分開"
L.NOTEFOOTER					= "按下'確定'接受變更或'取消'放棄變更"
L.NOTESHAREDHEADER				= "%s已分享%s的註記。接受註記會覆蓋你原有的註記。"
L.NOTESHARED					= "你的註記已經送出至隊伍"
L.NOTESHAREERRORSOLO			= "寂寞嗎?不應該能分享注意給你自己"
L.NOTESHAREERRORBLANK			= "不能分享空白註記"
L.NOTESHAREERRORGROUPFINDER		= "註記不能被分享在戰場、隨機團隊或隨機隊伍"
L.NOTESHAREERRORALREADYOPEN		= "不能開啟分享註記連結當註記編輯器已經被打開，避免你失去正在編輯的註記"

L.ALLMOD_DEFAULT_LOADED			= "此副本所有的選項設定已套用預設值。"
L.ALLMOD_STATS_RESETED			= "所有模組狀態已經被重置。"
L.MOD_DEFAULT_LOADED			= "此戰鬥的預設選項已套用。"
L.SOUNDKIT_MIGRATION			= "您的一個或多個警告/特別警告音效被重置為預設設置，因為不相容的媒體類型或無效的聲音路徑。DBM現在僅支援播放在您的addons資料夾之內的聲音文件，或者媒體的SoundKit編號。"

L.WORLDBOSS_ENGAGED				= "在你的伺服器上的%s已在百分之%s時開戰(%s發送)。"
L.WORLDBOSS_DEFEATED			= "在你的伺服器上的%s已被擊敗(%s發送)。"

L.TIMER_FORMAT_SECS				= "%.2f秒"
L.TIMER_FORMAT_MINS				= "%d分鐘"
L.TIMER_FORMAT					= "%d分%.2f秒"

L.MIN							= "分"
L.MIN_FMT						= "%d分"
L.SEC							= "秒"
L.SEC_FMT						= "%s秒"

L.GENERIC_WARNING_OTHERS		= "與一個其他"
L.GENERIC_WARNING_OTHERS2		= "與其他%d"
L.GENERIC_WARNING_BERSERK		= "%s%s後狂暴"
L.GENERIC_TIMER_BERSERK			= "狂暴"
L.OPTION_TIMER_BERSERK			= "為$spell:26662顯示計時器"
L.GENERIC_TIMER_COMBAT			= "戰鬥開始"
L.OPTION_TIMER_COMBAT			= "為戰鬥開始顯示計時器"
L.BAD							= "地板技能"
L.OPTION_HEALTH_FRAME			= "顯示首領血量框架"

L.OPTION_CATEGORY_TIMERS			= "計時條"
--Sub cats for "announce" object
L.OPTION_CATEGORY_WARNINGS			= "一般提示"
L.OPTION_CATEGORY_WARNINGS_YOU		= "個人提示"
L.OPTION_CATEGORY_WARNINGS_OTHER	= "目標提示"
L.OPTION_CATEGORY_WARNINGS_ROLE		= "角色專精提示"

L.OPTION_CATEGORY_SOUNDS			= "音效"
--Misc object broken down into sub cats
L.OPTION_CATEGORY_DROPDOWNS			= "下拉選項"
L.OPTION_CATEGORY_YELLS				= "大喊"
L.OPTION_CATEGORY_NAMEPLATES		= "名條"
L.OPTION_CATEGORY_ICONS				= "圖示"

L.AUTO_RESPONDED						= "已自動回覆密語。"
L.STATUS_WHISPER						= "%s：%s，%d/%d存活。"
--Bosses
L.AUTO_RESPOND_WHISPER				= "%s正在與%s交戰（當前%s，%d/%d存活）"
L.WHISPER_COMBAT_END_KILL			= "%s已經擊敗%s!"
L.WHISPER_COMBAT_END_KILL_STATS		= "%s已經擊敗%s! 他們總共已擊殺了%d次。"
L.WHISPER_COMBAT_END_WIPE_AT		= "%s在%s還有%s時滅團了。"
L.WHISPER_COMBAT_END_WIPE_STATS_AT	= "%s在%s還有%s時滅團了。他們在這個難度總共滅團了%d次。"
--Scenarios (no percents. words like "fighting" or "wipe" changed to better fit scenarios)
L.AUTO_RESPOND_WHISPER_SCENARIO		= "%s忙碌於%s(%d/%d存活)"
L.WHISPER_SCENARIO_END_KILL			= "%s已經完成%s!"
L.WHISPER_SCENARIO_END_KILL_STATS	= "%s已經完成%s!他們總共有%d次勝利。"
L.WHISPER_SCENARIO_END_WIPE			= "%s未完成%s。"
L.WHISPER_SCENARIO_END_WIPE_STATS	= "%s未完成%s。他們在這個難度總共未完成%d次。"

L.VERSIONCHECK_HEADER			= "Boss Mods - 版本檢測"
L.VERSIONCHECK_ENTRY			= "%s: %s (%s) %s"--One Boss mod
L.VERSIONCHECK_ENTRY_TWO		= "%s: %s (%s) & %s (%s)"--Two Boss mods
L.VERSIONCHECK_ENTRY_NO_DBM		= "%s：尚未安裝任何團隊首領模組"
L.VERSIONCHECK_FOOTER			= "找到有%d玩家正在使用DBM"
L.VERSIONCHECK_OUTDATED			= "下列有%d玩家正在使用過期的首領模組:%s"
L.YOUR_VERSION_OUTDATED			= "你的 Deadly Boss Mod 已經過期。" .. L.UPDATEREMINDER_URL
L.VOICE_PACK_OUTDATED			= "你的DBM語音包可能缺少在這個版本的DBM需要的語音。部分警告音效已經被停用。請下載新版本的語音包或是聯絡語音包作者更新並加入缺少的語音。"
L.VOICE_MISSING					= "DBM找不到你所選取的語音包。請確定你的語音包已正確的安裝與啟用。"
L.VOICE_DISABLED				= "你的語音包已安裝但是尚未啟用。如果你想使用語音包，請確定語言包已在語音警告中被選取，或是刪除不使用的語音包去隱藏此訊息。"
L.VOICE_COUNT_MISSING			= "所選取的語音/倒數語音包%d找不到倒數語音。設定已被重置回預設值：%s。"
L.BIG_WIGS						= "BigWigs"

L.UPDATEREMINDER_HEADER				= "你的Deadly Boss Mod已經過期。\n版本 %s (r%d) 可在此处下载："
L.UPDATEREMINDER_FOOTER				= "按下" .. (IsMacClient() and "Cmd-C" or "Ctrl-C")  ..  "：複製下載網址到剪貼簿。"
L.UPDATEREMINDER_FOOTER_GENERIC		= "按下" .. (IsMacClient() and "Cmd-C" or "Ctrl-C")  ..  "：複製網址到剪貼簿。"
L.UPDATEREMINDER_DISABLE			= "警告:  你的DBM版本已大幅度的過期，DBM已被強制關閉並且無法使用直到更新為止。這是為了確保舊而不相容的程式碼不會對你而團隊夥伴造成低落的遊戲體驗。"
L.UPDATEREMINDER_HOTFIX				= "你的DBM版本會在這首領戰鬥有不準確的計時器或警告。這問題已被修正在新版正式版(或是更新到最新的測試版。)"
L.UPDATEREMINDER_HOTFIX_ALPHA		= "您的DBM版本在此首領戰有些已知問題，將會在未來的正式版修正 (或是最新的測試版)"
L.UPDATEREMINDER_MAJORPATCH			= "警告: 你的DBM已經過期，DBM已被禁用直到你更新至最新版，因為遊戲大改版。為了不讓舊的程式碼拖累遊戲體驗。請至curse、WoWI或是GitHub發佈頁下載最新版本的DBM。"
L.VEM								= "警告: 你同時使用DBM和VEM。DBM將停用而無法執行。"
L.OUTDATEDPROFILES					= "警告: DBM-Profiles不相容此版本DBM。請移除避免衝突。"
L.OUTDATEDSPELLTIMERS				= "警告：DBM-SpellTimers破壞了" .. L.DBM .. ".必須要移除" .. L.DBM .. "才能正常運作。"
L.OUTDATEDRLT						= "警告：DBM-RaidLeadTools破壞了" .. L.DBM .. ". DBM-RaidLeadTools已經不再支援並且必須移除" .. L.DBM .. "才能正常運作。"
L.VICTORYSOUND						= "警告：DBM-VictorySound不相容此版本DBM。請移除避免衝突。"
L.DPMCORE							= "警告: Deadly PvP 模組已經停止更新而且不相容此版本的DBM。請先移除以避免衝突。"
L.DBMLDB							= "警告: DBM-LDB已內建在DBM-核心。雖然它不會造成任何傷害，但建議從addons資料夾中刪除“DBM-LDB”"
L.DBMLOOTREMINDER					= "警告：已安裝第三方模組 DBM-LootReminder。 此附加插件不再與正式版WOW客戶端相容，並且將導致DBM中斷並且無法發送請求計時器。 建議卸載此插件。"
L.UPDATE_REQUIRES_RELAUNCH			= "警告: 如果你沒有重啟你的遊戲，這次DBM更新可能無法正確運作。這次更新包含了新的檔案或是.toc檔更新而不能使用ReloadUI載入。如果沒有將遊戲完全重啟可能會導致錯誤或功能不完整。"
L.OUT_OF_DATE_NAG					= "你的"..L.DEADLY_BOSS_MODS.."版本已經過期，新版本針對特定的首領戰鬥增加新的功能和錯誤的修復。建議您進行更新來改善您的游戲體驗。"
L.RETAIL_ONLY						= "警告: 此版本的DBM僅適用於最新正式版魔獸世界。反安裝此版本並為經典魔獸世界安裝正確的DBM版本。"

L.MOVABLE_BAR					= "拖動我!"

L.PIZZA_SYNC_INFO				= "|Hplayer:%1$s|h[%1$s]|h sent you a " .. L.DBM .. " timer: '%2$s'\n|HDBM:cancel:%2$s:nil|h|cff3588ff[Cancel this timer]|r|h  |HDBM:ignore:%2$s:%1$s|h|cff3588ff[Ignore timers from %1$s]|r|h"
--L.PIZZA_SYNC_INFO				= "|Hplayer:%1$s|h[%1$s]|h向你發送了一個倒數計時"
L.PIZZA_CONFIRM_IGNORE			= "是否要在該次遊戲連結中忽略來自%s的計時？"
L.PIZZA_ERROR_USAGE				= "命令：/dbm [broadcast] timer <時間（秒）> <文字>。<時間>必須大於等於3"

L.MINIMAP_TOOLTIP_FOOTER		= "按下Shift並拖曳即可移動"

L.RANGECHECK_HEADER				= "距離監視(%d碼)"
L.RANGECHECK_HEADERT			= "距離監視 (%d碼-%d人)"
L.RANGECHECK_RHEADER			= "反向距離監視 (%d碼)"
L.RANGECHECK_RHEADERT			= "反向距離監視 (%d碼-%d人)"
L.RANGECHECK_SETRANGE			= "設置距離"
L.RANGECHECK_SETTHRESHOLD		= "設置玩家數量門檻"
L.RANGECHECK_SOUNDS				= "音效"
L.RANGECHECK_SOUND_OPTION_1		= "當一位玩家在範圍內時播放音效"
L.RANGECHECK_SOUND_OPTION_2		= "當多於一位玩家在範圍內時播放音效"
L.RANGECHECK_SOUND_0			= "沒有音效"
L.RANGECHECK_SOUND_1			= "預設音效"
L.RANGECHECK_SOUND_2			= "蜂鳴聲"
L.RANGECHECK_SETRANGE_TO		= "%d 碼"
L.RANGECHECK_OPTION_FRAMES		= "框架"
L.RANGECHECK_OPTION_RADAR		= "顯示雷達框架"
L.RANGECHECK_OPTION_TEXT		= "顯示文字框"
L.RANGECHECK_OPTION_BOTH		= "兩者都顯示"
L.RANGERADAR_HEADER				= "測距雷達(%d碼)"
L.RANGERADAR_RHEADER			= "反距離:%d玩家:%d"
L.RANGERADAR_IN_RANGE_TEXT		= "%d在範圍內(%0.1f碼)"--Multi
L.RANGECHECK_IN_RANGE_TEXT		= "%d在範圍內"--Text based doesn't need (%dyd), especially since it's not very accurate to the specific yard anyways
L.RANGERADAR_IN_RANGE_TEXTONE	= "%s (%0.1f碼)"--One target

L.INFOFRAME_SHOW_SELF			= "總是顯示你的能量"
L.INFOFRAME_SETLINES			= "設定最大行數"
L.INFOFRAME_SETCOLS				= "設定最大行數"
L.INFOFRAME_LINESDEFAULT		= "由插件設定"
L.INFOFRAME_LINES_TO			= "%d 行"
L.INFOFRAME_COLS_TO				= "%d 行"
L.INFOFRAME_POWER				= "能量"
L.INFOFRAME_AGGRO				= "仇恨"
L.INFOFRAME_MAIN				= "主要："--Main power
L.INFOFRAME_ALT					= "次要："--Alternate Power

L.LFG_INVITE					= "地城準備確認"

L.SLASHCMD_HELP				= {
	"可用指令：",
	"-----------------",
	"/dbm unlock：顯示一個可移動的計時器（也可使用：move）。",
	"/range <數字> or /distance <數字>: 顯示距離框架。/rrange 或 /rdistance 顯示相反色。",
	"/hudar <數字>: 顯示基於距離查詢的HUD。",
	"/dbm timer: 開始一個自訂的DBM計時器，輸入'/dbm timer'獲得更多訊息。",
	"/dbm arrow: 顯示DBM箭頭，輸入'/dbm arrow help'獲得更多訊息。",
	"/dbm hud: 顯示DBM hud，輸入'/dbm hud'獲得更多訊息。",
	"/dbm help2: 顯示團隊管理指令",
}
L.SLASHCMD_HELP2				= {
	"可用指令：",
	"-----------------",
	"/dbm pull <秒數>: 開始備戰計時器<秒數>。向所有團隊成員發送一個DBM備戰計時器（需要權限）。",
	"/dbm break <分鐘>: 開始休息計時器<分鐘>。向所有團隊成員發送一個DBM休息計時器（需要權限）。",
	"/dbm version: 進行首領插件的版本檢測（也可使用：ver）。",
	"/dbm version2: 進行首領插件的版本檢測同時也密語提醒過期的使用者（也可使用：ver2）。",
	"/dbm lag: 進行團隊範圍內的網路延遲檢測。",
	"/dbm durability: 進行團隊範圍內的裝備耐久度檢測。"
}
L.TIMER_USAGE	= {
	"DBM計時器指令：",
	"-----------------",
	"/dbm timer <秒數> <文字>: 開始一個時間為<秒數>秒並以<文字>為名稱的計時器。",
	"/dbm ltimer <秒數> <文字>: 開始一個時間為<秒數>秒的計時器同時無限循環直到取消。",
	"(在任何計時器指令前加入'Broadcast'可以把指令分享給團隊，如果有團隊隊長或助理權限)",
	"/dbm timer endloop: 停止任何無限循環ltimer的計時器。",
}

L.ERROR_NO_PERMISSION		= "無權進行此操作。"
L.TIME_TOO_SHORT			= "備戰計時器必須超過3秒。 "

--Common Locals
L.RANDOM					= "隨機"
L.NEXT						= "下一次%s"
L.COOLDOWN					= "%s冷卻"
L.UNKNOWN					= "未知"
L.LEFT						= "左"
L.RIGHT						= "右"
L.BOTH						= "兩邊"
L.BEHIND					= "背後"
L.BACK						= "後"
L.SIDE						= "側邊"
L.TOP						= "上"
L.BOTTOM					= "下"
L.MIDDLE					= "中"
L.FRONT						= "前"
L.EAST						= "東"
L.WEST						= "西"
L.NORTH						= "北"
L.SOUTH						= "南"
L.INTERMISSION				= "中場時間"
L.ORB						= "球"
L.ORBS						= "球"
L.RING						= "環"
L.RINGS						= "環"
L.CHEST						= "獎勵箱"
L.NO_DEBUFF					= "沒有%s"
L.ALLY						= "隊友"
L.ALLIES					= "隊友"--Such as "Move to Ally"
L.ADD						= "小怪"
L.ADDS						= "小怪"
L.BIG_ADD					= "大怪"
L.BOSS						= "首領"
L.ROOM_EDGE					= "房間邊緣"
L.FAR_AWAY					= "遠離"
L.BREAK_LOS					= "卡視角"
L.RESTORE_LOS				= "恢復/保持視角"
L.SAFE						= "安全"
L.NOTSAFE					= "不安全"
L.SHIELD					= "護盾"
L.PILLAR					= "柱子"
L.INCOMING					= "%s 來了"
L.BOSSTOGETHER				= "首領靠近"
L.BOSSAPART					= "首領分開"
--Common Locals end

--Retail Globals
L.RAID_INFO_WORLD_BOSS 			= "世界首領"
--Retail Globals end

L.BREAK_USAGE					= "休息時間不可以長過60分鐘。請確定您輸入的時間是分鐘而不是秒。"
L.BREAK_START					= "現在開始休息-你有%s分鐘! (由 %s 發送)"
L.BREAK_MIN						= "%s分鐘後休息時間結束!"
L.BREAK_SEC						= "%s秒後休息時間結束!"
L.TIMER_BREAK					= "休息時間!"
L.ANNOUNCE_BREAK_OVER			= "休息結束於%s"

L.TIMER_PULL					= "戰鬥準備"
L.ANNOUNCE_PULL					= "%d秒後拉怪 (%s發起)"
L.ANNOUNCE_PULL_NOW				= "拉怪囉!"
L.ANNOUNCE_PULL_TARGET			= "%2$d秒後開打%1$s! (%3$s 發起)"
L.ANNOUNCE_PULL_NOW_TARGET		= "%s現在開打!"
L.GEAR_WARNING					= "警告：檢查裝備。你的所裝備的裝備等級低於包包中的裝備%d個等級。"
L.GEAR_WARNING_WEAPON			= "警告：檢查你是否裝備正確的武器。"
L.GEAR_FISHING_POLE				= "釣魚竿"

L.ACHIEVEMENT_TIMER_SPEED_KILL = "成就"

L.AUTO_ANNOUNCE_TEXTS.you					= "你中了%s"
L.AUTO_ANNOUNCE_TEXTS.target				= "%s:>%%s<"
L.AUTO_ANNOUNCE_TEXTS.targetsource			= ">%%s< 施放 %s 在 >%%s<"
L.AUTO_ANNOUNCE_TEXTS.targetcount			= "%s (%%s):>%%s<"
L.AUTO_ANNOUNCE_TEXTS.spell					= "%s"
L.AUTO_ANNOUNCE_TEXTS.ends 					= "%s結束"
L.AUTO_ANNOUNCE_TEXTS.endtarget				= "%s結束:>%%s<"
L.AUTO_ANNOUNCE_TEXTS.fades					= "%s消退"
L.AUTO_ANNOUNCE_TEXTS.adds					= "%s還剩下:%%d"
L.AUTO_ANNOUNCE_TEXTS.cast					= "施放%s:%.1f秒"
L.AUTO_ANNOUNCE_TEXTS.soon					= "%s即將到來"
L.AUTO_ANNOUNCE_TEXTS.sooncount				= "%s (%%s)即將到來"
L.AUTO_ANNOUNCE_TEXTS.countdown				= "%s還有%%ds"
L.AUTO_ANNOUNCE_TEXTS.prewarn				= "%s在%s"
L.AUTO_ANNOUNCE_TEXTS.bait					= "%s即將到來 - 快引誘"
L.AUTO_ANNOUNCE_TEXTS.stage					= "第%s階段"
L.AUTO_ANNOUNCE_TEXTS.prestage				= "第%s階段即將到來"
L.AUTO_ANNOUNCE_TEXTS.count					= "%s (%%s)"
L.AUTO_ANNOUNCE_TEXTS.stack					=">%%s<中了%s (%%d)"
L.AUTO_ANNOUNCE_TEXTS.moveto				= "%s - 移動到>%%s<"

local prewarnOption							= "預先警告：$spell:%s"
L.AUTO_ANNOUNCE_OPTIONS.you					= "警告：中了$spell:%s時"
L.AUTO_ANNOUNCE_OPTIONS.target				= "警告：$spell:%s的目標"
L.AUTO_ANNOUNCE_OPTIONS.targetNF			= "警告：$spell:%s的目標(忽略全局目標過濾)"
L.AUTO_ANNOUNCE_OPTIONS.targetsource		= "警告：$spell:%s的目標(包含來源)"
L.AUTO_ANNOUNCE_OPTIONS.targetcount			= "警告：$spell:%s的目標(包含計數)"
L.AUTO_ANNOUNCE_OPTIONS.spell				= "警告：$spell:%s"
L.AUTO_ANNOUNCE_OPTIONS.ends				= "警告：$spell:%s結束"
L.AUTO_ANNOUNCE_OPTIONS.endtarget			= "警告：$spell:%s結束"
L.AUTO_ANNOUNCE_OPTIONS.fades				= "警告：$spell:%s消退"
L.AUTO_ANNOUNCE_OPTIONS.adds				= "警告：$spell:%s剩餘數量"
L.AUTO_ANNOUNCE_OPTIONS.cast				= "警告：$spell:%s的施放"
L.AUTO_ANNOUNCE_OPTIONS.soon				= prewarnOption
L.AUTO_ANNOUNCE_OPTIONS.sooncount			= prewarnOption
L.AUTO_ANNOUNCE_OPTIONS.countdown			= "預先警告：$spell:%s的倒數計時訊息"
L.AUTO_ANNOUNCE_OPTIONS.prewarn				= prewarnOption
L.AUTO_ANNOUNCE_OPTIONS.bait				= "警告：$spell:%s去引誘的預先警告"
L.AUTO_ANNOUNCE_OPTIONS.stage				= "警告：第%s階段"
L.AUTO_ANNOUNCE_OPTIONS.phasechange			= "警告：階段轉換"
L.AUTO_ANNOUNCE_OPTIONS.stagechange			= "預先警告：第%s階段"
L.AUTO_ANNOUNCE_OPTIONS.count				= "警告：$spell:%s(包含計數)"
L.AUTO_ANNOUNCE_OPTIONS.stack				= "警告：$spell:%s疊加層數"
L.AUTO_ANNOUNCE_OPTIONS.moveto				= "警告：$spell:%s需要移動到某人或某個地方"

L.AUTO_SPEC_WARN_TEXTS.spell				= "%s!"
L.AUTO_SPEC_WARN_TEXTS.ends 				= "%s結束"
L.AUTO_SPEC_WARN_TEXTS.fades				= "%s消退"
L.AUTO_SPEC_WARN_TEXTS.soon					= "%s即將到來"
L.AUTO_SPEC_WARN_TEXTS.sooncount			= "%s (%%s)即將到來"
L.AUTO_SPEC_WARN_TEXTS.bait					= "%s即將到來 - 快引誘"
L.AUTO_SPEC_WARN_TEXTS.prewarn				= "%s在%s"
L.AUTO_SPEC_WARN_TEXTS.dispel				= ">%%s<中了%s - 現在驅散"
L.AUTO_SPEC_WARN_TEXTS.interrupt			= "%s - 快中斷>%%s< !"
L.AUTO_SPEC_WARN_TEXTS.interruptcount		= "%s - 快中斷>%%s< !(%%d)"
L.AUTO_SPEC_WARN_TEXTS.you					= "你中了%s"
L.AUTO_SPEC_WARN_TEXTS.youcount				= "你中了%s (%%s)"
L.AUTO_SPEC_WARN_TEXTS.youpos				= "你中了%s (位置：%%s)"
L.AUTO_SPEC_WARN_TEXTS.soakpos				= "%s - 快到%%s分傷"
L.AUTO_SPEC_WARN_TEXTS.target				= ">%%s<中了%s"
L.AUTO_SPEC_WARN_TEXTS.targetcount			= ">%%2$s<中了%s (%%1$s) "
L.AUTO_SPEC_WARN_TEXTS.defensive			= "%s - 使用防禦技能"
L.AUTO_SPEC_WARN_TEXTS.taunt				= ">%%s<中了%s - 快嘲諷"
L.AUTO_SPEC_WARN_TEXTS.close				= "你附近的>%%s<中了%s"
L.AUTO_SPEC_WARN_TEXTS.move					= "%s - 快移動"
L.AUTO_SPEC_WARN_TEXTS.keepmove				= "%s - 保持移動"
L.AUTO_SPEC_WARN_TEXTS.stopmove				= "%s - 停止移動"
L.AUTO_SPEC_WARN_TEXTS.dodge				= "%s - 閃避攻擊"
L.AUTO_SPEC_WARN_TEXTS.dodgecount			= "%s (%%s) - 閃避攻擊"
L.AUTO_SPEC_WARN_TEXTS.dodgeloc				= "%s - 閃避技能 %%s"
L.AUTO_SPEC_WARN_TEXTS.moveawaycount		= "%s (%%s) - 快離開其他人"
L.AUTO_SPEC_WARN_TEXTS.moveaway				= "%s - 快離開其他人"
L.AUTO_SPEC_WARN_TEXTS.moveto				= "%s - 快跑向>%%s<"
L.AUTO_SPEC_WARN_TEXTS.soak					= "%s - 踩圈分擔"
L.AUTO_SPEC_WARN_TEXTS.soakcount			= "%s - 踩圈分擔 %%s"
L.AUTO_SPEC_WARN_TEXTS.jump					= "%s - 快跳躍"
L.AUTO_SPEC_WARN_TEXTS.run					= "%s - 快跑開"
L.AUTO_SPEC_WARN_TEXTS.cast					= "%s - 停止施法"
L.AUTO_SPEC_WARN_TEXTS.lookaway				= "%s 點名 %%s - 快轉頭"
L.AUTO_SPEC_WARN_TEXTS.reflect				= ">%%s<中了%s - 停止攻擊"
L.AUTO_SPEC_WARN_TEXTS.count				= "%s!(%%s)"
L.AUTO_SPEC_WARN_TEXTS.stack				= "你中了%%d層%s"
L.AUTO_SPEC_WARN_TEXTS.switch				= "%s - 快更換目標!"
L.AUTO_SPEC_WARN_TEXTS.switchcount			= "%s - 快更換目標！(%%s)"
L.AUTO_SPEC_WARN_TEXTS.gtfo					= "%%s 傷害 - 快移動"
L.AUTO_SPEC_WARN_TEXTS.adds					= "小怪出現 - 快更換目標！"
L.AUTO_SPEC_WARN_TEXTS.addscustom			= "小怪來了 - %%s"
L.AUTO_SPEC_WARN_TEXTS.targetchange			= "更換目標 - 轉火 %%s"

L.AUTO_SPEC_WARN_OPTIONS.spell				= "特別警告：$spell:%s"
L.AUTO_SPEC_WARN_OPTIONS.ends				= "特別警告：$spell:%s結束"
L.AUTO_SPEC_WARN_OPTIONS.fades				= "特別警告：$spell:%s消退"
L.AUTO_SPEC_WARN_OPTIONS.soon				= "特別警告：$spell:%s即將到來"
L.AUTO_SPEC_WARN_OPTIONS.sooncount			= "特別警告：$spell:%s (包含計數)即將到來"
L.AUTO_SPEC_WARN_OPTIONS.bait				= "特別警告：$spell:%s(當誘餌)預先顯示"
L.AUTO_SPEC_WARN_OPTIONS.prewarn 			= "特別警告：$spell:%s在%d秒前預先顯示"
L.AUTO_SPEC_WARN_OPTIONS.dispel				= "特別警告：需要驅散或偷取$spell:%s"
L.AUTO_SPEC_WARN_OPTIONS.interrupt			= "特別警告：需要中斷$spell:%s"
L.AUTO_SPEC_WARN_OPTIONS.interruptcount		= "特別警告：需要中斷$spell:%s (包含計數)"
L.AUTO_SPEC_WARN_OPTIONS.you				= "特別警告：當你中了$spell:%s時"
L.AUTO_SPEC_WARN_OPTIONS.youcount			= "特別警告：當你中了$spell:%s時 (包含計數)"
L.AUTO_SPEC_WARN_OPTIONS.youpos				= "特別警告：當你中了$spell:%s時 (包含站位)"
L.AUTO_SPEC_WARN_OPTIONS.soakpos			= "特別警告：當需要為$spell:%s分傷時(包含站位)"
L.AUTO_SPEC_WARN_OPTIONS.target				= "特別警告：當他人中了$spell:%s時"
L.AUTO_SPEC_WARN_OPTIONS.targetcount 		= "特別警告：當他人中了$spell:%s時 (包含計數)"
L.AUTO_SPEC_WARN_OPTIONS.defensive 			= "特別警告：當需要使用$spell:%s技能來減傷時"
L.AUTO_SPEC_WARN_OPTIONS.taunt 				= "特別警告：當另外一個坦中了$spell:%s並需要你嘲諷時"
L.AUTO_SPEC_WARN_OPTIONS.close				= "特別警告：當你附近有人中了$spell:%s時"
L.AUTO_SPEC_WARN_OPTIONS.move				= "特別警告：當你中了$spell:%s時"
L.AUTO_SPEC_WARN_OPTIONS.keepmove 			= "特別警告：當你中了$spell:%s需要保持移動時"
L.AUTO_SPEC_WARN_OPTIONS.stopmove 			= "特別警告：當你中了$spell:%s需要停止移動時"
L.AUTO_SPEC_WARN_OPTIONS.dodge				= "特別警告：當你中了$spell:%s並需要躲開攻擊"
L.AUTO_SPEC_WARN_OPTIONS.dodgecount			= "特別警告：當你中了$spell:%s並需要躲開攻擊 (包含計數)"
L.AUTO_SPEC_WARN_OPTIONS.dodgeloc			= "特別警告：當你需要閃避$spell:%s技能時(包含站位)"
L.AUTO_SPEC_WARN_OPTIONS.moveaway			= "特別警告：當你中了$spell:%s並需要跑開人群時"
L.AUTO_SPEC_WARN_OPTIONS.moveawaycount		= "特別警告：當你中了$spell:%s並需要跑開人群時 (包含計數)"
L.AUTO_SPEC_WARN_OPTIONS.moveto				= "特別警告：當中了$spell:%s並需要你去靠近某人或某地點時"
L.AUTO_SPEC_WARN_OPTIONS.soak				= "特別警告：當需要你去踩圈分擔$spell:%s時"
L.AUTO_SPEC_WARN_OPTIONS.soakcount			= "特別警告：當需要你去踩圈分擔$spell:%s時 (包含計數)"
L.AUTO_SPEC_WARN_OPTIONS.jump				= "特別警告：當你中了$spell:%s需要跳起來時"
L.AUTO_SPEC_WARN_OPTIONS.run				= "特別警告：$spell:%s"
L.AUTO_SPEC_WARN_OPTIONS.cast				= "特別警告：$spell:%s的施放（停止施法）"
L.AUTO_SPEC_WARN_OPTIONS.lookaway			= "特別警告：當需要為$spell:%s轉頭時"
L.AUTO_SPEC_WARN_OPTIONS.reflect 			= "特別警告：$spell:%s需要停止攻擊"
L.AUTO_SPEC_WARN_OPTIONS.count 				= "特別警告：$spell:%s"
L.AUTO_SPEC_WARN_OPTIONS.stack				= "特別警告：當疊加了>=%d層$spell:%s時"
L.AUTO_SPEC_WARN_OPTIONS.switch 			= "特別警告：針對$spell:%s需要轉換目標"
L.AUTO_SPEC_WARN_OPTIONS.switchcount		= "特別警告：針對$spell:%s需要轉換目標 (包含計數)"
L.AUTO_SPEC_WARN_OPTIONS.gtfo 				= "特別警告：當地板出現危險的東西需要躲開時"
L.AUTO_SPEC_WARN_OPTIONS.adds				= "特別警告：當小怪出現需要更換目標時"
L.AUTO_SPEC_WARN_OPTIONS.addscustom			= "特別警告：即將到來的小怪"
L.AUTO_SPEC_WARN_OPTIONS.targetchange		= "特別警告：當需要更換主要目標時"

L.AUTO_TIMER_TEXTS.target					= "%s: %%s"
L.AUTO_TIMER_TEXTS.targetcount				= "%s: %%s (%%s)"
L.AUTO_TIMER_TEXTS.cast						= "%s"
L.AUTO_TIMER_TEXTS.castshort				= "%s "
L.AUTO_TIMER_TEXTS.castcount				= "%s (%%s)"
L.AUTO_TIMER_TEXTS.castcountshort			= "%s (%%s) "
L.AUTO_TIMER_TEXTS.castsource				= "%s: %%s"
L.AUTO_TIMER_TEXTS.castsourceshort			= "%s: %%s "
L.AUTO_TIMER_TEXTS.active					= "%s結束"
L.AUTO_TIMER_TEXTS.fades					= "%s消退"
L.AUTO_TIMER_TEXTS.ai						= "%s AI"
L.AUTO_TIMER_TEXTS.cd						= "%s冷卻"
L.AUTO_TIMER_TEXTS.cdshort					= "~%s"
L.AUTO_TIMER_TEXTS.cdcount					= "%s冷卻 (%%s)"
L.AUTO_TIMER_TEXTS.cdcountshort				= "~%s (%%s)"
L.AUTO_TIMER_TEXTS.cdsource					= "%s冷卻:>%%s<"
L.AUTO_TIMER_TEXTS.cdsourceshort			= "~%s: >%%s<"
L.AUTO_TIMER_TEXTS.cdspecial				= "特別技能冷卻"
L.AUTO_TIMER_TEXTS.cdspecialshort			= "~特別技能"
L.AUTO_TIMER_TEXTS.next 					= "下一次%s"
L.AUTO_TIMER_TEXTS.nextshort				= "%s"
L.AUTO_TIMER_TEXTS.nextcount 				= "下一次%s (%%s)"
L.AUTO_TIMER_TEXTS.nextcountshort			= "%s (%%s)"
L.AUTO_TIMER_TEXTS.nextsource				= "下一次%s: >%%s<"
L.AUTO_TIMER_TEXTS.nextsourceshort			= "%s: %%s"
L.AUTO_TIMER_TEXTS.nextspecial				= "下一次特別技能"
L.AUTO_TIMER_TEXTS.nextspecialshort			= "特別技能"
L.AUTO_TIMER_TEXTS.achievement				= "%s"
L.AUTO_TIMER_TEXTS.stage					= "下一個階段"
L.AUTO_TIMER_TEXTS.stageshort				= "階段"
L.AUTO_TIMER_TEXTS.adds						= "小怪到來"
L.AUTO_TIMER_TEXTS.addsshort				= "小怪"
L.AUTO_TIMER_TEXTS.addscustom  				= "小怪出現(%s%s)"
L.AUTO_TIMER_TEXTS.addscustomshort			= "小怪 (%%s)"
L.AUTO_TIMER_TEXTS.roleplay					= GUILD_INTEREST_RP

L.AUTO_TIMER_OPTIONS.target					= "計時條：$spell:%s減益效果持續時間 (%ds)"
L.AUTO_TIMER_OPTIONS.targetcount			= "計時條：$spell:%s減益效果持續時間(包含計數) (%ds)"
L.AUTO_TIMER_OPTIONS.cast					= "計時條：$spell:%s施法時間 (%ds)"
L.AUTO_TIMER_OPTIONS.castcount				= "計時條：$spell:%s施法時間(包含計數) (%ds)"
L.AUTO_TIMER_OPTIONS.castsource				= "計時條：$spell:%s施放(包含來源) (%ds)"
L.AUTO_TIMER_OPTIONS.active					= "計時條：$spell:%s效果持續時間 (%ds)"
L.AUTO_TIMER_OPTIONS.fades					= "計時條：$spell:%s何時從玩家身上消失 (%ds)"
L.AUTO_TIMER_OPTIONS.ai						= "計時條：$spell:%s冷卻的AI計時條 (%ds)"
L.AUTO_TIMER_OPTIONS.cd						= "計時條：$spell:%s冷卻時間 (%ds)"
L.AUTO_TIMER_OPTIONS.cdcount				= "計時條：$spell:%s冷卻時間 (%ds)"
L.AUTO_TIMER_OPTIONS.cdsource				= "計時條：$spell:%s冷卻時間以及來源 (%ds)"
L.AUTO_TIMER_OPTIONS.cdspecial				= "計時條：特殊技能冷卻 (%ds)"
L.AUTO_TIMER_OPTIONS.next					= "計時條：下一次$spell:%s (%ds)"
L.AUTO_TIMER_OPTIONS.nextcount				= "計時條：下一次$spell:%s (%ds)"
L.AUTO_TIMER_OPTIONS.nextsource				= "計時條：下一次$spell:%s以及來源 (%ds)"
L.AUTO_TIMER_OPTIONS.nextspecial			= "計時條：下一次特殊技能 (%ds)"
L.AUTO_TIMER_OPTIONS.achievement			= "計時條：成就%s (%ds)"
L.AUTO_TIMER_OPTIONS.stage					= "計時條：下一階段 (%ds)"
L.AUTO_TIMER_OPTIONS.adds					= "計時條：下一次小怪 (%ds)"
L.AUTO_TIMER_OPTIONS.addscustom				= "計時條：小怪出現 (%ds)"
L.AUTO_TIMER_OPTIONS.roleplay				= "計時條：劇情持續時間 (%ds)"

L.AUTO_ICONS_OPTION_TEXT					= "為$spell:%s的目標設置標記"
L.AUTO_ICONS_OPTION_TEXT2					= "為$spell:%s設置標記"
L.AUTO_ARROW_OPTION_TEXT					= "為跑向中了$spell:%s的目標顯示"..L.DBM.."箭頭"
L.AUTO_ARROW_OPTION_TEXT2					= "為離開中了$spell:%s的目標顯示"..L.DBM.."箭頭"
L.AUTO_ARROW_OPTION_TEXT3					= "為中了$spell:%s後移動到特定區域顯示"..L.DBM.."箭頭"
L.AUTO_YELL_OPTION_TEXT.shortyell			= "當你中了$spell:%s時大喊"
L.AUTO_YELL_OPTION_TEXT.yell				= "當你中了$spell:%s時大喊(玩家名字)"
L.AUTO_YELL_OPTION_TEXT.count				= "當你中了$spell:%s時大喊(次數)"
L.AUTO_YELL_OPTION_TEXT.fade				= "當$spell:%s正消退時大喊(倒數和技能名稱)"
L.AUTO_YELL_OPTION_TEXT.shortfade			= "當$spell:%s正消退時大喊(倒數)"
L.AUTO_YELL_OPTION_TEXT.iconfade			= "當$spell:%s正消退時大喊(倒數與圖示)"
L.AUTO_YELL_OPTION_TEXT.position			= "當你中了$spell:%s時大喊(包含位置與玩家名字)"
L.AUTO_YELL_OPTION_TEXT.shortposition		= "當你中了$spell:%s時大喊(包含位置)"
L.AUTO_YELL_OPTION_TEXT.combo				= "當你同時中了$spell:%s與其他法術時大喊(包含自訂文字)"
L.AUTO_YELL_OPTION_TEXT.repeatplayer		= "當你中了$spell:%s時重複大喊(玩家名字)"
L.AUTO_YELL_OPTION_TEXT.repeaticon			= "當你中了$spell:%s時重複大喊(圖示)"
L.AUTO_YELL_ANNOUNCE_TEXT.shortyell			= "%s"
L.AUTO_YELL_ANNOUNCE_TEXT.yell				= "" .. UnitName("player") .. "中了%s"
L.AUTO_YELL_ANNOUNCE_TEXT.count				= "" .. UnitName("player") .. "中了%s(%%d)"
L.AUTO_YELL_ANNOUNCE_TEXT.fade				= "%s %%d秒後消退!"
L.AUTO_YELL_ANNOUNCE_TEXT.shortfade			= "%%d"
L.AUTO_YELL_ANNOUNCE_TEXT.iconfade			= "{rt%%2$d}%%1$d"
L.AUTO_YELL_ANNOUNCE_TEXT.position 			= UnitName("player").." ({rt%%3$d})中了%1$s! (%%1$s - {rt%%2$d})"
L.AUTO_YELL_ANNOUNCE_TEXT.shortposition 	= "{rt%%1$d}%s %%2$d"--Icon, Spellname, number
L.AUTO_YELL_ANNOUNCE_TEXT.combo				= "%s與%%s"--Spell name (from option, plus spellname given in arg)
L.AUTO_YELL_ANNOUNCE_TEXT.repeatplayer		= UnitName("player")--Doesn't need translation, it's just player name spam
L.AUTO_YELL_ANNOUNCE_TEXT.repeaticon		= "{rt%%1$d}"

L.AUTO_YELL_CUSTOM_FADE					= "%s已消退"
L.AUTO_HUD_OPTION_TEXT					= "為$spell:%s顯示HudMap(不再作用)"
L.AUTO_HUD_OPTION_TEXT_MULTI			= "為不同的機制顯示HudMap(不再作用)"
L.AUTO_NAMEPLATE_OPTION_TEXT			= "為$spell:%s顯示姓名版光環"
L.AUTO_RANGE_OPTION_TEXT				= "為$spell:%2$s顯示距離框架(%1$s碼)"
L.AUTO_RANGE_OPTION_TEXT_SHORT			= "顯示距離框架(%s碼)"
L.AUTO_RRANGE_OPTION_TEXT				= "為$spell:%2$s顯示反色距離框架(%1$s碼)"--Reverse range frame (green when players in range, red when not)
L.AUTO_RRANGE_OPTION_TEXT_SHORT			= "顯示反色距離框架(%s碼)"
L.AUTO_INFO_FRAME_OPTION_TEXT			= "為$spell:%s顯示訊息框架"
L.AUTO_INFO_FRAME_OPTION_TEXT2			= "為戰鬥概覽顯示訊息框架"
L.AUTO_READY_CHECK_OPTION_TEXT			= "當首領開打時撥放準備檢查的音效(即使沒有選定目標)"
L.AUTO_SPEEDCLEAR_OPTION_TEXT			= "顯示 %s 的最快清除計時器"

--Sounds
L.AUTO_SOUND_OPTION_TEXT			= "在$spell:%d上播放聲音"
L.AUTO_SOUND_OPTION_TEXT5			= "$spell:%d 的 5 秒音頻倒計時"
L.AUTO_SOUND_OPTION_TEXT3			= "$spell:%d 的 3 秒音頻倒計時"
L.AUTO_SOUND_OPTION_TEXT_YOU		= "如果 $spell:%d 出現在你身上，播放聲音"
L.AUTO_SOUND_OPTION_TEXT_SOON		= "在 $spell:%d 上播放聲音"
L.AUTO_SOUND_OPTION_TEXT_CLOSE		= "在您附近的 $spell:%d 上播放聲音"

-- New special warnings
L.MOVE_WARNING_BAR			= "可移動提示"
L.MOVE_WARNING_MESSAGE		= "感謝您使用"..L.DEADLY_BOSS_MODS..""
L.MOVE_SPECIAL_WARNING_BAR	= "可拖動的特別警告"
L.MOVE_SPECIAL_WARNING_TEXT	= "特別警告"

L.HUD_INVALID_TYPE			= "無效的HUD類型定義"
L.HUD_INVALID_TARGET		= "無有效的HUD目標"
L.HUD_INVALID_SELF			= "不能將HUD目标設定成自己"
L.HUD_INVALID_ICON			= "不能設定對無團隊標記的目標"
L.HUD_SUCCESS				= "HUD成功使用你的參數運作。這會在%s後取消，或是使用'/dbm hud hide'指令取消。"
L.HUD_USAGE	= {
	"DBM-HudMap 用法:",
	"/dbm hud <類型> <目標> <持續時間>: 建立一個指向玩家的HUD",
	"有效類型: arrow, dot, red, blue, green, yellow, icon(需要團隊標記)",
	"有效目標: target, focus, <玩家名字>",
	"有效持續時間: 任何秒數。如果無輸入值則預設為20分鐘",
	"/dbm hud hide  停用玩家生成的HUD物件"
}

L.ARROW_MOVABLE					= "可移動箭頭"
L.ARROW_WAY_USAGE				= "/dway <x> <y>: 建立一個箭頭指向一個指定地點 (使用本地區域地圖座標)"
L.ARROW_WAY_SUCCESS				= "要隱藏箭頭，鍵入 '/dbm arrow hide' 或到達箭頭"
L.ARROW_ERROR_USAGE	= {
	"DBM-Arrow 用法:",
	"/dbm arrow <x> <y>: 建立一個箭頭在特定的位置(使用世界地圖座標)",
	"/dbm arrow map <x> <y>: 建立一個箭頭在特定的位置 (使用小地圖座標)",
	"/dbm arrow <玩家>: 建立並箭頭指向你的隊伍或團隊中特定的玩家",
	"/dbm arrow hide: 隱藏箭頭",
	"/dbm arrow move: 可移動箭頭"
}

L.SPEED_KILL_TIMER_TEXT		= "勝利紀錄"
L.SPEED_CLEAR_TIMER_TEXT	= "最佳紀錄"
L.COMBAT_RES_TIMER_TEXT		= "下一個戰復充能"
L.TIMER_RESPAWN				= "%s 重生"

L.LAG_CHECKING					= "檢測團隊成員的網路延遲中..."
L.LAG_HEADER					= ""..L.DEADLY_BOSS_MODS.." - 網路延遲結果"
L.LAG_ENTRY						= "%s:世界延遲[%d毫秒]/本地延遲[%d毫秒]"
L.LAG_FOOTER					= "無回應:%s"

L.DUR_CHECKING					= "檢測團隊裝備耐久度..."
L.DUR_HEADER					= ""..L.DEADLY_BOSS_MODS.." - 裝備耐久度結果"
L.DUR_ENTRY						= "%s:耐久度[%d百分比]/裝備損壞[%s]"
L.LAG_FOOTER					= "無回應:%s"

--LDB
L.LDB_TOOLTIP_HELP1				= "點擊開啟" .. L.DBM
L.SILENTMODE_IS                 = "無聲模式是 "
L.LDB_LOAD_MODS					= "載入首領模組"
L.LDB_ENABLE_BOSS_MOD			= "啟用首領模組"
