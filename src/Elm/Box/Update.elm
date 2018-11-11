module Box.Update exposing (update)

import Box.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleModal bool ->
            ( { model | modalToggle = bool }, Cmd.none )
