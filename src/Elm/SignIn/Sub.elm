module SignIn.Sub exposing (subscriptions)

import Firebase
import SignIn.Model exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    always SignInResult
        |> Firebase.message
