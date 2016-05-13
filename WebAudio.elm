module WebAudio exposing (..)

import Html exposing (Html, text)
import Html.Events exposing (onClick)
import Html.App
import Ports exposing (playSoundOut)

-- MODEL
type alias Model = Int

model : Model
model = 0

-- UPDATE
type Msg
  = PlaySound
  | Done

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( model, Debug.log "play sound" (playSoundOut "" ))

-- VIEW
view : Model -> Html Msg
view model =
  Html.button
    [ onClick PlaySound ] [ text "Play" ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.done (\_ -> Done)

-- MAIN

main : Program Never
main =
  Html.App.program
    { init = ( model, Cmd.none )
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

