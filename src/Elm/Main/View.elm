module Main.View exposing (view)

import Browser exposing (Document)
import Bulma.Components as B
import Bulma.Elements as B exposing (buttonModifiers)
import Bulma.Layout as B
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography as BT
import Home.View as Home
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Main.Model exposing (..)
import SignIn.View as SignIn
import SignUp.View as SignUp
import Util


view : Model -> Document Msg
view model =
    case getPage model.pageState of
        Home ->
            { title = "Home"
            , body =
                [ Home.view
                , generalFooter
                ]
            }

        SignIn subModel ->
            { title = "SignIn"
            , body =
                [ SignIn.view subModel
                    |> Html.map SignInMsg
                ]
            }

        SignUp subModel ->
            { title = "SignUp"
            , body =
                [ SignUp.view subModel
                    |> Html.map SignUpMsg
                ]
            }

        _ ->
            { title = "NotFound"
            , body = [ h1 [] [ text "NotFound" ] ]
            }


generalFooter : Html msg
generalFooter =
    B.footer []
        [ B.container []
            [ p [] [ text "Footer" ] ]
        ]
