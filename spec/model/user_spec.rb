require 'rails_helper'

RSpec.describe User, type: :model do
  context "valid inputs" do
    subject {User.create(name: 'teste name', twitterUrl: 'https://twitter.com/keterpie', twitterName: 'Keterpie' )}
    it 'is valid' do
      expect(subject).to be_valid
    end
  end
  context "missing name" do
    subject {User.create(name: '', twitterUrl: 'https://twitter.com/keterpie', twitterName: 'Keterpie' )}
    it 'is valid' do
      expect(subject.errors[:name]).to include("não pode ficar em branco")
    end
  end
  context "missing twitterUrl" do
    subject {User.create(name: 'asd', twitterUrl: '', twitterName: 'Keterpie' )}
    it 'is valid' do
      expect(subject.errors[:twitterUrl]).to include("não pode ficar em branco")
    end
  end
  context "missing twitterName" do
    subject {User.create(name: 'asd', twitterUrl: 'https://twitter.com/keterpie', twitterName: '' )}
    it 'is valid' do
      expect(subject.errors[:twitterName]).to include("Usuario não encontrado")
    end
  end
  context "twitterName is unique" do
    before {User.create(name: 'teste name', twitterUrl: 'https://twitter.com/keterpie', twitterName: 'Keterpie' )}
    subject {User.create(name: 'teste name', twitterUrl: 'https://twitter.com/keterpie', twitterName: 'Keterpie' )}
    it 'is not valid' do
      expect(subject.errors[:twitterName]).to include("já está em uso")
    end
  end   
end