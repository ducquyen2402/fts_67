function getTimeRemaining(endtime) {
  var t = Date.parse(endtime) - Date.parse(new Date());
  var seconds = Math.floor((t / 1000) % 60);
  var minutes = Math.floor((t / 1000 / 60) % 60);
  return {
    'total': t,
    'minutes': minutes,
    'seconds': seconds
  };
}

function initializeClock(id, endtime) {
  var clock = document.getElementById(id);
  var minutesSpan = clock.querySelector('.minutes');
  var secondsSpan = clock.querySelector('.seconds');

  function updateClock() {
    var t = getTimeRemaining(endtime);

    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);

    if (t.total <= 0) {
      clearInterval(timeinterval);
      document.getElementById('submit').click();
    }
  }

  updateClock();
  var timeinterval = setInterval(updateClock, 1000);
}

var remaining_time = document.getElementById('remaining-times').firstChild
remaining_time = parseInt(remaining_time.textContent)
var deadline = new Date(Date.parse(new Date()) +  remaining_time * 1000);
initializeClock('clockdiv', deadline);
