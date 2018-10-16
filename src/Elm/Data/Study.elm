module Data.Study exposing (Mode(..), request)

import Http exposing (..)


type Mode
    = Public
    | Private


request : Mode -> Request String
request mode =
    case mode of
        Public ->
            getString "http://localhost:5000/public"

        Private ->
            getString "http://localhost:5000/private"
