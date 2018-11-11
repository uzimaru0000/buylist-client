module Box.Sub exposing (subscriptions)

import Box.Model exposing (..)
import Port exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    getCode GetCode
