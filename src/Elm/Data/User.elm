module Data.User exposing (User, decoder, view)

import Bulma.Elements as B
import Bulma.Layout as B
import Bulma.Modifiers as B
import Bulma.Modifiers.Typography as BT
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder)


type alias User =
    { uid : String
    , email : String
    , name : Maybe String
    , imageUrl : Maybe String
    , jwt : String
    }


decoder : Decoder User
decoder =
    Decode.map5 User
        (Decode.field "uid" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "displayName" <| Decode.maybe Decode.string)
        (Decode.field "photoURL" <| Decode.maybe Decode.string)
        (Decode.field "qa" Decode.string)


view : User -> msg -> Html msg
view user msg =
    div []
        [ B.horizontalLevel []
            [ B.levelLeft []
                [ B.levelItem []
                    [ case user.imageUrl of
                        Just url ->
                            B.image (B.OneByOne B.X24) [ B.marginless ] [ img [ src url ] [] ]

                        Nothing ->
                            B.easyPlaceholderImage (B.OneByOne B.X24) [ B.marginless ]
                    ]
                , B.levelItemText [ BT.textColor BT.White ]
                    [ text user.email
                    ]
                ]
            ]
        ]
