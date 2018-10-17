module Data.Study exposing (Mode(..), request)

import Http exposing (..)


type Mode
    = Public
    | Private String


request : Mode -> Request String
request mode =
    case mode of
        Public ->
            getString "http://localhost:5000/public"

        Private jwt ->
            Http.request
                { method = "GET"
                , headers = [ header "Authorization" <| String.join " " [ "Bearer", jwt ] ]
                , url = "http://localhost:5000/private"
                , body = emptyBody
                , expect = expectString
                , timeout = Nothing
                , withCredentials = False
                }
