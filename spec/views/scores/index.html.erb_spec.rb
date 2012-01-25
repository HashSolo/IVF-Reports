require 'spec_helper'

describe "scores/index.html.erb" do
  before(:each) do
    assign(:scores, [
      stub_model(Score,
        :clinic_id => 1,
        :year => "Year",
        :age_group => "Age Group",
        :diagnosis => "Diagnosis",
        :cycle_type => "Cycle Type",
        :ivf_reports_score => 1.5,
        :quality_score => 1.5,
        :safety_score => 1.5,
        :sart_score => 1.5
      ),
      stub_model(Score,
        :clinic_id => 1,
        :year => "Year",
        :age_group => "Age Group",
        :diagnosis => "Diagnosis",
        :cycle_type => "Cycle Type",
        :ivf_reports_score => 1.5,
        :quality_score => 1.5,
        :safety_score => 1.5,
        :sart_score => 1.5
      )
    ])
  end

  it "renders a list of scores" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Year".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Age Group".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Diagnosis".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Cycle Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
