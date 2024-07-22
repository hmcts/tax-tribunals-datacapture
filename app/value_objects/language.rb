class Language < ValueObject
  VALUES = [
    English = new(:english),
    EnglishWelsh = new(:welsh)
  ].freeze

  def self.values
    VALUES
  end
end
