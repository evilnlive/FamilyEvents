module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, li, text, ul)
import Http
import Json.Decode exposing (Decoder, field, list, map3, map4, string)



-- MODEL


type alias Event =
    { id : String
    , title : String
    , startTime : String
    , endTime : String
    }


type alias Person =
    { id : String
    , nickName : String
    , events : List Event
    }


type alias Model =
    { persons : List Person, apiHost : String }


init : String -> Model
init apiHost =
    { persons = [], apiHost = apiHost }



-- UPDATE


type Msg
    = FetchPersons
    | PersonsFetched (Result Http.Error (List Person))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPersons ->
            ( model, fetchPersons model.apiHost )

        PersonsFetched (Ok persons) ->
            ( { model | persons = persons }, Cmd.none )

        PersonsFetched (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Familjeschema" ]
        , viewPersons model.persons
        ]


viewPersons : List Person -> Html msg
viewPersons persons =
    ul []
        (List.map
            (\person ->
                li []
                    [ div []
                        [ h2 [] [ text person.nickName ]
                        , ul [] (List.map (\event -> li [] [ text event.title ]) person.events)
                        ]
                    ]
            )
            persons
        )



-- HTTP REQUEST


eventDecoder : Decoder Event
eventDecoder =
    map4 Event
        (field "id" string)
        (field "title" string)
        (field "startTime" string)
        (field "endTime" string)


personDecoder : Decoder Person
personDecoder =
    map3 Person
        (field "id" string)
        (field "nickName" string)
        (field "events" (list eventDecoder))


fetchPersons : String -> Cmd Msg
fetchPersons apiHost =
    Http.get
        { url = apiHost ++ "/events"
        , expect = Http.expectJson PersonsFetched (list personDecoder)
        }



-- MAIN


main : Program String Model Msg
main =
    Browser.element
        { init = \apiHost -> ( init apiHost, fetchPersons apiHost )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
