if GetLocale() ~= "ruRU" then return end
if not DBM_GUI_Translations then DBM_GUI_Translations = {} end

local L = DBM_GUI_Translations

L.MainFrame = "Deadly Boss Mods"

L.TranslationByPrefix		= "Retail backport by "
L.TranslationBy 			= "Barsoom, Bunny67, Zidras"
L.Website					= "Discord для обсуждения: |cFF73C2FBhttps://discord.gg/RH7ZE6e6rH|r"
L.WebsiteButton				= "GitHub"

L.OTabBosses				= "Боссы"
L.OTabOptions				= "Настройки"

L.TabCategory_Options	 	= "Общие параметры"
L.TabCategory_OTHER    		= "Другие боссы"

L.BossModLoaded 			= "%s - статистика"
L.BossModLoad_now 			= [[База данных для этих боссов не загружена.
Она будет загружена сразу после входа в подземелье.
Можно также нажать кнопку, чтобы загрузить вручную.]]

L.PosX						= 'Позиция X'
L.PosY						= 'Позиция Y'

L.MoveMe 					= 'Передвинь меня'
L.Button_OK 				= 'OK'
L.Button_Cancel 			= 'Отмена'
L.Button_LoadMod 			= 'Загрузить надстройку'
L.Mod_Enabled				= "Включить DBM"
L.Mod_EnableAnnounce		= "Объявлять рейду"
L.Mod_Reset					= "Сброс настроек"
L.Reset 					= "Сброс"

L.Enable  					= "вкл."
L.Disable					= "откл."

L.NoSound					= "Без звука"

L.IconsInUse				= "Используемые метки"

L.Large						= "Больше"
L.Small						= "Меньше"

-- Tab: Boss Statistics
L.BossStatistics			= "Статистика для босса"
L.Statistic_Kills			= "Убийства:"
L.Statistic_Wipes			= "Поражения:"
L.Statistic_BestKill		= "Лучший бой:"
L.Statistic_Heroic			= "Героическая сложность"
L.Statistic_10Man			= "10 игроков"
L.Statistic_25Man			= "25 игроков"

-- Tab: General Options
L.General 					= "Общие параметры DBM"
L.EnableMiniMapIcon			= "Отображать кнопку на мини-карте"
L.UseSoundChannel			= "Выбор аудио канала для предупреждений DBM"
L.UseMasterChannel			= "Основной аудио канал"
L.UseDialogChannel			= "Аудио канал диалогов"
L.UseSFXChannel				= "Аудио канал эффектов"
L.Latency_Text				= "Макс. задержка для синхр-ции: %d"

L.EnableStatus 				= "Отвечать на запрос статуса боя шепотом"
L.AutoRespond 				= "Включить авто-ответ в бою"
L.FixCLEUOnCombatStart		= "Очищать кэш журнала боя в начале/конце битвы и после смены зоны"

L.ModelOptions				= "Настройки 3D моделей на странице боссов"
L.EnableModels				= "Показывать 3D модели боссов"

L.Button_RangeFrame			= "Окно проверки дистанции"
L.Button_InfoFrame			= "Окно инфо-фрейма"
L.Button_TestBars			= "Запустить проверку"

L.PizzaTimer_Headline 		= 'Создать "Pizza Timer"'
L.PizzaTimer_Title			= 'Название (например, "Pizza!")'
L.PizzaTimer_Hours 			= "час."
L.PizzaTimer_Mins 			= "мин."
L.PizzaTimer_Secs 			= "сек."
L.PizzaTimer_ButtonStart 	= "Начать отсчет"
L.PizzaTimer_BroadCast		= "Транслировать рейду"

-- Tab: Raidwarning
L.Tab_RaidWarning 			= "Предупреждения для рейда"
L.RaidWarning_Header		= "Параметры рейд-предупреждений"
L.RaidWarnColors 			= "Цвета предупреждений для рейда"
L.RaidWarnColor_1 			= "Цвет 1"
L.RaidWarnColor_2 			= "Цвет 2"
L.RaidWarnColor_3		 	= "Цвет 3"
L.RaidWarnColor_4 			= "Цвет 4"
L.InfoRaidWarning			= [[Вы можете указать расположение и цвет предупреждений для рейда.
Используется для сообщений вроде "Игрок X под воздействием Y"]]
L.ColorResetted 			= "Цветовые параметры для этого поля восстановлены."
L.ShowWarningsInChat 		= "Показывать предупреждения в окне чата"
L.ShowFakedRaidWarnings 	= "Показывать предупреждения в качестве \"Объявление рейду\""
L.WarningIconLeft 			= "Отображать значок с левой стороны"
L.WarningIconRight 			= "Отображать значок с правой стороны"
L.WarningIconChat 			= "Отображать значки в окне чата"
L.WarningAlphabetical		= "Сортировать имена по алфавиту"
L.Warn_Duration				= "Длительность предупреждения: %0.1f сек"
L.None						= "Нет"
L.Random					= "Случайно"
L.Outline					= "Контур"
L.ThickOutline				= "Толстый контур"
L.MonochromeOutline			= "Монохромный контур"
L.MonochromeThickOutline	= "Монохромный толстый контур"
L.RaidWarnSound				= "Звук рейд-предупреждения"

-- Tab: Generalwarnings
L.Tab_GeneralMessages 		= "Общие сообщения"
L.CoreMessages				= "Параметры общих сообщений"
L.ShowPizzaMessage 			= "Показывать сообщения транслируемых таймеров в окне чата"
L.ShowAllVersions	 		= "Показывать версии DBM для всех членов группы в окне чата"
L.CombatMessages			= "Параметры сообщений в бою"
L.ShowEngageMessage 		= "Показывать сообщения о вступлении в бой в окне чата"
L.ShowDefeatMessage 		= "Показывать сообщения об убийстве босса в окне чата"
L.ShowGuildMessages 		= "Показывать сообщения о вступлении в бой/убийстве/вайпе рейда гильдии в окне чата"
L.ShowGuildMessagesPlus		= "Так же показывать сообщения о вступлении в бой/убийстве/вайпе для группы гильдии в M+ (требуется опция рейда)"
L.Area_WhisperMessages		= "Параметры приватных сообщений"
L.AutoRespond 				= "Включить авто-ответ в бою"
L.WhisperStats 				= "Добавлять статистику убийств/вайпов в авто-ответ"
L.DisableStatusWhisper 		= "Отключить ответы на запрос статуса боя шепотом для всей группы (требуется лидер группы)."
L.DisableGuildStatus 		= "Отключить отправку гильдии сообщений о прогрессе для всей группы (требуется лидер группы)."

-- Tab: Barsetup
L.BarSetup   				= "Настройки индикатора"
L.BarTexture 				= "Текстура индикатора"
L.BarStyle					= "Стиль индикатора"
L.BarDBM					= "DBM"
L.BarSimple					= "Простой (без анимации)"
L.BarStartColor				= "Цвет в начале"
L.BarEndColor 				= "Цвет в конце"
L.Bar_Height				= "Высота индикатора: %d"
L.Slider_BarOffSetX 		= "Сдвиг X: %d"
L.Slider_BarOffSetY 		= "Сдвиг Y: %d"
L.Slider_BarWidth 			= "Ширина: %d"
L.Slider_BarScale 			= "Масштаб: %0.2f"
--Types
L.BarStartColorAdd			= "Начальный цвет (Помощник)"
L.BarEndColorAdd			= "Конечный цвет (Помощник)"
L.BarStartColorAOE			= "Начальный цвет (АоЕ урон)"
L.BarEndColorAOE			= "Конечный цвет (АоЕ урон)"
L.BarStartColorDebuff		= "Начальный цвет (Цель)"
L.BarEndColorDebuff			= "Конечный цвет (Цель)"
L.BarStartColorInterrupt	= "Начальный цвет (Прерывание)"
L.BarEndColorInterrupt		= "Конечный цвет (Прерывание)"
L.BarStartColorRole			= "Начальный цвет (Роль)"
L.BarEndColorRole			= "Конечный цвет (Роль)"
L.BarStartColorPhase		= "Начальный цвет (Фаза)"
L.BarEndColorPhase			= "Конечный цвет (Фаза)"
L.BarStartColorUI			= "Начальный цвет (Польз.)"
L.BarEndColorUI				= "Конечный цвет (Польз.)"
--Type 7 options
L.Bar7Header				= "Параметры пользовательского индикатора"
L.Bar7ForceLarge			= "Всегда использовать большой индикатор"
L.Bar7CustomInline			= "Использовать пользовательскую '!' встроенную иконку"
L.Bar7Footer				= "(Таймер обновляется в прямом эфире)"
--Dropdown Options
L.CBTGeneric				= "Общий"
L.CBTAdd					= "Add"
L.CBTAOE					= "АОЕ"
L.CBTTargeted				= "Цель"
L.CBTInterrupt				= "Прерывание"
L.CBTRole					= "Роль"
L.CBTPhase					= "Фаза"
L.CBTImportant				= "Важно (Игрок)"
L.CVoiceOne					= "Count Voice 1"
L.CVoiceTwo					= "Count Voice 2"
L.CVoiceThree				= "Count Voice 3"

-- Tab: Timers
L.AreaTitle_BarColors		= "Цвета индикатора по типу таймера"
L.AreaTitle_BarSetup		= "Параметры основного индикатора"
L.AreaTitle_Behavior		= "Параметры поведения индикаторов"
L.AreaTitle_BarSetupSmall 	= "Параметры уменьшенного индикатора"
L.AreaTitle_BarSetupHuge	= "Параметры увеличенного индикатора"
L.EnableHugeBar 			= "Включить увеличенный индикатор (Полоса 2)"
L.BarIconLeft 				= "Значок слева"
L.BarIconRight 				= "Значок справа"
L.ExpandUpwards				= "Выровнять по верху"
L.FillUpBars				= "Наполняющая заливка"
L.ClickThrough				= "Отключить события мыши (щелчок сквозь)"
L.Bar_Decimal				= "Отображать десятые когда время меньше: %d"
L.Bar_Alpha					= "Прозрачность индикатора: %0.1f"
L.Bar_DBMOnly				= "Настройки ниже работают только со стилем индикатора \"DBM\"."
L.Bar_EnlargeTime			= "Увеличивать, когда время меньше: %d"
L.Bar_EnlargePercent		= "Увеличивать, когда процент меньше: %0.1f%%"
L.BarSpark					= "Искрение индикатора"
L.BarFlash					= "Мигание когда индикатор скоро исчезнет"
L.BarSort					= "Сортировать по ставшемуся времени"
L.BarColorByType			= "Цвет по типу"
L.NoBarFade					= "Use Start/End colors as Small/Large colors instead of gradual color change"
L.BarInlineIcons			= "Показывать встроенные иконки"
L.ShortTimerText			= "Использовать короткий текст таймера (когда доступен)"
L.StripTimerText            = "Обрезать CD / Следующий из таймеров"
L.KeepBar					= "Оставить таймер активным до применения способности"
L.KeepBar2					= "(когда поддерживается модулем)"
L.FadeBar					= "Таймеры исчезновения для способностей вне диапазона"

-- Tab: Spec Warn Frame
L.Panel_SpecWarnFrame		= "Специальные предупреждения"
L.Area_SpecWarn				= "Настройка специальных предупреждений"
L.SpecWarn_ClassColor		= "Использовать цвета классов для спец-предупреждений"
L.ShowSWarningsInChat 		= "Показывать спец-предупреждения в окне чата"
L.SWarnNameInNote			= "Использовать SW5 настройки если пользовательская заметка содержит ваше имя"
L.SpecialWarningIcon		= "Показывать иконки на специальных предупреждениях"
L.ShortTextSpellname        = "Использовать более короткое назв. заклинания (когда доступно)"
L.SpecWarn_FlashFrameRepeat	= "Повторять %d раз (если включено)"
L.SpecWarn_Flash			= "Моргающий экран"
L.SpecWarn_FlashRepeat		= "Повторять мигание"
L.SpecWarn_FlashColor		= "Цвет мигания"
L.SpecWarn_FlashDur			= "Длительности мигания: %0.1f"
L.SpecWarn_FlashAlpha		= "Прозрачность мигания: %0.1f"
L.SpecWarn_DemoButton		= "Показать пример"
L.SpecWarn_ResetMe			= "Восстановить умолчания"
L.SpecialWarnSoundOption    = "Установить звук по умолчанию"
L.SpecialWarnHeader1        = "Тип 1: Параметры для предупреждений о нормальном приоритете, влияющих на вас или ваши действия"
L.SpecialWarnHeader2        = "Тип 2: Параметры для предупреждений о нормальном приоритете, влияющих на всех"
L.SpecialWarnHeader3        = "Тип 3: Параметры для предупреждений о ВЫСОКОМ приоритете"
L.SpecialWarnHeader4        = "Тип 4: Параметры для ВЫСОКОГО приоритета, избегать специальных предупреждений"
L.SpecialWarnHeader5        = "Тип 5: Параметры для предупреждений с примечаниями, содержащими имя вашего игрока"

-- Tab: Spoken Alerts Frame
L.Panel_SpokenAlerts		= "Голосовые предупреждения"
L.Area_VoiceSelection		= "Выбор голоса"
L.CountdownVoice			= "Основной голос для звуков отсчета"
L.CountdownVoice2			= "Вторичный голос для звуков отсчета"
L.CountdownVoice3			= "Третичный голос для звуков отсчета"
L.VoicePackChoice			= "Голосовой пакет для предупреждений"
L.Area_CountdownOptions		= "Настройки обратного отсчета"
L.Area_VoicePackOptions		= "Настройки голосового пакета (голосовые пакеты третих лиц)"
L.SpecWarn_NoSoundsWVoice	= "Не проигрывать звуки спец-предупреждений для предупреждений, которые имеют голосовую настройку"
L.SWFNever					= "Никогда"
L.SWFDefaultOnly			= "когда спец-предупреждения используют звуки по умолчанию. (позволяет проигрывать пользовательские звуки)"--too long, doesn't fit into frame
L.SWFAll					= "когда спец-предупреждения используют любые звуки"
L.SpecWarn_AlwaysVoice		= "Всегда воспроизводить все голосовые предупреждения (даже если спец предупреждения отключены. Полезно для рейд лидера, иначе не рекомендуется.)"
--TODO, maybe add URLS right to GUI panel on where to acquire 3rd party voice packs?
L.Area_GetVEM				= "Получить голосовой пакет VEM"
L.VEMDownload				= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/dbm-voicepack-vem|r"
L.Area_BrowseOtherVP		= "Посмотреть другие голосовые пакеты на Curse"
L.BrowseOtherVPs			= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/search?search=dbm+voice|r"
L.Area_BrowseOtherCT		= "Посмотреть пакеты обратного отсчета на Curse"
L.BrowseOtherCTs			= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/search?search=dbm+count+pack|r"

-- Tab: Event Sounds
L.Panel_EventSounds			= "Звуки событий"
L.Area_SoundSelection		= "Выбор звука (прокрутите меню выбора колесом мыши)"
L.EventVictorySound			= "Установить звук при победе в бою"
L.EventWipeSound			= "Установить звук при поражении в бою"
L.EventEngageSound			= "Установить звук при вступлении в бой"
L.EventDungeonMusic			= "Установить музыку в подземельях/рейдах"
L.EventEngageMusic			= "Установить музыку во время боя"
L.Area_EventSoundsExtras	= "Настройки звуков событий"
L.EventMusicCombined		= "Разрешить все варианты выбора музыки для подземелий и боя (изменение этой настройки требует перезагрузки интерфейса, чтобы увидеть изменения)"

-- Tab: HealthFrame
L.Panel_HPFrame				= "Здоровье босса"
L.Area_HPFrame				= "Настройка здоровья босса"
L.HP_Enabled				= "Всегда отображать здоровье босса\n(имеет приоритет над аналогичныи параметром у каждого босса)"
L.HP_GrowUpwards			= "Выровнять индикатор здоровья по верху"
L.HP_ShowDemo				= "Индикатор здоровья"
L.BarWidth					= "Ширина индикатора: %d"

-- Tab: Global Filter
L.Panel_SpamFilter			= "Глобальные отключения и фильтры"
L.Area_SpamFilter_Outgoing	= "Настройки глобальных отключений и фильтров"
L.SpamBlockNoShowAnnounce	= "Не показывать текст или проигрывать звук для ЛЮБЫХ общих объявлений"
L.SpamBlockNoShowTgtAnnounce= "Не показывать текст или проигрывать звук для общих объявлений ЦЕЛИ (фильтр выше переопределяет этот)"
L.SpamBlockNoSpecWarn		= "Не показывать спец-предупреждения и не проигрывать звуки для них"
L.SpamBlockNoSpecWarnText	= "Не показывать текст спец-предупреждений, но разрешить голосовые пакеты (фильтр выше переопределяет этот)"
L.SpamBlockNoShowTimers		= "Не показывать таймеры (отсчет времени)"
L.SpamBlockNoShowUTimers	= "Не показывать таймеры, отправленные пользователями (пользов./пул/отдых)"
L.SpamBlockNoSetIcon		= "Не устанавливать метки на цели"
L.SpamBlockNoRangeFrame		= "Не показывать окно проверки дистанции"
L.SpamBlockNoInfoFrame		= "Не показывать информационное окно"
L.SpamBlockNoHudMap			= "Не показывать HudMap"
L.SpamBlockNoNameplate		= "Не показывать Nameplate Auras (отключает полностью)"
L.SpamBlockNoNameplateLines	= "Не показывать линии Nameplate Aura (иконки аур будут отображаться)"
L.SpamBlockNoCountdowns		= "Не воспроизводить звуки обратного отсчета"
L.SpamBlockNoYells			= "Не отправлять крики в чат"
L.SpamBlockNoNoteSync		= "Не принимать заметки"
L.SpamBlockNoReminders		= "Не показывать никаких сообшений при входе в игру, рекомендаций или об обновлениях (НЕ рекомендуется)"

L.Area_Restore				= "Параметры DBM для возврата настроек (восстанавливать ли предыдущее пользов. состояние по окончание работы модулей)"
L.SpamBlockNoIconRestore	= "Не сохранять состояние меток и восстанавливать их после боя"
L.SpamBlockNoRangeRestore	= "Не восстанавливать окно проверки дистанции в предыдущее состояние при скрытии модулями"


-- Tab: Spam Filter
L.Area_SpamFilter			= "Параметры спам-фильтра"
L.DontShowFarWarnings		= "Не отображать предупреждения/таймеры для событий, которые далеко"
L.FilterVoidFormSay			= "Не отправлять в чат позицию/отсчёт если находитесь в $spell:47241"

L.Area_SpecFilter			= "Параметры фильтра по роли"
L.FilterTankSpec			= "Фильтровать предупреждения для роли танка когда не в специализации танка. (Примечание: отключение этого не рекомендуется для большинства пользователей, так как предупреждения «насмешка» теперь все включены по умолчанию.)"
L.FilterInterruptsHeader	= "Фильтровать предупреждения для прерываемых спеллов на основе предпочтений поведения."
L.FilterInterrupts			= "если кастер не является вашей текущей целью/фокусом (Всегда)."
L.FilterInterrupts2			= "если кастер не является вашей текущей целью/фокусом (Всегда) или сбитие на кд (только босс)"
L.FilterInterrupts3			= "если кастер не является вашей текущей целью/фокусом (Всегда) или сбитие на кд (босс и трэш )"
L.FilterInterruptNoteName	= "Фильтровать предупреждения для прерываемых спеллов (со счетчиком) если предупреждение не содержит ваше имя в пользов. заметке"
L.FilterDispels				= "Фильтровать предупреждения для рассеиваемых спеллов если ваш диспел на кулдауне."
L.FilterTrashWarnings		= "Фильтровать предупреждения для трэша в обычных и героических подземельях"

L.Area_PullTimer			= "Параметры фильтра таймеров пулла/боя/пользов."
L.DontShowPTNoID			= "Блокировать таймер пулла, отправленный из другой зоны"
L.DontShowPT				= "Не отображать индикатор таймера пулла"
L.DontShowPTText			= "Не отображать текст объявления для таймера пулла"
L.DontShowPTCountdownText	= "Не отображать текст отсчета таймера пулла"
L.DontPlayPTCountdown		= "Не воспроизводить звук отсчета таймера пулла/боя/пользов."
L.PT_Threshold				= "Не отображать текст отсчета таймера пулла/боя/пользов. больше: %d"

L.Panel_HideBlizzard		= "Скрыть Blizzard"
L.Area_HideBlizzard			= "Настройки скрытия Blizzard"
L.HideBossEmoteFrame		= "Скрывать окно эмоций рейдового босса во время боя с боссом"
L.SpamBlockRaidWarning		= "Фильтрация предупреждений от других DBM"
L.SpamBlockBossWhispers		= "Фильтрация DBM предупреждений шепотом в бою"
L.HideWatchFrame			= "Скрывать окно отслеживания заданий во время боя с боссом"
L.HideGarrisonUpdates		= "Скрывать уведомления из гарнизона во время боя с боссом"
L.HideGuildChallengeUpdates	= "Скрывать уведомления о гильдейских испытаниях во время боя с боссами"
L.HideQuestTooltips			= "Скрывать цели заданий в подсказках во время боя с боссами"
L.HideTooltips				= "Скрывать подсказки во время боя с боссом"
L.DisableSFX				= "Отключить канал звуковых эффектов во время боя с боссами"
L.DisableCinematics			= "Отключить внутриигровые ролики"
L.ReportRecount		    	= "Отправлять отчёт Recount после окончания боя с боссом (треб. помощник)"
L.ReportSkada		    	= "Отправлять отчёт SkadaRevisited после окончания боя с боссом (треб. помощник)"
L.PerCharacterSettings    	= "Использовать отдельные профили для каждого персонажа вместо глобального"
L.OnlyFight					= "Только во время боя, после того как ролик был показан один раз"
L.AfterFirst				= "После одного просмотра"
L.Always					= "Всегда"
L.CombatOnly				= "Отключить в бою (любом)"
L.RaidCombat				= "Отключить в бою (только боссы)"

L.Panel_ExtraFeatures		= "Дополнительные возможности"
--
L.Area_ChatAlerts			= "Параметры оповещений в чате"
L.RoleSpecAlert				= "Показывать предупреждение когда ваша специализация добычи не совпадает с текущей специализацией при присоединении к рейду"
L.CheckGear					= "Показывать предупреждение когда уровень надетых предметов намного ниже чем максимальный (40+)"
L.WorldBossAlert			= "Показывать предупреждение когда в вашем игровом мире ваши друзья или согильдийцы возможно вступают в бой с боссами вне подземелья<br/>(неточно, если отправитель в межсерверной зоне)"
--
L.Area_SoundAlerts			= "Параметры звуковых оповещений"
L.LFDEnhance				= "Проигрывать звук проверки готовности для проверки ролей и приглашений на БГ/ЛФГ через основной аудио канал"
L.WorldBossNearAlert		= "Проигрывать звук проверки готовности когда неподалеку пулят нужных вам боссов вне подземелья (переопределяет настройку для конкретного босса)"
L.RLReadyCheckSound			= "Проигрывать звук проверки готовности при проверке готовности через основной аудио канал или канал диалогов"
L.AFKHealthWarning			= "Звуковое оповещение если вы теряете здоровье во время АФК"
L.AutoReplySound			= "Звуковое оповещение при получении авто-ответа шепотом от DBM"
--
L.TimerGeneral 				= "Параметры таймера"
L.SKT_Enabled				= "Всегда отображать таймер рекордной победы<br/>(переопределяет настройку для конкретного босса)"
L.ShowRespawn				= "Отсчет времени до появления босса после вайпа"
L.ShowQueuePop				= "Отсчет оставшегося времени до принятия очереди (поиск группы,БГ и т.д.)"
--
L.Area_AutoLogging			= "Параметры автоматической записи"
L.AutologBosses				= "Автоматически записывать бои с боссами используя журнал боя Blizzard (Требуется использовать /dbm pull перед боссами для совместимости с <a href=\"http://worldoflogs.com\">|cff3588ffworldoflogs.com|r</a>)"
L.AdvancedAutologBosses		= "Автоматически записывать бои с боссами используя Transcriptor"
L.RecordOnlyBosses			= "Только записывать боссов (исключая весь мусор. Используйте '/ dbm pull' перед боссами, чтобы захватить pre-поты)"
L.LogOnlyNonTrivial			= "Записывать только бои с рейдовыми боссами (искл. 5 ппл)"
--
L.Area_3rdParty				= "Параметры аддонов третих лиц"
L.ShowBBOnCombatStart		= "Выполнять проверку положительных эффектов Big Brother в начале боя"
L.BigBrotherAnnounceToRaid	= "Объявлять результаты проверки Big Brother в рейд"
L.Area_Invite				= "Параметры приглашений"
L.AutoAcceptFriendInvite	= "Автоматически принимать приглашения в группу от друзей"
L.AutoAcceptGuildInvite		= "Автоматически принимать приглашения в группу от согильдийцев"
L.Area_Advanced				= "Дополнительные настройки"
L.FakeBW					= "Притворяться BigWigs вместо DBM при приверке версий (Полезно для гильдий которые заставляют использовать BigWigs)"
L.AITimer					= "Автоматически генерируйте таймеры для никогда ранее не встречавшихся поединков, используя встроенный в DBM AI таймера (полезно для того, чтобы вытащить тестового босса в самый первый раз, например, бета или PTR). Примечание: это не будет работать должным образом для нескольких добавлений с одинаковыми способностями."

L.Panel_Profile				= "Профили"
L.Area_CreateProfile		= "Создание профиля настроек DBM Core"
L.EnterProfileName			= "Введите имя профиля"
L.CreateProfile				= "Создать новый профиль с стандартными настройками"--Might go off screen?
L.Area_ApplyProfile			= "Выбор активного профиля"
L.SelectProfileToApply		= "Выберите профиль для применения"
L.Area_CopyProfile			= "Копирование профиля настроек DBM Core"
L.SelectProfileToCopy		= "Выберите профиль для копирования"
L.Area_DeleteProfile		= "Удаление профиля настроек DBM Core"
L.SelectProfileToDelete		= "Выберите профиль для удаления"
L.Area_DualProfile			= "Настройки профиля для босс-модулей"
L.DualProfile				= "Включить поддержку разных настроек босс-модулей для специализаций. (Управление профилями босс-модулей производится с экрана статистики загруженного модуля)"

L.Area_ModProfile			= "Копирование настроек модуля с другого персонажа/спека или удаление настроек модуля"
L.ModAllReset				= "Сбросить все настройки модуля"
L.ModAllStatReset			= "Сбросить всю статистику модуля"
L.SelectModProfileCopy		= "Скопировать все настройки из"
L.SelectModProfileCopySound	= "Скопировать настройки звука из"
L.SelectModProfileCopyNote	= "Скопировать заметки из"
L.SelectModProfileDelete	= "Удалить настройки модуля для"

-- Misc
L.FontType					= "Выбор шрифта"
L.FontStyle					= "Флаги шрифта"
L.FontColor					= "Цвет шрифта"
L.FontShadow				= "Тень"
L.FontSize					= "Размер шрифта: %d"

L.FontHeight	= 16
