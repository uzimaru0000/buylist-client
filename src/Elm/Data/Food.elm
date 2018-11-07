module Data.Food exposing (Food)

import Json.Decode as JD
import Time exposing (..)


type alias Food =
    { name : String
    , exp : Posix
    , code : Maybe Int
    , amount : Int
    }


decoder : JD.Decoder Food
decoder =
    JD.map4 Food
        (JD.field "name" JD.string)
        (JD.field "exp" <| JD.map millisToPosix JD.int)
        (JD.field "code" (JD.maybe JD.int))
        (JD.field "amount" JD.int)
