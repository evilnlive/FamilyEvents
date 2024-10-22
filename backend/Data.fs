namespace FamilyEventsBackend.Data

open System
open FamilyEventsBackend.Domain

module Data =
    let persons =
        [ { Id = Guid.NewGuid()
            NickName = "Juni"
            Events =
              [ { Id = Guid.NewGuid()
                  Title = "Simskola"
                  StartTime = new DateTime(2024, 10, 23, 16, 40, 00)
                  EndTime = new DateTime(2024, 10, 23, 17, 10, 00) } ] } ]
