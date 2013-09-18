# -*- coding: utf-8 -*-
require 'spec_helper'

module Pickpocket
  describe PocketClient do
    let(:pocket) { PocketClient.instance }

    it "아이템 등록하고 삭제하기" do
      url = "http://google.com"
      result = pocket.modify([{action: "add", url: url}])
      result.should be_has_key("action_results")

      item = result["action_results"][0]
      item["normal_url"].should eq(url)

      pocket.stub(:modify).and_return({"action_results" => [true]})
      result = pocket.modify([{action: "delete", item_id: item["item_id"]}])
      result.should be_has_key("action_results")
      result["action_results"][0].should be_true
    end
 
  end
end


