module SignIn.Model exposing (Model, Msg(..), init)

import Data.User exposing (User)


type alias Model =
    { email : Maybe String
    , pass : Maybe String
    }


type Msg
    = EmailInput String
    | PassInput String
    | SignIn


init : Model
init =
    { email = Nothing
    , pass = Nothing
    }
