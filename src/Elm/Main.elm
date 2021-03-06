module Main exposing (main)

import Browser exposing (..)
import Html exposing (Html, text)
import Json.Decode as Decode
import Main.Model exposing (..)
import Main.Sub exposing (..)
import Main.Update exposing (..)
import Main.View exposing (..)
import SignIn.Sub as SignIn


main : Program Decode.Value Model Msg
main =
    application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequest
        }
