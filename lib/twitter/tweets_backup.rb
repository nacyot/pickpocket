module Pickpocket
  module Twitter
    class TweetsBackup
      TMP_DIR = File.join(__dir__, "..", "..","tmp")
      
      def self.tmp_file
        File.join(TMP_DIR, "timeline.dump")
      end
      
      def self.save(tweets)
        File.open(tmp_file, "w+") do |f|
          f.write Marshal.dump(tweets)
        end
      end

      def self.restore
        Marshal.restore File.read(tmp_file)
      end
    end
  end
end
