module SignUp.View exposing (..)

import SignUp.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "SignIn" ]
        , div []
            [ input
                [ placeholder "Email"
                , onInput EmailInput
                ]
                []
            ]
        , div []
            [ input
                [ placeholder "password"
                , type_ "password"
                , onInput PassInput
                ]
                []
            ]
        , div []
            [ button
                [ onClick SignUp ]
                [ text "SignUp" ]
            ]
        , div []
            [ a [ href "/signin" ]
                [ text "SignIn" ]
            ]
        , div []
            [ a [ href "/" ]
                [ text "Home" ]
            ]
        ]
