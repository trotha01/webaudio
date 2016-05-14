module WebAudio exposing (..)

import Html exposing (Html, text)
import Html.Events exposing (onClick)
import Html.App
import Collage exposing (collage, solid, outlined, circle, move, group)
import Color exposing (blue)
import Element exposing (Element, toHtml)
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
      let newModel = model++data
          -- _        = Debug.log "model" (List.length newModel)
      in (model++data, Cmd.none)
    Done ->
      (model, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  Html.div []
  [ playButton
  , toHtml (graph model) ]

playButton : Html Msg
playButton =
  Html.button
    [ onClick PlaySound ] [ text "Play" ]

graph : Model -> Element
graph model =
  let points = List.length model
      moveLeft =
        if
          points < 500
        then
          0
        else
          500 - points
      -- _ = Debug.log "left" moveLeft
  in collage 500 500
    [ group (List.indexedMap point model)
        |> move (toFloat moveLeft, 0)
    ]

{-
#    move left
0 -> 0
250 -> 0
500 -> 0

501 -> -1
502 -> -2
-}


point x y =
    -- let _ = Debug.log "x,y" (x,y)
    circle 1
      |> outlined (solid blue)
      |> move (toFloat (x - 250), toFloat (y-100))

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

