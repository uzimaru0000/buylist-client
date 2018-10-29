module SignIn.Sub exposing (subscriptions)

import Firebase
import Json.Decode
import SignIn.Model exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    (\v ->
        v
            |> Json.Decode.decodeValue Json.Decode.string
            |> Result.map SignInResult
            |> Result.toMaybe
            |> Maybe.withDefault (SignInResult "")
    )
        |> Firebase.message
