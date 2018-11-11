module Box.Update exposing (update)

import Box.Model exposing (..)
import Data.Food as Food exposing (Food)
import Http
import Json.Decode as JD
import Port exposing (..)
import Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleModal bool ->
            ( { model
                | modalToggle = bool
                , itemCode = Nothing
                , addingFood = Nothing
              }
            , if bool then
                readCode ()

              else
                stopReadCode ()
            )

        GetCode code ->
            ( { model | itemCode = Just code }, getItemData code |> Http.send GetFood )

        GetFood (Ok value) ->
            ( { model
                | addingFood =
                    Just
                        { name = Tuple.first value
                        , imageURL = Just <| Tuple.second value
                        , exp = Time.millisToPosix 0
                        , amount = 1
                        }
              }
            , Cmd.none
            )

        GetFood (Err err) ->
            Debug.todo <| Debug.toString err


url : String
url =
    "http://localhost:5000/api/v1/food/"


getItemData : Int -> Http.Request ( String, String )
getItemData code =
    let
        decoder =
            JD.map2 Tuple.pair
                (JD.field "name" JD.string)
                (JD.field "imageURL" JD.string)
    in
    Http.get (url ++ String.fromInt code) decoder
