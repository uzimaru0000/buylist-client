port module Util exposing (UniqueData, Updater, alert, uniqueDataDecoder)

import Bulma.Components as Bulma exposing (NavbarBurger, navbarModifiers)
import Bulma.Elements as Bulma exposing (TitleSize(..))
import Bulma.Modifiers as Bulma
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
