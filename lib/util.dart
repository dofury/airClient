class Util
{
  String? getWeb(String airLine) {
    String? link;
    switch (airLine) {
      case '진에어':
        link = 'https://www.jinair.com/booking/index';
        break;
      case '제주항공':
        link = 'https://www.jejuair.net/ko/main/base/index.do';
        break;
      case '대한항공':
        link = 'https://www.koreanair.com/kr/ko';
        break;
      case '에어부산':
        link = 'https://www.airbusan.com/content/individual/?';
        break;
      case '티웨이항공':
        link = 'https://www.twayair.com/app/main';
        break;
      case '에어서울':
        link = 'https://flyairseoul.com/CW/ko/main.do';
        break;
      case '이스타항공':
        link = 'https://www.eastarjet.com/newstar/PGWHC00001?lang=KR';
        break;
      case '하이에어':
        link = 'https://www.hi-airlines.com/';
        break;
      case '플라이강원':
        link = 'https://flygangwon.com/ko/main/main.do';
        break;
      case '아시아나항공':
        link = 'https://flyasiana.com/C/KR/KO/index?site_preference=NORMAL';
        break;
      default:
        link = 'error';
    }
    return link;
  }

  String? transTime(String time) {
    String transData = '';
    if (time.length == 4) {
      String hour, minute;

      hour = time.substring(0, 2);
      minute = time.substring(2, 4);
      transData = '$hour:$minute';
    } else if (time.length == 8) {
      String year, month, day;

      year = time.substring(0, 4);
      month = time.substring(4, 6);
      day = time.substring(6, 8);
      transData = '$year/$month/$day';
    } else {
      transData = 'error';
    }

    return transData;
  }

  String getTime(var dep, var arr) {
    var depHour, arrHour;
    var depMinute, arrMinute;
    var hour, minute;

    depHour = int.parse(dep.substring(0, 2));
    depMinute = int.parse(dep.substring(2, 4));
    arrHour = int.parse(arr.substring(0, 2));
    arrMinute = int.parse(arr.substring(2, 4));

    if (arrMinute - depMinute < 0) //분이 0보다 작을시
        {
      arrMinute += 60;
      arrHour -= 1;
    }
    if (arrHour - depHour < 0) //시가 0보다 작을시
        {
      arrHour += 24;
    }

    hour = arrHour - depHour;
    minute = arrMinute - depMinute;

    return '$hour시간 $minute분';
  }
  String getCharge(String charge){
    String result;
    if(charge == '999999')
      result = "홈페이지 참조";
    else
      result = charge + '원';
    return result;
  }

}