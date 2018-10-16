module SignUp.Update exposing (..)

import SignUp.Model exposing (..)
import Firebase


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

        SignUp ->
            case ( model.email, model.pass ) of
                ( Just email, Just pass ) ->
                    ( model
                    , Firebase.signUp ( email, pass )
                    )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
