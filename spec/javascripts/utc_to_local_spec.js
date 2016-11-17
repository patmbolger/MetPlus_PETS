describe('Convert UTC to local Time', function () {
  beforeEach(function () {
    loadFixtures('utc_to_local/utc_time.html');
  });

  // https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

  it('New York', function () {
    spyOn(moment.tz, 'guess').and.returnValue('America/New_York')

    utcToLocal.setup();  // convert UTC time to local time in the DOM
    ele = $('.utc_to_local_time')[0]  // Get the converted span element

    expect($(ele).text()).toEqual('November 7, 2016 1:04 PM');
  });

  it('Johannesburg', function () {
    spyOn(moment.tz, 'guess').and.returnValue('Africa/Johannesburg')
    utcToLocal.setup();
    ele = $('.utc_to_local_time')[0]
    expect($(ele).text()).toEqual('November 7, 2016 8:04 PM');
  });

  it('London', function () {
    spyOn(moment.tz, 'guess').and.returnValue('Europe/London')
    utcToLocal.setup();
    ele = $('.utc_to_local_time')[0]
    expect($(ele).text()).toEqual('November 7, 2016 6:04 PM');
  });
});
