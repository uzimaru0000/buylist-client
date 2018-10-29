module SignUp.Model exposing (Errors, Model, Msg(..), init)

import Browser.Navigation exposing (Key)


type alias Errors =
    { emailNotInput : Bool
    , passNotInput : Bool
    }


type alias Model =
    { email : Maybe String
    , pass : Maybe String
    , userName : Maybe String
    , key : Key
    , errors : Errors
    , isSubmit : Bool
    , isSuccess : Bool
    }


type Msg
    = EmailInput String
    | PassInput String
    | UsernameInput String
    | SignUp
    | SuccessCreateUser
    | ErrorCreateUser
    | NoOp


init : Key -> Model
init key =
    { email = Nothing
    , pass = Nothing
    , userName = Nothing
    , key = key
    , errors = Errors True True
    , isSubmit = False
    , isSuccess = False
    }
