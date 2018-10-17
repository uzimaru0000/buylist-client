module Data.User exposing (User, decoder)

import Json.Decode as Decode exposing (Decoder)


type alias User =
    { uid : String
    , email : String
    , jwt : String
    }


decoder : Decoder User
decoder =
    Decode.map3 User
        (Decode.field "uid" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "qa" Decode.string)
