#
# Copyright (c) 2015 Harry Cheung
#

describe 'Gate tests' do

  it 'tests gate crossing' do
    gate = Gate.new(Gate::START_FINISH, 1, 37.452602, -122.207069, 32)
    a = Point.new(37.452414, -122.207193, speed: 14.210000038146973, bearing: 32.09501647949219, timestamp: 1)
    b = Point.new(37.452523, -122.207107, speed: 14.239999771118164, bearing: 32.09501647949219, timestamp: 2)
    b.lap_distance = 100
    b.lap_time = 0.1
    c = Point.new(37.45263, -122.207023, speed: 14.15999984741211, bearing: 32.09501647949219, timestamp: 3)
    gate.cross(a, b).should.equal nil
    gate.cross(c, b).should.equal nil
    cross = gate.cross(b, c)
    cross.generated.should.equal true
    cross.latitude_degrees.should.equal 37.452593.round(6)
    cross.longitude_degrees.should.equal -122.207052.round(6)
    cross.speed.should.be.close 14.18, 0.01
    cross.bearing.should.be.close 31.93, 0.01
    cross.timestamp.should.be.close 2.64915, 0.00001
    cross.lap_distance.should.be.close 100 + b.distance_to(cross), 0.01
    cross.lap_time.should.be.close 0.74915, 0.00001
    cross.split_time.should.be.close 0.64915, 0.00001
  end

end