module SignIn.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SignIn.Model exposing (..)


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
                [ onClick SignIn ]
                [ text "SignIn" ]
            ]
        , div []
            [ a [ href "/signup" ]
                [ text "SignUp" ]
            ]
        , div []
            [ a [ href "/" ]
                [ text "Home" ]
            ]
        ]
