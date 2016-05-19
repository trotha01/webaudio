module Visualizer exposing (..)

import Html exposing (Html, text)
import Html.Events exposing (onClick)
import Html.App
import Collage exposing (collage, solid, outlined, circle, move, group)
import Color exposing (blue)


-- import Ports

import Element exposing (Element, toHtml)
import WebAudio exposing (..)


-- MODEL


type alias Model =
    { oscillators : List (WebAudio.OscillatorNode Msg)
    , soundData : List Int
    }


model : Model
model =
    { oscillators = []
    , soundData = []
    }



-- UPDATE


type Msg
    = PlaySound
    | SoundData (List Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        oscillator =
            newOscillator 440
    in
        case msg of
            PlaySound ->
                ( model, WebAudio.play oscillator )

            SoundData data ->
                ( { model | soundData = model.soundData ++ data }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ playButton
        , toHtml (graph model.soundData)
        ]


playButton : Html Msg
playButton =
    Html.button [ onClick PlaySound ]
        [ text "Play" ]


graphWidth =
    500


graphHeight =
    500


halfGraphWidth =
    graphWidth / 2


graph : List Int -> Element
graph model =
    let
        points =
            List.length model

        moveLeft =
            if points < graphWidth then
                0
            else
                graphWidth - points
    in
        collage graphWidth
            graphHeight
            [ group (List.indexedMap point model)
                |> move ( toFloat moveLeft, 0 )
            ]


point x y =
    circle 1
        |> outlined (solid blue)
        |> move ( ((toFloat x) - halfGraphWidth), toFloat (y - 100) )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch (List.map (\o -> o.soundData SoundData) model.oscillators)



-- [ WebAudio.soundData SoundData ]
-- MAIN


main : Program Never
main =
    Html.App.program
        { init = ( model, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
