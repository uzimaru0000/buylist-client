module SignIn.Update exposing (update)

import Browser.Navigation as Nav
import Firebase
import SignIn.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailInput str ->
            ( { model | email = Just str }, Cmd.none )

        PassInput str ->
            ( { model | pass = Just str }, Cmd.none )

        SignIn ->
            case ( model.email, model.pass ) of
                ( Just email, Just pass ) ->
                    ( model, Firebase.createUser ( email, pass ) )

                _ ->
                    ( model, Cmd.none )

        SuccessCreateUser ->
            ( model, Nav.load "/" )

        _ ->
            ( model, Cmd.none )
