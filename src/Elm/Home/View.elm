module Home.View exposing (view)

import Bulma.Columns as B exposing (columnModifiers, columnsModifiers)
import Bulma.Components as B exposing (navbarModifiers)
import Bulma.Elements as B exposing (TitleSize(..), buttonModifiers)
import Bulma.Layout as B
import Bulma.Modifiers as B exposing (..)
import Bulma.Modifiers.Typography as BT
import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    B.section B.NotSpaced
        [ B.paddingless
        ]
        [ homeHero
        , homeContent
        , homeFooter
        ]


homeHero : Html msg
homeHero =
    B.hero { color = B.Primary, size = B.Small, bold = False }
        []
        [ B.heroHead []
            [ B.navbar { navbarModifiers | color = B.Primary }
                []
                [ B.navbarBrand []
                    (B.navbarBurger False
                        []
                        [ span [] []
                        , span [] []
                        , span [] []
                        ]
                    )
                    [ B.navbarItemLink False
                        []
                        [ text "Pantry" ]
                    ]
                , B.navbarMenu True
                    []
                    [ B.navbarEnd []
                        [ B.navbarItem False
                            []
                            [ B.buttons Left
                                []
                                [ B.button { buttonModifiers | color = Link }
                                    [ BT.textColor BT.Grey ]
                                    [ text "SignUp" ]
                                , B.button { buttonModifiers | color = Primary }
                                    []
                                    [ text "SignIn" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , B.image B.Natural
            []
            [ img [ src "assets/Logo/facebook_cover_photo_2.png" ] [] ]
        ]


homeContent : Html msg
homeContent =
    B.section B.NotSpaced
        []
        [ B.container []
            [ [ { url = "https://bulma.io/images/placeholders/1280x960.png"
                , title = "Pantry"
                , info = "あなたの食材を管理します."
                }
              , { url = "https://bulma.io/images/placeholders/1280x960.png"
                , title = "Recipe"
                , info = "Pantryの食材からレシピをおすすめします."
                }
              , { url = "https://bulma.io/images/placeholders/1280x960.png"
                , title = "ShoppingList"
                , info = "足りない食材の買い物リストを作ります."
                }
              ]
                |> List.map infoCard
                |> B.columns columnsModifiers []
            ]
        ]


homeFooter : Html msg
homeFooter =
    B.section B.NotSpaced
        []
        [ B.container []
            [ B.box [ B.radiusless ]
                [ B.columns columnsModifiers
                    []
                    [ B.column columnModifiers
                        []
                        [ B.button { buttonModifiers | color = Link, size = Large }
                            [ BT.textColor BT.Grey
                            , B.fullWidth
                            ]
                            [ text "SignUp" ]
                        ]
                    , B.column columnModifiers
                        []
                        [ B.button { buttonModifiers | color = Primary, size = Large }
                            [ B.fullWidth ]
                            [ text "SignIn" ]
                        ]
                    ]
                ]
            ]
        ]


type alias Info =
    { url : String
    , title : String
    , info : String
    }


infoCard : Info -> Html msg
infoCard { url, title, info } =
    B.column columnCardModifiers
        []
        [ B.card
            []
            [ B.cardImage []
                [ B.image B.ThreeByTwo
                    []
                    [ img [ src url ] []
                    ]
                ]
            , B.cardContent []
                [ B.title H4
                    []
                    [ text title ]
                , B.subtitle H6
                    []
                    [ text info
                    ]
                ]
            ]
        ]


columnCardModifiers : B.ColumnModifiers
columnCardModifiers =
    { columnModifiers
        | widths =
            { mobile = Just Width4
            , tablet = Just Width4
            , desktop = Just Width4
            , widescreen = Just Width4
            , fullHD = Just Width4
            }
    }
