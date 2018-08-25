--NightmareAdventure.hs
--Copyright Laurence Emms 2018
--Base module for the nightmare adventure game

module NightmareAdventure (gameIntro,
                           allVerbs,
                           allNouns,
                           allPrepositions,
                           allTokens,
                           startScene,
                           startInventory,
                           startFlags,
                           defaultScene,
                           allScenes) where

import qualified Data.List
import qualified Data.Map

import NaturalLanguageLexer
import NaturalLanguageParser
import NarrativeGraph

gameIntro :: String
gameIntro = "Nightmare Adventure by Vibha Laljani, Raji Venkat, and Laurence Emms\n\n"

allVerbs :: [Token]
allVerbs =
    [
        TokenVerb "get" ["get", "take", "pick up"],
        TokenVerb "put" ["put", "place", "put down"],
        TokenVerb "throw" ["throw", "pitch"],
        TokenVerb "give" ["give"],
        TokenVerb "select" ["select", "pick"],
        TokenVerb "look" ["look", "see", "view", "scan", "spy", "observe"],
        TokenVerb "inspect" ["inspect", "check out", "observe", "scan"],
        TokenVerb "look around" ["look around"],
        TokenVerb "use" ["use"],
        TokenVerb "jump" ["jump"],
        TokenVerb "go" ["move", "proceed"],
        TokenVerb "walk" ["walk", "stride", "strut", "step", "hike", "trot", "stroll", "march", "amble", "saunter", "trek", "wander", "trudge", "perambulate", "plod", "traverse", "prance", "promenade", "perambulate", "tread", "traipse", "hoof it", "move", "go"],
        TokenVerb "walk down" ["walk down", "move down", "go down"],
        TokenVerb "walk up" ["walk up", "move up", "go up"],
        TokenVerb "fly" ["fly", "float", "drift", "glide", "move", "go"],
        TokenVerb "run" ["run", "race", "jog", "sprint", "dash"],
        TokenVerb "run down" ["run down", "jog down", "sprint down", "dash down"],
        TokenVerb "run up" ["run up", "jog up", "sprint up", "dash up"],
        TokenVerb "dance" ["dance"],
        TokenVerb "smile" ["smile", "grin"],
        TokenVerb "frown" ["frown"],
        TokenVerb "climb" ["climb", "scale"],
        TokenVerb "climb down" ["climb down", "scale down"],
        TokenVerb "climb up" ["climb up", "scale up"],
        TokenVerb "unlock" ["unlock"],
        TokenVerb "lock" ["lock"],
        TokenVerb "open" ["open"],
        TokenVerb "close" ["close", "shut"],
        TokenVerb "enter" ["enter"],
        TokenVerb "insert" ["insert"],
        TokenVerb "remove" ["remove"],
        TokenVerb "leave" ["leave", "exit"],
        TokenVerb "eat" ["eat", "consume"],
        TokenVerb "drink" ["drink", "consume"],
        TokenVerb "do something" ["do something"],
        TokenVerb "press" ["press", "hit", "push", "depress", "poke"],
        TokenVerb "lift" ["lift", "remove"],
        TokenVerb "touch" ["touch", "stroke", "grab", "feel", "handle", "pat", "brush", "tap"],
        TokenVerb "ask" ["ask", "question", "query", "inquire", "quiz", "interrogate"],
        TokenVerb "talk" ["talk", "chat", "converse", "communicate", "speak", "parley"]
    ]

allNouns :: [Token]
allNouns =
    [
        TokenNoun "north" ["north"], --General nouns
        TokenNoun "south" ["south"],
        TokenNoun "west" ["west"],
        TokenNoun "east" ["east"],
        TokenNoun "up" ["up"],
        TokenNoun "down" ["down"],
        TokenNoun "inside" ["inside"],
        TokenNoun "outside" ["outside"],
        TokenNoun "me" ["me"],
        TokenNoun "myself" ["myself"],
        TokenNoun "chrome amulet" ["chrome amulet"],
        TokenNoun "front door" ["front door"],
        TokenNoun "door" ["door", "doorway"],
        TokenNoun "home" ["home", "my house", "cottage", "mud-brick cottage"], --Cottage nouns
        TokenNoun "Jorryn" ["Jorryn"],
        TokenNoun "parents" ["parents"],
        TokenNoun "square" ["square", "aldeia square"], --Aldeia square nouns
        TokenNoun "clock" ["ancient clock", "clock"],
        TokenNoun "Evanna" ["Evanna"],
        TokenNoun "jade amulet" ["jade amulet"],
        TokenNoun "tower" ["tower", "aeon tower", "crystal tower"], --Tower nouns
        TokenNoun "gateway" ["gate", "cloaked gateway"],
        TokenNoun "elevator" ["elevator"],
        TokenNoun "ground floor" ["ground floor"],
        TokenNoun "bedroom" ["bedroom"],
        TokenNoun "music room" ["music room"],
        TokenNoun "guest room" ["guest room"],
        TokenNoun "button panel" ["button panel"],
        TokenNoun "button" ["button"],
        TokenNoun "gear" ["gear"],
        TokenNoun "chest of drawers" ["chest of drawers", "drawers"],
        TokenNoun "bed" ["bed"],
        TokenNoun "gramophone" ["gramophone", "phonograph"],
        TokenNoun "needle" ["needle", "stylus"],
        TokenNoun "star" ["star", "stars"], -- Star field nouns
        TokenNoun "clock constellation" ["clock", "clock constellation"],
        TokenNoun "hypnotism constellation" ["hypnotism", "hypnotism constellation"],
        TokenNoun "cupcake constellation" ["cupcake", "cup cake", "cupcake constellation", "cup cake constellation"]
    ]

allPrepositions :: [Token]
allPrepositions =
    [
        TokenPreposition "in" ["in", "inside", "within"],
        TokenPreposition "into" ["into"],
        TokenPreposition "out" ["out", "outside"],
        TokenPreposition "on" ["on", "on top", "upon"],
        TokenPreposition "on" ["on", "with"],
        TokenPreposition "above" ["above", "over"],
        TokenPreposition "over" ["over"],
        TokenPreposition "below" ["below", "under", "underneath", "beneath"],
        TokenPreposition "across" ["across"],
        TokenPreposition "before" ["before"],
        TokenPreposition "after" ["after"],
        TokenPreposition "against" ["against"],
        TokenPreposition "around" ["around"],
        TokenPreposition "among" ["among"],
        TokenPreposition "about" ["about"],
        TokenPreposition "at" ["at"],
        TokenPreposition "in front" ["in front"],
        TokenPreposition "from" ["from"],
        TokenPreposition "behind" ["behind"],
        TokenPreposition "beside" ["beside", "by", "next to"],
        TokenPreposition "beyond" ["beyond"],
        TokenPreposition "near" ["near"],
        TokenPreposition "down" ["down"],
        TokenPreposition "up" ["up"],
        TokenPreposition "past" ["past"],
        TokenPreposition "through" ["through"],
        TokenPreposition "to" ["to", "toward"],
        TokenPreposition "until" ["until"],
        TokenPreposition "with" ["with"],
        TokenPreposition "together with" ["together with"]
    ]

--Helper function to make unambiguous sentences
uSentence :: [String] -> Sentence
uSentence words = unambiguousSentence allVerbs allNouns allPrepositions words

allTokens :: [Token]
allTokens = allNouns ++ allVerbs ++ allPrepositions

startScene :: String
startScene = "cottage"

startInventory :: Inventory
startInventory = Inventory ["chrome amulet"]

startFlags :: Flags
startFlags = Flags []

introString :: String
introString = "It's been a long day working at the moisture farms outside of your village, your aldeia. You return home just as the sun is setting. You open the door to your mud-brick cottage to find your brother, <Jorryn>, lying on the dirt floor just inside the <front door>.\nAt first, you fear the worst; life on the edge of The Beyond can be dangerous.\nBut as you lean down to inspect your brother you realize that he is not dead, but asleep.\nYou rush to check your parents, who are also on the floor by the stove, they are also asleep.\nNo amount of shaking or shouting seems to wake them."

cottageDescriptionString :: String
cottageDescriptionString = "You're standing in your home. <Jorryn> is lying by the <front door> to the <east>. Your parents are on the floor by the stove."

cottageScene :: Scene
cottageScene =
    Scene
    {
        sceneDescription =
            ConditionalDescription
            [
                (CNot (FlagSet "intro"), introString, [SetFlag "intro"]),
                (CNot (FlagSet "cottage described"), cottageDescriptionString, [SetFlag "cottage described"])
            ],
        interactions =
            [
                Interaction
                {
                    sentences = [uSentence ["look"],
                                 uSentence ["look around"],
                                 uSentence ["look", "at", "home"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, cottageDescriptionString, [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "parents"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, "Your parents are unhurt but you can't wake them from their slumber.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "Jorryn"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, "Jorryn lies asleep on the floor, you can't seem to wake him.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "east"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CNot (FlagSet "front door closed"), "You peer out of your <front door>. You see the path to the <aldeia square>.", []),
                                        ((FlagSet "front door closed"), "You look at your <front door>. It's closed.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "door"],
                                 uSentence ["look", "at", "front door"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CNot (FlagSet "front door closed"), "It's your <front door>. The door is open.", []),
                                        ((FlagSet "front door closed"), "It's your <front door>. The door is closed.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["close", "door"],
                                 uSentence ["close", "front door"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CNot (FlagSet "front door closed"), "You close your front door.", []),
                                        ((FlagSet "front door closed"), "Your front door is already closed.", [])
                                    ],
                                stateChanges = [SetFlag "front door closed"]
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["open", "door"],
                                 uSentence ["open", "front door"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CNot (FlagSet "front door closed"), "Your front door is already open.", []),
                                        ((FlagSet "front door closed"), "You open your front door.", [])
                                    ],
                                stateChanges = [RemoveFlag "front door closed"]
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "through", "door"],
                                 uSentence ["leave", "through", "door"],
                                 uSentence ["leave", "out", "door"],
                                 uSentence ["walk", "out", "door"],
                                 uSentence ["walk", "through", "front door"],
                                 uSentence ["leave", "through", "front door"],
                                 uSentence ["leave", "out", "front door"],
                                 uSentence ["walk", "out", "front door"],
                                 uSentence ["walk", "outside"],
                                 uSentence ["walk", "east"],
                                 uSentence ["leave", "east"],
                                 uSentence ["leave"],
                                 uSentence ["leave", "home"],
                                 uSentence ["walk", "to", "square"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CNot (FlagSet "front door closed"),
                                conditionalDescription =
                                    ConditionalDescription
                                        [
                                            (FlagSet "square visited", "You walk through the front door of your home out into the aldeia. Everyone you pass is still asleep. Your friend, <Evanna>, is still asleep at the base of the <Ancient Clock>.", []),
                                            (CNot (FlagSet "square visited"), "You walk through the front door of your home out into your aldeia. As you walk through the aldeia, you come across several people asleep on the ground. You arrive at the aldeia square and you notice that, for the first time in your life, the <Ancient Clock> has stopped. You see your friend, <Evanna>, walking slowly through the square in a dazed stupor. As you approach, she collapses to the ground. The <Ancient Clock> chimes and her body starts to glow a deep green color, the glowing aura shoots quickly into the <Ancient Clock> and it falls silent.", [])
                                        ],
                                stateChanges = [SceneChange "aldeia", SetFlag "square visited", RemoveFlag "cottage described"]
                            },
                            ConditionalAction
                            {
                                condition = FlagSet "front door closed",
                                conditionalDescription =
                                    ConditionalDescription
                                        [
                                            (CTrue, "Your front door is closed, blocking your way.", [])
                                        ],
                                stateChanges = []
                            }
                        ]
                }
            ]
    }

winScene :: Scene
winScene =
    Scene
    {
        sceneDescription = ConditionalDescription [(CTrue, "Game over", [])],
        interactions = []
    }

aldeiaDescriptionString :: String
aldeiaDescriptionString = "You are standing in the <aldeia square>. It is a dusty open area surrounded by mud-brick buildings. The <Ancient Clock> stands silent in the center of the square. Your friend, <Evanna>, is lying at the base of the clock. Your <home> is to the <west>. You see the <Aeon Tower> to the <south> at the edge of the Kethar desert."

aldeiaScene :: Scene
aldeiaScene =
    Scene
    {
        sceneDescription = ConditionalDescription [(CNot (FlagSet "aldeia described"), aldeiaDescriptionString, [SetFlag "aldeia described"])],
        interactions =
            [
                Interaction
                {
                    sentences = [uSentence ["look", "at", "clock"],
                                 uSentence ["inspect", "clock"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, "You inspect the <Ancient Clock>. It appears to be carved out of a block of marble and has stood on this spot, steadily ticking since long before your tribe came to settle in The Beyond. The clock is not ticking, and the hands have stopped. You notice that something appears to have bored a a perfectly round hole in the marble. Inside, you see that the clock operates with a complicated set of gears. One of the gears appears to be missing.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "Evanna"],
                                 uSentence ["inspect", "Evanna"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CNot (InInventory "jade amulet"), "Your friend Evanna, lies in a deep slumber at the base of the Ancient clock. You call her name and shake her, but nothing you do can wake her. You notice that her <jade amulet> is gently glowing.", []),
                                        (InInventory "jade amulet", "Your friend Evanna, lies in a deep slumber at the base of the Ancient clock. You call her name and shake her, but nothing you do can wake her.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["get", "jade amulet"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CNot (InInventory "jade amulet"), "You reach down and remove Evanna's jade amulet.", []),
                                        (InInventory "jade amulet", "You have already take Evanna's jade amulet.", [])
                                    ],
                                stateChanges = [AddToInventory "jade amulet"]
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look"],
                                 uSentence ["look around"],
                                 uSentence ["look", "at", "square"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, aldeiaDescriptionString, [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "west"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, "You see the path back <home>", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "south"],
                                 uSentence ["look", "at", "tower"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, "You see the <Aeon Tower>, a single massive crystal growing out of the Kethar desert. It serves as Isvald's home.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "west"],
                                 uSentence ["walk", "home"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                        [
                                            (CTrue, "You walk through the deserted streets of your aldeia, passing several sleeping bodies on your way home.", [RemoveFlag "aldeia described"])
                                        ],
                                stateChanges = [SceneChange "cottage"]
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "south"],
                                 uSentence ["walk", "to", "tower"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                        [
                                            (CTrue, "You walk towards the looming <Aeon Tower>.", [RemoveFlag "aldeia described"])
                                        ],
                                stateChanges = [SceneChange "tower"]
                            }
                        ]
                }
            ]
    }

towerDescriptionString :: String
towerDescriptionString = "You are standing at the base of the <Aeon Tower>, inhabited by Isvald, the aldeia's resident Aeon Priest. The tower is a giant spiral of blue crystal, maybe 100 feet tall, with no visible entrances. Beyond the tower is Kethar desert, which stretches to the horizon. The <aledeia square> is to the <north>."

towerScene :: Scene
towerScene =
    Scene
    {
        sceneDescription = ConditionalDescription [(CNot (FlagSet "tower described"), towerDescriptionString, [SetFlag "tower described"])],
        interactions =
            [
                Interaction
                {
                    sentences = [uSentence ["look"],
                                 uSentence ["look around"],
                                 uSentence ["look", "at", "tower"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, towerDescriptionString, [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "north"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, "You see your aldeia. A dirt path leads from the <Aeon Tower> back to the <aldeia square>", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "north"],
                                 uSentence ["walk", "to", "square"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                        [
                                            (CTrue, "You walk back to the <aldeia square>.", [RemoveFlag "tower described"])
                                        ],
                                stateChanges = [SceneChange "aldeia"]
                            }
                        ]
                }
            ]
    }

wizardTowerGroundFloorDescriptionString :: String
wizardTowerGroundFloorDescriptionString = "You are inside <Aeon Tower>, inhabited by Isvald, the aldeia's resident Aeon Priest. The tall tower’s blue crystal interiors playfully bounce the sunlight streaming in. To your <west>, is the cloaked <gateway> that let you in. To your east, is an elevator with a <button> to summon it, which seems to be the only way to get past the foyer."

wizardTowerGroundFloorScene :: Scene
wizardTowerGroundFloorScene =
    Scene
    {
        sceneDescription = ConditionalDescription [(CNot (FlagSet "wizardTowerGroundFloor described"), wizardTowerGroundFloorDescriptionString, [SetFlag "wizardTowerGroundFloor described"])],
        interactions =
            [
                Interaction
                {
                    sentences = [uSentence ["look"],
                                 uSentence ["look around"],
                                 uSentence ["look", "at", "tower"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, wizardTowerGroundFloorDescriptionString, [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "west"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                    [
                                        (CTrue, "You see the cloaked <gateway> that let you in.", [])
                                    ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "through", "gateway"],
                                 uSentence ["leave", "through", "gateway"],
                                 uSentence ["walk", "out", "gateway"],
                                 uSentence ["leave", "out", "gateway"],
                                 uSentence ["walk", "outside"],
                                 uSentence ["walk", "west"],
                                 uSentence ["leave", "west"],
                                 uSentence ["leave"],
                                 uSentence ["leave", "tower"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription =
                                    ConditionalDescription
                                        [
                                            (CTrue, "You exit through the cloaked gateway, and find yourself at the base of <Aeon Tower>.", [RemoveFlag "wizardTowerGroundFloor described"])
                                        ],
                                stateChanges = [SceneChange "tower"]
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["press", "button"],
                                 uSentence ["use", "button"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = (CNot (FlagSet "elevator arrived")),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> arrives with a *ping* sound, and opens its arms to welcome you in.", [SetFlag "elevator arrived"]) 
                                       ],
                                stateChanges = []
                            },
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator arrived"),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> is already waiting for you with open arms! Go on in before it tires out.", [])
                                       ],
                                stateChanges = []
                            }
                        ]   
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "elevator"],
                                 uSentence ["look", "in", "elevator"]],
                    conditionalActions = 
                        [
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator arrived"),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> is a cool glass cube that allows a 360-degree view of the tower.", [])
                                       ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "into", "elevator"],
                                 uSentence ["use", "elevator"],
                                 uSentence ["enter", "elevator"],
                                 uSentence ["go", "in", "elevator"],
                                 uSentence ["go", "into", "elevator"],
                                 uSentence ["get", "into", "elevator"]],
                    conditionalActions = 
                        [
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator arrived"),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "You enter the cool glass cube elevator. The doors slide shut as you take in a 360-degree view of the tower.", [RemoveFlag "elevator arrived"]) 
                                       ],
                                stateChanges = [SceneChange "elevator", SetFlag "elevator ground floor"]
                            }
                        ]
                }
            ]
    }

elevatorDescriptionString :: String
elevatorDescriptionString = "The elevator has a magic <button panel> so you can pick a destination for your ride."
elevatorScene :: Scene
elevatorScene = 
    Scene
    {
        sceneDescription = ConditionalDescription [(CNot (FlagSet "elevator described"), elevatorDescriptionString, [SetFlag "elevator described"])],
        interactions = 
            [
                Interaction
                {
                    sentences = [uSentence ["look", "at", "button panel"],
                                 uSentence ["observe", "button panel"]],
                    conditionalActions = 
                        [
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator ground floor"),
                                conditionalDescription = 
                                    ConditionalDescription 
                                       [
                                           (CTrue, "You may go to the <Bedroom>, the <Music Room>, or the <Guest Room>", []) 
                                       ],
                                stateChanges = []
                            },
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator bedroom"),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "You may go to the <Ground Floor>, the <Music Room>, or the <Guest Room>", [])
                                       ],
                                stateChanges = []
                            },
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator music room"),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "You may go to the <Ground Floor>, the <Bedroom>, or the <Guest Room>", [])
                                       ],
                                stateChanges = []
                            },
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator guest room"),
                                conditionalDescription =
                                    ConditionalDescription
                                       [
                                           (CTrue, "You may go to the <Ground Floor>, the <Bedroom>, or the <Music Room>", [])
                                       ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["go", "to", "Ground Floor"],
                                 uSentence ["press", "Ground Floor"],
                                 uSentence ["ride", "to", "Ground Floor"]],
                    conditionalActions = 
                        [
                            ConditionalAction
                            {
                                condition = (CNot (FlagSet "elevator ground floor")),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> whisks you off, and brings you to the ground floor with a gentle bounce. Exit <elevator> to hop off here, or ride to a different room by picking from the magical <button panel>.", [])
                                       ],
                                stateChanges = [SetFlag "elevator ground floor"]
                            }
                        ]
               },
               Interaction
               {
                   sentences = [uSentence ["go", "to", "Bedroom"],
                                uSentence ["press", "Bedroom"],
                                uSentence ["ride", "to", "Bedroom"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = (CNot (FlagSet "elevator bedroom")),
                               conditionalDescription = 
                                   ConditionalDescription
                                      [
                                          (CTrue, "The <elevator> zooms across the tower, and comes to a floating stop at the bedroom. Exit <elevator> to hop off here, or ride to a different room by picking from the magical <button panel>.", [])
                                      ],
                               stateChanges = [SetFlag "elevator bedroom"]
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["go", "to", "Music Room"],
                                uSentence ["press", "Music Room"],
                                uSentence ["ride", "to", "Music Room"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = (CNot (FlagSet "elevator music room")),
                               conditionalDescription = 
                                   ConditionalDescription
                                      [
                                          (CTrue, "The <elevator> glides away, and comes to a rest at the music room. Exit <elevator> to hop off here, or ride to a different room by picking from the magical <button panel>.", []) 
                                      ],
                               stateChanges = [SetFlag "elevator music room"]
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["go", "to", "Guest Room"],
                                uSentence ["press", "Guest Room"],
                                uSentence ["ride", "to", "Guest Room"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = (CNot (FlagSet "elevator guest room")),
                               conditionalDescription = 
                                   ConditionalDescription 
                                      [
                                          (CTrue, "The <elevator> sails across the tower, and docks at the guest room. Exit <elevator> to hop off here, or ride to a different room by picking from the magical <button panel>.", [])
                                      ],
                               stateChanges = [SetFlag "elevator guest room"]
                           }
                      ]
               },
               Interaction
               {
                   sentences = [uSentence ["exit", "elevator"],
                                uSentence ["walk", "out", "elevator"],
                                uSentence ["leave", "elevator"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = (FlagSet "elevator ground floor"),
                               conditionalDescription = 
                                   ConditionalDescription 
                                      [
                                          (CTrue, "You step out to the ground floor, and the elevator lifts off.", [])
                                      ],
                               stateChanges = [SceneChange "tower ground floor", RemoveFlag "elevator ground floor"]
                           },
                           ConditionalAction
                           {
                               condition = (FlagSet "elevator bedroom"),
                               conditionalDescription = 
                                   ConditionalDescription
                                      [
                                          (CTrue, "You step out into the bedroom, and the elevator drifts away.", [])
                                      ],
                               stateChanges = [SceneChange "wizardTowerBedroomScene", RemoveFlag "elevator bedroom"]
                           },
                           ConditionalAction
                           {
                               condition = (FlagSet "elevator music room"),
                               conditionalDescription = 
                                   ConditionalDescription
                                      [
                                          (CTrue, "You step out into the music room, and the elevator cruises away.", [])
                                      ],
                               stateChanges = [SceneChange "wizardTowerMusicRoomScene", RemoveFlag "elevator music room"]
                           },
                           ConditionalAction
                           {
                               condition = (FlagSet "elevator guest room"),
                               conditionalDescription =
                                   ConditionalDescription
                                      [
                                          (CTrue, "You step out into the guest room, and the elevator slides away.", [])
                                      ],
                               stateChanges = [SetFlag "wizardTowerGuestRoomScene", RemoveFlag "elevator guest room"]
                           }
                       ]
               }
            ]
    }

wizardTowerBedroomDescriptionString :: String
wizardTowerBedroomDescriptionString = "You are in the ornate bedroom. The <wizard>, Isvald, is sleeping on the <bed>. One corner of the room is inhabited by a <chest of drawers>, with a mirror atop. You hear music floating up to the bedroom, presumably from the music room. It sounds like a lullaby, and is making you sleepy. Behind you is the <elevator>, with a call <button> to summon it."

wizardTowerBedroomScene :: Scene
wizardTowerBedroomScene =
    Scene
    {
        sceneDescription = ConditionalDescription [(CNot (FlagSet "wizardTowerBedroom described"), wizardTowerBedroomDescriptionString, [SetFlag "wizardTowerBedroom described"])],
        interactions =
            [
                Interaction
                {
                    sentences = [uSentence ["look", "at", "wizard"],
                                 uSentence ["see", "wizard"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = ConditionalDescription [(CTrue, "The <wizard> has a big smile on his face because he is dreaming. He is clutching a <gear> to his chest. A luxurious purple velvet blanket envelopes him.", [])],
                                stateChanges = [SetFlag "wizard seen"]
                            }
                        ]
               },
               Interaction
               {
                   sentences = [uSentence ["look", "at", "bed"],
                                uSentence ["see", "bed"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = CTrue,
                               conditionalDescription = ConditionalDescription [(CTrue, "The magnificent four poster bed looks quite comfortable. Alas, no one save the <wizard> can be in it. The bed's canopy looks lovely even drawn aside.", [])],
                               stateChanges = []
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["look", "at", "chest of drawers"],
                                uSentence ["see", "chest of drawers"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = CTrue,
                               conditionalDescription = ConditionalDescription [(CTrue, "The eye-catching distressed dresser has a gold-hued finish that accents the jewel-toned tabletop trinkets. It has three <drawers> to stow away unwanted clutter.", [])],
                               stateChanges = []
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["look", "at", "elevator"],
                                uSentence ["see", "elevator"]],
                   conditionalActions =
                       [
                           ConditionalAction
                           {
                               condition = FlagSet "elevator arrived",
                               conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is a cool glass cube that allows a 360-degree view of the tower.", [])],
                               stateChanges = []
                           },
                           ConditionalAction
                           {
                               condition = CTrue,
                               conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is not here. Use the call <button> to summon it.", [])],
                               stateChanges = []
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["open", "drawers"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = CTrue,
                               conditionalDescription = ConditionalDescription [(CTrue, "You see clothes that don't seem like the right size. You also find dusty old books written in a language you don't understand. The magical drawers tuck themselves away upon noticing your disinterest.", [])],
                               stateChanges = [SetFlag "at chest of drawers", RemoveFlag "at wizard", RemoveFlag "at elevator"]
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["take", "gear"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = FlagSet "wizard seen",
                               conditionalDescription = ConditionalDescription [(CTrue, "The <wizard> is holding the <gear> magically. Thus, you are not able to pry it free.", [])],
                               stateChanges = [SetFlag "at wizard", RemoveFlag "at chest of drawers", RemoveFlag "at elevator"]
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["walk", "to", "wizard"],
                                uSentence ["walk", "to", "bed"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = CNot (FlagSet "at wizard"),
                               conditionalDescription = ConditionalDescription [(CTrue, "You walk to the sleeping <wizard>.", [])],
                               stateChanges = [SetFlag "at wizard", RemoveFlag "at chest of drawers", RemoveFlag "at elevator"]
                           },
                           ConditionalAction
                           {
                               condition = FlagSet "at wizard",
                               conditionalDescription = ConditionalDescription [(CTrue, "You are close enough to the wizard that you can see his whiskers vibrate with every sleeping breath", [])],
                               stateChanges = []
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["walk", "to", "chest of drawers"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = CNot (FlagSet "at chest of drawers"),
                               conditionalDescription = ConditionalDescription [(CTrue, "You noiselessly walk to the <chest of drawers>.", [])],
                               stateChanges = [SetFlag "at chest of drawers", RemoveFlag "at wizard", RemoveFlag "at elevator"]
                           },
                           ConditionalAction
                           {
                               condition = FlagSet "at chest of drawers",
                               conditionalDescription = ConditionalDescription [(CTrue, "To get any closer, you'd have to tuck yourself into a drawer", [])],
                               stateChanges = []
                           }
                       ]
               },
               Interaction
               {
                   sentences = [uSentence ["walk", "to", "elevator"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = CNot (FlagSet "at elevator"),
                               conditionalDescription = ConditionalDescription [(CTrue, "You walk to the <elevator> and call <button>.", [])],
                               stateChanges = [SetFlag "at elevator", RemoveFlag "at wizard", RemoveFlag "at chest of drawers"]
                           },
                           ConditionalAction
                           {
                               condition = FlagSet "elevator arrived",
                               conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is waiting for you with open arms! Go on in before it tires out.", [])],
                               stateChanges = []
                           },
                           ConditionalAction
                           {
                               condition = CTrue,
                               conditionalDescription = ConditionalDescription [(CTrue, "You are at the <elevator>. Press the call <button> to summon it.", [])],
                               stateChanges = []
                           }
                       ]
                },
                Interaction
                {
                    sentences = [uSentence ["press", "button"],
                                 uSentence ["use", "button"]],
                    conditionalActions =
                        [   
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator arrived"),
                                conditionalDescription =
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> is already waiting for you with open arms! Go on in before it tires out.", [])
                                       ],
                                stateChanges = [SetFlag "at elevator", RemoveFlag "at wizard", RemoveFlag "at chest of drawers"]
                            },
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> arrives with a *ping* sound, and opens its arms to welcome you in.", [SetFlag "elevator arrived"]) 
                                       ],
                                stateChanges = [SetFlag "at elevator", RemoveFlag "at wizard", RemoveFlag "at chest of drawers"]
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "into", "elevator"],
                                 uSentence ["use", "elevator"],
                                 uSentence ["enter", "elevator"],
                                 uSentence ["go", "in", "elevator"],
                                 uSentence ["go", "into", "elevator"],
                                 uSentence ["get", "into", "elevator"]],
                    conditionalActions = 
                        [
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator arrived"),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "You enter the cool glass cube elevator. The doors slide shut as you take in a 360-degree view of the tower.", [RemoveFlag "elevator arrived"]) 
                                       ],
                                stateChanges = [SetFlag "at elevator", RemoveFlag "at wizard", RemoveFlag "at chest of drawers", SceneChange "elevator", SetFlag "elevator bedroom"]
                            },
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is not here. Use the call <button> to summon it.", [])],
                                stateChanges = [SetFlag "at elevator", RemoveFlag "at wizard", RemoveFlag "at chest of drawers"]
                            }
                        ]
                }
            ]
    }

wizardTowerMusicRoomDescriptionString :: String
wizardTowerMusicRoomDescriptionString = "You are in a harmonious room. The walls are white, with black musical notes running across them. Their tune interleaves with framed pictures of the wizard playing the piano. At the head of the room, sits a grand paino. Arm chairs with delicate detail on the cushions face the piano. The <gramophone> to the right of the piano, seems to be the source of a lullaby that's making you sleepy."

wizardTowerMusicRoomScene :: Scene
wizardTowerMusicRoomScene = 
    Scene
    {
        sceneDescription = ConditionalDescription [(CNot (FlagSet "music room described"), wizardTowerMusicRoomDescriptionString, [SetFlag "music room described"])],
        interactions = 
            [
                Interaction
                {
                    sentences = [uSentence ["look", "at", "gramophone"],
                                 uSentence ["see", "gramophone"],
                                 uSentence ["walk", "to", "gramophone"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = ConditionalDescription [(CTrue, "The exquisite artwork on the record is mesmerizing you as it spins. The <needle> is amicably vibrating to produce the melodious sound.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["lift", "needle"],
                                 uSentence ["touch", "needle"]],
                    conditionalActions = 
                        [
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = ConditionalDescription [(CTrue, "The music does not turn off. Yet, it dims gently, and you hear the wizard's voice say, \"I am trapped in dream land by accident. I need a pendulum in the dream world to break the spell.\" The music is distinct again.", [])],
                                stateChanges = [SetFlag "heard wizard"]
                            }
                        ]
                },
                Interaction
                {
                   sentences = [uSentence ["look", "at", "elevator"],
                                uSentence ["see", "elevator"]],
                   conditionalActions =
                       [
                           ConditionalAction
                           {
                               condition = FlagSet "elevator arrived",
                               conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is a cool glass cube that allows a 360-degree view of the tower.", [])],
                               stateChanges = []
                           },
                           ConditionalAction
                           {
                               condition = CTrue,
                               conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is not here. Use the call <button> to summon it.", [])],
                               stateChanges = []
                           }
                       ]
                },
                Interaction
                {
                   sentences = [uSentence ["walk", "to", "elevator"]],
                   conditionalActions = 
                       [
                           ConditionalAction
                           {
                               condition = FlagSet "elevator arrived",
                               conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is waiting for you with open arms! Go on in before it tires out.", [])],
                               stateChanges = []
                           },
                           ConditionalAction
                           {
                               condition = CTrue,
                               conditionalDescription = ConditionalDescription [(CTrue, "You are at the <elevator>. Press the call <button> to summon it.", [])],
                               stateChanges = []
                           }
                       ]
                },
                Interaction
                {
                    sentences = [uSentence ["press", "button"],
                                 uSentence ["use", "button"]],
                    conditionalActions =
                        [   
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator arrived"),
                                conditionalDescription =
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> is already waiting for you with open arms! Go on in before it tires out.", [])
                                       ],
                                stateChanges = []
                            },
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "The <elevator> arrives with a *ping* sound, and opens its arms to welcome you in.", [SetFlag "elevator arrived"]) 
                                       ],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "into", "elevator"],
                                 uSentence ["use", "elevator"],
                                 uSentence ["enter", "elevator"],
                                 uSentence ["go", "in", "elevator"],
                                 uSentence ["get", "into", "elevator"]],
                    conditionalActions = 
                        [
                            ConditionalAction
                            {
                                condition = (FlagSet "elevator arrived"),
                                conditionalDescription = 
                                    ConditionalDescription
                                       [
                                           (CTrue, "You enter the cool glass cube elevator. The doors slide shut as you take in a 360-degree view of the tower.", [RemoveFlag "elevator arrived"]) 
                                       ],
                                stateChanges = [SceneChange "elevator", SetFlag "elevator music room"]
                            },
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = ConditionalDescription [(CTrue, "The <elevator> is not here. Use the call <button> to summon it.", [])],
                                stateChanges = []
                            }
                        ]
                }
            ]
    }
 

starFieldDescriptionString :: String
starFieldDescriptionString = "You open your eyes and find yourself floating in a sea of stars. To your left you see a constellation which looks like a [Clock]." ++
                             "To your right you see a constellation which you know is called [Hypnotism]. Above you is a constellation called [Cup Cake]."

starFieldScene :: Scene
starFieldScene =
    Scene
    {
        sceneDescription = ConditionalDescription [(CNot (FlagSet "star field described"), starFieldDescriptionString, [SetFlag "star field described"])],
        interactions =
            [
                Interaction
                {
                    sentences = [uSentence ["get", "star"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = InInventory "star",
                                conditionalDescription = ConditionalDescription [(CTrue, "You already have a star.", [])],
                                stateChanges = []
                            },
                            ConditionalAction
                            {
                                condition = CTrue,
                                conditionalDescription = ConditionalDescription [(CTrue, "You pluck a star out of the sky and put it in your pocket.", [])],
                                stateChanges = [AddToInventory "star"]
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "to", "clock constellation"],
                                 uSentence ["fly", "to", "clock constellation"]],
                    conditionalActions =
                    [
                        ConditionalAction
                        {
                            condition = CTrue,
                            conditionalDescription = ConditionalDescription [(CTrue, "You float towards the [Clock] constellation", [])],
                            stateChanges = [SceneChange "clock"]
                        }
                    ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "to", "hypnotism constellation"],
                                 uSentence ["fly", "to", "hypnotism constellation"]],
                    conditionalActions =
                    [
                        ConditionalAction
                        {
                            condition = CTrue,
                            conditionalDescription = ConditionalDescription [(CTrue, "You float towards the [Hypnotism] constellation", [])],
                            stateChanges = [SceneChange "hypnotism"]
                        }
                    ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk", "to", "cupcake constellation"],
                                 uSentence ["fly", "to", "cupcake constellation"]],
                    conditionalActions =
                    [
                        ConditionalAction
                        {
                            condition = CTrue,
                            conditionalDescription = ConditionalDescription [(CTrue, "You float towards the [Cup Cake] constellation", [])],
                            stateChanges = [SceneChange "cupcake"]
                        }
                    ]
                }
            ]
    }

defaultScene :: Scene
defaultScene =
    Scene
    {
        sceneDescription = ConditionalDescription [],
        interactions =
            [
                Interaction
                {
                    sentences = [uSentence ["jump"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "You jump up and down in place.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["walk"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "You walk around a bit.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["run"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "You jog in place.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["dance"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "You dance a happy dance.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["smile"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "You smile.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["frown"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "You frown.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["do something"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "That does something.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "chrome amulet"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = InInventory "chrome amulet", --The key is in your inventory
                                conditionalDescription = ConditionalDescription [(CTrue, "You are wearing the chrome amulet your grandfather gave you as a child. It shimmers as you inspect it.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "jade amulet"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = InInventory "jade amulet", --The key is in your inventory
                                conditionalDescription = ConditionalDescription [(CTrue, "You look at Evanna's jade amulet. It shimmers as you inspect it.", [])],
                                stateChanges = []
                            }
                        ]
                },
                Interaction
                {
                    sentences = [uSentence ["look", "at", "me"],
                                 uSentence ["look", "at", "myself"]],
                    conditionalActions =
                        [
                            ConditionalAction
                            {
                                condition = CTrue, --Always do this
                                conditionalDescription = ConditionalDescription [(CTrue, "You look fine.", [])],
                                stateChanges = []
                            }
                        ]
                }
            ]
    }

allScenes :: (Data.Map.Map String Scene, [String])
allScenes = (Data.Map.fromList [("cottage", cottageScene),
                                ("win", winScene),
                                ("aldeia", aldeiaScene),
                                ("tower", towerScene),
                                ("starfield", starFieldScene),
                                ("tower ground floor", wizardTowerGroundFloorScene),
                                ("elevator", elevatorScene)], --List of scenes
             ["win"]) --End scenes
