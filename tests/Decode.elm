module Decode exposing (userDecode)

import Data.User as User
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode exposing (decodeString)
import Test exposing (..)


userDecode : Test
userDecode =
    describe "User decoding test"
        [ test "All in" <|
            \_ ->
                let
                    json =
                        """
                        {
                            "uid": "hogehoge",
                            "email": "hoge@foo.com",
                            "displayName": "Hoge Hoge",
                            "photoURL": "https://hogehoge.com/photo/0000",
                            "qa": "fhiaga;ogsdlhvo;ihrgvhoier;n"
                        }
                        """

                    ans =
                        { uid = "hogehoge"
                        , email = "hoge@foo.com"
                        , name = Just "Hoge Hoge"
                        , imageUrl = Just "https://hogehoge.com/photo/0000"
                        , jwt = "fhiaga;ogsdlhvo;ihrgvhoier;n"
                        }
                in
                Expect.equal (decodeString User.decoder json) (Ok ans)
        ]
