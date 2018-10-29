module SignIn.View exposing (view)

import Bulma.Columns as B exposing (columnModifiers, columnsModifiers)
import Bulma.Components as B
import Bulma.Elements as B exposing (buttonModifiers)
import Bulma.Form as B exposing (controlInputModifiers)
import Bulma.Layout as B
import Bulma.Modifiers as B
import Bulma.Modifiers.Typography as BT
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SignIn.Model exposing (..)


view : Model -> Html Msg
view model =
    B.section B.Spaced
        []
        [ signIn model
        ]


signIn : Model -> Html Msg
signIn model =
    B.columns { columnsModifiers | centered = True }
        [ BT.textCentered ]
        [ B.column { columnModifiers | widths = widths }
            []
            [ B.box
                []
                [ B.image (B.OneByOne B.X128)
                    [ class "logo-icon"
                    ]
                    [ img [ src "assets/Logo/logo_pig.png" ] []
                    ]
                , B.title
                    B.H3
                    []
                    [ text "SignIn"
                    ]
                , if model.signInFail |> Maybe.withDefault False then
                    B.field []
                        [ B.controlLabel
                            [ BT.textColor BT.Danger
                            ]
                            [ text "email or password is incorrect."
                            ]
                        ]

                  else
                    text ""
                , B.field []
                    [ B.controlEmail
                        { controlInputModifiers
                            | size = B.Large
                            , state = inputState model.signInFail
                            , disabled = model.signInFail |> Maybe.map not |> Maybe.withDefault False
                            , iconLeft = Just ( B.Medium, [], i [ class "fas fa-envelope" ] [] )
                        }
                        []
                        [ onInput EmailInput
                        , placeholder "Your Email"
                        ]
                        []
                    ]
                , B.field []
                    [ B.controlPassword
                        { controlInputModifiers
                            | size = B.Large
                            , state = inputState model.signInFail
                            , disabled = model.signInFail |> Maybe.map not |> Maybe.withDefault False
                            , iconLeft = Just ( B.Medium, [], i [ class "fas fa-key" ] [] )
                        }
                        []
                        [ onInput PassInput
                        , placeholder "Your Password"
                        ]
                        []
                    ]
                , B.field []
                    [ B.controlButton { buttonModifiers | color = B.Primary, size = B.Medium }
                        []
                        [ onClick SignIn
                        , B.fullWidth
                        ]
                        [ text "SignIn" ]
                    ]
                ]
            , B.content B.Standard
                []
                [ a [ href "/signup" ] [ text "SignUp" ]
                , text " / "
                , a [ href "/" ] [ text "Forget Password" ]
                ]
            ]
        ]


inputState : Maybe Bool -> B.State
inputState maybeFail =
    case maybeFail of
        Just False ->
            B.Loading

        _ ->
            B.Blur


widths : B.Devices (Maybe B.Width)
widths =
    { mobile = Just B.Width5
    , tablet = Just B.Width5
    , desktop = Just B.Width5
    , fullHD = Just B.Width5
    , widescreen = Just B.Width5
    }
