module Main.Model exposing (Model, Msg(..), Page(..), PageState(..), getPage, init)

import Box.Model as Box
import Browser exposing (UrlRequest(..))
import Browser.Navigation exposing (Key)
import Bulma.Components exposing (IsActive)
import Data.User as User exposing (User)
import Firebase
import Http exposing (Error)
import Json.Decode as Decode
import SignIn.Model as SignIn
import SignUp.Model as SignUp
import Task
import Time
import Url exposing (Url)
import Url.Parser as Url exposing (Parser)
import Util exposing (..)


type alias Model =
    { key : Key
    , pageState : PageState
    , user : Maybe User
    , isActive : IsActive
    }


type Msg
    = NoOp
    | UrlRequest UrlRequest
    | UrlChanged Url
    | ToggleBurger
    | SignOut
    | GetUser Decode.Value
    | SuccessSignOut ()
    | SignInMsg SignIn.Msg
    | SignUpMsg SignUp.Msg
    | BoxInit Time.Zone
    | BoxMsg Box.Msg


type Page
    = Home
    | SignUp SignUp.Model
    | SignIn SignIn.Model
    | Box Box.Model
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
      , isActive = False
      }
    , Task.succeed url
        |> Task.perform UrlChanged
    )


getPage : PageState -> Page
getPage state =
    case state of
        Loaded page ->
            page

        Transition page ->
            page
