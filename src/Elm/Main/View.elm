module Main.View exposing (view)

import Box.View as Box
import Browser exposing (Document)
import Bulma.Components as B exposing (IsActive, navbarModifiers)
import Bulma.Elements as B exposing (buttonModifiers)
import Bulma.Layout as B
import Bulma.Modifiers as B
import Bulma.Modifiers.Typography as BT
import Data.User as User
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
                [ generalNavbar model.isActive
                    (case model.user of
                        Just user ->
                            [ B.hoverableNavbarItemDropdown
                                B.Down
                                []
                                (B.navbarItemLink False [] [ User.view user NoOp ])
                                [ B.navbarDropdown False B.Right [] []
                                ]
                            ]

                        Nothing ->
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
                    )
                , Home.view
                , generalFooter
                ]
            }

        SignIn subModel ->
            { title = "SignIn"
            , body =
                [ generalNavbar model.isActive []
                , SignIn.view subModel
                    |> Html.map SignInMsg
                ]
            }

        SignUp subModel ->
            { title = "SignUp"
            , body =
                [ generalNavbar model.isActive []
                , SignUp.view subModel
                    |> Html.map SignUpMsg
                ]
            }

        Box subModel ->
            { title = "Pantry"
            , body =
                [ generalNavbar model.isActive []
                , Box.view subModel
                    |> Html.map BoxMsg
                ]
            }

        _ ->
            { title = "NotFound"
            , body = [ h1 [] [ text "NotFound" ] ]
            }


generalNavbar : IsActive -> List (Html Msg) -> Html Msg
generalNavbar isActive items =
    B.navbar { navbarModifiers | color = B.Primary }
        []
        [ B.navbarBrand []
            (if List.length items > 0 then
                div
                    [ onClick ToggleBurger
                    , classList
                        [ ( "navbar-burger", True )
                        , ( "is-active", isActive )
                        ]
                    ]
                    [ span [] []
                    , span [] []
                    , span [] []
                    ]

             else
                text ""
            )
            [ B.navbarItemLink False
                [ href "/" ]
                [ text "Pantry" ]
            ]
        , B.navbarMenu isActive
            [ class "has-background-primary" ]
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
