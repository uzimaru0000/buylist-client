module SignIn.Update exposing (update)

import Firebase
import SignIn.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailInput str ->
            ( { model | email = Just str }
            , Cmd.none
            )

        PassInput str ->
            ( { model | pass = Just str }
            , Cmd.none
            )

        SignIn ->
            case ( model.email, model.pass ) of
                ( Just email, Just pass ) ->
                    ( model
                    , Firebase.signIn ( email, pass )
                    )

                _ ->
                    ( model, Cmd.none )
