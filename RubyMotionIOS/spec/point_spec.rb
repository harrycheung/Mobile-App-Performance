#
# Copyright (c) 2015 Harry Cheung
#

describe 'Point tests' do

  it 'should subtract' do
    a = Point.new(5, 5)
    b = Point.new(10, 10)
    c = b.subtract(a)

    c.latitude_degrees.should.equal 5.0
    c.longitude_degrees.should.equal 5.0
  end

  it 'should compute bearing' do
    a = Point.new(5, 5)
    b = Point.new(5, 10)

    a.bearing_to(b).round(6).should.equal 89.781973
    a.bearing_to(b, true).round(6).should.equal 1.566991.round(6)
  end

  it 'should compute destination' do
    a = Point.new(37.452602, -122.207069)
    d = a.destination(308, 50)

    d.latitude_degrees.should.equal 37.452879.round(6)
    d.longitude_degrees.should.equal -122.207515.round(6)
  end

  it 'should compute distance to' do
    a = Point.new(50.06639, -5.71472)
    b = Point.new(58.64389, -3.07000)

    a.distance_to(b).round.should.equal 968854
  end

  it 'should compute simple intersect' do
    a = Point.new(5, 5)
    b = Point.new(15, 15)
    c = Point.new(5, 15)
    d = Point.new(15, 5)

    i = Point.intersect_simple(a, b, c, d)

    i.latitude_degrees.should.equal 10.0
    i.longitude_degrees.should.equal 10.0
  end

end