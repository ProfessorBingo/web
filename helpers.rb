module Helpers
  def self.included( app )
    app.helpers do
      def test(text)
        puts "Testing: " + text + "..."
      end
    end
  end
end