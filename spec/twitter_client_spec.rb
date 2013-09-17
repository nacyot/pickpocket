# -*- coding: utf-8 -*-
require 'spec_helper'

module Pickpocket
  describe TwitterClient do
    let(:twitter) { Pickpocket::TwitterClient.instance }

    describe "Twitter API" do
      before(:each) do
        twitter.stub(:fetch_timeline){ Twitter::TweetsBackup.restore }
        twitter.stub(:fetch_favorites){ Twitter::TweetsBackup.restore }
      end
      
      it "Timeline 가져오기" do
        timeline = twitter.fetch_timeline
        timeline.should be_instance_of(Array)
        timeline.count.should eq(21)
      end

      it "Favorites 가져오기" do
        favorites = twitter.fetch_favorites
        favorites.should be_instance_of(Array)
        favorites.count.should eq(21)
      end
    end


    # p.restore_tmp_timeline
    # p.extract_links
    # p.get_titles
  end
end
