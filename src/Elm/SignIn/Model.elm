module SignIn.Model exposing (Model, Msg(..), init)

import Data.User exposing (User)


type alias Model =
    { email : String
    , pass : String
    , signInFail : Maybe Bool
    , errorMessage : String
    }


type Msg
    = EmailInput String
    | PassInput String
    | SignIn
    | SignInResult String


init : Model
init =
    { email = ""
    , pass = ""
    , signInFail = Nothing
    , errorMessage = ""
    }
