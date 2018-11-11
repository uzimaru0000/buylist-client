module Routing exposing (Route(..), parseUrl, routing)

import Url exposing (Url)
import Url.Parser as Url exposing (Parser)


type Route
    = Home
    | SignUp
    | SignIn
    | Box
    | NotFound


routing : Parser (Route -> a) a
routing =
    Url.oneOf
        [ Url.map SignUp (Url.s "signup")
        , Url.map SignIn (Url.s "signin")
        , Url.map Box (Url.s "pantry")
        , Url.map Home Url.top
        ]


parseUrl : Url -> Route
parseUrl url =
    Maybe.withDefault NotFound (Url.parse routing url)
