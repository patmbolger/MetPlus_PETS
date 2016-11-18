describe('Convert UTC to local Time', function () {
  beforeEach(function () {
    loadFixtures('utc_to_local/utc_time.html');
  });

  // https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

  it('New York', function () {
    // set local timezone so "moment.tz.guess()"" will detect that, or,
    // stub "moment.tz.guess()" function to return a specific timezone string
    // (see timezone strings in above link)
    // here. we want to use timezone 'America/New_York'

    utcToLocal.setup();  // convert UTC time to local time in the DOM
    ele = $('.utc_to_local_time')[0]  // Get the converted span element

    // test that timezone in the DOM is equal to expected timezone
    // hint: use $('ele').text()
  });

  it('Johannesburg', function () {
    // tz = 'Africa/Johannesburg'

  });

  it('London', function () {
    // tz = 'Europe/London'
  });
});
