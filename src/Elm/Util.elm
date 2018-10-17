port module Util exposing (..)

import Json.Decode as Decode exposing (Decoder)


type alias UniqueData a =
    { uid : String
    , asset : a
    }


type alias Updater a b
    = a -> b -> (b, Cmd a)


uniqueDataDecoder : Decoder a -> Decoder (UniqueData a)
uniqueDataDecoder decoder =
    Decode.map2 UniqueData
        (Decode.field "uid" Decode.string)
        (Decode.field "asset" decoder)


port alert : String -> Cmd msg