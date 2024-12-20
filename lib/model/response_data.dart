import 'dart:convert';

class ResponseData {
    bool error;
    String message;
    List<Task> data;

    ResponseData({
        required this.error,
        required this.message,
        required this.data,
    });

    factory ResponseData.fromRawJson(String str) => ResponseData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        error: json["error"],
        message: json["message"],
        data: List<Task>.from(json["data"].map((x) => Task.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Task {
    String id;
    List<String> field;
    Point start;
    Point end;

    Task({
        required this.id,
        required this.field,
        required this.start,
        required this.end,
    });

    factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        field: List<String>.from(json["field"].map((x) => x)),
        start: Point.fromJson(json["start"]),
        end: Point.fromJson(json["end"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "field": List<dynamic>.from(field.map((x) => x)),
        "start": start.toJson(),
        "end": end.toJson(),
    };
}

class Point {
    int x;
    int y;

    Point({
        required this.x,
        required this.y,
    });

    factory Point.fromRawJson(String str) => Point.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());
    
    @override
    String toString() => "($x, $y)";

    factory Point.fromJson(Map<String, dynamic> json) => Point(
        x: json["x"],
        y: json["y"],
    );

    Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
    };
}
