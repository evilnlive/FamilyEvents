module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Decoder, field, int, list, map2, map4, string)



-- MODEL


type alias WeekDay =
    { dayOfWeek : Int, name : String }


weekDays : List WeekDay
weekDays =
    [ { dayOfWeek = 1, name = "Måndag" }
    , { dayOfWeek = 2, name = "Tisdag" }
    , { dayOfWeek = 3, name = "Onsdag" }
    , { dayOfWeek = 4, name = "Torsdag" }
    , { dayOfWeek = 5, name = "Fredag" }
    , { dayOfWeek = 6, name = "Lördag" }
    , { dayOfWeek = 0, name = "Söndag" }
    ]


type alias Time =
    { hh : Int
    , mm : Int
    }


type alias Event =
    { id : String
    , title : String
    , startTime : Time
    , endTime : Time
    }


type alias Person =
    { id : String
    , nickName : String
    }


type alias ScheduleEntry =
    { event : Event
    , persons : List Person
    }


type alias Day =
    { dayOfWeek : Int
    , entries : List ScheduleEntry
    }


type alias Week =
    { weekNumber : Int
    , days : List Day
    }


type alias Model =
    { weeks : List Week, apiHost : String }


init : String -> Model
init apiHost =
    { weeks = [ { weekNumber = 0, days = [] } ], apiHost = apiHost }


onlyDaysOnWeekDay : WeekDay -> List Day -> List Day
onlyDaysOnWeekDay weekDay days =
    List.filter (\day -> day.dayOfWeek == weekDay.dayOfWeek) days



-- UPDATE


type Msg
    = FetchWeeks
    | WeeksFetched (Result Http.Error (List Week))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchWeeks ->
            ( model, fetchWeeks model.apiHost )

        WeeksFetched (Ok weeks) ->
            ( { model | weeks = weeks }, Cmd.none )

        WeeksFetched (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Familjeschema" ]
        , viewWeeks model.weeks
        ]


viewWeeks : List Week -> Html Msg
viewWeeks weeks =
    div [ class "weeks" ] (List.map viewWeek weeks)


viewWeek : Week -> Html msg
viewWeek week =
    div [ class "week" ]
        [ div [] [ text ("Vecka " ++ String.fromInt week.weekNumber) ]
        , div [ class "week-row" ] (viewWeekDays week)
        ]


viewWeekDays : Week -> List (Html msg)
viewWeekDays week =
    List.map
        (\weekDay ->
            viewWeekDay weekDay week
        )
        weekDays


viewWeekDay : WeekDay -> Week -> Html msg
viewWeekDay weekDay week =
    div [ class "week-day", class (String.concat [ "week-day-", String.fromInt weekDay.dayOfWeek ]) ]
        (div [ class "week-day-name" ] [ text weekDay.name ]
            :: List.map
                (\day ->
                    div [ class "week-day-entries" ]
                        (List.map viewScheduleEntry day.entries)
                )
                (onlyDaysOnWeekDay weekDay week.days)
        )


viewScheduleEntry : ScheduleEntry -> Html msg
viewScheduleEntry scheduleEntry =
    div [ class "week-day-entry" ]
        [ text
            (scheduleEntry.event.title
                ++ " "
                ++ timeIntervalString scheduleEntry.event.startTime scheduleEntry.event.endTime
                ++ " "
                ++ (scheduleEntry.persons
                        |> List.map .nickName
                        |> String.join ", "
                   )
            )
        ]


timeIntervalString : Time -> Time -> String
timeIntervalString start end =
    timeToString start ++ " - " ++ timeToString end


timeToString : Time -> String
timeToString time =
    String.fromInt time.hh ++ ":" ++ minutesToString time.mm


minutesToString : Int -> String
minutesToString mm =
    String.right 2 ("0" ++ String.fromInt mm)



-- HTTP REQUEST


timeDecoder : Decoder Time
timeDecoder =
    map2 Time
        (field "hh" int)
        (field "mm" int)


eventDecoder : Decoder Event
eventDecoder =
    map4 Event
        (field "id" string)
        (field "title" string)
        (field "startTime" timeDecoder)
        (field "endTime" timeDecoder)


personDecoder : Decoder Person
personDecoder =
    map2 Person
        (field "id" string)
        (field "nickName" string)


scheduleEntryDecoder : Decoder ScheduleEntry
scheduleEntryDecoder =
    map2 ScheduleEntry
        (field "event" eventDecoder)
        (field "persons" (list personDecoder))


dayDecoder : Decoder Day
dayDecoder =
    map2 Day
        (field "dayOfWeek" int)
        (field "entries" (list scheduleEntryDecoder))


weekDecoder : Decoder Week
weekDecoder =
    map2 Week
        (field "weekNumber" int)
        (field "days" (list dayDecoder))


weeksDecoder : Decoder (List Week)
weeksDecoder =
    list weekDecoder


fetchWeeks : String -> Cmd Msg
fetchWeeks apiHost =
    Http.get
        { url = apiHost ++ "/weeks"
        , expect = Http.expectJson WeeksFetched weeksDecoder
        }



-- MAIN


main : Program String Model Msg
main =
    Browser.element
        { init = \apiHost -> ( init apiHost, fetchWeeks apiHost )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
