using System;
using System.Collections.Generic;

namespace FamilyEventsBackend.Domain
{
    public record Time(int HH, int MM);

    public record Event(Guid Id, string Title, Time StartTime, Time EndTime);

    public record Person(Guid Id, string NickName);

    public record ScheduleEntry(Event Event, List<Person> Persons);

    public record Day(DayOfWeek DayOfWeek, List<ScheduleEntry> Entries);

    public record Week(int WeekNumber, List<Day> Days);
}