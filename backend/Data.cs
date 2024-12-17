using System;
using FamilyEventsBackend.Domain;

namespace FamilyEventsBackend;

public static class Data
{
    public static readonly Person Mamma = new(Guid.NewGuid(), "Mamma");
    public static readonly Person Pappa = new(Guid.NewGuid(), "Pappa");
    public static readonly Person Juni = new(Guid.NewGuid(), "Juni");
    public static readonly Person Penny = new(Guid.NewGuid(), "Penny");
    public static readonly Person Charlie = new(Guid.NewGuid(), "Charlie");
    private static readonly System.Collections.Generic.List<Person> alla = [Mamma, Pappa, Juni, Penny, Charlie];
    public static readonly Week[] Weeks = [
        new(51,
            [new Day(DayOfWeek.Sunday,
                    [
                        new ScheduleEntry(
                            new Event(
                                Guid.NewGuid(),
                                "Adventsfika",
                                new Time(14, 0),
                                new Time(17, 0)
                            ),
                            alla
                        )
                    ]
                )
            ]),
        new(52,
            [
                new Day(DayOfWeek.Monday,
                    [
                        new ScheduleEntry(
                            new Event(
                                Guid.NewGuid(),
                                "Bilblioteket",
                                new Time(10, 0),
                                new Time(11, 0)
                            ),
                            alla
                        )
                    ]
                ),
                new Day(DayOfWeek.Tuesday,
                    [
                        new ScheduleEntry(
                            new Event(
                                Guid.NewGuid(),
                                "Julafton",
                                new Time(0, 0),
                                new Time(0, 0)
                            ),
                            alla
                        )
                    ]
                ),
                new Day(DayOfWeek.Thursday,
                    [
                        new ScheduleEntry(
                            new Event(
                                Guid.NewGuid(),
                                "Annandag Jul",
                                new Time(0, 0),
                                new Time(0, 0)
                            ),
                            alla
                        )
                    ]
                )
            ])
    ];
}