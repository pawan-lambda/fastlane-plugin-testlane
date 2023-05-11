describe Fastlane::Actions::TestlaneAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The testlane plugin is working!")

      Fastlane::Actions::TestlaneAction.run(nil)
    end
  end
end
