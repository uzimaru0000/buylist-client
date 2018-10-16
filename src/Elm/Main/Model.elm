module Main.Model exposing (Model, Msg(..), Page(..), PageState(..), getPage, init)

import Browser exposing (UrlRequest(..))
import Browser.Navigation exposing (Key)
import Firebase
import Http exposing (Error)
import Result exposing (Result)
import SignIn.Model as SignIn
import SignUp.Model as SignUp
import Url exposing (Url)
import Url.Parser as Url exposing (Parser)


type alias Model =
    { key : Key
    , pageState : PageState
    , msg : String
    }


type Msg
    = NoOp
    | UrlRequest UrlRequest
    | UrlChanged Url
    | GetData (Result Error String)
    | SignInMsg SignIn.Msg
    | SignUpMsg SignUp.Msg


type Page
    = Home
    | SignUp SignUp.Model
    | SignIn SignIn.Model
    | Private String
    | Public String
    | NotFound


type PageState
    = Loaded Page
    | Transition Page


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key
      , msg = ""
      , pageState = Loaded Home
      }
    , Cmd.none
    )


getPage : PageState -> Page
getPage state =
    case state of
        Loaded page ->
            page

        Transition page ->
            page
