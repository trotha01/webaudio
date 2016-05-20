port module Oscillator exposing (..)

-- MODEL


type alias Model =
    { settings : OscillatorSettings
    }


type alias OscillatorSettings =
    { frequency : Hertz
    , detune : Int
    , shape : String
    }


type alias Hertz =
    Int


init : Hertz -> Model
init frequency =
    { settings =
        { frequency = frequency
        , detune = 0
        , shape = "sine"
        }
    }



-- UPDATE


type Msg
    = Play


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play ->
            ( model, play model )



-- PORTS


port playOscillator : OscillatorSettings -> Cmd msg


port logExternalOut : String -> Cmd msg


play : Model -> Cmd msg
play oscillator =
    let
        _ =
            Debug.log "Play Now" ()
    in
        playOscillator oscillator.settings



-- SUBSCRIPTIONS


port soundData : (List Int -> msg) -> Sub msg


subscriptions : (List Int -> msg) -> Sub msg
subscriptions f =
    soundData f
