module SignUp.View exposing (view)

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
import SignUp.Model exposing (..)


view : Model -> Html Msg
view model =
    B.section B.NotSpaced
        []
        [ if not model.isSuccess then
            emailAndPassForm model

          else
            successSignUp model
        ]


base : Model -> List (Html Msg) -> Html Msg
base model forms =
    B.columns { columnsModifiers | centered = True }
        []
        [ B.column { columnModifiers | widths = widths }
            [ style "margin" "64px 0 64px" ]
            [ B.box
                []
                ([ B.image (B.OneByOne B.X128)
                    [ class "logo-icon"
                    ]
                    [ img [ src "assets/Logo/logo_pig.png" ] []
                    ]
                 , B.title
                    B.H3
                    [ BT.textCentered ]
                    [ text "SignUp"
                    ]
                 ]
                    ++ forms
                )
            , B.content B.Standard
                [ BT.textCentered ]
                [ a [ href "/signin" ] [ text "SignIn" ]
                ]
            ]
        ]


emailAndPassForm : Model -> Html Msg
emailAndPassForm model =
    base model
        [ B.field []
            [ B.controlEmail
                { controlInputModifiers
                    | size = B.Large
                    , state =
                        if model.isSubmit then
                            B.Loading

                        else
                            B.Blur
                    , disabled = model.isSubmit
                    , iconLeft = Just ( B.Medium, [], i [ class "fas fa-envelope" ] [] )
                }
                []
                [ onInput EmailInput
                , placeholder "Email"
                , model.email |> Maybe.withDefault "" |> value
                ]
                []
            , if model.email /= Nothing && model.errors.emailNotInput then
                B.controlLabel [ BT.textColor BT.Danger ] [ text "Email has not been entered." ]

              else
                text ""
            ]
        , B.field []
            [ B.controlPassword
                { controlInputModifiers
                    | size = B.Large
                    , state =
                        if model.isSubmit then
                            B.Loading

                        else
                            B.Blur
                    , disabled = model.isSubmit
                    , iconLeft = Just ( B.Medium, [], i [ class "fas fa-key" ] [] )
                }
                []
                [ onInput PassInput
                , placeholder "Password"
                , model.pass |> Maybe.withDefault "" |> value
                ]
                []
            , if model.pass /= Nothing && model.errors.passNotInput then
                B.controlLabel [ BT.textColor BT.Danger ] [ text "Password has not been entered." ]

              else
                text ""
            ]
        , B.field []
            [ B.controlButton
                { buttonModifiers | size = B.Medium, color = B.Primary }
                []
                [ B.fullWidth
                , onClick SignUp
                ]
                [ text "SignUp" ]
            ]
        ]


successSignUp : Model -> Html Msg
successSignUp model =
    base model
        [ B.content B.Standard
            [ BT.textCentered ]
            [ p [] [ text "登録が完了しました！" ]
            , p [] [ text "Emailアドレスを確認した後、ログインしてください." ]
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
    { mobile = Just B.Auto
    , tablet = Just B.Auto
    , desktop = Just B.Width5
    , fullHD = Just B.Width5
    , widescreen = Just B.Width5
    }
