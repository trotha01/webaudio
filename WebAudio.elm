module WebAudio exposing (..)

import Html exposing (Html, text)
import Html.Events exposing (onClick)
import Html.App
import Ports exposing (playSoundOut, logExternalOut)

-- MODEL
type alias Model = List Int

model : Model
model = []

-- UPDATE
type Msg
  = PlaySound
  | SoundData (List Int)
  | Done

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    PlaySound ->
      ( model, Debug.log "play sound" (playSoundOut "some message" ))
    SoundData data ->
      let _ = Debug.log "sound data" data
      in (model++data, Cmd.none)
    Done ->
      (model, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  Html.button
    [ onClick PlaySound ] [ text "Play" ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ (Ports.done (\_ -> Done))
  , Ports.soundData SoundData
  ]

-- MAIN

main : Program Never
main =
  Html.App.program
    { init = ( model, Cmd.none )
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

