module ClinicsHelper

  def print_score_color(score)
    score = score.to_f
    if(score>=90.0)
      return "green"
    elsif(score<90.0 && score >=80.0)
      return "blue"      
    elsif(score<80.0 && score >=70.0)
      return "yellow"      
    else
      return "gray"      
    end

  end
  
end
