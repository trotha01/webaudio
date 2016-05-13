port module Ports exposing (..)

port playSoundOut : String -> Cmd msg

port done : (Bool -> msg) -> Sub msg

