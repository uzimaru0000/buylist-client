module Main.View exposing (view)

import Browser exposing (Document)
import Bulma.Components as B exposing (IsActive, navbarModifiers)
import Bulma.Elements as B exposing (buttonModifiers)
import Bulma.Layout as B
import Bulma.Modifiers as B
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
                [ generalNavbar False
                    [ B.navbarItem False
                        []
                        [ B.buttons B.Left
                            []
                            [ a
                                [ BT.textColor BT.BlackLighter
                                , class "button is-warning"
                                , href "/signup"
                                ]
                                [ text "SignUp" ]
                            , a
                                [ class "button is-primary"
                                , href "/signin"
                                ]
                                [ text "SignIn" ]
                            ]
                        ]
                    ]
                , Home.view
                , generalFooter
                ]
            }

        SignIn subModel ->
            { title = "SignIn"
            , body =
                [ generalNavbar False []
                , SignIn.view subModel
                    |> Html.map SignInMsg
                , generalFooter
                ]
            }

        SignUp subModel ->
            { title = "SignUp"
            , body =
                [ generalNavbar False []
                , SignUp.view subModel
                    |> Html.map SignUpMsg
                , generalFooter
                ]
            }

        _ ->
            { title = "NotFound"
            , body = [ h1 [] [ text "NotFound" ] ]
            }


generalNavbar : IsActive -> List (Html msg) -> Html msg
generalNavbar isActive items =
    B.navbar { navbarModifiers | color = B.Primary }
        []
        [ B.navbarBrand []
            (B.navbarBurger isActive
                []
                [ span [] []
                , span [] []
                , span [] []
                ]
            )
            [ B.navbarItemLink False
                [ href "/" ]
                [ text "Pantry" ]
            ]
        , B.navbarMenu isActive
            []
            [ B.navbarEnd []
                items
            ]
        ]


generalFooter : Html msg
generalFooter =
    B.footer []
        [ B.container []
            [ p [] [ text "Footer" ] ]
        ]
