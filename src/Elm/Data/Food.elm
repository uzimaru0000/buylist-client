module Data.Food exposing (Food, amount, code, decoder, exp, imageURL, name, zero)

import Focus exposing (..)
import Json.Decode as JD
import Time exposing (..)


type alias Food =
    { name : String
    , exp : Posix
    , imageURL : Maybe String
    , amount : Int
    , code : Maybe Int
    }


zero : Food
zero =
    { name = ""
    , exp = millisToPosix 0
    , imageURL = Nothing
    , amount = 1
    , code = Nothing
    }


decoder : JD.Decoder Food
decoder =
    JD.map5 Food
        (JD.field "name" JD.string)
        (JD.field "exp" <| JD.map millisToPosix JD.int)
        (JD.field "imageURL" <| JD.nullable JD.string)
        (JD.field "amount" JD.int)
        (JD.nullable <| JD.field "code" JD.int)



-- FOCI


name : Focus { r | name : a } a
name =
    create .name (\f r -> { r | name = f r.name })


exp : Focus { r | exp : a } a
exp =
    create .exp (\f r -> { r | exp = f r.exp })


imageURL : Focus { r | imageURL : a } a
imageURL =
    create .imageURL (\f r -> { r | imageURL = f r.imageURL })


amount : Focus { r | amount : a } a
amount =
    create .amount (\f r -> { r | amount = f r.amount })


code : Focus { r | code : a } a
code =
    create .code (\f r -> { r | code = f r.code })
