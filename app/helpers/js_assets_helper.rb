module JsAssetsHelper
  def locale_json(key)
    I18n.
      available_locales.
      index_with { |locale| I18n.t(key, locale:) }.
      to_json
  end
end
