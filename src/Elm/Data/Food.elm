module Data.Food exposing (Food, decoder)

import Json.Decode as JD
import Time exposing (..)


type alias Food =
    { name : String
    , exp : Posix
    , imageURL : Maybe String
    , amount : Int
    }


decoder : JD.Decoder Food
decoder =
    JD.map4 Food
        (JD.field "name" JD.string)
        (JD.field "exp" <| JD.map millisToPosix JD.int)
        (JD.field "imageURL" <| JD.nullable JD.string)
        (JD.field "amount" JD.int)
