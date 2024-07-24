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
    return  Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))
        
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
          TimeSlot(
            startTime: '08:00 am',
            endTime: '10:00 am',
            color: colors[0]['color']!,
            lineColor: colors[0]['lineColor']!,
            subject: 'Introducción a la ingeniería',
          ),
          TimeSlot(
            startTime: '10:00 am',
            endTime: '12:00 pm',
            color: colors[1]['color']!,
            lineColor: colors[1]['lineColor']!,
            subject: 'Ingeniería web',
          ),
          TimeSlot(
            startTime: '01:00 pm',
            endTime: '03:00 pm',
            color: colors[2]['color']!,
            lineColor: colors[2]['lineColor']!,
            subject: 'Cátedra Unilibrista',
          ),
        ],
      ),
    );
  }
}

class DateChip extends StatelessWidget {
  final String weekDay;

  const DateChip({
    super.key,
    required this.weekDay
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Consumer(builder: (context, ScheduleProviderModel scheduleModel , child){
          return GestureDetector(
            onTap: (){
              scheduleModel.selectDay(weekDay);
            },
            child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: scheduleModel.selectedDay == weekDay ? Colors.red :Colors.red[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              weekDay,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
                    ),
          );
       }),

        const SizedBox(height: 5)
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

  const TimeSlot({super.key, 
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
                  fontWeight: FontWeight.w600
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
                  fontWeight: FontWeight.w600
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
                      style: TextStyle(
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
                      borderRadius: BorderRadius.only(
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
