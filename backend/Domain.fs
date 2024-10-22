namespace FamilyEventsBackend.Domain

open System

type Event =
    { Id: Guid
      Title: string
      StartTime: DateTime
      EndTime: DateTime }

type Person =
    { Id: Guid
      NickName: string
      Events: Event list }
