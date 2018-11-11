module Box.View exposing (view)

import Box.Model exposing (..)
import Bulma.Columns as B exposing (columnModifiers, columnsModifiers)
import Bulma.Components as B
import Bulma.Elements as B exposing (buttonModifiers)
import Bulma.Form as B
import Bulma.Layout as B
import Bulma.Modifiers as B exposing (..)
import Bulma.Modifiers.Typography as BT
import Data.Food exposing (Food)
import DateFormat as DF
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (..)


view : Model -> Html Msg
view model =
    B.section B.NotSpaced
        []
        [ B.columns { columnsModifiers | centered = True }
            []
            [ B.column
                { columnModifiers
                    | widths = widthSetter <| Just Width8
                }
                []
                [ B.button
                    { buttonModifiers
                        | color = B.Primary
                        , size = B.Medium
                    }
                    [ B.fullWidth
                    , onClick <| ToggleModal True
                    ]
                    [ text "追加" ]
                ]
            ]
        , B.columns columnsModifiers
            []
          <|
            List.map (foodItemView model.timeZone) model.foods
        , addModal model.modalToggle
        ]


foodItemView : Zone -> Food -> Html Msg
foodItemView timeZone food =
    B.column
        { columnModifiers
            | widths = widthSetter <| Just Width4
        }
        []
        [ B.card
            []
            [ B.cardHeader []
                [ B.easyCardTitle [] food.name
                ]
            , B.cardContent []
                [ cardContentText "個数" <| String.fromInt food.amount
                , cardContentText "賞味期限" (expFormatter timeZone food.exp)
                ]
            , B.cardFooter []
                [ B.cardFooterItem
                    [ B.display B.Block ]
                    [ B.buttons B.Right
                        [ B.fullWidth ]
                        [ B.button
                            { buttonModifiers
                                | color = B.Danger
                                , outlined = True
                            }
                            []
                            [ text "Delete" ]
                        ]
                    ]
                ]
            ]
        ]


cardContentText : String -> String -> Html Msg
cardContentText subTitle item =
    B.level []
        [ B.levelLeft [] [ text subTitle ]
        , B.levelRight [] [ text item ]
        ]


expFormatter : Zone -> Posix -> String
expFormatter =
    DF.format
        [ DF.yearNumber
        , DF.text "-"
        , DF.monthNumber
        , DF.text "-"
        , DF.dayOfMonthNumber
        ]


addModal : Bool -> Html Msg
addModal isOpen =
    B.modal isOpen
        []
        [ B.modalBackground [ onClick <| ToggleModal False ] []
        , B.modalCard []
            [ B.modalCardHead [] [ B.modalCardTitle [] [ text "食材の追加" ] ]
            , B.modalCardBody []
                [ B.columns
                    { columnsModifiers
                        | centered = True
                        , multiline = True
                    }
                    []
                    [ B.column
                        columnModifiers
                        [ class "is-12" ]
                        [ text "食材を追加します" ]
                    , B.column
                        { columnModifiers | widths = widthSetter <| Just Width8 }
                        [ style "background" "black"
                        , style "height" "320px"
                        , id "quagga-display"
                        ]
                        []
                    ]
                ]
            , B.modalCardFoot [ B.display Block ]
                [ B.buttons Right
                    []
                    [ B.button { buttonModifiers | color = B.Success }
                        []
                        [ text "追加" ]
                    , B.button { buttonModifiers | color = B.Light }
                        [ onClick <| ToggleModal False ]
                        [ text "キャンセル" ]
                    ]
                ]
            ]
        , B.modalClose B.Large [ onClick <| ToggleModal False ] []
        ]


showTouchOnly : Devices Display
showTouchOnly =
    { mobile = B.Block
    , tablet = B.Block
    , desktop = B.Hidden
    , widescreen = B.Hidden
    , fullHD = B.Hidden
    }


widthSetter : Maybe Width -> Devices (Maybe Width)
widthSetter w =
    { mobile = Just B.Auto
    , tablet = w
    , desktop = w
    , widescreen = w
    , fullHD = w
    }
