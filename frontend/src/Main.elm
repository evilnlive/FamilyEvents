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
    { week : Week, apiHost : String }


init : String -> Model
init apiHost =
    { week = { weekNumber = 0, days = [] }, apiHost = apiHost }


onlyDaysOnWeekDay : WeekDay -> List Day -> List Day
onlyDaysOnWeekDay weekDay days =
    List.filter (\day -> day.dayOfWeek == weekDay.dayOfWeek) days



-- UPDATE


type Msg
    = FetchWeek
    | WeekFetched (Result Http.Error Week)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchWeek ->
            ( model, fetchWeek model.apiHost )

        WeekFetched (Ok week) ->
            ( { model | week = week }, Cmd.none )

        WeekFetched (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Familjeschema" ]
        , div [] [ text ("Vecka " ++ String.fromInt model.week.weekNumber) ]
        , viewWeek model.week
        ]


viewWeek : Week -> Html msg
viewWeek week =
    div [ class "week" ]
        (viewWeekDays week)


viewWeekDays : Week -> List (Html msg)
viewWeekDays week =
    List.map
        (\weekDay ->
            viewWeekDay weekDay week
        )
        weekDays


viewWeekDay : WeekDay -> Week -> Html msg
viewWeekDay weekDay week =
    div [ class "week-day" ]
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


fetchWeek : String -> Cmd Msg
fetchWeek apiHost =
    Http.get
        { url = apiHost ++ "/week"
        , expect = Http.expectJson WeekFetched weekDecoder
        }



-- MAIN


main : Program String Model Msg
main =
    Browser.element
        { init = \apiHost -> ( init apiHost, fetchWeek apiHost )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
