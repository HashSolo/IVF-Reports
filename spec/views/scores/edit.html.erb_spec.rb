require 'spec_helper'

describe "scores/edit.html.erb" do
  before(:each) do
    @score = assign(:score, stub_model(Score,
      :clinic_id => 1,
      :year => "MyString",
      :age_group => "MyString",
      :diagnosis => "MyString",
      :cycle_type => "MyString",
      :ivf_reports_score => 1.5,
      :quality_score => 1.5,
      :safety_score => 1.5,
      :sart_score => 1.5
    ))
  end

  it "renders the edit score form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => scores_path(@score), :method => "post" do
      assert_select "input#score_clinic_id", :name => "score[clinic_id]"
      assert_select "input#score_year", :name => "score[year]"
      assert_select "input#score_age_group", :name => "score[age_group]"
      assert_select "input#score_diagnosis", :name => "score[diagnosis]"
      assert_select "input#score_cycle_type", :name => "score[cycle_type]"
      assert_select "input#score_ivf_reports_score", :name => "score[ivf_reports_score]"
      assert_select "input#score_quality_score", :name => "score[quality_score]"
      assert_select "input#score_safety_score", :name => "score[safety_score]"
      assert_select "input#score_sart_score", :name => "score[sart_score]"
    end
  end
end
