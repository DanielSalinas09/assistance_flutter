import 'dart:convert';

class GetScheduleResponse {
    bool status;
    List<Datum> data;

    GetScheduleResponse({
        required this.status,
        required this.data,
    });

    GetScheduleResponse copyWith({
        bool? status,
        List<Datum>? data,
    }) => 
        GetScheduleResponse(
            status: status ?? this.status,
            data: data ?? this.data,
        );

    factory GetScheduleResponse.fromJson(String str) => GetScheduleResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetScheduleResponse.fromMap(Map<String, dynamic> json) => GetScheduleResponse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Datum {
    String day;
    List<Schedule> schedules;

    Datum({
        required this.day,
        required this.schedules,
    });

    Datum copyWith({
        String? day,
        List<Schedule>? schedules,
    }) => 
        Datum(
            day: day ?? this.day,
            schedules: schedules ?? this.schedules,
        );

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        day: json["day"],
        schedules: List<Schedule>.from(json["schedules"].map((x) => Schedule.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "day": day,
        "schedules": List<dynamic>.from(schedules.map((x) => x.toMap())),
    };
}

class Schedule {
    String hourStart;
    String hourEnd;
    String name;

    Schedule({
        required this.hourStart,
        required this.hourEnd,
        required this.name,
    });

    Schedule copyWith({
        String? hourStart,
        String? hourEnd,
        String? name,
    }) => 
        Schedule(
            hourStart: hourStart ?? this.hourStart,
            hourEnd: hourEnd ?? this.hourEnd,
            name: name ?? this.name,
        );

    factory Schedule.fromJson(String str) => Schedule.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Schedule.fromMap(Map<String, dynamic> json) => Schedule(
        hourStart: json["hour_start"],
        hourEnd: json["hour_end"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "hour_start": hourStart,
        "hour_end": hourEnd,
        "name": name,
    };
}
