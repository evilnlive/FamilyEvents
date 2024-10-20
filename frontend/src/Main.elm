module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, li, text, ul)
import Http
import Json.Decode exposing (Decoder, andThen, field, int, list, map, string)



-- MODEL


type alias Event =
    { id : Int
    , title : String
    , startTime : String
    , endTime : String
    }


type alias Model =
    { events : List Event, apiHost : String }


init : String -> Model
init apiHost =
    { events = [], apiHost = apiHost }



-- UPDATE


type Msg
    = FetchEvents
    | EventsFetched (Result Http.Error (List Event))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchEvents ->
            ( model, fetchEvents model.apiHost )

        EventsFetched (Ok events) ->
            ( { model | events = events }, Cmd.none )

        EventsFetched (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Familjeschema" ]
        , viewEvents model.events
        ]


viewEvents : List Event -> Html msg
viewEvents events =
    ul []
        (List.map (\event -> li [] [ text event.title ]) events)



-- HTTP REQUEST


fetchEvents : String -> Cmd Msg
fetchEvents apiHost =
    let
        decoder : Decoder (List Event)
        decoder =
            list
                (field "id" int
                    |> andThen
                        (\id ->
                            field "title" string
                                |> andThen
                                    (\title ->
                                        field "startTime" string
                                            |> andThen
                                                (\startTime ->
                                                    field "endTime" string
                                                        |> map (\endTime -> { id = id, title = title, startTime = startTime, endTime = endTime })
                                                )
                                    )
                        )
                )
    in
    Http.get
        { url = apiHost ++ "/events"
        , expect = Http.expectJson EventsFetched decoder
        }



-- MAIN


main : Program String Model Msg
main =
    Browser.element
        { init = \apiHost -> ( init apiHost, fetchEvents apiHost )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
