port module Firebase exposing (createUser, getUser, message, signIn, signOut, successSignOut)

import Data.User exposing (User)
import Json.Decode as Decode


port createUser : ( String, String ) -> Cmd msg


port signIn : ( String, String ) -> Cmd msg


port signOut : () -> Cmd msg


port message : (Decode.Value -> msg) -> Sub msg


port getUser : (User -> msg) -> Sub msg


port successSignOut : (() -> msg) -> Sub msg
