module Main.View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Main.Model exposing (..)
import SignIn.View as SignIn
import SignUp.View as SignUp


view : Model -> Document Msg
view model =
    case getPage model.pageState of
        Home ->
            { title = "Home"
            , body =
                [ h1 [] [ text "Home" ]
                , div [] [ a [ href "/signin" ] [ text "SignIn" ] ]
                , div [] [ a [ href "/signup"] [ text "SignUp" ] ]
                , div [] [ a [ href "/public" ] [ text "public" ] ]
                , div [] [ a [ href "/private" ] [ text "private" ] ]
                ]
            }

        Public str ->
            { title = "PublicPage"
            , body =
                [ h1 [] [ text "PublicPage" ]
                , div [] [ text str ]
                , div [] [ a [ href "/" ] [ text "home" ] ]
                ]
            }

        Private str ->
            { title = "PrivatePage"
            , body =
                [ h1 [] [ text "PrivatePage" ]
                , div [] [ text str ]
                , div [] [ a [ href "/" ] [ text "home" ] ]
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
