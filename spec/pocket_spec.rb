# -*- coding: utf-8 -*-
require 'spec_helper'

module Pickpocket
  describe PocketClient do
    let(:pocket) { Object.new }

    it "아이템 등록하고 삭제하기" do
      url = "http://google.com"

      pocket.stub(:modify).and_return({"action_results" => [{"normal_url" => url, "item_id" => "2893842"}]})

      result = pocket.modify([{action: "add", url: url}])
      result.should be_has_key("action_results")

      item = result["action_results"][0]
      item["normal_url"].should eq(url)

      result = pocket.modify([{action: "delete", item_id: item["item_id"]}])
      result.should be_has_key("action_results")
      result["action_results"][0].should be_true
    end
 
  end
end


