require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/plain"
require 'lib/logstash/inputs/twitter'
require "twitter"

describe LogStash::Inputs::Twitter do
   let(:queue) { Queue.new }
   let(:klass) { LogStash::Inputs::Twitter }
   let(:twitter_instance) { object_spy(Twitter::Streaming::Client.new) }
   let(:tweet_mock) { Twitter::Tweet.new :id => 1 }
   let(:keywords) { ["keywords", "keywords2"] }
   let(:follows) { ["follows", "follows2"] }
   let(:locations) { ["locations", "locations2"] }
   let(:default_opts) {
     {
       "consumer_key" => "consumer_key",
       "consumer_secret" => "consumer_secret",
       "oauth_token" => "oauth_token",
       "oauth_token_secret" => "oauth_token_secret",
       "keywords" => :keywords,
       "follows" => :follows,
       "locations" => :locations
     }
   }
   subject(:twitter_plugin) { klass.new(default_opts) }

   context "#register" do
     it "raise no exception" do
       plugin = klass.new(default_opts)
       expect { plugin.register }.not_to raise_error
     end
   end

   before do
     twitter_plugin.register
   end

   describe "#run" do
     it "should run only with track, follow and location and return tweet" do
       thread = Thread.new do
         twitter_plugin.run(:queue).once
       end

       expect(twitter_instance).to receive(:filter)
       thread.kill
       #expect(twitter_instance).to have_received(:filter).with(:keywords, :follows, :locations)
     end
   end
end
