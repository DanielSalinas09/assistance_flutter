import 'package:assistance_flutter/helper/parcing_day.dart';
import 'package:assistance_flutter/providers/shedule_prodiver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Color>> colors = List.generate(20, (index) {
      return {
        'color': Colors.primaries[index % Colors.primaries.length][100]!,
        'lineColor': Colors.primaries[index % Colors.primaries.length],
      };
    });

    return Consumer<ScheduleProviderModel>(
      builder: (context, scheduleModel, child) {
        if (scheduleModel.isSheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final schedules = scheduleModel.getSchedulesForSelectedDay();

        schedules.sort((a, b) => a.hourStart.compareTo(b.hourStart));

        return Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(6, (index) {
                  return DateChip(weekDay: ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'][index]);
                }),
              ),
              const SizedBox(height: 20),
              schedules.isEmpty
                ? const Text(
                    'No tienes clases este día',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )
                : Column(
                    children: schedules.map((schedule) {
                      final index = schedules.indexOf(schedule) % colors.length;
                      return TimeSlot(
                        startTime: schedule.hourStart,
                        endTime: schedule.hourEnd,
                        color: colors[index]['color']!,
                        lineColor: colors[index]['lineColor']!,
                        subject: schedule.name,
                      );
                    }).toList(),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class DateChip extends StatelessWidget {
  final String weekDay;

  const DateChip({
    super.key,
    required this.weekDay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ScheduleProviderModel>(
          builder: (context, scheduleModel, child) {
            return GestureDetector(
              onTap: () {
                scheduleModel.selectDay(DayHelper.parseDay(weekDay));
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: DayHelper.parseDay(scheduleModel.selectedDay, reverse: true) == weekDay
                      ? Colors.red
                      : Colors.red[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  weekDay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class TimeSlot extends StatelessWidget {
  final String startTime;
  final String endTime;
  final Color color;
  final Color lineColor;
  final String subject;

  const TimeSlot({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.lineColor,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                startTime,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                width: 2,
                height: 60,
                color: lineColor,
              ),
              Text(
                endTime,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    decoration: BoxDecoration(
                      color: lineColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
