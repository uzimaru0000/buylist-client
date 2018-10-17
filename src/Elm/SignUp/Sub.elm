module SignUp.Sub exposing (subscriptions)

import Firebase
import Json.Decode as Decode
import SignUp.Model exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    (\v ->
        case Decode.decodeValue Decode.string v of
            Ok "Success" ->
                SuccessCreateUser

            Ok "Error" ->
                ErrorCreateUser

            _ ->
                NoOp
    )
        |> Firebase.message
