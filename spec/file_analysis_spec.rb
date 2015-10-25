require 'spec_helper'

describe FileAnalysis do

  it 'shoud be able to recognize the language which a file was written' do

    fa = FileAnalysis.new Dir["data/*"]
    expect(fa.detect_language(File.read("spec/test_data/test-spanish.txt"))).to  eq("SPANISH")
    expect(fa.detect_language(File.read("spec/test_data/test-portuguese.txt"))).to  eq("PORTUGUESE")
    expect(fa.detect_language(File.read("spec/test_data/test-german.txt"))).to  eq("GERMAN")
    expect(fa.detect_language(File.read("spec/test_data/test-english.txt"))).to  eq("ENGLISH")

  end

  it 'shoud be able to recognize the language which a string was written' do

    fa = FileAnalysis.new Dir["data/*"]
    expect(fa.detect_language("Meu nome e Fabiana e eu gosto muito de comer chocolate")).to  eq("PORTUGUESE")
    expect(fa.detect_language("According to analysis,magpies do not form the monophyletic group they are traditionally believed to be a long tail has certainly elongated (or shortened) independently in multiple lineages of corvid birds. Among the traditional magpies, there appear to be two distinct lineages: one consists of Holarctic species with")).to  eq("ENGLISH")
    expect(fa.detect_language("Marseille est en tete des villes francaises pour la grande criminalite. Au palais de justice, la permanence durgence du parquet traite les appels des commissariats. Immersion dans la tour de controle de la delinquance marseillaise")).to  eq("FRENCH")

  end


end
