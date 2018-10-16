module Main.Update exposing (update)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Data.Study as Study
import Http
import Main.Model exposing (..)
import Routing exposing (Route)
import Url
import Util exposing (Updater)
import SignIn.Model as SignIn
import SignIn.Update as SignIn
import SignUp.Model as SignUp
import SignUp.Update as SignUp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequest request ->
            case request of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            let
                ( state, cmd ) =
                    pageInit model <| Routing.parseUrl url
            in
                ( { model | pageState = state }
                , cmd
                )

        GetData (Ok res) ->
            let
                state =
                    case getPage model.pageState of
                        Public _ ->
                            Loaded <| Public res

                        Private _ ->
                            Loaded <| Private res

                        _ ->
                            Loaded Home
            in
                ( { model | pageState = state }
                , Cmd.none
                )

        _ ->
            pageUpdate (getPage model.pageState) msg model


pageUpdate : Page -> Msg -> Model -> ( Model, Cmd Msg )
pageUpdate page msg model =
    case ( msg, page ) of
        ( SignInMsg subMsg, SignIn subModel ) ->
            pageUpdater model SignIn SignInMsg subMsg subModel SignIn.update
        
        ( SignUpMsg subMsg, SignUp subModel ) ->
            pageUpdater model SignUp SignUpMsg subMsg subModel SignUp.update

        _ ->
            ( model, Cmd.none )


pageUpdater :
    Model ->
    (subModel -> Page) -> 
    (subMsg -> Msg) -> 
    subMsg -> 
    subModel -> 
    Updater subMsg subModel ->
    (Model, Cmd Msg)
pageUpdater model page msg subMsg subModel updater =
    let
        ( newModel, newCmd) =
            updater subMsg subModel
    in
        ( { model | pageState = Loaded <| page newModel }
        , Cmd.map msg newCmd
        )


pageInit : Model -> Route -> ( PageState, Cmd Msg )
pageInit model route =
    case route of
        Routing.Home ->
            ( Loaded Home, Cmd.none )

        Routing.SignIn ->
            ( Loaded <| SignIn <| SignIn.init model.key, Cmd.none )

        Routing.SignUp ->
            ( Loaded <| SignUp SignUp.init, Cmd.none )

        Routing.Private ->
            ( Transition <| Private "", Http.send GetData (Study.request Study.Private) )

        Routing.Public ->
            ( Transition <| Public "", Http.send GetData (Study.request Study.Public) )

        Routing.NotFound ->
            ( Loaded NotFound, Cmd.none )
