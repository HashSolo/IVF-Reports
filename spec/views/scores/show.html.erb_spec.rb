require 'spec_helper'

describe "scores/show.html.erb" do
  before(:each) do
    @score = assign(:score, stub_model(Score,
      :clinic_id => 1,
      :year => "Year",
      :age_group => "Age Group",
      :diagnosis => "Diagnosis",
      :cycle_type => "Cycle Type",
      :ivf_reports_score => 1.5,
      :quality_score => 1.5,
      :safety_score => 1.5,
      :sart_score => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Year/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Age Group/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Diagnosis/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Cycle Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
  end
end
