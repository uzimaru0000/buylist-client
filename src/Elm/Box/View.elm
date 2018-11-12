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
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (..)
import Time exposing (..)
import Util


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
        , addModal model
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
            , B.cardContent [ onClick <| UpdateFood food ]
                [ B.media []
                    [ B.mediaLeft []
                        [ case food.imageURL of
                            Just url ->
                                B.image (B.OneByOne B.X96)
                                    []
                                    [ img [ src url ] [] ]

                            Nothing ->
                                text ""
                        ]
                    , B.mediaContent []
                        [ cardContentText "個数" <| String.fromInt food.amount
                        , cardContentText "賞味期限" (expFormatter timeZone food.exp)
                        ]
                    ]
                ]
            , B.cardFooter []
                [ B.cardFooterItem
                    [ B.display B.Block ]
                    [ B.buttons B.Right
                        []
                        [ B.button
                            { buttonModifiers
                                | color = B.Danger
                                , outlined = True
                            }
                            [ onClick <| DeleteFood food ]
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


addModal : Model -> Html Msg
addModal ({ modalToggle, addingFood, currentMode } as model) =
    B.modal modalToggle
        []
        [ B.modalBackground [ onClick <| ToggleModal False ] []
        , B.modalCard []
            [ B.modalCardHead [] [ B.modalCardTitle [] [ text "食材の追加" ] ]
            , B.modalCardBody []
                [ B.tabs B.tabsModifiers
                    []
                    []
                    [ B.tab (currentMode == ScanCode)
                        []
                        [ onClick <| ChangeMode ScanCode ]
                        [ text "読み取り" ]
                    , B.tab (currentMode == InputData)
                        []
                        [ onClick <| ChangeMode InputData ]
                        [ text "入力" ]
                    ]
                , case currentMode of
                    ScanCode ->
                        scanView

                    InputData ->
                        inputView model

                    _ ->
                        text ""
                ]
            , B.modalCardFoot [ B.display Block ]
                [ B.buttons Right
                    []
                    [ B.button { buttonModifiers | color = B.Success }
                        [ onClick AddFood ]
                        [ text "追加" ]
                    , B.button { buttonModifiers | color = B.Light }
                        [ onClick <| ToggleModal False ]
                        [ text "キャンセル" ]
                    ]
                ]
            ]
        , B.modalClose B.Large [ onClick <| ToggleModal False ] []
        ]


scanView : Html Msg
scanView =
    B.columns
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
            [ style "height" "320px"
            , id "quagga-display"
            ]
            []
        ]


inputView : Model -> Html Msg
inputView { timeZone, addingFood } =
    B.field []
        [ case addingFood.imageURL of
            Just url ->
                B.image (B.OneByOne B.X128)
                    []
                    [ img [ src url ] [] ]

            Nothing ->
                text ""
        , B.controlLabel [] [ text "名前" ]
        , B.controlInput B.controlInputModifiers
            []
            [ value addingFood.name
            , onInput <| ChangeValue FoodName
            ]
            []
        , B.controlLabel [] [ text "賞味期限" ]
        , B.connectedFields B.Left
            []
            [ B.controlInput B.controlInputModifiers
                []
                [ type_ "number"
                , Attr.min "1970"
                , Attr.max "2030"
                , placeholder "年"
                , onInput <| ChangeValue Year
                , addingFood.exp
                    |> Time.toYear timeZone
                    |> String.fromInt
                    |> value
                ]
                []
            , B.controlInput B.controlInputModifiers
                []
                [ type_ "number"
                , Attr.min "1"
                , Attr.max "12"
                , placeholder "月"
                , onInput <| ChangeValue Month
                , addingFood.exp
                    |> Time.toMonth timeZone
                    |> Util.monthToInt
                    |> String.fromInt
                    |> value
                ]
                []
            , B.controlInput B.controlInputModifiers
                []
                [ type_ "number"
                , Attr.min "1"
                , Attr.max "31"
                , placeholder "日"
                , onInput <| ChangeValue Day
                , addingFood.exp
                    |> Time.toDay timeZone
                    |> String.fromInt
                    |> value
                ]
                []
            ]
        , B.controlLabel [] [ text "個数" ]
        , B.controlInput B.controlInputModifiers
            []
            [ type_ "number"
            , onInput <| ChangeValue Amount
            , value <| String.fromInt addingFood.amount
            ]
            []
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
