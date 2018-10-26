module Main.Model exposing (Model, Msg(..), Page(..), PageState(..), getPage, init)

import Browser exposing (UrlRequest(..))
import Browser.Navigation exposing (Key)
import Data.User as User exposing (User)
import Firebase
import Http exposing (Error)
import Json.Decode as Decode
import Result exposing (Result)
import SignIn.Model as SignIn
import SignUp.Model as SignUp
import Url exposing (Url)
import Url.Parser as Url exposing (Parser)
import Util exposing (..)


type alias Model =
    { key : Key
    , pageState : PageState
    , user : Maybe User
    }


type Msg
    = NoOp
    | UrlRequest UrlRequest
    | UrlChanged Url
    | GetData (Result Error String)
    | SignOut
    | GetUser Decode.Value
    | SuccessSignOut ()
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


init : Decode.Value -> Url -> Key -> ( Model, Cmd Msg )
init value url key =
    let
        user =
            Decode.decodeValue (Decode.nullable User.decoder) value
                |> Result.toMaybe
                |> Maybe.withDefault Nothing
    in
    ( { key = key
      , pageState = Loaded Home
      , user = user
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
