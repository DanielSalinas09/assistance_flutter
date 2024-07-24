import 'package:flutter/material.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            color: Colors.teal[100]!,
            lineColor: Colors.teal,
            subject: 'Introducción a la ingeniería',
          ),
          TimeSlot(
            startTime: '10:00 am',
            endTime: '12:00 pm',
            color: Colors.red[100]!,
            lineColor:  Colors.red,
            subject: 'Ingeniería web',
          ),
          TimeSlot(
            startTime: '01:00 pm',
            endTime: '03:00 pm',
            color: Colors.purple[100]!,
            lineColor: Colors.purple,
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
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.red,
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
              Text(startTime),
              Container(
                width: 2,
                height: 60,
                color: Colors.grey,
              ),
              Text(endTime),
            ],
          ),
          SizedBox(width: 10),
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
