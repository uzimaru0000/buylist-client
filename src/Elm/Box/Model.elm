module Box.Model exposing (Model, Msg(..), init)

import Data.Food exposing (Food)
import Http
import Time exposing (..)


type alias Model =
    { foods : List Food
    , modalToggle : Bool
    , timeZone : Zone
    , itemCode : Maybe Int
    , addingFood : Maybe Food
    }


type Msg
    = ToggleModal Bool
    | GetCode Int
    | GetFood (Result Http.Error ( String, String ))


init : Zone -> Model
init timeZone =
    { foods =
        [ { name = "鶏肉"
          , exp = Time.millisToPosix 0
          , imageURL = Nothing
          , amount = 1
          }
        , { name = "豚肉"
          , exp = Time.millisToPosix 0
          , imageURL = Nothing
          , amount = 1
          }
        , { name = "牛肉"
          , exp = Time.millisToPosix 0
          , imageURL = Nothing
          , amount = 1
          }
        ]
    , modalToggle = False
    , timeZone = timeZone
    , itemCode = Nothing
    , addingFood = Nothing
    }
