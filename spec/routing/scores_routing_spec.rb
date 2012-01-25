require "spec_helper"

describe ScoresController do
  describe "routing" do

    it "routes to #index" do
      get("/scores").should route_to("scores#index")
    end

    it "routes to #new" do
      get("/scores/new").should route_to("scores#new")
    end

    it "routes to #show" do
      get("/scores/1").should route_to("scores#show", :id => "1")
    end

    it "routes to #edit" do
      get("/scores/1/edit").should route_to("scores#edit", :id => "1")
    end

    it "routes to #create" do
      post("/scores").should route_to("scores#create")
    end

    it "routes to #update" do
      put("/scores/1").should route_to("scores#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/scores/1").should route_to("scores#destroy", :id => "1")
    end

  end
end
