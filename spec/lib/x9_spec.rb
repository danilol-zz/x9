require 'spec_helper'

describe X9 do
  let(:file) { './log/x9.log' }
  let(:x9)   { X9.new(:file => file) }
  let(:transaction_id) { "128 bits random hex" }

  before do
    @now = Time.parse('2013-01-15T14:22:44.123-02:00')
    Time.stub(:now).and_return(@now)
    SecureRandom.stub(:hex).and_return(transaction_id)
    Dir.mkdir(File.join(Dir.pwd, "log"), 0777)
  end

  after  { FileUtils.rm_rf Dir.glob('./log')}

  describe '.initialize' do
    before do
      Logger.stub(:new).and_return(stub(:formatter=))
      X9.any_instance.stub(:set_default_format)
    end

    after { X9.any_instance.unstub(:set_default_format) }

    context "when options aren't sent" do
      it "will initialize with default options" do
        Logger.should_receive(:new).with('log/x9.log')
        X9.new
      end
    end

    context "when options are sent" do
      let(:options) { { :file => '/tmp/x9.log'} }

      it "will initialize with custom options" do
        Logger.should_receive(:new).with('/tmp/x9.log')
        X9.new(options)
      end
    end
  end

  describe '.log' do
    let(:params) do
      {
        :error  => "ASS123",
        :method => 'CRIAR_USUARIO',
        "params" => {'nome' => 'user', 'telefone' => 123123123, :endereco => {'cep' => 192038120, 'rua' => 'Baker St', 'país' => 'BR'}}
      }
    end

    context "when params has no values" do
      let(:params) { {"params" => nil } }

      subject { x9.warn(params); `tail -n 1 #{file}`.strip.split('||') }

      it { subject[0].should == DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%L %z") }
      it { subject[1].should == "WARN" }
      it { subject[2].should == transaction_id }
      it { subject[3].should == "error=#{params["error"]}"  }
      it { subject[4].should == "method=#{params["method"]}" }
      it { subject[5].should == "params=" }

      it "should create file" do
        subject
        File.should exist(File.join(Dir.pwd,"/log/x9.log"))
      end
    end

    context "when params has values" do
      subject { x9.warn(params); `tail -n 1 #{file}`.strip.split('||') }

      it { subject[0].should == DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%L %z") }
      it { subject[1].should == "WARN" }
      it { subject[2].should == transaction_id }
      it { subject[3].should == "error=#{params["error"]}"  }
      it { subject[4].should == "method=#{params["method"]}" }
      it { subject[5].should == "params=end[cep]=192038120&&end[pais]=BR&&end[rua]=Baker+St&&nome=user&&fone=123123123" }

      it "should create file" do
        subject
        File.should exist(File.join(Dir.pwd,"/log/x9.log"))
      end
    end

    describe ".debug" do
      subject { x9.debug(params); `tail -n 1 #{file}`.strip.split('||')[1] }

      it "should log in DEBUG level" do
        subject.should == "DEBUG"
      end
    end

    describe ".info" do
      subject { x9.info(params); `tail -n 1 #{file}`.strip.split('||')[1] }

      it "should log in INFO level" do
        subject.should == "INFO"
      end
    end

    describe ".warn" do
      subject { x9.warn(params); `tail -n 1 #{file}`.strip.split('||')[1] }

      it "should log in WARN level" do
        subject.should == "WARN"
      end
    end

    describe ".error" do
      subject { x9.error(params); `tail -n 1 #{file}`.strip.split('||')[1] }

      it "should log in ERROR level" do
        subject.should == "ERROR"
      end
    end

    describe ".fatal" do
      subject { x9.fatal(params); `tail -n 1 #{file}`.strip.split('||')[1] }

      it "should log in FATAL level" do
        subject.should == "FATAL"
      end
    end
  end
end
