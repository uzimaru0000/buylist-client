port module Util exposing (UniqueData, Updater, alert, monthToInt, uniqueDataDecoder)

import Bulma.Components as B exposing (NavbarBurger, navbarModifiers)
import Bulma.Elements as B exposing (TitleSize(..))
import Bulma.Modifiers as B
import Html exposing (..)
import Html.Attributes exposing (src)
import Json.Decode as Decode exposing (Decoder)
import Time exposing (Month(..))


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


monthToInt : Time.Month -> Int
monthToInt month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12
