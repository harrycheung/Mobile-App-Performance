#
# Copyright (c) 2015 Harry Cheung
#

describe 'Physics tests' do

  it 'computes distances' do
    Physics.distance(0, 0, 0).should.equal 0.0
    Physics.distance(1, 1, 1).should.equal 1.5
    Physics.distance(2, 2, 2).should.equal 8.0
    Physics.distance(3, 0, 3).should.equal 9.0
  end

  it 'computes time' do
    Physics.time(1.5, 1, 1).should.equal 1.0
    Physics.time(8.0, 2, 2).should.equal 2.0
    Physics.time(9.0, 3, 0).should.equal 3.0
  end

end