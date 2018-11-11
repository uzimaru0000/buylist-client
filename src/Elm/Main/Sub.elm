module Main.Sub exposing (subscriptions)

import Box.Sub as Box
import Firebase
import Main.Model exposing (..)
import SignIn.Sub as SignIn
import SignUp.Sub as SignUp


subscriptions : Model -> Sub Msg
subscriptions model =
    [ case getPage model.pageState of
        SignUp subModel ->
            SignUp.subscriptions subModel
                |> Sub.map SignUpMsg

        SignIn subModel ->
            SignIn.subscriptions subModel
                |> Sub.map SignInMsg

        Box subModel ->
            Box.subscriptions subModel
                |> Sub.map BoxMsg

        _ ->
            Sub.none
    , Firebase.getUser GetUser
    , Firebase.successSignOut SuccessSignOut
    ]
        |> Sub.batch
