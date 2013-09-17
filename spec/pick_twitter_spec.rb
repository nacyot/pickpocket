# -*- coding: utf-8 -*-
require 'spec_helper'

module Pickpocket
  describe PickTwitter do
    describe "Pocket 등록" do
      let(:tweets) { Pickpocket::Twitter::Tweets.new [] }

      before(:each) do
        tweets.stub(:tweets) { Twitter::TweetsBackup.restore "timeline_with_title.dump" }
      end
      
      it "아이템 등록 및 삭제" do
        result = PickTwitter.pick tweets.tweets
        result.should be_has_key("action_results")

        item = result["action_results"][0]
        item["item_id"].should_not be_nil

        items = []
        result["action_results"].each do |pocket|
          items <<{
            "action" => "delete",
            "item_id" => pocket["item_id"]
          }
        end
        
        result = PocketClient.instance.modify(items)
        result.should be_has_key("action_results")
        result["action_results"][0].should be_true
      end
      
    end # descibe
  end # describe
  
end # module
