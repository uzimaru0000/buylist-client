port module Port exposing (getCode, readCode, stopReadCode)


port readCode : () -> Cmd msg


port stopReadCode : () -> Cmd msg


port getCode : (Int -> msg) -> Sub msg
