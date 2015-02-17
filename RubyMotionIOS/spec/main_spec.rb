#
# Copyright (c) 2015 Harry Cheung
#

describe "Application 'RubyMotionIOS'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    @app.windows.size.should == 1
  end
end
