module Data.User exposing (User, userDecoder)

import Json.Decode as Decode exposing (Decoder)


type alias User =
    { name : String
    , email : String
    }


userDecoder : Decoder User
userDecoder =
    Decode.map2 User
        (Decode.field "name" Decode.string)
        (Decode.field "email" Decode.string)
