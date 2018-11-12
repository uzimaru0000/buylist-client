module Box.Model exposing (FormField(..), Mode(..), Model, Msg(..), init)

import Data.Food as Food exposing (Food, zero)
import Focus exposing (Focus, create)
import Http
import Time exposing (..)


type alias Model =
    { foods : List Food
    , modalToggle : Bool
    , timeZone : Zone
    , itemCode : Maybe Int
    , addingFood : Food
    , currentMode : Mode
    , year : String
    , month : String
    , day : String
    }


type Msg
    = ToggleModal Bool
    | GetCode Int
    | GetFood (Result Http.Error Food)
    | RereadCode
    | ChangeMode Mode
    | ChangeValue FormField String
    | AddFood
    | UpdateFood Food
    | DeleteFood Food


type Mode
    = ScanCode
    | InputData
    | UpdateData


type FormField
    = FoodName
    | Year
    | Month
    | Day
    | Amount


init : Zone -> Model
init timeZone =
    { foods =
        [ { zero | name = "うどん", amount = 5 }
        ]
    , modalToggle = False
    , timeZone = timeZone
    , itemCode = Nothing
    , addingFood = Food.zero
    , currentMode = ScanCode
    , year = "1970"
    , month = "1"
    , day = "1"
    }



-- FOCI


addingFood : Focus { r | addingFood : a } a
addingFood =
    create .addingFood (\f r -> { r | addingFood = f r.addingFood })


year : Focus { r | year : a } a
year =
    create .year (\f r -> { r | year = f r.year })


month : Focus { r | month : a } a
month =
    create .month (\f r -> { r | month = f r.month })


day : Focus { r | day : a } a
day =
    create .day (\f r -> { r | day = f r.day })
