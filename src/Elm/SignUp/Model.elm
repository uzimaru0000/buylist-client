module SignUp.Model exposing (..)


type alias Model =
    { email : Maybe String
    , pass : Maybe String
    }


type Msg
    = EmailInput String
    | PassInput String
    | SignUp
    | ScusessSignUp
    | ErrorSignUp


init : Model
init =
    { email = Nothing
    , pass = Nothing
    }
