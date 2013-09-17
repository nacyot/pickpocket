module Pickpocket
  module Twitter
    class TweetsBackup
      TMP_DIR = File.join(__dir__, "..", "..","tmp")
      
      def self.tmp_file(file = "timeline.dump")
        File.join(TMP_DIR, file)
      end
      
      def self.save(tweets)
        File.open(tmp_file, "w+") do |f|
          f.write Marshal.dump(tweets)
        end
      end

      def self.restore(file = "timeline.dump")
        Marshal.restore File.read(tmp_file(file))
      end
    end
  end
end
