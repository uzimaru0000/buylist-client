module SignUp.Update exposing (update)

import Browser.Navigation as Nav
import Firebase
import SignUp.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailInput str ->
            let
                newModel =
                    { model | email = Just str }
            in
            ( { newModel | errors = errorCheck newModel }, Cmd.none )

        PassInput str ->
            let
                newModel =
                    { model | pass = Just str }
            in
            ( { newModel | errors = errorCheck newModel }, Cmd.none )

        SignUp ->
            if allGreen model.errors then
                case ( model.email, model.pass ) of
                    ( Just email, Just pass ) ->
                        ( { model | isSubmit = True }
                        , Firebase.createUser ( email, pass )
                        )

                    _ ->
                        ( model, Cmd.none )

            else
                ( model, Cmd.none )

        SuccessCreateUser ->
            ( { model | isSuccess = True }, Cmd.none )

        _ ->
            ( model, Cmd.none )


errorCheck : Model -> Errors
errorCheck model =
    { emailNotInput =
        model.email
            |> Maybe.map String.isEmpty
            |> Maybe.withDefault False
    , passNotInput =
        model.pass
            |> Maybe.map String.isEmpty
            |> Maybe.withDefault False
    }


allGreen : Errors -> Bool
allGreen { emailNotInput, passNotInput } =
    emailNotInput
        || passNotInput
        |> not
