using System;
using FamilyEventsBackend.Domain;

namespace FamilyEventsBackend.Data
{
    public static class Data
    {
        // Persons
        public static readonly Person Mamma = new(Guid.NewGuid(), "Mamma");
        public static readonly Person Pappa = new(Guid.NewGuid(), "Pappa");
        public static readonly Person Juni = new(Guid.NewGuid(), "Juni");
        public static readonly Person Penny = new(Guid.NewGuid(), "Penny");
        public static readonly Person Charlie = new(Guid.NewGuid(), "Charlie");

        // Week Schedule
        public static readonly Week WeekSchedule = new(
            47,
            [
                new Day(DayOfWeek.Wednesday,
                    [
                        new ScheduleEntry(
                            new Event(
                                Guid.NewGuid(),
                                "Simskola",
                                new Time(16, 40),
                                new Time(17, 10)
                            ),
                            [Juni]
                        )
                    ]
                ),
                new Day(DayOfWeek.Friday,
                    [
                        new ScheduleEntry(
                            new Event(
                                Guid.NewGuid(),
                                "AW",
                                new Time(16, 0),
                                new Time(22, 0)
                            ),
                            [Mamma]
                        )
                    ]
                ),
                new Day(DayOfWeek.Sunday,
                    [
                        new ScheduleEntry(
                            new Event(
                                Guid.NewGuid(),
                                "Gymnastik",
                                new Time(11, 0),
                                new Time(12, 0)
                            ),
                            [Juni]
                        )
                    ]
                )
            ]
        );
    }
}