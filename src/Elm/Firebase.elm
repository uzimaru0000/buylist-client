port module Firebase exposing (..)

import Json.Decode as Decode


port createUser : ( String, String ) -> Cmd msg


port signUp : ( String, String ) -> Cmd msg


port message : (Decode.Value -> msg) -> Sub msg
