module Box.Model exposing (Model, Msg(..), init)

import Data.Food exposing (Food)
import Time exposing (..)


type alias Model =
    { foods : List Food
    , modalToggle : Bool
    , timeZone : Zone
    }


type Msg
    = ToggleModal Bool


init : Zone -> Model
init timeZone =
    { foods =
        [ { name = "鶏肉"
          , exp = Time.millisToPosix 0
          , code = Nothing
          , amount = 1
          }
        , { name = "豚肉"
          , exp = Time.millisToPosix 0
          , code = Nothing
          , amount = 1
          }
        , { name = "牛肉"
          , exp = Time.millisToPosix 0
          , code = Nothing
          , amount = 1
          }
        ]
    , modalToggle = False
    , timeZone = timeZone
    }
