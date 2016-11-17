describe('Convert UTC to local Time', function () {
  beforeEach(function () {
    loadFixtures('utc_to_local/utc_time.html');
  });

  it('New York', function () {
    // SET LOCAL TIME ZONE HERE .....

    utcToLocal.setup();  // convert UTC time to local time in the DOM
    ele = $('.utc_to_local_time')[0]  // Get the converted span element

    expect($(ele).text()).toEqual('November 7, 2016 1:04 PM');
  });
});
