# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe R18n::Loader::Rails do
  before :all do
    I18n.load_path = [SIMPLE]
    @loader = R18n::Loader::Rails.new
  end
  
  it "should return available locales" do
    @loader.available.should =~ [EN, RU]
  end
  
  it "should load translation" do
    @loader.load(RU).should == { 'one' => 'Один', 'two' => 'Два' }
  end
  
  it "should change pluralization" do
    @loader.load(EN).should == {
      'users' => R18n::Typed.new('pl', {
        0 => 'Zero', 1 => 'One', 2 => 'Few', 'n' => 'Many', 'other' => 'Other'
       }),
       'typed' => R18n::Typed.new('type', 'value')
    }
  end
  
  it "should reload translations on load_path changes" do
    I18n.load_path << OTHER
    @loader.load(RU).should == { 'one' => 'Один', 'two' => 'Два',
                                 'three' => 'Три' }
  end
  
  it "should change hash on load_path changes" do
    before = @loader.hash
    I18n.load_path << OTHER
    @loader.hash.should_not == before
  end
  
end
