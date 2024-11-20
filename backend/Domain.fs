namespace FamilyEventsBackend.Domain

open System

type Time = { HH: int; MM: int }

type Event =
    { Id: Guid
      Title: string
      StartTime: Time
      EndTime: Time }

type Person = { Id: Guid; NickName: string }

type ScheduleEntry = { Event: Event; Persons: Person list }

type Day =
    { DayOfWeek: DayOfWeek
      Entries: ScheduleEntry list }

type Week = { WeekNumber: int; Days: Day list }
