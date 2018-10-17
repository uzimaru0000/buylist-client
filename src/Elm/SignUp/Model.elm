module SignUp.Model exposing (Model, Msg(..), init)

import Browser.Navigation exposing (Key)


type alias Model =
    { email : Maybe String
    , pass : Maybe String
    , key : Key
    }


type Msg
    = EmailInput String
    | PassInput String
    | SignUp
    | SuccessCreateUser
    | ErrorCreateUser
    | NoOp


init : Key -> Model
init key =
    { email = Nothing
    , pass = Nothing
    , key = key
    }
