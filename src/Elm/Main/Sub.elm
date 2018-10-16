module Main.Sub exposing (..)

import Main.Model exposing (..)
import SignIn.Sub as SignIn


subscriptions : Model -> Sub Msg
subscriptions model =
    case getPage model.pageState of
        SignIn subModel ->
            SignIn.subscriptions subModel
                |> Sub.map SignInMsg

        _ ->
            Sub.none
