require 'spec_helper'

describe FrequencyMap do

  let(:fm1) {fm1 = FrequencyMap.from_string "AABCCCDDDD"}
  let(:fm2) {fm1 = FrequencyMap.from_string "ABBBBBDDDE"}
  let(:empty) {empty = FrequencyMap.empty}

  it 'should return the expected frequencies for each char' do
      expect(fm1.frequency("A")).to be(20)
      expect(fm1.frequency("B")).to be(10)
      expect(fm1.frequency("C")).to be(30)
      expect(fm1.frequency("D")).to be(40)
      expect(fm1.frequency("E")).to be(0)
  end


  it 'should return the "distance" from 2 strings' do
    expect(fm1.distance(fm1)).to be(0)
    expect(fm1.distance(fm2)).to be(2800)
  end

  it 'should be transitive' do
    expect(fm2.distance(fm1)). to be(fm1.distance(fm2))
  end

  it 'should have an empty frequency' do
    expect(empty.frequency("A")).to be(0)
  end


  it 'should be possible to add frequencies' do

    fm = fm1 + fm2
    expect(fm.frequency("A")).to be(15)
    expect(fm.frequency("B")).to be(30)
    expect(fm.frequency("C")).to be(15)
    expect(fm.frequency("D")).to be(35)
    expect(fm.frequency("E")).to be(5)
    expect(fm.frequency("F")).to be(0)
    expect((fm+empty).frequency("A")).to be(15)

  end

end
