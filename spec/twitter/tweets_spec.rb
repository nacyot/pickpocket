# -*- coding: utf-8 -*-
require 'spec_helper'

module Pickpocket
  module Twitter
    describe Tweets do
      let(:twitter) { Pickpocket::TwitterClient.instance }

      describe "Tweets 가공하기" do
        before(:each) do
          twitter.stub(:fetch_timeline){ Twitter::TweetsBackup.restore }
        end

        let(:tweets) { Tweets.new twitter.fetch_timeline }

        it "Link가 있는 Tweets 추려내기" do
          tweets.tweets.should be_instance_of(Array)
          tweets.tweets.count.should eq(8)
        end

        describe "타이틀 테스트", long_time: true do
          it "Link의 타이틀 가져오기" do
            tweets.get_titles
            tweets.tweets[0].attrs[:entities][:urls][0][:title].should eq("Splunk Acquires BugSense, A Platform For Analyzing Mobile Data  |  TechCrunch")
          end
        end

      end # describe
    end # descirbe

  end # module Twitter
end # module Pickpocket
