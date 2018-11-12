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
                | addingFood = food
                , currentMode = InputData
                , year =
                    food.exp
                        |> Time.toYear model.timeZone
                        |> String.fromInt
                , month =
                    food.exp
                        |> Time.toMonth model.timeZone
                        |> Util.monthToInt
                        |> String.fromInt
                , day =
                    food.exp
                        |> Time.toDay model.timeZone
                        |> String.fromInt
              }
            , stopReadCode ()
            )

        GetFood (Err err) ->
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
            ( { model | currentMode = mode }
            , case mode of
                ScanCode ->
                    readCode ()

                InputData ->
                    stopReadCode ()

                _ ->
                    Cmd.none
            )

        ChangeValue field str ->
            let
                newModel =
                    case field of
                        FoodName ->
                            { model | addingFood = Focus.set Food.name str model.addingFood }

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
            in
            ( newModel, Cmd.none )

        AddFood ->
            ( { model
                | foods = model.foods ++ [ Focus.set Food.code model.itemCode model.addingFood ]
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
                , currentMode = InputData
              }
            , Cmd.none
            )

        DeleteFood food ->
            ( { model
                | foods = List.filter ((/=) food) model.foods
              }
            , Cmd.none
            )


url : String
url =
    "http://localhost:5000/api/v1/food/"


getItemData : Int -> Http.Request Food
getItemData code =
    Http.get (url ++ String.fromInt code) Food.decoder


intToPosix : String -> String -> String -> Posix
intToPosix y m d =
    String.join "-" [ y, m, d ]
        ++ "T00:00:00+09:00"
        |> Iso8601.toTime
        |> Result.toMaybe
        |> Maybe.withDefault (millisToPosix 0)
