class Language < ValueObject
  VALUES = [
    English = new(:english),
    Welsh = new(:welsh)
  ].freeze

  def self.values
    VALUES
  end
end
