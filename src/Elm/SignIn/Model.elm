module SignIn.Model exposing (Model, Msg(..), init)

import Data.User exposing (User)


type alias Model =
    { email : String
    , pass : String
    , signInFail : Maybe Bool
    }


type Msg
    = EmailInput String
    | PassInput String
    | SignIn
    | SignInResult


init : Model
init =
    { email = ""
    , pass = ""
    , signInFail = Nothing
    }
