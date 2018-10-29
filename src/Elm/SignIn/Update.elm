module SignIn.Update exposing (update)

import Firebase
import SignIn.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailInput str ->
            ( { model | email = str }
            , Cmd.none
            )

        PassInput str ->
            ( { model | pass = str }
            , Cmd.none
            )

        SignIn ->
            ( { model | signInFail = Just False }
            , Firebase.signIn ( model.email, model.pass )
            )

        SignInResult err ->
            ( { model | errorMessage = err, signInFail = Just True }
            , Cmd.none
            )
