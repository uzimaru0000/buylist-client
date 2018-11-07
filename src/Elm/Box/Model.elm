module Box.Model exposing (Model)

import Data.Food exposing (Food)


type alias Model =
    { foods : List Food
    , modalToggle : Bool
    }


type Msg
    = ToggleModal Bool


init : Model
init =
    { foods = []
    , modalToggle = False
    }
