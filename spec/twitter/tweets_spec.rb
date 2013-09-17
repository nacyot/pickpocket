# -*- coding: utf-8 -*-
require 'spec_helper'

module Pickpocket
  module Twitter
    describe Tweets do
      let(:twitter) { Pickpocket::TwitterClient.instance }

      describe "Tweets 가공하기" do
        let(:tweets) { Tweets.new twitter.fetch_timeline }

        before(:each) do
          twitter.stub(:fetch_timeline){ Twitter::TweetsBackup.restore }
          tweets.stub(:tweets) { Twitter::TweetsBackup.restore "timeline_with_title.dump" }
        end

        it "Link가 있는 Tweets 추려내기" do
          tweets.tweets.should be_instance_of(Array)
          tweets.tweets.count.should eq(8)
        end

        it "Link의 타이틀 가져오기" do
          # tweets.get_titles
          tweets.tweets[0].attrs[:entities][:urls][0][:title].should match(/TechCrunch/)
        end

      end # describe
    end # descirbe

  end # module Twitter
end # module Pickpocket
