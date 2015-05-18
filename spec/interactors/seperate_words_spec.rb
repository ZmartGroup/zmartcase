# encoding: UTF-8
require 'rails_helper'


describe SeperateWords do

    it "SeperateWords should seperaate swedish characters correctly" do
        sentance = "Ån ligger långt härifrån; hur tycker du att vi ska lösa det? Många får gått för att hämta vatten där! Dessa: Pelle, per"
        sep_sentance =SeperateWords.new.seperate(sentance)

        expect(sep_sentance.fetch(3)).to eq "härifrån"
        expect(sep_sentance.fetch(10)).to eq "lösa"
        expect(sep_sentance.fetch(21)).to eq "Pelle"

    end
end