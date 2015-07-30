require 'spec_helper'

describe String do
  describe ".remove_accents" do
    subject { string.remove_accents }

    context "should remove accents" do
      let(:string) { "çÇáàãâÁÀÂÃéèêÉÈÊ" }

      it { should == 'cCaaaaAAAAeeeEEE' }
    end
  end

  describe ".replace_spaces" do
    subject { string.replace_spaces }

    context "should replace spaces for '+'" do
      let(:string) { " just a test  " }

      it { should == 'just+a+test' }
    end
  end

  describe ".shortname" do
    subject { string.shortname }

    context "should replace name for shortname in the list" do
      let(:string) { "endereco" }

      it { should == 'end' }
    end

    context "should return name not in the list" do
      let(:string) { "name" }

      it { should == 'name' }
    end
  end
end
