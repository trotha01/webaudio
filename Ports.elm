port module Ports exposing (..)

port playSoundOut : String -> Cmd msg

port soundData : (List Int -> msg) -> Sub msg

port logExternalOut : String -> Cmd msg

