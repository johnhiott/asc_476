require 'spec_helper'

describe "AvailableTimes" do
  describe "GET /available_times" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get available_times_path
      response.status.should be(200)
    end
  end
end
