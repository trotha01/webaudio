port module WebAudio exposing (..)


type alias Hertz =
    Int


type alias OscillatorNode msg =
    { settings : OscillatorSettings
    , soundData : (List Int -> msg) -> Sub msg
    }


type alias OscillatorSettings =
    { frequency : Hertz
    , detune : Int
    , shape : String
    }


newOscillator : Hertz -> OscillatorNode msg
newOscillator frequency =
    { settings =
        { frequency = frequency
        , detune = 0
        , shape = "sine"
        }
    , soundData = soundData
    }


port playOscillator : OscillatorSettings -> Cmd msg


port soundData : (List Int -> msg) -> Sub msg


port logExternalOut : String -> Cmd msg


play : OscillatorNode msg -> Cmd msg
play oscillator =
    playOscillator oscillator.settings
