# -*- coding: utf-8 -*-
require 'spec_helper'

module Pickpocket
  describe TwitterClient do
    let(:twitter) {Pickpocket::TwitterClient.new}

    describe "Twitter API" do
      before(:each) do
        twitter.stub(:fetch_timeline){ twitter.restore_tmp_timeline }        
      end
      
      it "Timeline 가져오기" do
        twitter.timeline.should be_instance_of(Array)
        twitter.timeline.count.should eq(21)
      end

      it "Link가 있는 Tweets 추려내기" do
        twitter.tweets_has_link.should be_instance_of(Array)
        twitter.tweets_has_link.count.should eq(8)
      end

      it "Link의 타이틀 가져오기" do
        twitter.get_titles
        twitter.tweets_has_link[0].attrs[:entities][:urls][0][:title].should eq("Splunk Acquires BugSense, A Platform For Analyzing Mobile Data  |  TechCrunch")
      end
      
    end


    # p.restore_tmp_timeline
    # p.extract_links
    # p.get_titles
  end
end
