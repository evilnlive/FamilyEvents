namespace FamilyEventsBackend.Data

open System
open FamilyEventsBackend.Domain

module Data =
    let mamma =
        { Id = Guid.NewGuid()
          NickName = "Mamma" }

    let pappa =
        { Id = Guid.NewGuid()
          NickName = "Pappa" }

    let juni =
        { Id = Guid.NewGuid()
          NickName = "Juni" }

    let penny =
        { Id = Guid.NewGuid()
          NickName = "Penny" }

    let charlie =
        { Id = Guid.NewGuid()
          NickName = "Charlie" }

    let persons = [ mamma; pappa; juni; penny; charlie ]

    let simskola =
        { Id = Guid.NewGuid()
          Title = "Simskola"
          StartTime = { HH = 16; MM = 40 }
          EndTime = { HH = 17; MM = 10 } }

    let gymnastik =
        { Id = Guid.NewGuid()
          Title = "Gymnastik"
          StartTime = { HH = 11; MM = 0 }
          EndTime = { HH = 12; MM = 0 } }

    let entriesWednesday = [ { Event = simskola; Persons = [ juni ] } ]

    let entriesSunday =
        [ { Event = gymnastik
            Persons = [ juni ] } ]

    let days =
        [ { DayOfWeek = DayOfWeek.Wednesday
            Entries = entriesWednesday }
          { DayOfWeek = DayOfWeek.Friday
            Entries =
              [ { Event =
                    { Id = Guid.NewGuid()
                      Title = "AW"
                      StartTime = { HH = 16; MM = 0 }
                      EndTime = { HH = 22; MM = 0 } }
                  Persons = [ mamma ] } ] }
          { DayOfWeek = DayOfWeek.Sunday
            Entries = entriesSunday } ]

    let weekSchedule = { WeekNumber = 47; Days = days }
