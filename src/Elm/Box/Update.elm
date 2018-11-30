module Box.Update exposing (update)

import Box.Model exposing (..)
import Data.Food as Food exposing (Food)
import Focus
import Http
import Iso8601 exposing (..)
import Json.Decode as JD
import Port exposing (..)
import Time exposing (..)
import Util


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleModal bool ->
            ( { model
                | modalToggle = bool
                , itemCode = Nothing
                , addingFood = Food.zero
                , currentMode = ScanCode
              }
            , if bool then
                readCode ()

              else
                stopReadCode ()
            )

        GetCode code ->
            ( { model | itemCode = Just code }
            , getItemData code |> Http.send GetFood
            )

        GetFood (Ok food) ->
            ( { model
                | addingFood =
                    model.foods
                        |> List.filter (isSameFood food)
                        |> List.head
                        |> Maybe.withDefault food
                , currentMode = InputData
                , year =
                    food.exp
                        |> Maybe.map
                            (Time.toYear model.timeZone >> String.fromInt)
                        |> Maybe.withDefault "2018"
                , month =
                    food.exp
                        |> Maybe.map
                            (Time.toMonth model.timeZone
                                >> Util.monthToInt
                                >> String.fromInt
                            )
                        |> Maybe.withDefault "1"
                , day =
                    food.exp
                        |> Maybe.map (Time.toDay model.timeZone >> String.fromInt)
                        |> Maybe.withDefault "1"
              }
            , stopReadCode ()
            )

        GetFood (Err err) ->
            let
                a =
                    Debug.log "" err
            in
            ( { model
                | itemCode = Nothing
                , addingFood = Food.zero
              }
            , readCode ()
            )

        RereadCode ->
            ( { model
                | itemCode = Nothing
                , addingFood = Food.zero
              }
            , readCode ()
            )

        ChangeMode mode ->
            ( { model
                | currentMode = mode
                , addingFood =
                    if mode /= UpdateData then
                        Food.zero

                    else
                        model.addingFood
              }
            , case mode of
                ScanCode ->
                    readCode ()

                InputData ->
                    stopReadCode ()

                _ ->
                    Cmd.none
            )

        ChangeValue field str ->
            ( inputFoodData model field str, Cmd.none )

        AddFood ->
            ( { model
                | foods = updateFoodList model.foods (Focus.set Food.code model.itemCode model.addingFood)
                , addingFood = Food.zero
                , itemCode = Nothing
                , modalToggle = False
                , currentMode = ScanCode
              }
            , stopReadCode ()
            )

        UpdateFood food ->
            ( { model
                | addingFood = food
                , modalToggle = True
                , currentMode = UpdateData
              }
            , Cmd.none
            )

        DeleteFood food ->
            ( { model
                | foods = List.filter ((/=) food) model.foods
              }
            , Cmd.none
            )


inputFoodData : Model -> FormField -> String -> Model
inputFoodData model field str =
    case field of
        FoodName ->
            { model
                | addingFood =
                    model.foods
                        |> List.filter (isSameFood <| Focus.set Food.name str model.addingFood)
                        |> List.head
                        |> Maybe.withDefault (Focus.set Food.name str model.addingFood)
                , currentMode =
                    if List.any (isSameFood <| Focus.set Food.name str model.addingFood) model.foods then
                        UpdateData

                    else
                        InputData
            }

        Year ->
            { model
                | addingFood =
                    Focus.set
                        Food.exp
                        (intToPosix str model.month model.day)
                        model.addingFood
                , year = str
            }

        Month ->
            { model
                | addingFood =
                    Focus.set
                        Food.exp
                        (intToPosix model.year str model.day)
                        model.addingFood
                , month = str
            }

        Day ->
            { model
                | addingFood =
                    Focus.set
                        Food.exp
                        (intToPosix model.year model.month str)
                        model.addingFood
                , day = str
            }

        Amount ->
            { model
                | addingFood =
                    Focus.set
                        Food.amount
                        (String.toInt str |> Maybe.withDefault 1)
                        model.addingFood
            }


url : String
url =
    "http://localhost:5000/api/v1/food/"


getItemData : Int -> Http.Request Food
getItemData code =
    Http.get (url ++ String.fromInt code) Food.decoder


isSameFood : Food -> Food -> Bool
isSameFood food target =
    food.name == target.name && food.code == target.code


updateFoodList : List Food -> Food -> List Food
updateFoodList list food =
    if List.any (isSameFood food) list then
        List.map
            (\f ->
                if isSameFood food f then
                    food

                else
                    f
            )
            list

    else
        list ++ [ food ]


zeroPadding : String -> String
zeroPadding n =
    if String.length n == 1 then
        "0" ++ n

    else
        n


intToPosix : String -> String -> String -> Maybe Posix
intToPosix y m d =
    String.join "-" [ y, zeroPadding m, zeroPadding d ]
        ++ "T00:00:00+09:00"
        |> Iso8601.toTime
        |> Result.toMaybe
