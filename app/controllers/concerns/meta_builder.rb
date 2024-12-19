# frozen_string_literal: true

module MetaBuilder
  module_function

  def build_meta(builders: [])
    meta = {}
    builders.each do |builder|
      meta = meta.merge builder.gen_meta
    end

    meta
  end
end
