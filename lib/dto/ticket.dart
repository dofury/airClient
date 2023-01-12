class Ticket
{
  Ticket(
      this._ticketNum,
      this._ticketName,
      this._airlineName,
      this._depAirportName,
      this._arrAirportName,
      this._ticketCharge,
      this._ticketDate,
      this._depTime,
      this._arrTime
      );

  String _ticketNum;
  String _ticketName;
  String _airlineName;
  String _depAirportName;
  String _arrAirportName;
  String _ticketCharge;
  String _ticketDate;
  String _depTime;
  String _arrTime;

  get ticketNum => _ticketNum;

  get ticketName => _ticketName;

  get arrTime => _arrTime;

  get depTime => _depTime;

  get ticketDate => _ticketDate;

  get ticketCharge => _ticketCharge;

  get arrAirportName => _arrAirportName;

  get depAirportName => _depAirportName;

  get airlineName => _airlineName;

  factory Ticket.fromJson(dynamic json){
    return Ticket(json['ticketNum'].toString(),
        json['ticketName'] as String,
      json['airlineName'] as String,
      json['depAirportName'] as String,
      json['arrAirportName'] as String,
      json['ticketCharge'].toString(),
      json['ticketDate'] as String,
      json['depTime'] as String,
      json['arrTime'] as String,
    );
  }
}