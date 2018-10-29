port module Util exposing (UniqueData, Updater, alert, uniqueDataDecoder)

import Bulma.Components as B exposing (NavbarBurger, navbarModifiers)
import Bulma.Elements as B exposing (TitleSize(..))
import Bulma.Modifiers as B
import Html exposing (..)
import Html.Attributes exposing (src)
import Json.Decode as Decode exposing (Decoder)


type alias UniqueData a =
    { uid : String
    , asset : a
    }


type alias Updater a b =
    a -> b -> ( b, Cmd a )


uniqueDataDecoder : Decoder a -> Decoder (UniqueData a)
uniqueDataDecoder decoder =
    Decode.map2 UniqueData
        (Decode.field "uid" Decode.string)
        (Decode.field "asset" decoder)


port alert : String -> Cmd msg
