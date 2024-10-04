module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, ul, li)
import Http
import Json.Decode exposing (Decoder, field, int, string, list)
import Json.Decode exposing (andThen)
import Json.Decode exposing (map)
import Debug exposing (log)
import Debug exposing (toString)


-- MODEL

type alias Event =
    { id : Int
    , name : String
    , date : String
    , time : String
    }

type alias Model =
    { events : List Event }

init : Model
init =
    { events = [] }


-- UPDATE

type Msg
    = FetchEvents
    | EventsFetched (Result Http.Error (List Event))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchEvents ->
            ( model, fetchEvents )

        EventsFetched (Ok events) ->
             ( { model | events = events }, Cmd.none )

        EventsFetched (Err _) ->
            ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Family Events" ]
        , viewEvents model.events
        ]

viewEvents : List Event -> Html msg
viewEvents events =
    ul []
        (List.map (\event -> li [] [ text event.name ]) events)


-- HTTP REQUEST

fetchEvents : Cmd Msg
fetchEvents =
    let
        decoder : Decoder (List Event)
        decoder =
            list (field "id" int
                |> andThen (\id ->
                    field "name" string
                        |> andThen (\name ->
                            field "date" string
                                |> andThen (\date ->
                                    field "time" string
                                        |> map (\time -> { id = id, name = name, date = date, time = time })
                                )
                        )
                )
            )
    in
    Http.get
        { url = "http://localhost:5000/events"
        , expect = Http.expectJson EventsFetched decoder
        }


-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, fetchEvents )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
